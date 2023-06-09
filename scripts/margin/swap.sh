#!/usr/bin/env bash

set -x

gridnoded tx clp swap \
  --from=$GRID_ACT \
  --keyring-backend=test \
  --sentSymbol=cusdc \
  --receivedSymbol=rowan \
  --sentAmount=1000000000000 \
  --minReceivingAmount=0 \
  --fees=100000000000000000rowan \
  --gas=500000 \
  --node=${GRIDNODE_NODE} \
  --chain-id=${GRIDNODE_CHAIN_ID} \
  --broadcast-mode=block \
  -y