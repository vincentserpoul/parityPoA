#!/bin/bash


for auth in A B C;
do
    rm -f authority.$auth.address;
    rm -f authority.$auth.password;
    rm -f authority.$auth.txt;
    rm -f authority.$auth.priv.json
    rm -f configPoANode.$auth.toml;
done;
rm -f PoA.json;
rm -f validatorsInitSet;