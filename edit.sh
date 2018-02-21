#!/usr/bin/env bash

set -euo pipefail

edit=true

while getopts ":rh" opt; do
  case $opt in
    # recrypt
    r)
      echo "recrypt"
      edit=false
      shift
      ;;
    h)
      echo "$0 [-r to recrypt] file"
      exit 1
      ;;
  esac
done

file=${1:?Specify file to edit}

me="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
basename=$(basename ${file})
tmpdir=$(mktemp -d)
temp_file="$(mktemp "${tmpdir}/${basename}.XXXXXX")"
editor=${EDITOR:-vim}

function cleanup() {
  rm -rf $tmpdir
}

trap cleanup EXIT INT


if [ -f $file ]; then
  ${me}/scripts/decrypt.sh ${file} > $temp_file
fi

[ "${edit}" = true ] && ${editor} ${temp_file}

${me}/scripts/encrypt.sh ${temp_file} ${file}
