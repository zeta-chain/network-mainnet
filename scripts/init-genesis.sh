#!/bin/bash

# variables
CHAINID="zetachain_7000-1"
GENESIS_PATH="./network_files/config/genesis.json"
TMP_GENESIS_PATH="./tmp_genesis.json"

DENOM_METADATA=$(cat <<EOF
[
  {
    "base": "azeta",
    "denom_units": [
      {
        "denom": "azeta",
        "exponent": "0",
        "aliases": ["attozeta"]
      },
      {
        "denom": "zeta",
        "exponent": "18"
      }
    ],
    "description": "The native token of ZetaChain",
    "display": "zeta",
    "name": "ZetaChain",
    "symbol": "ZETA"
  }
]
EOF
)

# clean up
rm -f $GENESIS_PATH
rm -rf ~/.zetacored

# create initial genesis
# note: moniker is not used but must be provided
zetacored init moniker --chain-id=$CHAINID > /dev/null 2>&1
mv ~/.zetacored/config/genesis.json $GENESIS_PATH

# custom params
params=(
    '.genesis_time="2023-10-17T16:00:00Z"'
    '.consensus_params["block"]["max_gas"]="10000000"'
    '.app_state["bank"]["params"]["default_send_enabled"]=false'
    '.app_state["bank"]["denom_metadata"]="false"'
    '.app_state["staking"]["params"]["bond_denom"]="azeta"'
    '.app_state["staking"]["params"]["max_validators"]=125'
    '.app_state["staking"]["params"]["min_commission_rate"]="0.05"' # 5%
    '.app_state["distribution"]["params"]["community_tax"]="0.0"'
    '.app_state["crisis"]["constant_fee"]["denom"]="azeta"'
    '.app_state["mint"]["params"]["mint_denom"]="azeta"'
    '.app_state["gov"]["deposit_params"]["min_deposit"][0]["denom"]="azeta"'
    '.app_state["gov"]["deposit_params"]["min_deposit"][0]["amount"]="100000000000000000"' # 0.1 ZETA
    '.app_state["gov"]["deposit_params"]["max_deposit_period"]="1209600s"' # 2 weeks
    '.app_state["gov"]["voting_params"]["voting_period"]="86400s"' # 1 day
    '.app_state["gov"]["tally_params"]["quorum"]="0.4"' # 40%
    '.app_state["evm"]["params"]["evm_denom"]="azeta"'
    '.app_state["observer"]["params"]["observer_params"]=[]'
    '.app_state["observer"]["params"]["admin_policy"]=[]'
)

# apply custom params
for i in "${params[@]}"
do
    cat $GENESIS_PATH | jq $i > $TMP_GENESIS_PATH && mv $TMP_GENESIS_PATH $GENESIS_PATH
done

# add denom metadata
cat $GENESIS_PATH | jq --argjson data "$DENOM_METADATA" '.app_state["bank"]["denom_metadata"]=$data' > $TMP_GENESIS_PATH && mv $TMP_GENESIS_PATH $GENESIS_PATH

# check genesis validity
zetacored validate-genesis $GENESIS_PATH
if [ $? -ne 0 ]; then
    echo "Generated genesis is invalid"
    exit 1
fi

echo "Genesis initialized at $GENESIS_PATH"
exit 0