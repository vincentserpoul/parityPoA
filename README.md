# Parity PoA setup

## Build the docker image

```bash
  ./build_docker_image.sh
```

## Generate the accounts and configs

/ ! \ CHANGE PASSA PASSB and PASSC / ! \

```bash
  ./generate PASSA PASSB PASSC
```

## Launching nodes

if you are using docker swarm, See ./docker-swarm/README.md.

if you re using kubernetes, see ./kubernetes.README.md.

## Cleaning up and removing sensitive fles

```bash
  rm -rf ./.generated
```
