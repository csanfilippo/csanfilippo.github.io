+++
date = '2026-07-26T10:00:00+02:00'
draft = false
title = 'CardStore 2.0.0 Released'
description = "CardStore 2.0.0 is a full rewrite of the original 2014 app: SwiftUI throughout, a GRDB-backed store, and automatic migration from the old data."
slug = "cardstore-200-released"
authors = ["Calogero Sanfilippo"]
tags = ["swift", "swiftui", "apps", "release"]
externalLink = ""
+++

Version **2.0.0** of CardStore is out on iOS.

The original CardStore dates back to 2014 — Objective-C-era Core Data, callback-based persistence, the works. 2.0.0 is a full rewrite: SwiftUI throughout, Swift's newer concurrency, and a different storage layer underneath.

### From Core Data to GRDB
The old app stored cards in Core Data through a hand-rolled `NSPersistentStoreCoordinator` setup. The new one uses [GRDB](https://github.com/groue/GRDB.swift) on top of SQLite, with a `DatabaseMigrator` that's grown by three small migrations as features were added: create the table, add a color column, add a usage counter. Easier to reason about, and easier to extend without touching a `.xcdatamodeld` file.

### Migrating in place
If you had the old app installed, migration runs once at launch: the legacy Core Data store is read, its cards are inserted into the new database, and the legacy rows are deleted afterward. No prompt, no "import your data" screen — it happens before the UI ever appears.

### Rendering barcodes
Barcode generation splits by code type: QR and Aztec codes go through Core Image's own generators (`CIQRCodeGenerator`, `CIAztecCodeGenerator`), while linear formats like EAN-13, Code128, and PDF417 are handled by [ZXingObjC](https://github.com/csanfilippo/zxingify-objc). Both paths end up rasterized to a plain `UIImage`, so SwiftUI just displays it.

### Small things that add up
Opening a card pushes screen brightness to maximum for as long as the view is on screen and restores the original value on the way out, so barcodes scan on the first try at checkout. Each view of a card also increments a usage count, stored alongside the card — nothing fancy, just enough to know which cards actually get used.

### Installation
CardStore 2.0.0 is available on the [App Store](https://apps.apple.com/it/app/cardstore/id957226651).
