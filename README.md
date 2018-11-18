# Parity PoA demo setup

## If you don't have any keys and want to generate them automatically \*FOR THE DEMO PURPOSE / ! \ INSECURE / ! \*

### Generate your keys

```bash
  for auth in A B C;
    do docker run -it --rm --name paritygenkeys --entrypoint /bin/bash parity/parity:v2.2.1 -c "parity account new --password <(echo '1234567890') && cat ~/.local/share/io.parity.ethereum/keys/ethereum/*" > authority.$auth.txt;
  done;
```

## Set secrets in docker

```bash
{echo '"';sed -n 1p authority.A.txt;echo '", "';sed -n 1p authority.B.txt;echo '", "';sed -n 1p authority.C.txt;echo '"';} | tr -d '\r\n' | docker secret create validatorsInitSet -;

for auth in A B C;
do
  sed -n 1p authority.$auth.txt | docker secret create authority.$auth.address -;
  sed -n 2p authority.$auth.txt | docker secret create authority.$auth.priv.json -;
  rm -f authority.$auth.txt;
  echo "1234567890" | docker secret create authority.$auth.password -;
done;
```
