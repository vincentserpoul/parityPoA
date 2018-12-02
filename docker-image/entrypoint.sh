#!/bin/bash

# Import the account from the secret storage
/home/parity/bin/parity --config /home/parity/configPoANode.toml account import /run/secrets/authority.priv.json;

/home/parity/bin/parity --config /home/parity/configPoANode.toml \
    --jsonrpc-port=$JSONRPC_PORT \
    --port=$NETWORK_PORT \
    --ws-port=$WS_PORT;