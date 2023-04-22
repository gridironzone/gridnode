#!/usr/bin/env bash

set -x

gridnoded tx clp swap \
  --from $GRID_ACT \
  --keyring-backend test \
  --sentSymbol rowan \
  --receivedSymbol cusdt \
  --sentAmount 100000000000000000000000 \
  --minReceivingAmount 0 \
  --fees 100000000000000000rowan \
  --node ${GRIDNODE_NODE} \
  --chain-id $GRIDNODE_CHAIN_ID \
  --broadcast-mode block \
  -y