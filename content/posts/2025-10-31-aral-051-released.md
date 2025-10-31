+++
date = 2025-10-31T22:38:49+01:00
draft = false
title = "aral 0.5.1 released: A More Robust and Performant Parser"
description = "Announcing the release of aral 0.5.1. This patch focuses on improving parser robustness with better handling of blank input and significantly boosts performance for character-heavy XML documents."
slug = "aral-051-released"
authors = ["Calogero Sanfilippo"]
tags = ["kotlin", "multiplatform", "xml", "jvm", "release"]
externalLink = ""
series = []
+++

**aral 0.5.1** is now available. It's a small update focused on correctness and efficiency.

### Changes
- Internal refactoring of the code managing the parser of an empty XML.
- Character data assembly uses `StringBuilder` for better performance.
- Documentation for `parse` updated to reflect the correct behavior.

### Links
- [Release notes](https://github.com/csanfilippo/aral/releases/tag/0.5.1)
- [Diff 0.5.0 → 0.5.1](https://github.com/csanfilippo/aral/compare/0.5.0...0.5.
