#!/bin/sh

# Create rowan/ceth; 
gridnoded tx clp create-pool \
--symbol ceth \
--nativeAmount 2000000000000000000 \
--externalAmount 2000000000000000000 \
--from grid --keyring-backend test \
--fees 100000000000000000rowan \
--chain-id localnet \
--broadcast-mode block \
-y