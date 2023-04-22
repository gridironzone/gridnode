#!/usr/bin/env bash

set -x

gridnoded tx bank send \
    $GRID_ACT \
    grid144w8cpva2xkly74xrms8djg69y3mljzplx3fjt \
    9299999999750930000rowan \
    --keyring-backend test \
    --node ${GRIDNODE_NODE} \
    --chain-id $GRIDNODE_CHAIN_ID \
    --fees 100000000000000000rowan \
    --broadcast-mode block \
    -y