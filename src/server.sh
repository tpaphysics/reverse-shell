#!/usr/bin/env bash

# Author : Chewbacca
# Licensed WTF

PORT="80"

[[ $EUID -ne 0 ]] && {
    echo "Esse script deve ser executado como root." 1>&2
    exit 1
}

wget -q --tries=10 --timeout=20 --spider http://google.com
[ $? != 0 ] && {
    echo "Você está offline, verifique sua conexão!"
    exit 1
}

command -v socat >/dev/null 2>&1 || {
    echo >&2 "O 'socat' não está instalado em seu sistema!"
    exit 1
}

if [[ ! -f server.pem ]]; then

    command -v openssl >/dev/null 2>&1 || {
        echo >&2 "O 'openssl' não está instalado em seu sistema, abortar operação!!"
        exit 1
    }

    echo -e "\n[+] generando novo certificado ssl e priv.key\n"

    sleep 3

    openssl req -x509 -sha256 -newkey rsa:2048 -keyout server.pem -out server.pem -days 1000 -nodes -subj "/C=NA/ST=NARNIA/L=HIDDEN/O=Global Security/OU=IT Department/CN=hidden.onion"

    sleep 3

    echo -e "\n\033[0;34m[*] certificado gerado com sucesso!!\033[0m"

    sleep 3
fi

echo -e "[+] escutando na porta $PORT ...\n"

socat $(tty),raw,echo=0 openssl-listen:$PORT,reuseaddr,cert=server.pem,verify=0

echo "[+] excuilndo os certificados!!"

rm -rf server.pem

exit
