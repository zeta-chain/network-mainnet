# Validator Setup guide

The ZetaChan Genesis process is broken up into two phases:

Phase 1: Core Genesis

- Setup your validator node
- Generate keys
- Submit keys to the coordinator via GitHub PR
- Wait for updated genesis file to be provided by the coordinator
- Start Your Node

Phase 2: TSS & ZetaClient Genesis

More details about this will be shared with the predetermined observer signers

## Phase 1: Node Setup

Here we assume a typical Ubuntu 22.04 LTS x86_64 setup. If you are using a
different OS you may need to make some adjustments. For more information about
the compute node requirement see [here](node_requirements.md)

This is process is designed for ease of use and is not the most secure approach. When setting up a validator we highly reccomend using a hardware wallet for storing operator keys and a HSM or other key managment solution to protect your block signing key.


#### Make sure `jq`, `git`, `curl`, and `make` are installed.

```bash
sudo apt update
sudo apt install -y jq curl git
jq --version
```

#### Download and install `zetacored` and `zetaclientd` binaries
Binaries are built based on OS version and CPU architecture. The available binaries are:


#### Build binaries on the machines

#### Run The Node Setup Script

To streamline this process we have provided scripts that will automatically
generate the required keys, and create your gentx and os_info files. There are
others ways to configure your node but this is the method we can provide
techincal support for during this testnet genesis.  

Give execute permissions to the scripts and run the node setup script.

When prompted for confirm, enter `y` to continue.

For observer validators
```bash
chmod +x ./scripts/*.sh
./scripts/node-setup.sh -o y
```
For non-observer validators
```bash
chmod +x ./scripts/*.sh
./scripts/node-setup.sh -o n
```

After the `node-setup.sh` script generates the keys and necessary files, create
a branch, commit, and raise a PR to submit the files to ZetaChain coordinator:

- Use `gen-files-<YourValidatorName>` as the branch name for the new branch.
- The pr must contain only two files
  - `os_XX.json`
  - `gentx-XX.json`
- Do not commit `network_files/config/genesis.json` if it exists
  - This file can be deleted, it is not required.
- An automated GitHub Action will validator your PR
- Your PR must pass this check before the coordinator will merge it

NOTE : A backup up is created for the existing zetacored folder under
`~/.zetacored_old/zetacored-<timestamp>`.You can copy back keys etc if needed .

## Node Setup - Observer/Signer Validators Only

These instructions apply to **Observer/Signer Validators only**. Most operators are
"core validators" and can skip these steps. If you aren't sure what type of node you have, you
are most likely a core validator.

### Configure RPC Connectivity

Observer Signers need an RPC endpoint for each connected chain. You can follow
the standard instructions to configure a node for most chains but the BTC
requires special instructions just for ZetaChain. The links below will take you
to a node setup guide for each chain.

- [Ethereum RPC Node Setup](https://ethereum.org/en/developers/docs/nodes-and-clients/run-a-node/)
- [BSC RPC Node Setup](https://docs.bnbchain.org/docs/validator/fullnode/)
- [Polygon RPC Node Setup](https://wiki.polygon.technology/docs/category/run-a-full-node)
- [BTC RPC Node Setup](btc-rpc.md)

Edit the `zetaclient_config.json` file located in the `.zetacored/config` directory
and add the RPC endpoints to the `Endpoint = ` section of each chain.

**BTC RPC Only:** When adding your BTC rpc endpoint to the
`zetaclient_config.json` file, you must use exclude http/https and only use the hostname:port. It will always
attempt to connect using http. If you include http or https in the endpoint
name, it will fail.

### Set Public IP in  `zetaclient_config.json`

Observer/Signer Validators must set their public IP in the
`zetaclient_config.json` file located in the `.zetacored/config` directory. This
file will be automatically created when you run `zetaclientd init`.

## Phase 2: Core Genesis

### Get Updated Genesis File

After the ZetaChain coordinator has merged the gentx PRs and updated the genesis file:

- Switch back to the `main` branch
- Pull the latest changes to get the updated genesis.json file

```bash
git switch main
git pull
```

### Start The Node 
The start-zetacored.sh script automatically copies the new genesis file to `~/.zetacored/config/`.

```bash
./scripts/start-zetacore.sh
```

### Start `zetaclient`

This step applies to **Observer/Signer Validators only**.

```bash
SEEDIP=3.218.170.198
./scripts/start-zetaclient.sh -s $SEEDIP
```

### Wait for Genesis to Complete

**Wait until ZetaChain coordinator confirms that genesis is completed.** 
You can terminate the `zetacored` process that was manually started in the
previous step. You'll want to resume zetacored using a more robust process
management system. See the final section below for more information.

```bash
pkill zetacored
```

## Process Management for `zetacored` and `zetaclientd`

These instructions are for the initial setup and genesis of the network. Running
a validator 24/7 requires a more robust setup that will change depending on the
environment you are running the validator in. At a minimum we reccomend you:

- [ ] Run each process as a systemd service or containerized service
- [ ] Do NOT run these services as root. Create a new restricted ZetaChain user
- [ ] Create Sentry nodes to protect your validator
- [ ] Setup ngnix to forward p2p traffic from Sentry node to zetaclientd -- TODO
      add documentation for this
- [ ] Make sure you setup resource monitoring (CPU, RAM, etc), uptime
      monitoring, log ingestion, etc to minimize the risk of downtime or
      slashing
- [ ] Install adequate security measures such as, Endpoint protection,
      Anti-Virus, system level logging, WAF, etc
