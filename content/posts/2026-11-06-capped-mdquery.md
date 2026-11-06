+++
date = '2026-11-06T01:30:00+01:00'
draft = false
title = 'MDQuerySetMaxCount can lose most of your Spotlight results'
description = "A capped MDQuery on kMDItemDisplayName can silently return a fraction of its matches, even when the cap is above the total: how to reproduce it, and the fix in oxus"
slug = "capped-mdquery"
authors = ["Calogero Sanfilippo"]
tags = ["swift", "oxus", "macos"]
toc = true
+++

[oxus](/tools/oxus/) 0.3.0 added `truncated`, a flag that tells an MCP client when `limit` has cut a result short. The plan was cheap: ask Spotlight for `limit + 1` results with `MDQuerySetMaxCount`, and if the extra result arrives, more matches exist.

All 125 tests passed, and the feature didn't work.

## The symptom

Against the real binary, a `search` for `.app` with a limit of 100 returned 3 paths and no `truncated`. More than a thousand items matched. A `search` for `photo` returned 2 paths.

Nothing failed. `MDQueryExecute` returned `true`, and a list of 3 paths looks like a complete answer to a narrow search. The released 0.2.1 returned the same 3 paths, so the problem was older than `truncated`. It had just never been visible.

## Reproducing it

```swift
import CoreServices
import Foundation

func count(_ text: String, cap: Int? = nil) -> Int {
    let query = MDQueryCreate(kCFAllocatorDefault, text as CFString, nil, nil)!
    if let cap { MDQuerySetMaxCount(query, cap) }
    _ = MDQueryExecute(query, CFOptionFlags(kMDQuerySynchronous.rawValue))
    return MDQueryGetResultCount(query)
}

for name in ["photo", ".app", "report", "config"] {
    for attribute in ["kMDItemDisplayName", "kMDItemFSName"] {
        let text = #"\#(attribute) == "*\#(name)*"cd"#
        print(text, "cap 5000:", count(text, cap: 5000), "no cap:", count(text))
    }
}
```

```sh
swiftc capped.swift -o capped && ./capped
```

A cap of 5,000 is above every total here, so it should change nothing:

| Name | `kMDItemDisplayName`, cap 5,000 | `kMDItemDisplayName`, no cap | `kMDItemFSName`, cap 5,000 | `kMDItemFSName`, no cap |
|---|---|---|---|---|
| `photo` | 1 | 388 | 389 | 389 |
| `.app` | 1 | 1,068 | 1,471 | 1,471 |
| `report` | 2 | 356 | 356 | 356 |
| `config` | 11 | 1,687 | 1,685 | 1,685 |

These numbers come from one Mac on macOS 27.2, so yours will differ. They also move on the same machine: `apple` with a cap of 101 gave 76, 75 and 74 in three consecutive runs, against 5,697 matches.

Apple's `MDQuery.h` says only that `MDQuerySetMaxCount` limits "the number of results returned by the query engine", and calls the value "the maximum number of results desired". It never promises that a capped query finds every match up to the cap, so I call this undocumented behaviour rather than a bug.

## What matters

Only the combination of a cap and `kMDItemDisplayName` comes back short. Without a cap, `kMDItemDisplayName` returns every match. With a cap, `kMDItemFSName` filled it or returned every match for every name I tried. The match flags don't help: `.app` comes back short with `cd`, `c` and no flags alike.

I don't know why. My untested guess is that Spotlight applies the cap first and finishes matching display names afterwards, discarding results it has already counted. Display names are localised, so they may be handled differently from file names.

I had measured the cap before adopting it: 0.03 s against 2.9 s on a broad name search. That measurement used `kMDItemFSName`, though, and `search` queries `kMDItemDisplayName`.

## The fix and its cost

oxus no longer calls `MDQuerySetMaxCount`. It runs the whole query and keeps the first `limit` results:

```swift
let resultCount = MDQueryGetResultCount(spotlightQuery)

let paths = (0..<min(resultCount, limit.value)).compactMap { index in
    let item = Unmanaged<MDItem>.fromOpaque(MDQueryGetResultAtIndex(spotlightQuery, index)).takeUnretainedValue()
    return MDItemCopyAttribute(item, kMDItemPath) as? String
}

return SpotlightMatches(paths: paths, truncated: resultCount > limit.value)
```

Now a search pays for every match. Typical names take 10 to 40 ms, but a one-letter `search` takes between 1.3 and 5.8 s, and queries run one at a time, so a slow one delays whatever is waiting behind it.

I rejected the two alternatives:

- **Retry without the cap when a capped query stays under it.** That puts two paths through one operation, only to keep one-letter searches fast.
- **Switch to `kMDItemFSName`.** `search` matches the display name on purpose: it finds Calculator as "calcolatri" on an Italian Mac, and "pdf" doesn't match every PDF. `spotlight_query` takes raw queries anyway, so it would stay exposed.

## Why the tests stayed green

This is the fake behind the server tests:

```swift
func search(query: Query, limit: Limit, folder: Folder?) async throws(SpotlightError) -> SpotlightMatches {
    let truncated = result.count > limit.value
    return SpotlightMatches(paths: Array(result.prefix(limit.value)), truncated: truncated)
}
```

This fake cuts a result down to `limit` with `prefix`, so it can only ever return `limit` paths or every match. I assumed the real cap did the same, and the fake turned that assumption into code. The server tests run against the fake, so they could never catch it.

The tests against real Spotlight missed it too. Most of them query `kMDItemFSName`, and the acceptance tests that search by display name check whether `Finder.app` is in the result, not how many paths come back.

In the [release post](/posts/oxus-released/) I wrote that every behaviour a fake assumes has a matching adapter test, so the fakes cannot drift away from macOS. That only works for the assumptions you know you are making, and I had never thought of this one as an assumption.

## Learn more

- The measurements and the decisions are in [increment 12](https://github.com/csanfilippo/oxus/blob/main/docs/increments/012-truncated-results.md).
- `truncated` shipped in 0.3.0, and since 0.4.0 every result carries it.
