#!/usr/bin/env bash

gridnoded tx clp liquidity-protection-params --isActive=true \
	--maxRowanLiquidityThreshold=43815115800 \
  --maxRowanLiquidityThresholdAsset=cusdc \
  --epochLength=14400 \
	--from $ADMIN_KEY \
	--gas=500000 \
	--gas-prices=0.5rowan \
	--chain-id $GRIDCHAIN_ID \
	--node $GRIDNODE \
	--broadcast-mode block \
	--yes