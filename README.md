# Stream Deck iconpack: system-uicons

This is a free iconpack for the [Elgato Stream Deck](https://www.elgato.com/en/stream-deck),
based on the clear and concise [System UIcons](https://systemuicons.com/) by
[Corey Ginnivan](https://corey.ginnivan.net/). Thanks, Corey!

The resulting icons are 144×144 PNG files.

## If you're only interested in the icon pack

Check the [`dist/`](dist/) folder, download the latest version of the ZIP file,
extract to the `IconPacks/` directory in your local SD data folder. On macOS,
that's `$HOME/Library/Application Support/com.elgato.StreamDeck/IconPacks`.

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
