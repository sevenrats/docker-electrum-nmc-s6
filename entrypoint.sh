#!/usr/bin/env bash
set -ex
# Proxy signals
sp_processes=("electrum-nmc")
. ./signalproxy.sh

# Overload Traps
  #none

# Configure Stuff
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

electrum-nmc $FLAGS --offline setconfig rpcuser ${ELECTRUM_USER}
electrum-nmc $FLAGS --offline setconfig rpcpassword ${ELECTRUM_PASSWORD}
electrum-nmc $FLAGS --offline setconfig rpchost 0.0.0.0
electrum-nmc $FLAGS --offline setconfig rpcport 7000

# Run application
electrum-nmc $FLAGS daemon & \
wait -n
