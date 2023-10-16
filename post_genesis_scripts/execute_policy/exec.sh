#!/bin/bash
CHAINID="zetachain_7000-1"
KEYRING="test"
HOSTNAME=$(hostname)
signer="operator"

signerAddress=$(zetacored keys show $signer -a --keyring-backend=test)
echo "signerAddress: $signerAddress"

clibuilder()
{
   echo ""
   echo "Usage: $0 -i ProposalID"
   echo -e "\t-i ProposalID"
   exit 1 # Exit script after printing help
}

while getopts "i:" opt
do
   case "$opt" in
      i ) PID="$OPTARG" ;;
      ? ) clibuilder ;; # Print cliBuilder in case parameter is non-existent
   esac
done

if [ -z "$PID" ]
then
   echo "Some or all of the parameters are empty";
   clibuilder
fi

zetacored tx group exec "$PID" --from $signer --fees=40azeta --chain-id=$CHAINID --keyring-backend=$KEYRING -y --broadcast-mode=block
