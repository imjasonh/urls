#! /usr/bin/env bash

while read l; do
  fn=${l#"https://"}
  echo $fn
  mkdir -p $(dirname $fn)
  curl -o $fn $l
done < urls.txt
