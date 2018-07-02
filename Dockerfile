FROM resin/raspberrypi3-debian:stretch AS kernel-builder

RUN apt-get update && apt-get install -y \
    build-essential \
    i2c-tools \
    wget \
    libraspberrypi-bin alsa-utils \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG HEADERS_URL="https://files.resin.io/images/raspberrypi3/2.12.7%2Brev1.prod/kernel_modules_headers.tar.gz"
ARG HEADERS_PATH=/tmp/kernel_modules_headers
ARG MODULE_URL="https://github.com/respeaker/seeed-voicecard/archive/master.tar.gz"
ARG MODULE_PATH="/opt/seeed-voicecard"

RUN mkdir -p $HEADERS_PATH \
    && cd $HEADERS_PATH \
    && wget $HEADERS_URL \
    && tar -xf kernel_modules_headers.tar.gz --strip 1
RUN mkdir -p $MODULE_PATH \
    && cd $MODULE_PATH \
    && wget $MODULE_URL \
    && tar -xf master.tar.gz --strip 1 \
    && make -C $HEADERS_PATH M=$MODULE_PATH modules \
    && mkdir -p /etc/voicecard \
    && cp *.conf /etc/voicecard \
    && cp *.state /etc/voicecard \
    && cp seeed-voicecard /usr/bin

##################################################

FROM resin/raspberrypi3-alpine-node:8-slim AS node-builder

RUN apk --no-cache add python make g++

WORKDIR /build

COPY ./package.json ./
COPY ./package-lock.json ./

RUN npm i

##################################################

FROM resin/raspberrypi3-alpine-node:8-slim

RUN apk --no-cache add alsa-utils
RUN apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing add i2c-tools

RUN mkdir -p /app/modules \
    && mkdir -p /etc/voicecard

COPY --from=kernel-builder /opt/seeed-voicecard/*.ko /app/modules/
COPY --from=kernel-builder /opt/seeed-voicecard/*.dtbo /etc/voicecard/
COPY --from=kernel-builder /opt/seeed-voicecard/*.dts /etc/voicecard/
COPY --from=kernel-builder /opt/seeed-voicecard/*.conf /etc/voicecard/
COPY --from=kernel-builder /opt/seeed-voicecard/*.state /etc/voicecard/

COPY --from=node-builder /build /app/
COPY --from=node-builder /build/node_modules /app/node_modules/

COPY run.sh /app/
COPY index.js /app/

WORKDIR /app

CMD [ "/bin/bash", "/app/run.sh" ]
