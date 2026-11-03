+++
date = '2026-11-03T16:40:00+01:00'
draft = false
title = 'oxus'
summary = "An MCP server that exposes macOS Spotlight search to MCP clients over stdio"
repository = 'https://github.com/csanfilippo/oxus'
programmingLanguage = 'Swift'
+++

{{< figure-dynamic
dark-src="/images/oxus-logo-dark.svg"
light-src="/images/oxus-logo-light.svg"
alt="oxus logo"
width="320"
style="text-align: left"
>}}

**oxus** is an [MCP](https://modelcontextprotocol.io) server that gives MCP clients, such as Claude Code and Claude Desktop, access to macOS Spotlight search. It runs locally over stdio and returns the paths of the files Spotlight has indexed.

## Why oxus?

oxus started as an experiment: building software test-first, with an AI as my pair. The experiment needed a problem small enough to finish, and a Spotlight MCP server was it.

Every Mac already keeps an index of its files, yet an agent looking for a document usually ignores it and crawls the disk with `find`. oxus puts that index behind two MCP tools, so a client can ask Spotlight directly.

## The approach

- **Two tools**: `spotlight_query` runs a raw [Spotlight query](https://developer.apple.com/library/archive/documentation/Carbon/Conceptual/SpotlightQuery/Concepts/QueryFormat.html); `search` finds files by name, kind and folder, with no query syntax to learn
- **Native**: written in Swift on the official [MCP Swift SDK](https://github.com/modelcontextprotocol/swift-sdk), calling Spotlight through CoreServices' `MDQuery`
- **Honest about privacy protection**: when macOS denies access to Downloads, Documents or Desktop, Spotlight silently leaves their files out; oxus reports each denied folder and the System Settings switch that grants access
- **Errors a client can act on**: a folder that does not exist, is a file, is a package or cannot be read returns an error naming the path and the fix, never an empty list
- **Signed and notarized**: one binary, installed with Homebrew or downloaded from each release

```sh
brew install csanfilippo/tap/oxus
claude mcp add oxus -- /opt/homebrew/bin/oxus
```

## Philosophy

oxus returns paths, never file contents, and makes no network requests. It does one thing: it lets a client ask Spotlight where a file is. Anything beyond that, such as reading or moving files, is left to the tools the client already has.

It was built test-first, increment by increment, with Claude as my pair. Every behaviour is covered by tests at three levels: the protocol, against fake adapters; the adapters, against real Spotlight; and the whole server, end to end.

## Learn more

- 📖 Tools, arguments, privacy notes and troubleshooting are on [GitHub](https://github.com/csanfilippo/oxus)
- Released under the MIT License
- Backstory: [the release post](/posts/oxus-released/)
