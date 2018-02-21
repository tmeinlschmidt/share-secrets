#!/usr/bin/env bash

file=${1:?Specify file to encrypt}
out_file=${2:-${file}.enc}
basename=$(basename $out_file)
access_file=$(echo $out_file | sed -e "s/$basename/.$basename.owners/g")

me="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cert_path=${me}/../certs
openssl=$(hash brew 2>/dev/null && brew ls openssl | grep '/bin/openssl' || echo $(which openssl))
#certs=$(ls ${cert_path}/*.pem | sed "s|^|${cert_path}/|" | tr '\n' ' ')
certs=$(ls ${cert_path}/*.pem | tr '\n' ' ')

# encrypt
>&2 echo "Encrypting file ${file} to ${out_file}"

${openssl} smime -encrypt -aes256 -in ${file} -out ${out_file} -outform PEM ${certs}

# write to owners
ls ${cert_path}/*.pem | egrep -o "([^/]*)\.pem" | cut -d'.' -f 1 > ${access_file}
