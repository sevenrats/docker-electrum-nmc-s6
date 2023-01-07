FROM python:3.9-alpine3.16
ARG BUILD_DATE
LABEL	maintainer="sevenrats" \
		build-date=$BUILD_DATE \
		name="Electrum-NMC" \
		description="Electrum-NMC with JSON-RPC enabled"

ENV ELECTRUM_VERSION "4.0.0b1"
ENV ELECTRUM_USER namecoin
ENV ELECTRUM_PASSWORD namecoinz
ENV ELECTRUM_HOME /home/$ELECTRUM_USER
ENV ELECTRUM_NETWORK mainnet

RUN \
	echo "**** install electrum-nmc ****" && \
	apk --no-cache add --virtual build-dependencies gcc musl-dev && \
	apk --no-cache add libsecp256k1-dev bash catatonit procps && \
	wget https://www.namecoin.org/files/electrum-nmc/electrum-nmc-${ELECTRUM_VERSION}/Electrum-NMC-${ELECTRUM_VERSION}.tar.gz && \
	pip3 install Electrum-NMC-${ELECTRUM_VERSION}.tar.gz pycryptodomex && \
	rm -f Electrum-NMC-${ELECTRUM_VERSION}.tar.gz && \
	apk del build-dependencies && \
	cd / && \
	wget https://raw.githubusercontent.com/sevenrats/signalproxy.sh/main/signalproxy.sh && \
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
EXPOSE 7000

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["catatonit", "/entrypoint.sh"]
