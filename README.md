# Stream Deck icon pack builder

## Build "System UIcons" pack

Run [`build-system-uicons.fish`](build-system-uicons.fish).

The script will download the current version of System UIcons from the web,
build whatever is needed, copy the resulting icon pack into the local SD
`IconPacks/` data directory (optional), update the submodule folder in
[`dist/`](dist/) (optional) and clean up after itself.

## Install dependencies

Run `brew install csvtk fd fish jq sd slugify librsvg`.

## Authors & License

Carlo Zottmann ([website](https://czm.io), [Github](https://github.com/carlo)).
[MIT licensed](LICENSE.md).
