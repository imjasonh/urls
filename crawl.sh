#! /usr/bin/env bash

set -euo pipefail

while read l; do
  [[ -z $l ]] && continue
  [[ $l =~ ^#.* ]] && continue

  fn=${l#"https://"}
  echo $fn
  mkdir -p $(dirname $fn)
  curl -s $l | jq > $fn
  if [ "$(jq 'has("keys")' $fn)" == "true" ]; then
    jq -S -s 'sort_by(.keys[].kid)' $fn > ${TMPDIR}/out && mv ${TMPDIR}/out $fn
  fi
  if grep -q "BEGIN CERTIFICATE" $fn; then
    jq -S '.' $fn > ${TMPDIR}/out && mv ${TMPDIR}/out $fn
  fi
done < urls.txt
