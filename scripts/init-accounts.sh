#!/bin/bash

GENESIS_PATH="./network_files/config/genesis.json"
BALANCE="20000000000000000000azeta" # 20 ZETA

# account list
accounts=(
    "zeta1hjct6q7npsspsg3dgvzk3sdf89spmlpf7rqmnw" # Figment
    "zeta1p0uwsq4naus5r4l7l744upy0k8ezzj84mn40nf" # Bastion
    "zeta1t5pgk2fucx3drkynzew9zln5z9r7s3wqqyy0pe" # Blockdaemon
    "zeta1t0uj2z93jd2g3w94zl3jhfrn2ek6dnuk3v93j9" # InfStones
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