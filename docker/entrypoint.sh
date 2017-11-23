#!/bin/bash

# Run parity
/parity/parity --config /etc/parityPoA/configPoAInit.toml daemon 1234

sleep 10s

# Import the authority account from the passphrase
curl --data "{\"jsonrpc\":\"2.0\",\"method\":\"parity_newAccountFromPhrase\",\"params\":[\"$(cat /run/secrets/authority.$AUTHORITY_COMPANY.passphrase)\", \"$(cat /run/secrets/authority.$AUTHORITY_COMPANY.password)\"],\"id\":0}" -H "Content-Type: application/json" -X POST 127.0.0.1:8545

# kill virgin parity
kill $(ps ax | grep parity | grep -v grep | awk '{ print $1 }');

sleep 5s

# Replace AUTHORITY_COMPANY by the company in the env variable
sed -i 's/AUTHORITY_ADDRESS/'$(cat /run/secrets/authority.$AUTHORITY_COMPANY.address)'/' /etc/parityPoA/configPoANode.toml;
sed -i 's/AUTHORITY_COMPANY/'$AUTHORITY_COMPANY'/' /etc/parityPoA/configPoANode.toml;

/parity/parity --config /etc/parityPoA/configPoANode.toml \
    --ui-port=$UI_PORT \
    --jsonrpc-port=$JSONRPC_PORT \
    --port=$NETWORK_PORT \
    --ws-port=$WEBSOCKETS_PORT \
    --gasprice 0

