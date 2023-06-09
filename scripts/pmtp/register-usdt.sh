#!/usr/bin/env bash

set -x

gridnoded tx tokenregistry register denoms/rowan.json \
  --node ${GRIDNODE_NODE} \
  --chain-id "${GRIDNODE_CHAIN_ID}" \
  --from "${ADMIN_ADDRESS}" \
  --keyring-backend test \
  --gas 500000 \
  --gas-prices 0.5rowan \
  -y \
  --broadcast-mode block

gridnoded tx tokenregistry register denoms/cusdt.json \
  --node ${GRIDNODE_NODE} \
  --chain-id "${GRIDNODE_CHAIN_ID}" \
  --from "${ADMIN_ADDRESS}" \
  --keyring-backend test \
  --gas 500000 \
  --gas-prices 0.5rowan \
  -y \
  --broadcast-mode block