FROM parity/parity:v2.2.1
LABEL maintainer="vincent@serpoul.com"

VOLUME ["/home/parity/.local/share/io.parity.ethereum"]

ADD ./configPoANode.toml /home/parity/configPoANode.toml
ADD ./PoA.json /home/parity/PoA.json
ADD ./entrypoint.sh /home/parity/entrypoint.sh

ENTRYPOINT ["/home/parity/entrypoint.sh"]