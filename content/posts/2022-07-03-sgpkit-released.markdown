+++ 
draft = false
date = 2022-07-03T23:52:10+02:00
title = "swift-sgp4 1.0.0 is here!"
description = ""
authors = ["Calogero Sanfilippo"]
tags = ["libs"]
categories = []
externalLink = ""
series = []
slug = "sgpkit-released"
+++

Today I released the first open source version of [swift-sgp4][swift-sgp], a very simple Swift Package that calculates the position of a satellite given a [two-line elements set (TLE)][tle-wiki].

The library wouldn't have been possible without the fundamental help of [sgp4][sgp4], a satellite prediction C++ library developed by [Daniel Warner][dnwrnr].

As you may imagine, swift-sgp4 is the core of [ISSSeeker]({{ site.url }}/apps/issseeker).

[swift-sgp]: https://github.com/csanfilippo/swift-sgp4
[tle-wiki]: https://en.wikipedia.org/wiki/Two-line_element_set
[sgp4]: https://www.danrw.com/sgp4/
[dnwrnr]: https://github.com/dnwrnr
