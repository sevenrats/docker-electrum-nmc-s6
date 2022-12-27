# docker-electrum-nmc

**Electrum-NMC client running as a daemon in a docker container with JSON-RPC enabled.**

[Electrum-NMC](https://www.namecoin.org/docs/electrum-nmc/) is light bitcoin wallet software operates through public Electrum-NMC server instances.

### Ports

* `7000` - JSON-RPC port.

### Volumes

* The internal paths `/data` and ``/home/user/.electrum`` are linked within the container. Mount your data directory to either one.

## Getting started

####  Running with docker-compose

```bash
version: '3'
services:
  electrum:
    image: electrum-nmc
    container_name: electrum-nmc
    ports:
      - 127.0.0.1:7000:7000
    environment:
      - ELECTRUM_USER=electrum
      - ELECTRUM_PASSWORD=electrumz
      - TESTNET="False"
    volumes:
      - ./data:/data
```


#### Commands
```bash
curl --data-binary '{"id":"1","method":"listaddresses"}' http://electrum:electrumz@localhost:7000
```
```bash
docker exec electrum-nmc nmc create
docker exec electrum-nmc nmc load_wallet
```
```bash
docker exec -it electrum-nmc nmc getinfo
{
    "auto_connect": true,
    "blockchain_height": 505136,
    "connected": true,
    "fee_per_kb": 427171,
    "path": "/home/electrum/.electrum",
    "server": "us01.hamster.science",
    "server_height": 505136,
    "spv_nodes": 10,
    "version": "3.0.6",
    "wallets": {
        "/home/electrum/.electrum/wallets/default_wallet": true
    }
}
```

:exclamation:**Warning**:exclamation:

As built, the electrum-nmc daemon listens on 0.0.0.0
You should limit access to port 7000 for security reasons.

## API

* [Electrum protocol specs](http://docs.electrum.org/en/latest/protocol.html)
* [API related sources](https://github.com/spesmilo/electrum/blob/master/lib/commands.py)

## License

See [LICENSE]()

