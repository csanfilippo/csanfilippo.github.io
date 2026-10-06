+++
date = '2026-10-06T00:30:00+02:00'
draft = false
title = 'sfera: GeoJSON for Swift, born from a trip to Oman'
description = "sfera: a Swift library that models RFC 7946 GeoJSON as value types and enforces its rules at compile time, at creation and when decoding"
slug = "sfera-released"
authors = ["Calogero Sanfilippo"]
tags = ["swift", "sfera", "geojson", "release"]
toc = true
+++


## Why?

Between being a father and a software engineer, it's always a challenge to find time to sit down in front of my faithful iMac and code.

This time the desire to code was guided (again) by another passion of mine: travel.

During the last New Year's Eve vacation I was in [Oman](https://en.wikipedia.org/wiki/Oman) with my family.
There, the need to have an offline map of all the petrol stations led to the creation of [oman-petrol-stations](/tools/oman-petrol-stations/), as I wrote in [the release post](/posts/oman-petrol-stations-released/).

Recently, I decided to enrich the CLI with support for another export format: [GeoJSON](https://en.wikipedia.org/wiki/GeoJSON).

The first idea was to implement GeoJSON support directly inside the CLI project, limiting the scope of the code to the needs of the CLI. Then, I started to wonder whether it would be more stimulating to model the GeoJSON format with Swift's type system inside a dedicated library (a developer's ego needs nurturing).

That's how [sfera](/libs/sfera/) was born.

## The name

Names define the essence of something: no name means no existence.

I wanted an evocative name. What does GeoJSON do? It represents geographical features of our planet, so I thought of a name connected to exploration, space, geography.
I started looking at names of Soviet Union space programs (an old passion of mine), and I discovered the existence of the [Сфера geodetic satellite series](https://en.wikipedia.org/wiki/Sfera_(satellite_series)).

Sfera (Сфера in Cyrillic) is also the Italian and Russian word for _sphere_. What a perfect name!

## Valid by construction

sfera models GeoJSON as Swift value types, and the rules of the format live in those types.

The format looks simple: a few object types and some nested arrays of numbers. A line string needs at least two positions. A polygon ring needs at least four, and the last one must repeat the first. The exterior ring runs counter-clockwise and holes run clockwise. Longitude comes before latitude.

When GeoJSON is modeled as `[[Double]]`, none of these rules is enforced, and a mistake shows up only when a map draws the polygon in the wrong place. sfera enforces each rule in one of three places: when a value is created, at compile time, or inside the library itself.

### Positions are checked when created

A latitude outside -90…90 cannot be caught at compile time. `Position` checks its coordinates in the initializer and throws a typed error:

```swift
let rome     = try Position(latitude: 41.9028, longitude: 12.4964)
let florence = try Position(latitude: 43.7696, longitude: 11.2558)
let milan    = try Position(latitude: 45.4642, longitude: 9.19)

do {
    _ = try Position(latitude: 91, longitude: 0)
} catch .latitudeOutOfRange {
    // latitudes run from -90 to 90
}
```

Once a `Position` exists, it is valid. It is always encoded longitude first, so the caller never deals with the order.

### Minimum lengths are checked by the compiler

`LineString` is an `AtLeast<2, Position>`, a collection that stores its first two elements in a fixed-size `InlineArray`:

```swift
public struct AtLeast<let minimum: Int, Element> {
    private let guaranteed: InlineArray<minimum, Element>
    private var rest: [Element]

    public init(_ guaranteed: InlineArray<minimum, Element>, _ rest: [Element] = []) {
        self.guaranteed = guaranteed
        self.rest = rest
    }

    public mutating func append(_ element: Element) {
        rest.append(element)
    }
}

extension AtLeast: RandomAccessCollection {
    public var startIndex: Int { 0 }
    public var endIndex: Int { minimum + rest.count }

    public subscript(position: Int) -> Element {
        position < minimum ? guaranteed[position] : rest[position - minimum]
    }
}
```

`minimum` is a value generic parameter, so the count is part of the type.

The full implementation, with its conformances, is [on GitHub](https://github.com/csanfilippo/sfera/blob/0.1.0/Sources/sfera/AtLeast.swift).

A line string that is too short does not compile:

```swift
var route = LineString([rome, florence])
route.append(milan)

LineString([rome])   // error: expected '2' elements in inline array literal, but got '1'
```

Elements can be appended but never removed, so the minimum holds for the whole life of the value. `LinearRing` stores its vertices the same way, with a minimum of three distinct vertices; the closing position is added when encoding.

### Some rules are the library's job

These don't need to be pushed onto the caller at all:

- **Rings close themselves.** You give each vertex once, and encoding repeats the first one at the end.
- **Polygons follow the right-hand rule.** `Polygon` reverses any ring that winds the wrong way, keeping its first vertex.

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

The vertices are given clockwise. The encoded ring is counter-clockwise and closed.

Beyond the format's rules, sfera also keeps large identifiers intact. Whole numbers are stored as `Int64`, not `Double`, so a 64-bit identifier comes back exactly as it went in, even on 32-bit platforms such as WebAssembly.

### Decoding applies the same rules

Valid types don't help if decoding lets invalid input through. Decoding in sfera runs the same checks as the initializers: an out-of-range coordinate, a line string with one position or an unclosed ring is rejected with a `DecodingError` that points to the offending value. A ring wound the wrong way is the one exception: [RFC 7946](https://datatracker.ietf.org/doc/html/rfc7946) asks parsers to accept it, so sfera accepts it and corrects it.

## How I built it

The library has been fully written test-first, pairing with [Claude](https://claude.ai).

Here's the _modus operandi_:
* I wrote all the tests following RFC 7946.
* Claude and I paired during the implementation, guiding the development alternately.

## Getting started

sfera requires Swift 6.4 and has no third-party dependencies. It runs on iOS, macOS, watchOS and tvOS 26, on Linux, and on WebAssembly. Add it with Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/csanfilippo/sfera.git", from: "0.1.0")
]
```

## Learn more

- The full guide, covering features, properties, decoding rules and output, is on [GitHub](https://github.com/csanfilippo/sfera).