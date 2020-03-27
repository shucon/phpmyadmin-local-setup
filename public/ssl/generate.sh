#!/bin/bash

# Source: https://github.com/chio-nzgft/docker-MariaDB-with-SSL

rm *.pem

SUBJECT_CA="/C=FR/O=Williamdes/OU=Docker/CN=ssl.williamdes.local/emailAddress=williamdes@wdes.fr"
SUBJECT_CLIENT="/C=FR/O=Williamdes/OU=Docker/CN=client.williamdes.local/emailAddress=williamdes@wdes.fr"
SUBJECT_SERVER="/C=FR/O=Williamdes/OU=Docker/CN=server.williamdes.local/emailAddress=williamdes@wdes.fr"

echo "CA key"

openssl genrsa 2048 > ca-key.pem
openssl req -new -x509 -nodes -days 3600 -subj "${SUBJECT_CA}" -key ca-key.pem -out ca-cert.pem
echo "server key"

openssl req -subj "${SUBJECT_SERVER}" -newkey rsa:2048 -days 3600 -nodes -keyout server-key.pem -out server-req.pem
openssl rsa -in server-key.pem -out server-key.pem
openssl x509 -req -in server-req.pem -days 3600 -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 -out server-cert.pem
echo "client key"

openssl req -subj "${SUBJECT_CLIENT}" -newkey rsa:2048 -days 3600 -nodes -keyout client-key.pem -out client-req.pem
openssl rsa -in client-key.pem -out client-key.pem
openssl x509 -req -in client-req.pem -days 3600 -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 -out client-cert.pem
echo "check key ok"

openssl verify -CAfile ca-cert.pem server-cert.pem client-cert.pem
