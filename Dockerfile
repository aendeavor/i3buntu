ARG OS_VER=18.04

FROM ubuntu:${OS_VER} AS baseOS

LABEL maintainer="georg.lauterbach@mailbox.tu-dresden.de"
LABEL version="0.0.1"
LABEL description="Custom Ubuntu 18.04 LTS with the i3 Window Manager"

SHELL [ "/bin/bash", "-c" ]

WORKDIR ${HOME}

COPY ./scripts/* i3buntu/scripts/
COPY ./resources/* i3buntu/resources/

# execute the actual scripts for i3buntu
RUN ${HOME}/i3buntu/scripts/packaging.sh
RUN ${HOME}/i3buntu/scripts/configuration.sh

CMD [ "/bin/bash" ]
