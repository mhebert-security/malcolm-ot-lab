# Feeding Malcolm Traffic

## Live capture

If Malcolm was configured for live capture during install, it begins
processing frames immediately after `docker compose up -d`. Confirm
with:

```bash
docker compose logs zeek | tail -20
```

You should see Zeek reporting packets processed on the capture interface.

## PCAP ingest

Drop a capture file into the upload directory and Malcolm will process it:

```bash
bash scripts/ingest-pcap.sh /path/to/capture.pcap
```

The script copies the file to `./pcap/upload/`. Malcolm's file monitor
picks it up, runs Zeek and Suricata over it, and indexes the results into
OpenSearch. Processing time depends on file size and host resources. A
100 MB capture typically takes two to five minutes.

## Generating test traffic

Use the Modbus and DNP3 lab scripts from earlier in this series to generate
known-good OT traffic, then capture and ingest it:

```bash
# capture 60 seconds of traffic on loopback
tcpdump -i lo -w test.pcap -G 60 -W 1
bash scripts/ingest-pcap.sh test.pcap
```

## Confirming ingestion

Query the OpenSearch Dashboards interface at https://localhost, navigate
to Discover, and filter by `_index: arkime_sessions3-*` to confirm
sessions were indexed. Filter by `zeek_modbus.func` to confirm Modbus
function codes were parsed.
