+++
date = '2026-11-03T16:40:00+01:00'
images = ['/images/oxus-social-preview.png']
draft = false
title = 'oxus: Spotlight search for MCP clients, built test-first with Claude'
description = "oxus: a Swift MCP server that exposes macOS Spotlight search to MCP clients, built increment by increment with TDD and Claude as a pair"
slug = "oxus-released"
authors = ["Calogero Sanfilippo"]
tags = ["swift", "oxus", "mcp", "macos", "release"]
toc = true
+++

## Why?

I wanted to find out what test-driven development feels like when the other half of the pair is an AI. I didn't want a code generator: I wanted a pair in the XP sense, someone to shape the design with, keep the test list honest and question each step.

An experiment like that needs a problem small enough to finish and real enough to be worth finishing. I chose an MCP server for Spotlight. I had been meaning to learn the [Model Context Protocol](https://modelcontextprotocol.io), and the problem was right there: every Mac already keeps an index of its files, yet an agent looking for a document usually crawls the disk with `find`.

[oxus](/tools/oxus/) gives MCP clients such as Claude Code and Claude Desktop direct access to that index through two tools:

- `spotlight_query` runs a raw Spotlight query.
- `search` finds files by name, kind and folder, with no query syntax to learn.

## Why Swift?

Spotlight's query API, `MDQuery`, lives in CoreServices. Swift calls it directly, with no bridge and no runtime to ship, and the official [MCP Swift SDK](https://github.com/modelcontextprotocol/swift-sdk) covers the protocol. The result is a single signed and notarized binary.

## How I built it

My pair was [Claude](https://claude.ai). Before writing any code, we worked out the idea, the scope and the increments that would get us there. Each increment has a short document (goal, contract, what is out of scope, open decisions) and a TDD test list next to it. Here is an excerpt from the first one:

```text
- [x] Acceptance test: a client queries `kMDItemFSName == "Finder.app"` over MCP and receives Finder's path
- [x] The server advertises spotlight_query as its only tool
- [x] Spotlight is asked for 100 results when the limit exceeds 100
- [x] A malformed query is rejected as an error result naming the query
- [x] Real Spotlight finds Finder.app by name
```

Then we worked through the list, one test at a time. I wrote the tests and the code. Claude was my pair and my reference: it dug through the SDK and CoreServices documentation when I needed it, reviewed what I wrote, and pushed back when the design drifted. An increment was finished when every test was green; only then did we move to the next one.

Increment zero was a walking skeleton: a `hello` tool, served over stdio and driven by a real MCP client in the tests. It proved the whole pipeline before a single line of Spotlight code existed. Ten increments later, oxus 0.2.0 is out.

## Under the hood

### Ports and adapters

The behaviour lives in the `OxusServer` module, which reaches macOS only through two protocols: `Spotlight` and `FileSystem`.

```swift
public protocol Spotlight: Sendable {
    func search(query: Query, limit: Limit, folder: Folder?) async throws(SpotlightError) -> [String]
}
```

`MacOSAdapters` implements them on top of `MDQuery` and `FileManager`. Dependencies point inward: the adapters know the server, the server never imports CoreServices, and the executable does nothing but wire the two together and connect them to stdio.

### Three layers of tests

- **Server tests** drive oxus through the SDK's in-memory transport and client, against fake adapters. They see exactly what a real client sees, so they survive any internal refactoring.
- **Adapter tests** run against real Spotlight, querying files that are always indexed, such as `Finder.app`. Every behaviour a fake assumes has a matching adapter test here, so the fakes cannot drift away from macOS.
- **Acceptance tests** connect an MCP client to the real adapters, end to end.

### The folders Spotlight keeps quiet about

The hardest problem had nothing to do with MCP. macOS privacy protection guards `~/Downloads`, `~/Documents` and `~/Desktop`, and when oxus lacks access, Spotlight does not fail. It silently leaves those files out.

An empty result that should not be empty is the worst kind of answer, because the client has no reason to doubt it. So every `spotlight_query`, and every `search` that could reach those folders, also returns `unreadableFolders`: each denied folder, together with the exact System Settings switch that grants access. Which app macOS asks about depends on who launched oxus: oxus itself under Claude Desktop, the terminal under Claude Code.

## The name

The Oxus is the ancient name of the Amu Darya, one of the great rivers of Central Asia. Its banks gave up the Oxus Treasure, a hoard of Achaemenid gold and silver now held at the British Museum. oxus does the same for your Mac: it digs through what Spotlight has indexed and brings the files you are looking for to the surface.

## Getting started

oxus requires macOS 27 on Apple silicon. Install it with Homebrew:

```sh
brew install csanfilippo/tap/oxus
```

Then register it with your client. For Claude Code:

```sh
claude mcp add oxus -- /opt/homebrew/bin/oxus
```

## Learn more

- The tools, their arguments, privacy notes and troubleshooting are documented on [GitHub](https://github.com/csanfilippo/oxus).
- The increments and their test lists are in [`docs/increments`](https://github.com/csanfilippo/oxus/tree/main/docs/increments).
