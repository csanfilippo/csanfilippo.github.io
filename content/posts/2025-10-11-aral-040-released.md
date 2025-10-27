+++
date = 2025-10-11T07:59:17+02:00
draft = false
title = "aral 0.4.0 Released"
description = ""
slug = "aral-040-released"
authors = ["Calogero Sanfilippo"]
tags = ["kotlin", "multiplatform", "xml", "jvm", "release"]
externalLink = ""
series = []
+++

Aral 0.4.0 is now available. This release introduces support for the [Android Gradle Library Plugin for Kotlin Multiplatform (KMP)](https://developer.android.com/kotlin/multiplatform/plugin).

## Android Gradle Library Plugin for KMP

The `com.android.kotlin.multiplatform.library` plugin is the officially supported way to add an Android target to a Kotlin Multiplatform library module. It replaces the previous use of `com.android.library` in KMP projects, which is now deprecated.

Key characteristics of the plugin include:

- **Single variant architecture**: removes product flavors and build types, simplifying configuration.
- **Optimized for KMP**: focuses on shared Kotlin code and interoperability, without Android-specific legacy features.
- **Tests disabled by default**: host and device tests can be enabled explicitly.
- **No top-level `android` block**: configuration is handled through `androidLibrary {}` within the KMP DSL.
- **Opt-in Java compilation**: Java sources are not compiled unless explicitly enabled.

For details, see the [official documentation](https://developer.android.com/kotlin/multiplatform/plugin).

## Migration Notes

Projects using `com.android.library` for KMP should migrate to the new plugin. The migration involves:

- Declaring the plugin in the version catalog.
- Applying it in the root and module-level `build.gradle(.kts)` files.
- Configuring the Android target with the `androidLibrary {}` block.
- Explicitly enabling Android resources or test source sets if required.

## Other Changes

- Internal adjustments to align with the new plugin’s single-variant model.
- Updated build configuration to improve consistency across supported targets.

## Availability

aral 0.4.0 is available on the usual distribution channels. Users are encouraged to update to ensure compatibility with the evolving Kotlin Multiplatform ecosystem.