#!/bin/bash

###################################
# / ! \ THIS IS FOR EASY POC ONLY #
###################################

# Launch the node for A
docker stack deploy --compose-file ./compose_A.yml poa;

# Launch the node for B
docker stack deploy --compose-file ./compose_B.yml poa;

# Launch the node for C
docker stack deploy --compose-file ./compose_C.yml poa;