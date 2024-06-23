#!/bin/bash

# Run cleanup script
./00clean.sh

# Define the build commands in a reusable format
build_with_buildx_commands="
    docker buildx create --name mybuilder --use &&
    docker buildx build --platform linux/amd64 --no-cache -t my-pkgbuild-builder . --load &&
    docker buildx rm mybuilder
"

build_with_dind_commands="
    docker run --privileged --rm \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v $(pwd):/workspace \
      -w /workspace \
      docker:26.1.4-dind-alpine3.20 \
      sh -c '
        echo \"Inside docker-in-docker container\"
        $build_with_buildx_commands
      '
"

build_with_buildx() {
    echo "Using docker buildx..."
    eval "$build_with_buildx_commands"
}

build_with_dind() {
    echo "Using docker-in-docker with buildx..."
    eval "$build_with_dind_commands"
}

# Parse command-line arguments
BUILD_MODE="auto"
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --build)
            BUILD_MODE="$2"
            shift
            ;;
        *)
            echo "Unknown parameter passed: $1"
            exit 1
            ;;
    esac
    shift
done

# Determine build method based on command-line arguments
case $BUILD_MODE in
    buildx)
        build_with_buildx
        ;;
    dind)
        build_with_dind
        ;;
    auto)
        if docker buildx version >/dev/null 2>&1; then
            build_with_buildx
        else
            echo "docker buildx is not available locally. Falling back to docker-in-docker with buildx..."
            build_with_dind
        fi
        ;;
    *)
        echo "Invalid build mode specified: $BUILD_MODE"
        exit 1
        ;;
esac

# Check for errors in the previous step
if [ $? -ne 0 ]; then
    echo "Error occurred during the build process."
    exit 1
fi

# Run the container
docker run -it --rm -v "$(pwd)":/home/builder/ my-pkgbuild-builder
