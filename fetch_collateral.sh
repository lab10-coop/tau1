#!/bin/bash

# Fetches the collateral from the ARTIS ValidatorSet contract (pre POSDAO).
# Will succeed only if the validator was first removed through a governance vote (https://voting.artis.network)
#
# The script assumes a node with unlocked and funded account (the one for which collateral is deposited) to be running on localhost, with http RPC available on port 8545.
# It will create and send the transaction, print the transaction hash and then exit.

set -e
set -u

# change if not matching
port=8545

if ! `which jq > /dev/null`; then
	echo 'The program "jq" is needed by this script, but not installed. Please install with:'
	echo "sudo apt install jq"
	exit 1
fi

address=`curl --silent --data '{"method":"eth_coinbase","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:$port | jq "."result`

echo "determined sender address: $address"

curl --data '{"method":"eth_sendTransaction","params":[{"from": '$address', "to": "0xAaA0000000000000000000000000000000000aaA", "gas": "0xFFFF", "gasPrice": "0x174876E800", "value": "0x00", "data": "0x00"}],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:$port

