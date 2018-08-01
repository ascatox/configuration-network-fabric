#!/bin/bash

ORG_NAME="org1.example.com"
TYPE="user"
PASSWORD="faredge2018"
#ATTRS='"hf.Registrar.Roles=peer,client,user"'
UUID=$(cat /proc/sys/kernel/random/uuid)
ATTRS="role=dcot-operator:ecert,uid=$UUID:ecert"


if [ "$1" == "" ]; then
	echo "Insert the name of the user to create'"
	echo "Usage ./createIdentity <name> <password> <user/peer>"
	exit 0
fi

if [ "$2" != "" ]; then
	PASSWORD=$2
fi

if [ "$3" != "" ]; then
	TYPE=$3
fi

# id.maxenrollments -1 infinite
docker exec -it ca.example.com fabric-ca-client enroll -u http://admin:adminpw@localhost:7054

docker exec -it ca.example.com fabric-ca-client register  --id.name $1  --id.type $TYPE  --id.secret $PASSWORD --id.maxenrollments -1 --id.attrs $ATTRS
docker exec -it ca.example.com  fabric-ca-client enroll -u http://$1:faredge2018@ca.example.com:7054 -M crypto-config/peerOrganizations/org1.example.com/msp
echo "UID is $UUID"
# Stop fabric-ca-server.
# Copy crypto-config/peerOrganizations/<orgName>/ca/*pem to $FABRIC_CA_SERVER_HOME/ca-cert.pem.
# Copy crypto-config/peerOrganizations/<orgName>/ca/*_sk to $FABRIC_CA_SERVER_HOME/msp/keystore/.
# Start fabric-ca-server.
# Delete any previously issued enrollment certificates and get new certificates by enrolling again.

docker stop ca.example.com
sudo cp crypto-config/peerOrganizations/$ORG_NAME/ca/*pem ca/data/ca-cert.pem
sudo cp crypto-config/peerOrganizations/$ORG_NAME/ca/*_sk ca/data/msp/keystore/.
docker start ca.example.com
