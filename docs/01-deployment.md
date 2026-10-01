# Deployment

## Host requirements

| Resource | Minimum | Recommended |
|----------|---------|-------------|
| RAM | 16 GB | 32 GB |
| vCPUs | 4 | 8 |
| Disk | 500 GB SSD | 1 TB SSD |
| OS | Ubuntu 20.04 | Ubuntu 22.04 |
| NICs | 1 (PCAP ingest only) | 2 (live capture) |

OpenSearch is the memory constraint. It will claim as much heap as you give
it. On a 32 GB host, the default Malcolm configuration splits memory
reasonably across OpenSearch, Zeek, and Arkime. On a 16 GB host, expect to
tune the JVM heap settings before the stack stabilizes.

## Install

```bash
git clone https://github.com/cisagov/Malcolm
cd Malcolm
python3 ./scripts/install.py
```

The install script asks a series of questions about authentication, TLS,
and which interface to listen on. Answer them, then:

```bash
docker compose up -d
```

The web interface is available at https://localhost (port 443).
Default credentials are set during the install script run.

## Modes

**Live capture**: Malcolm listens on a network interface in promiscuous mode
and processes every frame as it arrives. Set the capture interface during
install or in `.env` (`PCAP_IFACE`).

**PCAP ingest**: Drop a `.pcap` or `.pcapng` file into `./pcap/upload/` and
Malcolm picks it up automatically. See `scripts/ingest-pcap.sh` and
`pcap/README.md`.

## Resource limits

The `compose/docker-compose.override.yml` in this repo sets conservative
memory limits for a 32 GB host. Edit the values if your host differs.
