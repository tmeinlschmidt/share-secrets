#!/usr/bin/env bash

file=${1:?Specify file to decrypt}
basename=$(basename $file)
access_file=$(echo $file | sed -e "s/$basename/.$basename.owners/g")

isid=$(whoami)
has_access=$(egrep "^${isid}$" ${access_file} >/dev/null || echo 1)

if [ ! ${has_access} = true ]; then
  >&2 echo "Can't decrypt $file, $isid has no access!"
  exit 1
fi

me="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cert_path=${me}/../certs
openssl=$(hash brew 2>/dev/null && brew ls openssl | grep '/bin/openssl' || echo $(which openssl))

key=$(cat ${cert_path}/${isid}.meta)

>&2 echo "Decrypting ${file} using ${key}"

if [ "${TEAMPWD}" = '' ]; then
  ${openssl} smime -decrypt -in ${file} -inform PEM -inkey ${key}
else
  ${openssl} smime -decrypt -in ${file} -inform PEM -inkey ${key} -passin env:TEAMPWD
fi
