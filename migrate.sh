#!/bin/sh

set -e

find $@ -exec sh -c 'for f; do
  cf=$f
  js="${f%.coffee}.js"

  # replace for loops with lodash
  gsed -E -i "s/for (\w+) in (\w+)/_.each \2, (\1) ->/g" $f
  gsed -E -i "s/for (\w+), index in (\w+)/_.each \2, (\1, index) ->/g" $cf

  # convert to javascript
  decaffeinate $cf --keep-commonjs --prefer-const

  # keep the git history
  mv $js $cf
  git mv $cf $js

  # apply style conventions
  ./node_modules/.bin/eslint $js --fix

  # beautify
  js-beautify -r -f $js

  # fix import / export
  gsed -E -i "s/import (\w+) from (.*)/const \1 = require(\2)/g" $js
  gsed -E -i "s/export function (\w+)/exports.\1 = function/g" $js
  gsed -E -i "s/export default /module.exports = /g" $js

  # replace let with const
  gsed -E -i "s/^(\s*)let /\1const /g" $js

  # remove unneeded newline
  gsed -E -i "s/^(\s*)}\n\s*\)/\1})/g" $js

  # remove unneeded returns
  gsed -E -i "s/return done\(/done(/g" $js
  gsed -E -i "s/return it\(/it(/g" $js
  gsed -E -i "s/return describe\(/describe(/g" $js

done' _ {} +
