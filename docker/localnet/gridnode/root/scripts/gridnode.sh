#!/bin/sh
#
# Gridchain: Gridnode Genesis Entrypoint.
#

#
# Configure the node.
#
setup() {
  gridgen node create "$CHAINNET" "$MONIKER" "$MNEMONIC" --bind-ip-address "$BIND_IP_ADDRESS" --standalone --keyring-backend test
}

#
# Run the node under cosmovisor.
#
run() {
  gridnoded start --rpc.laddr=tcp://0.0.0.0:26657 --minimum-gas-prices="$GAS_PRICE"
}

setup
run
