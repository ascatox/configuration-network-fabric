#!/bin/bash
echo "WARNING Remove ALL DATA of HLF"
echo "REBUILD Network!!!!"
sudo bash stopNetwork.sh && sudo bash ./scripts/doRestartNetwork.sh
