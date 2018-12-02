# Parity PoA demo setup

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

## Connecting the nodes together

get the node A enode id:

```bash
curl --data '{"jsonrpc":"2.0","method":"parity_enode","params":[],"id":0}' -H "Content-Type: application/json" -X POST 127.0.0.1:8545

>> {"jsonrpc":"2.0","result":"enode://AAAAA@10.255.0.4:30303","id":0}
```

```bash
curl -X POST --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":["enode://AAAAA@poa_A:30303"],"id":0}' -H "Content-Type: application/json" 127.0.0.1:8547

>> {"jsonrpc":"2.0","result":true,"id":0}
```

now add the C peer to the B peer:

Get the C peer details

```bash
curl --data '{"jsonrpc":"2.0","method":"parity_enode","params":[],"id":0}' -H "Content-Type: application/json" -X POST 127.0.0.1:8549

>> {"jsonrpc":"2.0","result":"enode://CCCCC@10.255.0.4:30305","id":0}
```

```bash
curl -X POST --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":["enode://CCCCC@poa_C:30305"],"id":0}' -H "Content-Type: application/json" 127.0.0.1:8547

>> {"jsonrpc":"2.0","result":true,"id":0}
```

and if needed, now add the B peer to the C peer:
Get the B peer details

```bash
curl --data '{"jsonrpc":"2.0","method":"parity_enode","params":[],"id":2}' -H "Content-Type: application/json" -X POST 127.0.0.1:8547

>> {"jsonrpc":"2.0","result":"enode://BBBBB@10.255.0.4:30304","id":0}
```

```bash
curl -X POST --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":["enode://BBBBB@poa_B:30304"],"id":0}' -H "Content-Type: application/json" 127.0.0.1:8549

>> {"jsonrpc":"2.0","result":true,"id":0}
```

You should now see the two peers synced (UI or logs) for peer A.s
