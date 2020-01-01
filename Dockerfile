FROM ubuntu:18.04

LABEL maintainer="georg.lauterbach@mailbox.tu-dresden.de"
LABEL version="0.0.1"
LABEL description="Custom Ubuntu 18.04 LTS"

# ! actually unnecessary as in the container, you are root by default
# TODO change later
RUN apt-get -y -qq update && apt-get install -y -qq dialog apt-utils sudo &>>/dev/null

COPY ./ /i3buntu/
# execute the actual scripts for i3buntu
RUN /i3buntu/scripts/docker_conf.sh

CMD [ "/bin/bash" ]
