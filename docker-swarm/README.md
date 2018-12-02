# Docker swarm setup

## Setting the configs in docker config

```bash
  docker config create PoA.json ./PoA.json;
  for auth in A B C;
  do
    docker config create configPoANode.$auth.toml ./configPoANode.$auth.toml;
    docker config create authority.$auth.address ./authority.$auth.address;
  done;
```

## Setting the secrets in docker secrets

```bash
  for auth in A B C;
  do
    docker secret create authority.$auth.priv.json ./authority.$auth.priv.json;
    docker secret create authority.$auth.password ./authority.$auth.password;
  done;
```
