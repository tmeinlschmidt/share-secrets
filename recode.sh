#!/usr/bin/env bash

set -euo pipefail

while getopts ":h" opt; do
  case $opt in
    h)
      echo "$0 path_to_files (default data/*)"
      exit 1
      ;;
  esac
done

filedir=${1:-data/*}
tmpdir=$(mktemp -d)
me="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function cleanup() {
  rm -rf $tmpdir
  unset TEAMPWD
}

trap cleanup EXIT INT


# read password
echo "Enter password to your private key"
read -s TEAMPWD
export TEAMPWD

for file in `ls ${filedir}`; do

  basename=$(basename ${file})
  temp_file="$(mktemp "${tmpdir}/${basename}.XXXXXX")"

  >&2 echo "Processing '${basename}'..."

  [ -f $file ] && ${me}/scripts/decrypt.sh ${file} > $temp_file

  ${me}/scripts/encrypt.sh ${temp_file} ${file}

  >&2 echo "Done"
done
