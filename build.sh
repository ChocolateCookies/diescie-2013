#!/bin/bash

# build sass
cd styles/
sass main.scss:main.css
cd ../

# compile the scripts directory
coffee --compile scripts/

# optimize to a single file
# requires a global require.js installation
r.js -o baseUrl='scripts/' name='main_index' out='scripts/main_index-built.js' mainConfigFile='scripts/main.js'
