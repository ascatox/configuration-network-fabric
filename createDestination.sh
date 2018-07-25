#!/bin/bash

ORG_NAME="org1.example.com"
DESTINATION="crypto-config-output"

if [ "$1" == "" ]; then
	echo "Insert the name of the user to create'"
	echo "Usage ./createIdentity <name> <destination folder>"
	exit 0
fi

if [ "$2" != "" ]; then
	DESTINATION = $2
fi

mkdir -p $DESTINATION/crypto-config/peerOrganizations/$ORG_NAME/users
cp -fR ./crypto-config/peerOrganizations/org1.example.com/users/$1@$ORG_NAME $DESTINATION/crypto-config/peerOrganizations/org1.example.com/users
tar -zcvf crypto-config-$1.tar.gz $DESTINATION && rm -rf $DESTINATION
