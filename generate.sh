#!/bin/bash

PASSWORDA=$1;
PASSWORDB=$2;
PASSWORDC=$3;

# Warning if previous folder is here
if [ -z $PASSWORDA ] || [ -z $PASSWORDB ] || [ -z $PASSWORDC ]; then echo "you must enter 3 passwords, like ./generate.sh pass1 pass2 pass3";exit; fi

# Warning if previous folder is here
if [ -d ./.generated ]; then echo ".generate is already there, delete it if you want to continue.";exit; fi

# Create folder .generated
mkdir -p ./.generated

# Save the passwords
echo $PASSWORDA > ./.generated/authority.A.password;
echo $PASSWORDB > ./.generated/authority.B.password;
echo $PASSWORDC > ./.generated/authority.C.password;

# Generate the accounts
docker run -it --rm --name paritygenkeys --entrypoint /bin/bash parity/parity:v2.5.0 -c "parity account new --password <(echo $PASSWORDA) && cat ~/.local/share/io.parity.ethereum/keys/ethereum/*" > ./.generated/authority.A.txt;
docker run -it --rm --name paritygenkeys --entrypoint /bin/bash parity/parity:v2.5.0 -c "parity account new --password <(echo $PASSWORDB) && cat ~/.local/share/io.parity.ethereum/keys/ethereum/*" > ./.generated/authority.B.txt;
docker run -it --rm --name paritygenkeys --entrypoint /bin/bash parity/parity:v2.5.0 -c "parity account new --password <(echo $PASSWORDC) && cat ~/.local/share/io.parity.ethereum/keys/ethereum/*" > ./.generated/authority.C.txt;

# Update the config according to the accounts;
for auth in A B C;
do
    cp configPoANode.tmpl.toml ./.generated/configPoANode.$auth.toml;
    sed -n 1p ./.generated/authority.$auth.txt  | tr -d '\r\n' > ./.generated/authority.$auth.address;
    sed -i 's/AUTHORITY_ADDRESS/'$(cat ./.generated/authority.$auth.address)'/' ./.generated/configPoANode.$auth.toml;
done;

# Update the boot validators set in PoA.json
echo -n '"' > ./.generated/validatorsInitSet;
cat ./.generated/authority.A.address | tr -d '\r\n' >> ./.generated/validatorsInitSet;
echo -n '", "'  >> ./.generated/validatorsInitSet;
cat ./.generated/authority.B.address | tr -d '\r\n' >> ./.generated/validatorsInitSet;
echo -n '", "' >> ./.generated/validatorsInitSet;
cat ./.generated/authority.C.address | tr -d '\r\n' >> ./.generated/validatorsInitSet;
echo -n '"' >> ./.generated/validatorsInitSet;
cp PoA.tmpl.json ./.generated/PoA.json;
sed -i "s/\"validatorsInitSet\"/$(sed 's:/:\\/:g' ./.generated/validatorsInitSet)/" ./.generated/PoA.json;

# Save the private keys
for auth in A B C;
do
    sed -n 2p ./.generated/authority.$auth.txt > ./.generated/authority.$auth.priv.json;
done;