#!/bin/bash

if [ -f .env ]; then
    source .env
fi

GO_IMAGE=${GO_IMAGE:-golang:1.15.0}

if [ "$KOOL_VERSION" == "" ]; then
    echo "missing environment variable KOOL_VERSION"
    exit 5
fi

rm -rf dist
mkdir -p dist

# ATTENTION - binary names must match the -GOOS-GOARCH suffix
# because self-update relies on this pattern to work.
BUILD=(\
  "dist/kool-darwin-amd64|--env GOOS=darwin --env GOARCH=amd64" \
  "dist/kool-linux-amd64|--env GOOS=linux --env GOARCH=amd64" \
  "dist/kool-linux-arm6|--env GOOS=linux --env GOARCH=arm --env GOARM=6" \
  "dist/kool-linux-arm7|--env GOOS=linux --env GOARCH=arm --env GOARM=7" \
  "dist/kool-windows-amd64.exe|--env GOOS=windows --env GOARCH=amd64" \
)

for i in "${!BUILD[@]}"; do
    dist=$(echo ${BUILD[$i]} | cut -d'|' -f1)
    flags=$(echo ${BUILD[$i]} | cut -d'|' -f2)
    echo "Building to ${flags}"
    docker run --rm \
        $flags \
        --env CGO_ENABLED=0 \
        -v $(pwd):/code -w /code $GO_IMAGE \
        go build -a -tags 'osusergo netgo static_build' \
        -ldflags '-X kool-dev/kool/cmd.version='$KOOL_VERSION' -extldflags "-static"' \
        -o $dist
done

echo "Building kool-install.exe"

cp dist/kool-windows-amd64.exe dist/kool.exe

docker run --rm -i \
    -v $(pwd):/work \
    amake/innosetup /dApplicationVersion=$KOOL_VERSION inno-setup/kool.iss
mv inno-setup/Output/mysetup.exe dist/kool-install.exe

echo "Going to generate CHECKSUMS"

for file in dist/*; do
    shasum -a 256 $file > $file.sha256
done
