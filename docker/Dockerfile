FROM parity/parity:v2.2.2
LABEL maintainer="vincent@serpoul.com"

# SAD but It seems impossible to read the mount otherwise
# https://github.com/moby/moby/issues/7198
USER root

VOLUME ["/home/parity/.local/share/io.parity.ethereum"]

COPY ./configPoANode.toml /home/parity/configPoANode.toml
COPY ./PoA.json /home/parity/PoA.json
COPY ./entrypoint.sh /home/parity/entrypoint.sh

ENTRYPOINT ["/home/parity/entrypoint.sh"]