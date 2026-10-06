+++
date = '2026-10-06T00:30:00+02:00'
draft = false
title = 'sfera'
summary = "A Swift library for parsing, building, and encoding GeoJSON, valid by construction"
repository = 'https://github.com/csanfilippo/sfera'
programmingLanguage = 'Swift'
+++

{{< figure-dynamic
dark-src="/images/sfera-lockup-dark.svg"
light-src="/images/sfera-lockup.svg"
alt="sfera logo"
width="307"
style="text-align: left"
>}}

**sfera** models [RFC 7946](https://datatracker.ietf.org/doc/html/rfc7946) GeoJSON as Swift value types. The rules of the format live in the types:

- Coordinates are validated the moment a `Position` is created.
- A line string needs two positions, and a ring three vertices. The compiler checks both.
- Rings close themselves, and polygons follow the right-hand rule automatically.
- Large integer identifiers and properties survive a round trip exactly.

Every type is `Codable`, `Sendable` and `Hashable`. sfera has no third-party dependencies and uses only the Swift standard library.

## Quick start

```swift
import Foundation
import sfera

let rome = try Position(latitude: 41.9028, longitude: 12.4964)
let city = Feature(id: "rome", geometry: .point(rome), properties: ["name": "Rome"])

let data = try JSONEncoder().encode(FeatureCollection([city]))
// {"type":"FeatureCollection","features":[{"type":"Feature","id":"rome","geometry":{"type":"Point","coordinates":[12.4964,41.9028]},"properties":{"name":"Rome"}}]}

let document = try JSONDecoder().decode(GeoJSON.self, from: data)
```

## Installation

sfera requires Swift 6.4. It runs on iOS, macOS, watchOS and tvOS 26, on Linux, and on WebAssembly (WASI). Add it with Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/csanfilippo/sfera.git", from: "0.1.0")
]
```

## Learn more

- The full guide, covering geometries, features, decoding rules and output, is on [GitHub](https://github.com/csanfilippo/sfera)
