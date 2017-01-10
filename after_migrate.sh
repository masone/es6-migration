#!/bin/sh

set -e

# Sanity checks

#echo "\n\n--> Using lodash but require is missing. Add: const _ = require('lodash')"
#grep -Rl --exclude-dir=node_modules '_\.' . | xargs grep -L 'lodash'

echo "\n\n--> Check if the following explicit returns are needed:"
grep -Rl --exclude-dir=node_modules 'return' .

echo "\n\n--> String coffee found:"
grep -Rl --exclude-dir=node_modules 'coffee' .

echo "\n\n--> Multiline require found:"
grep -Rl --exclude-dir=node_modules 'require(`\\' .
