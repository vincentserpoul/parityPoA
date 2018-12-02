#!/bin/bash

# Import the account from the secret storage
/home/parity/bin/parity --config /home/parity/.poaconfigs/configPoANode.toml account import /home/parity/.poasecrets/authority.priv.json;

/home/parity/bin/parity --config /home/parity/.poaconfigs/configPoANode.toml \
    --jsonrpc-port=$JSONRPC_PORT \
    --port=$NETWORK_PORT \
    --ws-port=$WS_PORT;