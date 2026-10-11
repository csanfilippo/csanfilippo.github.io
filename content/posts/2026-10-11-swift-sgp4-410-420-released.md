+++
date = '2026-10-11T23:55:37+02:00'
draft = false
title = 'SGPKit 4.1.0 and 4.2.0 released'
description = "SGPKit 4.1.0 reads TLEs with Alpha-5 catalog numbers, and 4.2.0 no longer requires C++ interoperability in the apps and packages that depend on it."
slug = "swift-sgp4-410-420-released"
authors = ["Calogero Sanfilippo"]
tags = ["swift", "swift-sgp4", "satellite", "orbital-mechanics", "release"]
+++

Two new versions of SGPKit, **4.1.0** and **4.2.0**, are now available.

## 4.1.0: Alpha-5 catalog numbers

Satellite catalog numbers have five digits, so a TLE can't hold a number above 99999. With the catalog crossing that limit, numbers from 100000 onward are written in the **Alpha-5** format: a letter followed by four digits, such as `A0000` for 100000.

Up to 4.0.0, SGPKit refused these TLEs. The bundled copy of [libsgp4](https://github.com/dnwrnr/sgp4) predated its Alpha-5 support, so `TLEInterpreter.satelliteData(from:date:)` threw `TLEInterpreter.Error.tle`.

4.1.0 upgrades the bundled libsgp4 to v3.0, which reads Alpha-5 numbers. SARAMAGO, the first satellite numbered 100000, now propagates:

```swift
import SGPKit

let tle = try TLE(
    title: "SARAMAGO",
    firstLine: "1 A0000U 26067CY  26195.90649229  .00004770  00000+0  22159-3 0  9994",
    secondLine: "2 A0000  97.4593 154.0970 0005590 270.5113  89.5482 15.20467281 15911"
)

let data = try TLEInterpreter().satelliteData(from: tle, date: .now)
```

## 4.2.0: no more C++ interoperability for consumers

Since 3.0.0, SGPKit has reached libsgp4 through a C++ wrapper. Swift's C++ interoperability is contagious: every app or package that depended on SGPKit had to enable it too, either with `.interoperabilityMode(.Cxx)` in `Package.swift` or with Xcode's *C++ and Objective-C Interoperability* build setting.

4.2.0 replaces the C++ wrapper with a plain C interface. libsgp4 is still C++ underneath, but SGPKit no longer exposes it, so consumers can remove the setting. The public Swift API is unchanged.

## Thanks

4.1.0 exists thanks to [hneogy](https://github.com/hneogy). Their [issue #4](https://github.com/csanfilippo/swift-sgp4/issues/4) is what made me realize SGPKit couldn't handle Alpha-5 catalog numbers. The report came with a reproducible example, the root cause, and the upstream version that fixed it, which made 4.1.0 a quick release. It also got me back to work on the library after almost a year, and 4.2.0 followed the same day.

## Upgrading

Update your `Package.swift`:

```swift
.package(url: "https://github.com/csanfilippo/swift-sgp4.git", from: "4.2.0")
```

### Coming from 3.x

4.0.0 changed how `TLE` decodes. It now decodes from the same keyed form it encodes, `{"title": …, "firstLine": …, "secondLine": …}`, so it survives a round trip through `JSONEncoder` and `JSONDecoder`. The array form `[title, firstLine, secondLine]` that 3.1.0 decoded no longer decodes. To migrate stored arrays, decode them as `[String]` and build the `TLE` yourself:

```swift
let lines = try JSONDecoder().decode([String].self, from: storedData)
let tle = try TLE(title: lines[0], firstLine: lines[1], secondLine: lines[2])
```

`TLEEncoder` and `TLEDecoder`, which read and write raw TLE text, are unchanged.

The full list of changes is in the [changelog](https://github.com/csanfilippo/swift-sgp4/blob/main/CHANGELOG.md).
