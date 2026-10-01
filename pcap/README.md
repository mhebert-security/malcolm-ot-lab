# PCAP Ingest

Place `.pcap` or `.pcapng` files here to ingest them into Malcolm manually.
The `scripts/ingest-pcap.sh` script handles the copy.

## How ingest works

Malcolm's `pcap-monitor` container watches `./pcap/upload/` inside the
Malcolm checkout directory. When a new file appears there, it is processed
by Zeek and Suricata, and the results are indexed into OpenSearch.

This directory is a staging area for files before the script copies them.
Do not commit large capture files to the repository.

## Generating captures for this lab

From the Modbus lab (Module 2, Article 1):

```bash
sudo tcpdump -i lo port 502 -w modbus-lab.pcap
```

From the DNP3 lab (Module 2, Article 3):

```bash
sudo tcpdump -i lo port 20000 -w dnp3-lab.pcap
```

From the EtherNet/IP lab (Module 2, Article 2):

```bash
sudo tcpdump -i lo port 44818 -w enip-lab.pcap
```

Then ingest:

```bash
bash scripts/ingest-pcap.sh modbus-lab.pcap
bash scripts/ingest-pcap.sh dnp3-lab.pcap
bash scripts/ingest-pcap.sh enip-lab.pcap
```
