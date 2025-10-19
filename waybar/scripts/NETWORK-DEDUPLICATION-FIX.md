# Network Deduplication Fix

## Issue
Networks were appearing multiple times in the WiFi picker, with duplicates increasing on each click.

## Root Cause
When a WiFi network (SSID) is broadcast from:
- **Multiple access points** (e.g., mesh network or multiple routers with same name)
- **Multiple bands** (2.4GHz and 5GHz)
- **Multiple channels**

NetworkManager's `nmcli dev wifi list` returns **separate entries** for each BSSID (MAC address of the access point), even if they share the same SSID.

Example:
```
SSID          BSSID              SIGNAL  CHANNEL
MyNetwork     AA:BB:CC:DD:EE:01  80%     2.4GHz Channel 6
MyNetwork     AA:BB:CC:DD:EE:02  75%     5GHz Channel 36
MyNetwork     AA:BB:CC:DD:EE:03  70%     2.4GHz Channel 11
```

All three would appear in the list, even though they're the same network.

## Solution
Implemented **deduplication by SSID** in the awk processing:

```awk
# Store only the strongest signal for each SSID
if (!(ssid in max_signal) || signal > max_signal[ssid]) {
    max_signal[ssid] = signal
    ssid_security[ssid] = security
    ssid_bars[ssid] = bars
}
```

This keeps track of the **strongest signal** for each unique SSID and shows only that entry.

## Benefits

1. **Cleaner list** - Each network appears only once
2. **Best connection** - Shows the strongest signal available
3. **Less clutter** - Easier to find the network you want
4. **Accurate representation** - Most users think of networks by SSID, not BSSID

## Technical Details

When you connect to a deduplicated SSID, NetworkManager automatically:
- Selects the best available access point (strongest signal)
- Handles roaming between access points
- Manages band steering (2.4GHz vs 5GHz)

So showing only the strongest signal is both accurate and user-friendly.

## Testing

Before fix:
- Same network appeared 3+ times
- Got worse with each menu open
- Confusing for users

After fix:
- Each network appears exactly once
- Shows strongest available signal
- Clean, professional interface
