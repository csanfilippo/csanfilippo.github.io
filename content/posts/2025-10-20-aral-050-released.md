+++
date = 2025-10-20T22:37:25+02:00
draft = false
title = "aral 0.5.0 released"
description = ""
slug = "aral-050-released"
authors = ["Calogero Sanfilippo"]
tags = ["kotlin", "multiplatform", "xml", "jvm", "release"]
externalLink = ""
series = []
+++

Version **0.5.0** of aral is now available.

This update does not introduce new features or breaking changes. The main focus has been a **refactoring of the internal engine**. The goal of this work is to make the codebase easier to maintain and extend in the future, while keeping the external API stable.

### Highlights
- Internal engine refactored for clarity and maintainability
- No changes required for existing users
- API and behavior remain the same

### Installation

aral is published on Maven Central. To use the latest version:

```kotlin
commonMain {
    dependencies {
        implementation("it.calogerosanfilippos:aral:0.5.0")
    }
}