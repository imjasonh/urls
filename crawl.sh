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

# sort keys for better diffs
jq -S '.' www.googleapis.com/oauth2/v1/certs > ${tmp} && mv ${tmp} www.googleapis.com/oauth2/v1/certs

# sort keys and items for better diffs
jq -S '.keys = (.keys | sort_by("kid"))' www.googleapis.com/oauth2/v2/certs > ${tmp} && mv ${tmp} www.googleapis.com/oauth2/v2/certs 
jq -S '.keys = (.keys | sort_by("kid"))' www.googleapis.com/oauth2/v3/certs > ${tmp} && mv ${tmp} www.googleapis.com/oauth2/v3/certs 
