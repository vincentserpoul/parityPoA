#!/bin/bash

# Replace the validator in set in the PoA.json
sed -i "s/\"validatorsInitSet\"/$(sed 's:/:\\/:g' /run/secrets/validatorsInitSet)/" /home/parity/PoA.json

# Import the account from the secret storage
/home/parity/bin/parity --config /home/parity/configPoANode.toml account import /run/secrets/authority.priv.json;

# Replace AUTHORITY_ADDRESS by the address in the env variable
sed -i 's/AUTHORITY_ADDRESS/'$(cat /run/secrets/authority.address)'/' /home/parity/configPoANode.toml;

/home/parity/bin/parity --config /home/parity/configPoANode.toml \
    --jsonrpc-port=$JSONRPC_PORT \
    --port=$NETWORK_PORT \
    --ws-port=$WS_PORT \
    --min-gas-price 0;