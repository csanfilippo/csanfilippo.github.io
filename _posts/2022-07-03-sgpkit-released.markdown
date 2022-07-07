---
layout: post
title:  "swift-sgp4 1.0.0 is here!"
date:   2022-07-03 23:30:00 +0200
categories: libs
---

Today I released the first open source version of [swift-sgp][swift-sgp], a very simple Swift Package that calculates the position of a satellite given a [two-line elements set (TLE)][tle-wiki].

The library wouldn't have been possible without the fundamental help of [sgp4][sgp4], a satellite prediction C++ library developed by [Daniel Warner][dnwrnr].

As you may imagine, swift-spg is the core of [ISSSeeker]({{ site.url }}/apps/issseeker).

[swift-sgp]: https://github.com/csanfilippo/swift-sgp4
[tle-wiki]: https://en.wikipedia.org/wiki/Two-line_element_set
[sgp4]: https://www.danrw.com/sgp4/
[dnwrnr]: https://github.com/dnwrnr
