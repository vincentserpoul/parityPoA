FROM parity/parity:v1.6.8
MAINTAINER Vincent Serpoul <vincent@serpoul.com>

EXPOSE 8180 8545 30303

# Install curl
RUN apt-get update && apt-get install curl -y

RUN mkdir -p /etc/parityPoA
ADD ./configPoAInit.toml /etc/parityPoA/configPoAInit.toml
ADD ./configPoANode.toml /etc/parityPoA/configPoANode.toml
ADD ./PoA.json /etc/parityPoA/PoA.json
ADD ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]