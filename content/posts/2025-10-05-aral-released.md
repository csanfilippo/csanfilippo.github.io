+++ 
draft = true
date = 2025-10-05T08:42:44+02:00
title = "Announcing aral: a multiplatform XML parser with a lightweight philosophy"
description = ""
slug = "aral-is-here"
authors = ["Calogero Sanfilippo"]
tags = ["kotlin", "multiplatform", "xml", "release"]
categories = []
externalLink = ""
series = []
+++

I’m happy to share something I’ve been working on: **aral**, a Kotlin Multiplatform library for parsing XML.

## The motivation

XML may not be the trendiest format, but it remains deeply embedded in the systems we rely on every day — from configuration files to data exchanges in healthcare, finance, and beyond.

When building with Kotlin Multiplatform, I found the existing XML tooling either too heavy or too tied to a single platform. What I wanted was something **lightweight, predictable, and consistent across environments**. That gap is what led to aral.

## The idea

aral takes a **push-based approach**: it emits a stream of events as the document is read.

This design keeps the library small and efficient, while giving developers the flexibility to decide how to handle the data. It’s not about doing everything — it’s about doing one thing well, and doing it everywhere Kotlin runs.

## The philosophy

aral is built on three principles:

- **Clarity**: a simple, event-driven API
- **Consistency**: the same behavior across Android, iOS, macOS, watchOS, and tvOS
- **Minimalism**: no unnecessary overhead, just the essentials

It’s a library shaped by the belief that tools should stay out of the way and let developers focus on their own logic.

## Learn more

The full documentation, installation instructions, and examples live on [GitHub](https://github.com/csanfilippo/aral).  
You’ll also find the package published on [Maven Central](https://search.maven.org/artifact/it.calogerosanfilippos/aral).

## Looking ahead

This is just the beginning. aral will continue to evolve, and I’d love to hear from anyone who tries it out. Feedback, ideas, and contributions are all welcome.

👉 You can also explore the [project page](/libs/aral) for an overview of the library’s story and philosophy.