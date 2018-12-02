#!/bin/bash

# We must have lowercase letters for the configMaps names

# delete configs
for auth in A B C;
do
    kubectl --namespace poa delete configmap poaconfigs-$(echo $auth | awk '{print tolower($0)}');
done;

# delete secrets
for auth in A B C;
do
    kubectl --namespace poa delete secret poasecrets-$(echo $auth | awk '{print tolower($0)}');
done;