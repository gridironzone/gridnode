#!/usr/bin/env bash

set -x

gridnoded tx clp remove-liquidity \
  --from $GRID_ACT \
  --keyring-backend test \
  --symbol cusdt \
  --asymmetry 10000 \
  --wBasis 295 \
  --fees 100000000000000000rowan \
  --node ${GRIDNODE_NODE} \
  --chain-id $GRIDNODE_CHAIN_ID \
  --broadcast-mode block \
  -y