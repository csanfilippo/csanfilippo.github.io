+++
date = '2025-10-05T08:24:17+02:00'
draft = false
title = 'aral'
summary = "A multiplatform XML parser with a lightweight, event-driven design"
+++

**aral** is a Kotlin Multiplatform library for parsing XML — but more than that, it’s an attempt to make working with structured data across platforms feel natural, lightweight, and modern.

## Why aral?

XML is everywhere: in legacy systems, configuration files, and data exchanges that still power critical infrastructure. Yet, for developers building with Kotlin Multiplatform, the tooling around XML has often felt fragmented or heavy.

**aral** was born from a simple idea:
> parsing XML should be as seamless across platforms as writing the code itself.

Instead of binding you to a single platform’s parser, aral provides a **unified, event-driven approach** that works the same way on Android, iOS, macOS, watchOS, and tvOS. It’s designed to be minimal, reactive, and easy to integrate into modern Kotlin projects.

## The approach

At its core, aral is a **push parser**. That means it doesn’t try to build a giant in-memory tree of your XML. Instead, it emits a stream of events — “document started,” “element opened,” “characters found,” and so on — that you can react to in real time.

This makes it:

- **Lightweight**: no unnecessary overhead
- **Predictable**: you decide how to handle events
- **Multiplatform**: the same code runs everywhere

## Philosophy

aral is intentionally small. It doesn’t aim to be the most feature-rich XML toolkit, but rather a **reliable foundation**: a parser you can trust to do one thing well, and do it consistently across platforms.

It’s also a project that embraces **clarity and minimalism** — in its API, in its design, and even in its name.

## Learn more

- 📖 Full documentation, installation instructions, and examples are on [GitHub](https://github.com/csanfilippo/aral)
- 📦 Available on [Maven Central](https://search.maven.org/artifact/it.calogerosanfilippos/aral)

## Closing note

aral is still young, but it’s built with care and an eye toward longevity. If you’re working with Kotlin Multiplatform and XML, I’d love for you to give it a try — and to share your feedback as the library grows.