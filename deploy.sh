#!/bin/bash

echo "Building the latest dev"
./build.sh

echo "Removing old build"
rm -rf build/

echo "Creating new build"
mkdir build/

echo "Copying files..."
cp -r index.html images/ fonts/ audio/ build/

# create dirs for selected files
mkdir build/scripts/ build/styles/ build/vendor/

# copy selected files to build
cp scripts/main_index-built.js build/scripts/
cp styles/main.css build/styles/
cp vendor/require.js build/vendor/
