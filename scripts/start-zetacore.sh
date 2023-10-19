#!/bin/bash
CHAINID="zetachain_70000-1"
KEYRING="test"

HOSTNAME=$(hostname)


rm -rf ~/.zetacored/config/genesis.json
cp -a network_files/config/genesis.json ~/.zetacored/config/


zetacored start \
--minimum-gas-prices=0.0001azeta \
--json-rpc.api eth,txpool,personal,net,debug,web3,miner \
--api.enable \
--pruning custom \
--pruning-keep-recent 54000 \
--pruning-interval 10 \
--min-retain-blocks 54000 \
--state-sync.snapshot-interval 10 \
--state-sync.snapshot-keep-recent 5 >> ~/.zetacored/zetacored.log 2>&1  &