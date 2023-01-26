#! /usr/bin/env bash

set -euo pipefail

while read l; do
  [[ -z $l ]] && continue
  [[ $l =~ ^#.* ]] && continue

  fn=${l#"https://"}
  echo $fn
  mkdir -p $(dirname $fn)
  curl -s $l | jq > $fn
done < urls.txt
