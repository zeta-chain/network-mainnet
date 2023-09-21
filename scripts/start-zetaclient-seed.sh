#!/bin/bash
CHAINID="zetachain_70000-1"
KEYRING="test"

HOSTNAME=$(hostname)

operatorAddress=$(zetacored keys show operator -a --keyring-backend=test)
echo "operatorAddress: $operatorAddress"

zetaclientd init --operator "$operatorAddress" --public-ip "$MYIP"
zetaclientd start >> ~/.zetacored/zetaclient.log 2>&1  &

