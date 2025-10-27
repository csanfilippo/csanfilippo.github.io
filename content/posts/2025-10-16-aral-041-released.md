+++
date = 2025-10-16T20:53:32+02:00
draft = false
title = "aral 0.4.1 released"
description = ""
slug = "aral-041-released"
authors = ["Calogero Sanfilippo"]
tags = ["kotlin", "multiplatform", "xml", "jvm", "release"]
externalLink = ""
series = []
+++

aral 0.4.1 is now available.

This patch release fixes a bug in the XML parser related to character handling between elements. 

When processing characters inside elements like `<element>characters</element>`, push parsers emit multiple character events. The previous implementation did not accumulate these fragments correctly, resulting in incomplete or malformed values during resource parsing.

The fix ensures that character data is properly buffered across consecutive events, restoring expected behavior for XML resource interpretation.

No other changes are included in this release.