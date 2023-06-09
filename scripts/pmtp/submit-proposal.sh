#!/usr/bin/env bash

set -x

gridnoded tx gov submit-proposal \
    param-change proposal.json \
    --from $GRID_ACT \
    --keyring-backend test \
    --node ${GRIDNODE_NODE} \
    --chain-id $GRIDNODE_CHAIN_ID \
    --fees 100000000000000000rowan \
    --broadcast-mode block \
    -y