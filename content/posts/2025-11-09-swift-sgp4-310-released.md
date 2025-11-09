+++
date = 2025-11-09T08:23:45+01:00
draft = false
title = "SGPKit 3.1.0 released"
description = "SGPKit 3.1.0 released"
slug = "sgpkit-310-released"
authors = ["Calogero Sanfilippo"]
tags = ["SGPKit", "swift", "Satellite", "Orbital Mechanics", "release"]
externalLink = ""
series = []
+++

A new version of SGPKit, **3.1.0**, has been released.

This new minor version introduces the conformance to Codable for the [TLE](https://swiftpackageindex.com/csanfilippo/swift-sgp4/3.1.0/documentation/sgpkit/tle) type. This allows easy serialization and deserialization of TLE objects.

# Encoding

```swift
import SGPKit

let tle = try TLE(
    title: "ISS (ZARYA)",
    firstLine: "1 25544U 98067A   25312.54791667  .00016717  00000-0  10270-3 0  9006",
    secondLine: "2 25544  51.6432 123.4567 0007417 234.5678 345.6789 15.50000012345678"
)

let encoder = TLEEncoder()

let data: Data = try encoder.encode(tle)

print("Encoded TLE data: \(data)")

```

# Decoding

Decoding a single TLE is quite simple.

1. Begin by creating a `Data` object that contains the serialized TLE.
2. Instantiate a TLEDecoder object.
3. Call the `decode(_:)` method to reconstruct the TLE object.

To decode a collection of TLEs, the method to call is `decodeCollection(_:)`

Below, you’ll find two example.

## Decoding single TLE

```swift
import SGPKit

let encodedData: Data = ... // Some previously encoded TLE data

let decoder = TLEDecoder()

let tle: TLE = try decoder.decode(encodedData)

print("Decoded TLE: \(tle)")

 ```

## Decoding multiple TLE

```swift
import SGPKit

let encodedCollection: Data = ... // Some previously encoded TLE data

let decoder = TLEDecoder()

let tle: [TLE] = try decoder.decodeCollection(encodedCollection)

print("Decoded collection of TLE: \(tle)")

 ```
