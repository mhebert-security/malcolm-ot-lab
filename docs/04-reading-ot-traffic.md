# Reading OT Traffic in Malcolm

## Modbus logs

Malcolm's Zeek ICSNPP build produces a `modbus.log` with one row per
Modbus transaction. Key fields:

| Field | Description |
|-------|-------------|
| `ts` | Timestamp |
| `uid` | Connection identifier |
| `id.orig_h` | Source IP |
| `id.resp_h` | Destination IP |
| `func` | Function code (integer) |
| `unit_id` | Modbus unit identifier |
| `pdu_type` | REQUEST or RESPONSE |

Common function codes:

| Code | Name |
|------|------|
| 1 | Read Coils |
| 3 | Read Holding Registers |
| 5 | Write Single Coil |
| 6 | Write Single Register |
| 15 | Write Multiple Coils |
| 16 | Write Multiple Registers |

A write from an engineering workstation to a PLC appears as `func=16`
with `id.orig_h` matching the workstation IP. A write from any other
source is worth investigating.

## DNP3 logs

The `dnp3.log` has one row per DNP3 application layer request. Key fields:

| Field | Description |
|-------|-------------|
| `ts` | Timestamp |
| `id.orig_h` | Master IP (source) |
| `id.resp_h` | Outstation IP (destination) |
| `fc_request` | Application function code |
| `fc_reply` | Reply function code |

Function codes to watch:

| Code | Name | Technique |
|------|------|-----------|
| 4 | Operate | T0855 |
| 5 | Direct Operate | T0855 |
| 6 | Direct Operate NR | T0855 |
| 13 | Cold Restart | T0816 |
| 14 | Warm Restart | T0816 |
| 21 | Disable Unsolicited | T0804 |

## EtherNet/IP logs

The ICSNPP EtherNet/IP analyzer produces an `enip.log`. The most useful
fields are `enip.command` (the encapsulation command) and `cip.service`
(the CIP service code). Service codes to flag outside the engineering
workstation:

| Service | Name |
|---------|------|
| 0x10 | SetAttributeSingle |
| 0x4d | WriteTag (ControlLogix) |
| 0x4b | Generic Service |

## Querying in Dashboards

Open https://localhost, navigate to OpenSearch Dashboards, and use the
Discover view. Useful queries:

```
# All Modbus writes
zeek_modbus.func: (5 OR 6 OR 15 OR 16)

# DNP3 control operations
zeek_dnp3.fc_request: (4 OR 5 OR 6)

# DNP3 restarts
zeek_dnp3.fc_request: (13 OR 14)
```

Pivot from any session to its raw packets in Arkime by clicking the
session ID in the Dashboards interface.
