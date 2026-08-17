+++
date = '2026-01-20T11:45:25+01:00'
draft = false
title = 'oman-petrol-stations: a Swift CLI tool to locate petrol stations in Oman'
description = "Oman petrol stations: a Swift CLI tool to locate petrol stations in Oman"
slug = "oman-petrol-stations-released"
authors = ["Calogero Sanfilippo"]
tags = ["swift", "oman", "travel", "cli", "open-source"]
+++

Traveling is one of the things I enjoy the most in my life. Recently I had the chance to visit Oman, a beautiful country with stunning landscapes and rich culture.

One leg of my trip involved driving south from Wahiba Sands to the Sugar Dunes area. 
While planning the route, I noticed that petrol stations were quite sparse in the southern part of the country. 
This made me a bit anxious, as I didn’t want to run out of fuel in the middle of nowhere.

I experienced the fear of remaining without fuel during the famous [2025 blackout in Spain](https://en.wikipedia.org/wiki/2025_Iberian_Peninsula_blackout), where we remained without electricity for an entire day and I had to drive around looking for petrol stations that were still operational.

Being a nerd, I embarked on a mission to create a Swift script that would assist me in locating petrol stations along my journey.
In Oman there are three major petrol station chains: [Oman Oil](https://www.oomco.com/), [Shell Oman](https://www.shell.com.om/) and [al Maha](https://www.almaha.com.om/en). 
I delved into their websites, meticulously analyzing their petrol station location information. Through this process, I discovered the services employed to display petrol stations on their maps.

This is the genesis of my new Swift project, which I named "Oman Petrol Stations".

It's a very simple CLI tool that fetches petrol station data from the three major chains in Oman and saves them into a KML file.

You can find the project on my [GitHub repository](https://github.com/csanfilippo/oman-petrol-stations)

To run the cli, just clone the repository and execute the following command in the terminal:

```bash
swift run oman-petrol-stations --output-file-path stations.kml
```

The script will generate a `stations.kml` file in the current directory, which you can open with Google Earth or any other KML viewer. An example of the KML file produced by the script can be found [here](/files/stations.kml).

Below is a map highlighting the primary destinations of my trip, along with two petrol stations I visited along the way.

<iframe title="Oman 25/26" aria-label="Locator map" id="datawrapper-chart-EQzFM" src="https://datawrapper.dwcdn.net/EQzFM/1/" scrolling="no" frameborder="0" style="width: 0; min-width: 100% !important; border: none;" height="520" data-external="1"></iframe><script type="text/javascript">window.addEventListener("message",function(a){if(void 0!==a.data["datawrapper-height"]){var e=document.querySelectorAll("iframe");for(var t in a.data["datawrapper-height"])for(var r,i=0;r=e[i];i++)if(r.contentWindow===a.source){var d=a.data["datawrapper-height"][t]+"px";r.style.height=d}}});</script>