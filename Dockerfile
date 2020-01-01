FROM ubuntu:18.04

SHELL [ "/bin/bash", "-c" ]

LABEL maintainer="georg.lauterbach@mailbox.tu-dresden.de"
LABEL version="0.0.1"
LABEL description="Custom Ubuntu 18.04 LTS"

RUN apt-get -y -qq update && apt-get install -y -q dialog apt-utils sudo &>>/dev/null

COPY resources/scripts/docker_conf.sh /setup/
COPY resources/sys/ /setup/sys/

RUN /setup/docker_conf.sh

CMD [ "/bin/bash" ]
