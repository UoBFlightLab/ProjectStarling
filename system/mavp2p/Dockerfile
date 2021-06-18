FROM ubuntu:focal

ARG TARGETARCH

ARG MAVP2P_REPO=https://github.com/aler9/mavp2p
ARG MAVP2P_RELEASE=v0.6.5

ADD ${MAVP2P_REPO}/releases/download/${MAVP2P_RELEASE}/mavp2p_${MAVP2P_RELEASE}_linux_${TARGETARCH}.tar.gz /usr/src/

RUN tar -xzf /usr/src/mavp2p_${MAVP2P_RELEASE}_linux_${TARGETARCH}.tar.gz -C /usr/bin

COPY entrypoint.sh get_sitls.sh /usr/bin/

ENTRYPOINT [ "entrypoint.sh" ]
