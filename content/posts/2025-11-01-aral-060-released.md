+++
date = 2025-11-01T20:23:45+01:00
draft = false
title = "aral 0.6.0 released: support for CDATA"
description = "aral 0.6.0 released: support for CDATA"
slug = "aral-060-released"
authors = ["Calogero Sanfilippo"]
tags = ["kotlin", "multiplatform", "xml", "jvm", "release"]
externalLink = ""
series = []
+++

**aral 0.6.0** is now available. It adds **support for CDATA sections** in XML parsing.

### Changes
- CDATA sections are now recognized and emitted as parser events.
- This improves compatibility with XML documents that embed raw text, code, or markup.