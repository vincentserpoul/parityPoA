#!/bin/bash

# We must have lowercase letters for the configMaps names

# Create configs
for auth in A B C;
do
    kubectl --namespace poa create configmap poaconfigs-$(echo $auth | awk '{print tolower($0)}') \
        --from-file=PoA.json=../.generated/PoA.json \
        --from-file=configPoANode.toml=../.generated/configPoANode.$auth.toml \
        --from-file=authority.address=../.generated/authority.A.address;
done;

# Create secrets
for auth in A B C;
do
    kubectl --namespace poa create secret generic poasecrets-$(echo $auth | awk '{print tolower($0)}') \
        --from-file=authority.priv.json=../.generated/authority.$auth.priv.json \
        --from-file=authority.password=../.generated/authority.$auth.password;
done;