# Parity PoA demo setup

## If you don't have any keys and want to generate them automatically \*FOR THE DEMO PURPOSE / ! \ INSECURE / ! \*

### Generate your keys

```bash
  for auth in A B C;
    do docker run -it --rm --name paritygenkeys --entrypoint /bin/bash parity/parity:v2.2.1 -c "parity account new --password <(echo '1234567890') && cat ~/.local/share/io.parity.ethereum/keys/ethereum/*" > authority.$auth.txt;
  done;
```

### Set secrets in docker

```bash
docker secret rm validatorsInitSet;
{echo '"';sed -n 1p authority.A.txt;echo '", "';sed -n 1p authority.B.txt;echo '", "';sed -n 1p authority.C.txt;echo '"';} | tr -d '\r\n' | docker secret create validatorsInitSet -;

for auth in A B C;
do
  docker secret rm authority.$auth.address authority.$auth.priv.json authority.$auth.password;
  sed -n 1p authority.$auth.txt | tr -d '\r\n' | docker secret create authority.$auth.address -;
  sed -n 2p authority.$auth.txt | docker secret create authority.$auth.priv.json -;
  rm -f authority.$auth.txt;
  echo "1234567890" | docker secret create authority.$auth.password -;
done;
```

## Connecting the nodes together

get the node A enode id:

```bash
curl --data '{"jsonrpc":"2.0","method":"parity_enode","params":[],"id":0}' -H "Content-Type: application/json" -X POST 127.0.0.1:8545

>> {"jsonrpc":"2.0","result":"enode://AAAAA@10.255.0.4:30303","id":0}
```

BEWARE, the default given IP (here 10.255.0.4) is obviously wrong! These containers speak together directly, so we need the virtual poa_network IP that was given to it.

```bash
docker service inspect poa_A -f '{{index .Endpoint.VirtualIPs 1}}'

>> {ohifa7fog4gyacne0w88bawaw 10.0.0.2/24}
```

You need to use the address 10.0.1.2 when you add the A peer to the B peer

```bash
curl -X POST --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":["enode://AAAAA@10.0.0.2:30303"],"id":0}' -H "Content-Type: application/json" 127.0.0.1:8547

>> {"jsonrpc":"2.0","result":true,"id":0}
```

now add the C peer to the B peer:

Get the C peer details

```bash
curl --data '{"jsonrpc":"2.0","method":"parity_enode","params":[],"id":0}' -H "Content-Type: application/json" -X POST 127.0.0.1:8549

>> {"jsonrpc":"2.0","result":"enode://CCCCC@10.255.0.4:30305","id":0}
```

```bash
docker service inspect poa_C -f '{{index .Endpoint.VirtualIPs 1}}'

>> {ohifa7fog4gyacne0w88bawaw 10.0.0.7/24}
```

```bash
curl -X POST --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":["enode://CCCCC@10.0.0.7:30305"],"id":0}' -H "Content-Type: application/json" 127.0.0.1:8547

>> {"jsonrpc":"2.0","result":true,"id":0}
```

and if needed, now add the B peer to the C peer:
Get the B peer details

```bash
curl --data '{"jsonrpc":"2.0","method":"parity_enode","params":[],"id":2}' -H "Content-Type: application/json" -X POST 127.0.0.1:8547

>> {"jsonrpc":"2.0","result":"enode://BBBBB@10.255.0.4:30304","id":0}
```

```bash
docker service inspect poa_B -f '{{index .Endpoint.VirtualIPs 1}}'

>> {at6teoejgl6fhk32ig1gu956k 10.0.0.5/24}
```

```bash
curl -X POST --data '{"jsonrpc":"2.0","method":"parity_addReservedPeer","params":["enode://BBBBB@10.0.0.5:30304"],"id":0}' -H "Content-Type: application/json" 127.0.0.1:8549

>> {"jsonrpc":"2.0","result":true,"id":0}
```

You should now see the two peers synced (UI or logs) for peer A.s
