# Stream Deck iconpack: System UIcons

This is a free iconpack for the [Elgato Stream Deck](https://www.elgato.com/en/stream-deck),
based on the clear and concise [System UIcons](https://systemuicons.com/) by
[Corey Ginnivan](https://corey.ginnivan.net/). Thanks, Corey!

The pack consists of 420 monochrome icons. 23 icons come with red/green
alternatives.

The resulting icons are 144×144 PNG files.

## Screenshot

![Screenshot of v1.1](dist/screenshot-1.1.png)

## If you're only interested in the icon pack

Check the [`dist/`](dist/) folder, download the latest version of the ZIP file,
extract to the `IconPacks/` directory in your local SD data folder. On macOS,
that's `$HOME/Library/Application Support/com.elgato.StreamDeck/IconPacks`.

## Why

I like clean, "readable" icons, preferrably on a black background. I'm over 40,
maybe there's a relation, what do I know.

## Build a new version of the icon pack

Run [`build.fish`](build.fish). Yes, it's a [fish](https://fishshell.com/)
script, meaning your machine needs to have it installed. There's a reason for
this decision, namely _"I like fish"_. 😉

The script will download the current version of System UIcons from the web,
build whatever is needed, copy the resulting icon pack into the local SD
`IconPacks/` data directory (optional), create a release file in
[`dist/`](dist/) (optional) and clean up after itself.

## Install dependencies

Run `brew install csvtk fd fish jq sd slugify librsvg`.

## Authors & License

This repository as well as the relatved icon packs are
[MIT licensed](LICENSE.md) by Carlo Zottmann ([website](https://czm.io),
[Github](https://github.com/carlo)).

The original [System UIcons](https://systemuicons.com/)
([Github](https://github.com/CoreyGinnivan/system-uicons)) by
[Corey Ginnivan](https://corey.ginnivan.net/) are released under
[The Unlicense](https://github.com/CoreyGinnivan/system-uicons/blob/master/LICENSE).
I'd like to thank Corey for his generous work.
