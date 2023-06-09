#!/usr/bin/env bash

gridnoded tx clp reward-period --path=./data/rp_24.json \
	--from $ADMIN_KEY \
	--gas=500000 \
	--gas-prices=0.5rowan \
	--chain-id $GRIDCHAIN_ID \
	--node $GRIDNODE \
	--broadcast-mode block \
	--yes