#!/bin/bash

ORG_NAME="org1.example.com"
TYPE="user"

if [ "$1" == "" ]; then
	echo "Insert the name of the user to create'"
	echo "Usage ./createIdentity <name> <user/peer>"
	exit 0
fi

if [ "$2" != "" ]; then
	TYPE = $2
fi

docker exec -it ca.example.com fabric-ca-client enroll -u http://admin:adminpw@localhost:7054

docker exec -it ca.example.com fabric-ca-client register  --id.name $1  --id.attrs "dcot-operator=true" --id.type $TYPE  --id.secret faredge2018
docker exec -it ca.example.com  fabric-ca-client enroll -u http://$1:faredge2018@ca.example.com:7054 --enrollment.attrs "dcot-operator"

mkdir -p ./crypto-config/peerOrganizations/$ORG_NAME/users/$1@$ORG_NAME/msp/signcerts
mkdir -p ./crypto-config/peerOrganizations/$ORG_NAME/users/$1@$ORG_NAME/msp/keystore
cp ./ca/data/msp/signcerts/cert.pem ./crypto-config/peerOrganizations/$ORG_NAME/users/$1@$ORG_NAME/msp/signcerts/$1@$ORG_NAME-cert.pem
cd ./ca/data/msp/keystore && cp $(ls -t | head -1) ../../../../crypto-config/peerOrganizations/$ORG_NAME/users/$1@$ORG_NAME/msp/keystore
