+++
date = '2026-10-05T00:30:00+02:00'
draft = false
title = 'sfera: GeoJSON for Swift, valid by construction'
description = "sfera: a Swift library that models RFC 7946 GeoJSON as value types, so any value you can hold is a value you can publish"
slug = "sfera-released"
authors = ["Calogero Sanfilippo"]
tags = ["swift", "sfera", "geojson"]
+++

[GeoJSON](https://datatracker.ietf.org/doc/html/rfc7946) looks simple: a few object types, some nested arrays of numbers. The rules hiding in those arrays are what make it tricky. A line string needs at least two positions. A polygon ring needs at least four, and the last one must repeat the first. The exterior ring runs counter-clockwise, and holes run clockwise. Longitude comes before latitude.

Most GeoJSON code models all of this as `[[Double]]` and leaves the rules to whoever builds the value. Nothing stops you from writing an open ring or swapping latitude and longitude, and you only find out when a map renders your polygon in the middle of the ocean.

**sfera** takes a different approach: the rules of the format live in the types, so any value you can hold is a value you can publish.

## Rules the compiler checks

A `LineString` stores its first two positions in a fixed-size `InlineArray`. A line string that is too short is not a runtime error. It does not compile:

```swift
var route = LineString([rome, florence])
route.append(milan)

LineString([rome])   // error: expected '2' elements in inline array literal, but got '1'
```

Positions can be appended but never removed, so the minimum always holds. A `LinearRing` works the same way with three vertices.

## Rules the initializer checks

Some rules can't be checked at compile time, such as a latitude outside -90…90. `Position` checks them once, when the value is created, and throws a typed error:

```swift
do {
    _ = try Position(latitude: 91, longitude: 0)
} catch .latitudeOutOfRange {
    // latitudes run from -90 to 90
}
```

Once a `Position` exists, it is valid. Nothing downstream has to check it again.

## Rules the library handles for you

Some rules don't need to be enforced on the caller at all, because the library can satisfy them itself:

- **Rings close themselves.** You give each vertex once, and the ring repeats the first one when encoded.
- **Polygons follow the right-hand rule.** You can list vertices in either direction, and `Polygon` reverses any ring that winds the wrong way.
- **Large identifiers survive a round trip.** Whole numbers are stored as `Int64`, not `Double`, so 64-bit IDs come back exactly as they went in, even on 32-bit platforms such as WebAssembly.

```swift
let field = LinearRing([
    try Position(latitude: 0, longitude: 0),
    try Position(latitude: 10, longitude: 0),
    try Position(latitude: 10, longitude: 10),
], [
    try Position(latitude: 0, longitude: 10),
])

let farm = Geometry.polygon(Polygon(exterior: field))
// {"type":"Polygon","coordinates":[[[0,0],[10,0],[10,10],[0,10],[0,0]]]}
```

The vertices above were given clockwise. The encoded exterior is counter-clockwise and closed.

## Decoding enforces the same rules

A type that is valid by construction is only half the story if decoding lets invalid input through. In sfera, decoding goes through the same checks as the initializers: an out-of-range coordinate, a two-position ring or an unclosed ring is rejected with a `DecodingError` that points to the offending value. The one exception is a ring wound the wrong way, which is accepted and corrected, as RFC 7946 asks of parsers.

## Getting started

sfera requires Swift 6.4 and has no third-party dependencies. It runs on iOS, macOS, watchOS and tvOS 26, on Linux, and on WebAssembly. Add it with Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/csanfilippo/sfera.git", from: "0.1.0")
]
```

## About the name

Sfera ("sphere") was a series of Soviet geodetic satellites, launched between 1968 and 1980 to measure the shape of the Earth.

## Learn more

- Full documentation and usage examples are on [GitHub](https://github.com/csanfilippo/sfera)
