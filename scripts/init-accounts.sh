#!/bin/bash

GENESIS_PATH="./network_files/config/genesis.json"
CHAINID="zetachain_70000-1"
BALANCE="10000000000000000000azeta" # 10 ZETA

# account list
accounts=(
    "zeta1gxz4392atnap6mrtgnzhn9e9uadgkr2tu496nw" # example
)

# add genesis accounts
for addr in "${accounts[@]}"; do
    zetacored add-genesis-account $addr $BALANCE --home ./network_files
done

# check genesis
zetacored validate-genesis $GENESIS_PATH
if [ $? -ne 0 ]; then
    echo "Generated genesis is invalid"
    exit 1
fi

# clean up
echo "Genesis accounts added in $GENESIS_PATH"
exit 0