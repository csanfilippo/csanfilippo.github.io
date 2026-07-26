+++
date = '2026-05-03T10:00:00+02:00'
draft = false
title = "aral 1.0.0: first stable release with namespace support"
description = "aral 1.0.0: first stable release with namespace support"
slug = "aral-100-released"
authors = ["Calogero Sanfilippo"]
tags = ["kotlin", "kotlin-multiplatform", "xml", "jvm", "aral", "release"]
externalLink = ""
series = []
+++

**aral 1.0.0** is out, marking the library's first stable release.

The main addition in this version is full **namespace support** for both the JVM/Android (SAX) and Apple (`NSXMLParser`) backends. `ElementStartFound` and `ElementEndFound` events now carry two additional fields:

- `namespaceURI: String?` — the namespace URI declared for that element, or `null` if absent
- `localName: String` — the unprefixed name (e.g. `creator` for `dc:creator`)

## Why this matters

Without namespace awareness, distinguishing between two `title` elements from different vocabularies in the same document requires brittle prefix-matching. With 1.0.0, the parser surfaces the URI directly, so the structure of the document drives the logic — not the prefix conventions an author happened to choose.

Consider an Atom feed that mixes entries with Dublin Core metadata:

```xml
<feed xmlns="http://www.w3.org/2005/Atom"
      xmlns:dc="http://purl.org/dc/elements/1.1/">
  <title>Engineering Notes</title>
  <entry>
    <title>Parsing XML across platforms</title>
    <dc:creator>Calogero Sanfilippo</dc:creator>
    <dc:subject>Kotlin Multiplatform</dc:subject>
  </entry>
</feed>
```

With the new fields you can handle each vocabulary independently:

```kotlin
val atomNS = "http://www.w3.org/2005/Atom"
val dcNS   = "http://purl.org/dc/elements/1.1/"

xmlParser.parse(feedXml).collect { event ->
    when (event) {
        is XMLParserEvent.ElementStartFound -> {
            when {
                event.namespaceURI == atomNS && event.localName == "title" ->
                    println("Atom title element")

                event.namespaceURI == dcNS && event.localName == "creator" ->
                    println("Dublin Core creator element")

                event.namespaceURI == dcNS && event.localName == "subject" ->
                    println("Dublin Core subject element")
            }
        }
        is XMLParserEvent.CharactersFound ->
            println("  text: ${event.characters}")

        else -> {}
    }
}
```

The dispatch is on stable, well-known URIs — prefix aliases (`dc:`, `atom:`, or any other convention) are irrelevant.

## Breaking change

If you are upgrading from 0.x, the constructor signature of `ElementStartFound` and `ElementEndFound` has changed. Code that pattern-matches on these events and ignores the new fields will still compile; code that constructs them directly (e.g. in tests) will need to supply `namespaceURI` and `localName`.

## Known limitation

Attributes are currently mapped by local name only. If two attributes from different namespaces share the same local name within a single element, they will collide. This is a known constraint and will be addressed in a future release.

## Installation

```kotlin
commonMain {
    dependencies {
        implementation("it.calogerosanfilippos:aral:1.0.0")
    }
}
```

Full release notes are on [GitHub](https://github.com/csanfilippo/aral/releases/tag/1.0.0).
