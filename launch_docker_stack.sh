#!/bin/bash

###################################
# / ! \ THIS IS FOR EASY POC ONLY #
###################################

# Set the docker secrets
echo "0x0097c0cfe63b641f9fb034f7bd8ecb99f2dabaf3" | docker secret create authority.A.address -;
echo "I want to try PoA at home, not secure at all" | docker secret create authority.A.passphrase -;
echo "1234567890" | docker secret create authority.A.password -;

echo "0x008549c7265000f5c06413c451d529870cf75d35" | docker secret create authority.B.address -;
echo "PoA will rule the private blockchain, but this is just a POC, not secure at all" | docker secret create authority.B.passphrase -;
echo "1234567890" | docker secret create authority.B.password -;

# Launch the first node for B
docker stack deploy --compose-file ./compose_A.yml poa;

# Launch the first node for IAC
docker stack deploy --compose-file ./compose_B.yml poa;