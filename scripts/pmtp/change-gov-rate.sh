#!/usr/bin/env bash

set -x

gridnoded tx clp pmtp-params \
  --rGov=0.02 \
  --from=$GRID_ACT \
  --keyring-backend=test \
  --fees 100000000000000000rowan \
  --node ${GRIDNODE_NODE} \
  --chain-id=$GRIDNODE_CHAIN_ID \
  --broadcast-mode=block \
  -y