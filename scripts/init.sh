#!/usr/bin/env bash

### chain init script for development purposes only ###

make clean install
rm -rf ~/.gridnoded
gridnoded init test --chain-id=localnet -o

echo "Generating deterministic account - grid"
echo "race draft rival universe maid cheese steel logic crowd fork comic easy truth drift tomorrow eye buddy head time cash swing swift midnight borrow" | gridnoded keys add grid --recover --keyring-backend=test

echo "Generating deterministic account - akasha"
echo "hand inmate canvas head lunar naive increase recycle dog ecology inhale december wide bubble hockey dice worth gravity ketchup feed balance parent secret orchard" | gridnoded keys add akasha --recover --keyring-backend=test

echo "Generating deterministic account - alice"
echo "crunch enable gauge equip sadness venture volcano capable boil pole lounge because service level giggle decide south deposit bike antique consider olympic girl butter" | gridnoded keys add alice --recover --keyring-backend=test

gridnoded keys add mkey --multisig grid,akasha --multisig-threshold 2 --keyring-backend=test

gridnoded add-genesis-account $(gridnoded keys show grid -a --keyring-backend=test) 500000000000000000000000000000000rowan,500000000000000000000000catk,500000000000000000000000cbtk,500000000000000000000000000000000ceth,990000000000000000000000000stake,500000000000000000000000cdash,500000000000000000000000clink,5000000000000cusdt,90000000000000000000ibc/96D7172B711F7F925DFC7579C6CCC3C80B762187215ABD082CDE99F81153DC80 --keyring-backend=test
gridnoded add-genesis-account $(gridnoded keys show akasha -a --keyring-backend=test) 500000000000000000000000rowan,500000000000000000000000catk,500000000000000000000000cbtk,500000000000000000000000ceth,990000000000000000000000000stake,500000000000000000000000cdash,500000000000000000000000clink --keyring-backend=test
gridnoded add-genesis-account $(gridnoded keys show alice -a --keyring-backend=test) 500000000000000000000000rowan,500000000000000000000000catk,500000000000000000000000cbtk,500000000000000000000000ceth,990000000000000000000000000stake,500000000000000000000000cdash,500000000000000000000000clink --keyring-backend=test

gridnoded add-genesis-clp-admin $(gridnoded keys show grid -a --keyring-backend=test) --keyring-backend=test
gridnoded add-genesis-clp-admin $(gridnoded keys show akasha -a --keyring-backend=test) --keyring-backend=test

gridnoded set-genesis-oracle-admin grid --keyring-backend=test
gridnoded add-genesis-validators $(gridnoded keys show grid -a --bech val --keyring-backend=test) --keyring-backend=test

gridnoded set-genesis-whitelister-admin grid --keyring-backend=test
gridnoded set-gen-denom-whitelist scripts/denoms.json

gridnoded gentx grid 1000000000000000000000000stake --moniker grid_val --chain-id=localnet --keyring-backend=test

echo "Collecting genesis txs..."
gridnoded collect-gentxs

echo "Validating genesis file..."
gridnoded validate-genesis
