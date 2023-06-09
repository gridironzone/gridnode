#!/bin/sh

# Remove liquidity 
gridnoded tx clp remove-liquidity \
--from grid --keyring-backend test \
--fees 100000000000000000rowan \
--symbol ceth \
--wBasis 5000 --asymmetry 0 \
--chain-id localnet \
--broadcast-mode block \
-y