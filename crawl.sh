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

tmp=$(mktemp)

# Sort keys for better diffs.
jq -S '.' www.googleapis.com/oauth2/v1/certs > ${tmp} && mv ${tmp} www.googleapis.com/oauth2/v1/certs
jq -S '.keys |= sort_by(.kid)' appleid.apple.com/auth/keys > ${tmp} && mv ${tmp} appleid.apple.com/auth/keys
jq -S '.keys |= sort_by(.kid)' www.googleapis.com/oauth2/v2/certs > ${tmp} && mv ${tmp} www.googleapis.com/oauth2/v2/certs
jq -S '.keys |= sort_by(.kid)' www.googleapis.com/oauth2/v3/certs > ${tmp} && mv ${tmp} www.googleapis.com/oauth2/v3/certs

# Ignore changes where rate limit is exceeded.
if grep "API rate limit exceeded" api.github.com/meta; then git checkout -- api.github.com/meta; fi
