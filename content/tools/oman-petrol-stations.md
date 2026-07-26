+++
date = '2026-07-26T10:00:00+02:00'
draft = false
title = 'oman-petrol-stations'
summary = "A Swift CLI for macOS that maps every petrol station in Oman from the three major providers"
aliases = ["/projects/oman-petrol-stations/"]
+++

**oman-petrol-stations** is a small Swift command line tool for macOS that downloads location and metadata for every petrol station operated by the three main Omani providers — Oman Oil, Shell, and Al Maha — and exports the result as CSV or KML.

## Why oman-petrol-stations?

While driving south from Wahiba Sands to the Sugar Dunes, I noticed petrol stations became sparse and hard to plan around. Having already felt the anxiety of hunting for a working pump during the [2025 Iberian Peninsula blackout](https://en.wikipedia.org/wiki/2025_Iberian_Peninsula_blackout), I didn't want to repeat that experience in the middle of the desert.

Each provider — Oman Oil, Shell, Al Maha — publishes its station locations through its own website, in its own format, with no shared or public dataset. oman-petrol-stations fetches from all three sources and normalizes them into one file you can load into any mapping tool before you leave signal range.

## The approach

- **Three sources, one format**: fetches station data from Oman Oil, Shell, and Al Maha, and normalizes it into a single schema
- **CSV or KML**: export to CSV for spreadsheets, or KML to open directly in Google Earth or any KML viewer
- **Selective fetching**: pick which providers to query with `--petrol-company-list`, instead of always hitting all three
- **Runs locally**: no server, no API key, no account — just a binary that talks to the same public endpoints the providers' own maps use

```bash
git clone https://github.com/csanfilippo/oman-petrol-stations.git
cd oman-petrol-stations
swift run oman-petrol-stations --output-file-path stations.kml
```

An example of the KML file the tool produces can be found [here](/files/stations.kml).

## Philosophy

This is a personal, offline, research-use tool, not a service — it doesn't cache, sync, or phone home. It exists to answer one question before a drive: where can I get fuel between here and there. Everything else was left out on purpose.

## Learn more

- 📖 Source, installation instructions, and the full option list are on [GitHub](https://github.com/csanfilippo/oman-petrol-stations)
- Released under the MIT License
- Backstory: [the original announcement](/posts/oman-petrol-stations-released) and the [v1.2.0 changelog](/posts/new-oman-petrol-stations-released)
