# Docker FWBuilder

## Build on your own

```bash
APP_VERSION=v6.0.0-beta docker build --build-arg APP_VERSION=$APP_VERSION -t fwbuilder:$APP_VERSION .
```

## How to run

Connecting a container to a host's X server for display

```bash
docker run -e DISPLAY --rm -ti --net host rchicoli/fwbuilder:latest
```

## To do

  - write an entrypoint for flexible UID and GID
  - use travis for CI