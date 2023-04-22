#!/bin/sh

# Vote yes to accept the proposal
gridnoded tx gov vote 1 yes \
--from grid --keyring-backend test \
--fees 100000rowan \
--chain-id  localnet \
--broadcast-mode block \
-y