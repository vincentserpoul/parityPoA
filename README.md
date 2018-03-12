# Initial setup

## Launch one parity node

## Create your authorities and user

Authority A

```bash
curl -X POST --data '{"method":"parity_newAccountFromPhrase","params":["I want to try PoA at home, not secure at all","1234567890"],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" localhost:8545

>> 0x0097c0cfe63b641f9fb034f7bd8ecb99f2dabaf3
```

Authority B

```bash
curl -X POST --data '{"method":"parity_newAccountFromPhrase","params":["PoA will rule the private blockchain, but this is just a POC, not secure at all","1234567890"],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" localhost:8545

>> 0x008549c7265000f5c06413c451d529870cf75d35
```

Authority C

```bash
curl -X POST --data '{"method":"parity_newAccountFromPhrase","params":["three nodes are better than two, which is why we do it","1234567890"],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" localhost:8545

>> 0x0070bba3fa8700b95025c9dd472c9c4af0ef426d
```

User1

```bash
curl -X POST --data '{"method":"parity_newAccountFromPhrase","params":["PoA user, first of all, with a lot of eth","1234567890"],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" localhost:8545

>> 0x009b98e786952f3ace412961b6008a34b059ff74
```

Update the authority keys in ./dockerimage/PoA.json engine.authorityRound.params.List if you decide to change them.
Update the accounts in ./dockerimage/PoA.json if you decide to change it.

## Create image

```bash
cd dockerimage
./build_docker_image.sh
```

## Launch the stack

```bash
./launch_docker_stack.sh
```

Add the user1:

```bash
curl -X POST --data '{"method":"parity_newAccountFromPhrase","params":["PoA user, first of all, with a lot of eth","1234567890"],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" localhost:8545

>> 0x009b98e786952f3ace412961b6008a34b059ff74
```

## Access to UI

```bash
docker exec -it $(docker container ls | grep poa_A | awk '{ print $1 }') /parity/parity signer new-token
docker exec -it $(docker container ls | grep poa_B | awk '{ print $1 }') /parity/parity signer new-token
docker exec -it $(docker container ls | grep poa_C | awk '{ print $1 }') /parity/parity signer new-token
```

Then you can now go to [the first node](http://0.0.0.0:8180), [the second node](http://0.0.0.0:8181) and [third node](http://0.0.0.0:8182) and enter the supplied token.

## Connecting the nodes together

get the node A enode id:

```bash
curl --data '{"jsonrpc":"2.0","method":"parity_enode","params":[],"id":0}' -H "Content-Type: application/json" -X POST 0.0.0.0:8545

>> {"jsonrpc":"2.0","result":"enode://AAAAA@10.255.0.4:30303","id":0}
```

BEWARE, the default given IP (here 10.255.0.4) is obviously wrong! These containers speak together directly, so we need the virtual poa_network IP that was given to it.

```bash
docker service inspect poa_A -f '{{index .Endpoint.VirtualIPs 1}}'

>> {ohifa7fog4gyacne0w88bawaw 10.0.0.2/24}
```

You need to use the address 10.0.1.2 when you add the A peer to the B peer

```bash
curl -X POST --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":["enode://AAAAA@10.0.0.2:30303"],"id":0}' -H "Content-Type: application/json" 0.0.0.0:8547

>> {"jsonrpc":"2.0","result":true,"id":0}
```

now add the C peer to the B peer:

Get the C peer details

```bash
curl --data '{"jsonrpc":"2.0","method":"parity_enode","params":[],"id":0}' -H "Content-Type: application/json" -X POST 0.0.0.0:8549

>> {"jsonrpc":"2.0","result":"enode://CCCCC@10.255.0.4:30305","id":0}
```

```bash
docker service inspect poa_C -f '{{index .Endpoint.VirtualIPs 1}}'

>> {ohifa7fog4gyacne0w88bawaw 10.0.0.7/24}
```

```bash
curl -X POST --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":["enode://CCCCC@10.0.0.7:30305"],"id":0}' -H "Content-Type: application/json" 0.0.0.0:8547

>> {"jsonrpc":"2.0","result":true,"id":0}
```

and if needed, now add the B peer to the C peer:
Get the B peer details

```bash
curl --data '{"jsonrpc":"2.0","method":"parity_enode","params":[],"id":2}' -H "Content-Type: application/json" -X POST 0.0.0.0:8547

>> {"jsonrpc":"2.0","result":"enode://BBBBB@10.255.0.4:30304","id":0}
```

```bash
docker service inspect poa_B -f '{{index .Endpoint.VirtualIPs 1}}'

>> {at6teoejgl6fhk32ig1gu956k 10.0.0.5/24}
```

```bash
curl -X POST --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":["enode://BBBBB@10.0.0.5:30304"],"id":0}' -H "Content-Type: application/json" 0.0.0.0:8549

>> {"jsonrpc":"2.0","result":true,"id":0}
```

You should now see the two peers synced (UI or logs) for peer A.s

## Authority accounts

The accounts are easy to remember as created from passphrase + password.
They are securely stored using docker secrets.

## TODO

[] recover from command line
[] test adding user account later
[] test adding authority later
