#!/usr/bin/env bash

echo "Creating pools ceth and cdash"
gridnoded tx clp create-pool --from grid --symbol ceth --nativeAmount 20000000000000000000 --externalAmount 20000000000000000000  --yes

sleep 5
gridnoded tx clp create-pool --from grid --symbol cdash --nativeAmount 20000000000000000000 --externalAmount 20000000000000000000  --yes


sleep 8
echo "Swap Native for Pegged - Sent rowan Get ceth"
gridnoded tx clp swap --from grid --sentSymbol rowan --receivedSymbol ceth --sentAmount 2000000000000000000 --minReceivingAmount 0 --yes
sleep 8
echo "Swap Pegged for Native - Sent ceth Get rowan"
gridnoded tx clp swap --from grid --sentSymbol ceth --receivedSymbol rowan --sentAmount 2000000000000000000 --minReceivingAmount 0 --yes
sleep 8
echo "Swap Pegged for Pegged - Sent ceth Get cdash"
gridnoded tx clp swap --from grid --sentSymbol ceth --receivedSymbol cdash --sentAmount 2000000000000000000 --minReceivingAmount 0 --yes

gridnoded q clp pools

