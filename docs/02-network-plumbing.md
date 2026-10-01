# Network Plumbing

## Getting OT traffic to Malcolm

Malcolm needs to receive a copy of OT network traffic. There are two ways
to do this.

### Option 1: SPAN port (port mirroring)

A managed switch can be configured to copy every frame from one or more
source ports to a designated mirror port. Connect the mirror port to a
second NIC on the Malcolm host. Configure Malcolm to listen on that NIC.

SPAN port configuration varies by vendor. On a Cisco IOS switch:

```
monitor session 1 source interface GigabitEthernet0/1 both
monitor session 1 destination interface GigabitEthernet0/8
```

This copies all traffic on Gi0/1 to Gi0/8. Gi0/8 connects to the Malcolm
host's capture NIC.

SPAN ports can drop frames under high load. For most lab and light
production deployments this is acceptable.

### Option 2: Network TAP

A hardware TAP sits inline on a cable and passively copies all traffic
to a monitoring port. TAPs never drop frames and are completely passive
from the network's point of view. They are the preferred option for
critical production segments.

## Keeping Malcolm off the OT network

The Malcolm host must not be able to inject traffic onto the OT segment.

- The capture NIC should receive only. Most switches with SPAN will not
  forward traffic sent back out the mirror port, but verify with your
  vendor.
- Remove the default gateway from the capture interface:
  ```bash
  ip route del default dev eth1
  ```
- Confirm with `ip route` that no route uses the capture interface as
  the outbound path.

## Interface naming

Find your capture interface name before starting Malcolm:

```bash
ip link show
```

Set it in `.env`:

```
PCAP_IFACE=eth1
```
