FROM python:3.9-alpine3.16
ARG BUILD_DATE
LABEL	maintainer="sevenrats" \
		build-date=$BUILD_DATE \
		name="Electrum-NMC" \
		description="Electrum-NMC with JSON-RPC enabled"

ENV VERSION_TAG "nc4.0.1"
ENV ELECTRUM_USER namecoin
ENV ELECTRUM_PASSWORD namecoinz
ENV ELECTRUM_HOME /home/$ELECTRUM_USER
ENV ELECTRUM_NETWORK mainnet

RUN \
	echo "**** install electrum-nmc ****" && \
	apk --no-cache add --virtual .build-deps git gcc musl-dev && \
	apk --no-cache add libsecp256k1-dev bash catatonit procps && \
    git clone --depth 1 --branch  ${VERSION_TAG} https://github.com/namecoin/electrum-nmc.git && \
	pip3 install ./electrum-nmc pycryptodomex && \
    git clone --depth 1 https://github.com/sevenrats/bash-signal-proxy.git && \
    cp bash-signal-proxy/signalproxy.sh / && \
	rm -rf electrum-nmc  bash-signal-proxy && \
	apk del .build-deps && \
	rm -rf \
		/tmp/* \
		/root/.cache

RUN \
adduser -D $ELECTRUM_USER && \
mkdir -p /data \
	${ELECTRUM_HOME}/.electrum/wallets/ \
	${ELECTRUM_HOME}/.electrum/testnet/wallets/ \
	${ELECTRUM_HOME}/.electrum/regtest/wallets/ \
	${ELECTRUM_HOME}/.electrum/simnet/wallets/ && \
ln -sf ${ELECTRUM_HOME}/.electrum/ /data && \
chown -R ${ELECTRUM_USER} ${ELECTRUM_HOME}/.electrum /data && \
ln -sf /usr/local/bin/electrum-nmc /usr/local/bin/nmc && \
mkdir /data/electrum-nmc

USER $ELECTRUM_USER
WORKDIR $ELECTRUM_HOME
VOLUME /data
EXPOSE 8334

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["catatonit", "/entrypoint.sh"]
