#!/bin/bash

# Create configs
docker config rm PoA.json;
for auth in A B C;
do
    docker config rm configPoANode.$auth.toml;
    docker config rm authority.$auth.address;
done;

# Create secrets
for auth in A B C;
do
    docker secret rm authority.$auth.priv.json;
    docker secret rm authority.$auth.password;
done;