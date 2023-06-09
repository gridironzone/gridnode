#!/usr/bin/env bash


clibuilder()
{
   echo ""
   echo "Usage: $0 -u UpgradeName -c CurrentBinary -n NewBinary"
   echo -e "\t-u Name of the upgrade [Must match a handler defined in setup-handlers.go in NewBinary]"
   echo -e "\t-c Branch name for old binary (Upgrade From)"
   echo -e "\t-n Branch name for new binary (Upgrade To)"
   exit 1 # Exit script after printing help
}

while getopts "u:c:n:" opt
do
   case "$opt" in
      u ) UpgradeName="$OPTARG" ;;
      c ) CurrentBinary="$OPTARG" ;;
      n ) NewBinary="$OPTARG" ;;
      ? ) clibuilder ;; # Print cliBuilder in case parameter is non-existent
   esac
done

if [ -z "$UpgradeName" ] || [ -z "$CurrentBinary" ] || [ -z "$NewBinary" ]
then
   echo "Some or all of the parameters are empty";
   clibuilder
fi


export DAEMON_HOME=$HOME/.gridnoded
export DAEMON_NAME=gridnoded
export DAEMON_ALLOW_DOWNLOAD_BINARIES=true

make clean
rm -rf ~/.gridnoded
rm -rf gridnode.log

rm -rf $GOPATH/bin/gridnoded
rm -rf $GOPATH/bin/old/gridnoded
rm -rf $GOPATH/bin/new/gridnoded

# Setup old binary and start chain
git checkout $CurrentBinary
make install
cp $GOPATH/bin/gridnoded $GOPATH/bin/old/
gridnoded init test --chain-id=localnet -o

echo "Generating deterministic account - grid"
echo "race draft rival universe maid cheese steel logic crowd fork comic easy truth drift tomorrow eye buddy head time cash swing swift midnight borrow" | gridnoded keys add grid --recover --keyring-backend=test

echo "Generating deterministic account - akasha"
echo "hand inmate canvas head lunar naive increase recycle dog ecology inhale december wide bubble hockey dice worth gravity ketchup feed balance parent secret orchard" | gridnoded keys add akasha --recover --keyring-backend=test


#gridnoded keys add mkey --multisig grid,akasha --multisig-threshold 2 --keyring-backend=test

gridnoded add-genesis-account $(gridnoded keys show grid -a --keyring-backend=test) 500000000000000000000000rowan,500000000000000000000000catk,500000000000000000000000cbtk,500000000000000000000000ceth,990000000000000000000000000stake,500000000000000000000000cdash,500000000000000000000000clink,90000000000000000000ibc/96D7172B711F7F925DFC7579C6CCC3C80B762187215ABD082CDE99F81153DC80 --keyring-backend=test
gridnoded add-genesis-account $(gridnoded keys show akasha -a --keyring-backend=test) 500000000000000000000000rowan,500000000000000000000000catk,500000000000000000000000cbtk,500000000000000000000000ceth,990000000000000000000000000stake,500000000000000000000000cdash,500000000000000000000000clink --keyring-backend=test

#gridnoded add-genesis-clp-admin $(gridnoded keys show grid -a --keyring-backend=test) --keyring-backend=test
#gridnoded add-genesis-clp-admin $(gridnoded keys show akasha -a --keyring-backend=test) --keyring-backend=test

#gridnoded set-genesis-whitelister-admin grid --keyring-backend=test

#gridnoded add-genesis-validators $(gridnoded keys show grid -a --bech val --keyring-backend=test) --keyring-backend=test

gridnoded gentx grid 1000000000000000000000000stake --chain-id=localnet --keyring-backend=test

echo "Collecting genesis txs..."
gridnoded collect-gentxs

echo "Validating genesis file..."
gridnoded validate-genesis


mkdir -p $DAEMON_HOME/cosmovisor/genesis/bin
mkdir -p $DAEMON_HOME/cosmovisor/upgrades/$UpgradeName/bin


# Setup new binary
git checkout $NewBinary
rm -rf $GOPATH/bin/gridnoded
make install
cp $GOPATH/bin/gridnoded $GOPATH/bin/new/


# Setup cosmovisor
cp $GOPATH/bin/old/gridnoded $DAEMON_HOME/cosmovisor/genesis/bin
cp $GOPATH/bin/new/gridnoded $DAEMON_HOME/cosmovisor/upgrades/$UpgradeName/bin/

chmod +x $DAEMON_HOME/cosmovisor/genesis/bin/gridnoded
chmod +x $DAEMON_HOME/cosmovisor/upgrades/$UpgradeName/bin/gridnoded

contents="$(jq '.app_state.gov.voting_params.voting_period = "10s"' $DAEMON_HOME/config/genesis.json)" && \
echo "${contents}" > $DAEMON_HOME/config/genesis.json

# Add state data here if required

cosmovisor start --home ~/.gridnoded/ --p2p.laddr 0.0.0.0:27655  --grpc.address 0.0.0.0:9096 --grpc-web.address 0.0.0.0:9093 --address tcp://0.0.0.0:27659 --rpc.laddr tcp://127.0.0.1:26657 >> gridnode.log 2>&1  &
#sleep 7
#gridnoded tx tokenregistry register-all /Users/tanmay/Documents/gridnode/scripts/ibc/tokenregistration/localnet/rowan.json --from grid --keyring-backend=test --chain-id=localnet --yes
sleep 7
gridnoded tx gov submit-proposal software-upgrade $UpgradeName --from grid --deposit 100000000stake --upgrade-height 10 --title $UpgradeName --description $UpgradeName --keyring-backend test --chain-id localnet --yes
sleep 7
gridnoded tx gov vote 1 yes --from grid --keyring-backend test --chain-id localnet --yes
clear
sleep 7
gridnoded query gov proposal 1

tail -f gridnode.log

#yes Y | gridnoded tx gov submit-proposal software-upgrade 0.9.14 --from grid --deposit 100000000stake --upgrade-height 30 --title 0.9.14 --description 0.9.14 --keyring-backend test --chain-id localnet