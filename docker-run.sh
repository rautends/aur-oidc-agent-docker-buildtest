#!/bin/bash

./00clean.sh
docker build --no-cache -t my-pkgbuild-builder .
docker run -it --rm -v $(pwd)/.:/home/builder/ my-pkgbuild-builder
