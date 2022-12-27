#!/usr/bin/env bash
set -ex

# Proxy signals
_term() { 
  echo "Caught SIGTERM signal!"
  pkill -TERM -P1
  electrum-nmc daemon stop
  exit 0
}

trap _term SIGTERM

# Network switch
if [ "$ELECTRUM_NETWORK" = "testnet" ]; then
  echo "Connecting to TESTNET!"
  FLAGS='--testnet'
elif [ "$ELECTRUM_NETWORK" = "regtest" ]; then
  echo "Connecting to REGTEST!"
  FLAGS='--regtest'
elif [ "$ELECTRUM_NETWORK" = "simnet" ]; then
  echo "Connecting to SIMNET!"
  FLAGS='--simnet'
fi

# Set config
electrum-nmc $FLAGS --offline setconfig rpcuser ${ELECTRUM_USER}
electrum-nmc $FLAGS --offline setconfig rpcpassword ${ELECTRUM_PASSWORD}
electrum-nmc $FLAGS --offline setconfig rpchost 0.0.0.0
electrum-nmc $FLAGS --offline setconfig rpcport 7000

# Run application
electrum-nmc $FLAGS daemon &
wait -n ${!}
