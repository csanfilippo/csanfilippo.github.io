+++
date = 2022-05-05T23:52:10+02:00
draft = false
title = "swift-sgp4"
description = ""
authors = ["Calogero Sanfilippo"]
tags = ["Swift"]
categories = []
externalLink = ""
series = []
summary = "A Swift package for satellite orbit prediction from TLE data"
+++

**swift-sgp4** is a Swift package for computing satellite positions from **[two-line elements (TLE)](https://en.wikipedia.org/wiki/Two-line_element_set)**.  
It wraps the [`sgp4lib`](https://github.com/dnwrnr/sgp4) implementation (by Daniel Warner) and brings it into the Swift ecosystem with a clean, modern API.

## Why swift-sgp4?

Satellites orbiting Earth follow predictable paths, but turning raw orbital data into usable positions isn’t trivial. The **SGP4 model** (Simplified General Perturbations 4) has long been the standard for propagating satellite orbits from TLE data.

With **swift-sgp4**, this capability is now directly available to Swift developers — whether you’re building an iOS app for satellite tracking, a macOS tool for research, or experimenting with orbital mechanics in Swift Playgrounds.

## The approach

- **Native Swift package**: integrates seamlessly with Swift Package Manager
- **Trusted foundation**: built on the `sgp4lib` implementation
- **Practical API**: work with TLEs and get back latitude, longitude, altitude, and velocity data

It’s designed to make orbital prediction accessible without sacrificing accuracy.

## Philosophy

swift-sgp4 is about **bridging worlds**: the rigor of orbital mechanics with the elegance of Swift.  
It doesn’t try to reinvent the SGP4 model — instead, it focuses on making it approachable, reliable, and ready to use in modern Swift projects.

## Learn more

- 📖 Full documentation and usage examples are on [GitHub](https://github.com/csanfilippo/swift-sgp4)
- 📦 Install via Swift Package Manager



