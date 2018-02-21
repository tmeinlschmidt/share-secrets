#!/usr/bin/env bash

priv_key=${1:?Specify private key, eg ~/.ssh/id_rsa}

isid=$(whoami)
me="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cert_path=${me}/../certs
openssl=$(hash brew 2>/dev/null && brew ls openssl | grep '/bin/openssl' || echo $(which openssl))

echo "Generating certificate from private key '${private_key} for isid '${isid}"
${openssl} req -x509 -new -key ${priv_key} -days 3650 -nodes -subj "/C=US/ST=*/L=*/O=*/OU=*/CN=${isid}/" -out ${cert_path}/$isid.pem
echo "${priv_key}" > ${cert_path}/${isid}.meta
echo "...Done!"
