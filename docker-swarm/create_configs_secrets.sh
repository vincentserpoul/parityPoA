#!/bin/bash

# Create configs
docker config create PoA.json ../.generated/PoA.json;
for auth in A B C;
do
    docker config create configPoANode.$auth.toml ../.generated/configPoANode.$auth.toml;
    docker config create authority.$auth.address ../.generated/authority.$auth.address;
done;

# Create secrets
for auth in A B C;
do
    docker secret create authority.$auth.priv.json ../.generated/authority.$auth.priv.json;
    docker secret create authority.$auth.password ../.generated/authority.$auth.password;
done;