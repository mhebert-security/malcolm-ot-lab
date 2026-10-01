# malcolm-ot-lab

Companion to "Deploying Malcolm for OT Traffic Visibility"
From Bedside to Substation — Module 3, Article 7
https://mhebert.dev/ot-learning/module-3-detection/

Malcolm is an open-source network traffic analysis suite from the Center for
Internet Security that bundles Zeek (with ICSNPP OT protocol parsers), Suricata,
Arkime, and OpenSearch into a single Docker Compose stack.

This repo does not package Malcolm. It packages the deployment decisions, network
plumbing notes, and log-reading reference so that someone standing up their own
instance has a guide for what working correctly looks like at each stage.

## Quick start

```bash
git clone https://github.com/cisagov/Malcolm
cd Malcolm
python3 ./scripts/install.py
cp /path/to/this/repo/compose/docker-compose.override.yml .
cp /path/to/this/repo/compose/.env.example .env   # edit before use
docker compose up -d
```

Drop a PCAP into the ingest path:

```bash
bash scripts/ingest-pcap.sh /path/to/capture.pcap
```

Tail only OT protocol logs during a live session:

```bash
bash scripts/tail-ot-logs.sh
```

## Layout

```
docs/01-deployment.md          host requirements, install script, docker compose
docs/02-network-plumbing.md    SPAN port config, TAP alternative, receive-only notes
docs/03-feeding-it-traffic.md  live capture vs PCAP ingest modes
docs/04-reading-ot-traffic.md  annotated log excerpts: Modbus, DNP3, EtherNet/IP
compose/docker-compose.override.yml  resource limits and interface overrides
compose/.env.example           required environment variables with comments
pcap/README.md                 how to drop captures into the ingest path
scripts/ingest-pcap.sh         copy a PCAP into Malcolm's upload directory
scripts/tail-ot-logs.sh        tail modbus.log, dnp3.log, enip.log live
```

## Requirements

- Ubuntu 22.04 (or comparable Linux)
- 32 GB RAM recommended (16 GB minimum)
- 8 vCPUs recommended
- 1 TB SSD for log and PCAP storage
- Docker and Docker Compose
- A second NIC connected to a SPAN port or network TAP for live capture
