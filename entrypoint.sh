#!/usr/bin/env bash


log() {
  echo
  echo $(date +%d/%m\ %I:%M:%S\ %p):  $@
}

print() {
  echo "                   "$@
}

echo $'
   ________          __                                   _   ____  _________
  / ____/ /__  _____/ /________  ______ ___              / | / /  |/  / ____/
 / __/ / / _ \/ ___/ __/ ___/ / / / __ \`__\   ______   /  |/ / /|_/ / /
/ /___/ /  __/ /__/ /_/ /  / /_/ / / / / / /  /_____/  / /|  / /  / / /___
\____/_/\___/\___/\__/_/   \__,_/_/ /_/ /_/           /_/ |_/_/  /_/\____/
'
log Starting up...

print Persistent RPC config is not yet supported...
# Configure Stuff

if [ -v ENMC_USER ]; then
  rpcuser=$ENMC_USER
else
  rpcuser=namecoin
fi

if [ -v ENMC_PASSWORD ]; then
  rpcpassword=$ENMC_PASSWORD
else
  rpcpassword=namecoinz
fi

if [ -v ENMC_HOST ]; then
  rpchost=$ENMC_HOST
else
  rpchost=0.0.0.0
fi

if [ -v ENMC_PORT ]; then
  rpcport=$ENMC_PORT
else
  rpcport=8334
fi

print RPC Server: $rpchost:$rpcport

if [ "$ELECTRUM_NETWORK" = "testnet" ]; then
  print "Network: TESTNET!"
  FLAGS='--testnet'
elif [ "$ELECTRUM_NETWORK" = "regtest" ]; then
  print "Network: REGTEST"
  FLAGS='--regtest'
elif [ "$ELECTRUM_NETWORK" = "simnet" ]; then
  print "Network: SIMNET"
  FLAGS='--simnet'
else
  print "Network: MAINNET"
fi

if  [ $(electrum-nmc $FLAGS --offline setconfig rpcuser ${rpcuser}) ] && \
    [ $(electrum-nmc $FLAGS --offline setconfig rpcpassword ${rpcpassword}) ] && \
    [ $(electrum-nmc $FLAGS --offline setconfig rpchost ${rpchost}) ] && \
    [ $(electrum-nmc $FLAGS --offline setconfig rpcport ${rpcport}) ]; then
    log Configuration successful.  Launching Electrum-NMC daemon...
    echo
else
    log Configuration failed. Exiting.
    exit
fi

# Run application
electrum-nmc $FLAGS daemon -v
