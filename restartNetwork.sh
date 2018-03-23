#!/bin/bash
echo "STOPPING Network!!!!"
sudo bash stopNetwork.sh && sudo bash ./scripts/doRestartNetwork.sh
