# AI Memory & Storage

HBM and DDR are volatile memory. NAND and HDD are persistent media; an SSD is a device built from NAND, a controller, and usually DRAM. For AI, HBM is the critical accelerator bottleneck, while SSDs and HDDs hold data outside the compute path.

## Stack

| Layer | What it is | Main AI role | Importance |
| --- | --- | --- | --- |
| HBM3e / HBM4 | Stacked DRAM beside the accelerator | Model weights, activations, KV cache | Highest: capacity and bandwidth constrain accelerator utilization |
| Server DDR5 RDIMM / MRDIMM | ECC host memory attached to CPUs | Data preparation, CPU inference, offload, caching | High at the node and cluster level |
| GDDR6 / GDDR7 | Lower-cost GPU memory | Workstations and cost-sensitive inference | Secondary for frontier training |
| NAND TLC / QLC | Nonvolatile flash cells used inside SSDs | Upstream cost driver, not a complete drive | Track as an SSD price signal |
| Enterprise NVMe SSD | NAND plus controller and firmware | Hot datasets, checkpoints, model loading, vector indexes | High for storage throughput and restart time |
| Nearline HDD | Magnetic disk, normally CMR at scale | Data lakes, cold corpora, backups, archive | Best capacity economics; lowest performance |

DRAM is the family: HBM, DDR, and GDDR are different forms of it. TLC NAND stores three bits per cell and favors endurance; QLC stores four and favors density. CMR HDDs handle general writes better than denser, more sequential SMR drives.

Typical bandwidth order: accelerator HBM `3-8+ TB/s`, one DDR5 channel `38-51 GB/s`, one PCIe 4/5 NVMe SSD `7-14 GB/s`, and one nearline HDD `0.25-0.30 GB/s`.

## Normalized Metrics

| Layer | Cost | Performance | Reliability / efficiency |
| --- | --- | --- | --- |
| HBM | $/GB, $/TB/s | GB/accelerator, TB/s | Generation, stack count, supplier |
| Server DRAM | $/GB | MT/s, platform GB/s | ECC, module capacity, watts/GB |
| NAND | $/Tb die or wafer, QoQ change | Bits/cell, layer count | Yield and endurance class |
| SSD | $/TB, $/(GB/s), $/M read IOPS | Sequential GB/s, random IOPS, latency | DWPD, PBW, watts/TB |
| HDD | $/TB, $/(GB/s) | Sustained GB/s | Workload TB/year, AFR, watts/TB |

Use decimal units consistently:

- `$/GB = price / capacity in GB`
- `$/TB = price / capacity in TB`
- `$/(GB/s) = price / sustained read GB/s`
- `watts/TB = active power / capacity in TB`

Do not convert NAND wafer prices to finished-drive $/TB without yield and packaging data. Do not compare HBM $/GB directly with SSD or HDD $/TB.

## August 2026 Baseline

| Market signal | Price | Normalized | Source type | Limitation |
| --- | ---: | ---: | --- | --- |
| HBM4 launch pricing | >30% premium | Relative to prior generation | Contract estimate | No transparent spot or public $/GB market; HBM3e debuted near a 20% premium |
| DDR5 16Gb 4800/5600 | $52.733 per 2GB die | $26.37/GB | Spot | Commodity die, not a qualified server RDIMM |
| 1TB TLC PCIe value SSD | $270.10 per drive | $270.10/TB | Q2 client OEM contract | Client SSD proxy; enterprise contracts differ |
| Solidigm D5-P5430 7.68TB QLC NVMe | $2,944 | $383/TB; $421/(GB/s) | New retail listing | Up to 7.0 GB/s; retail is not fleet contract pricing |
| Seagate Exos X24 24TB HDD | $960 | $40/TB; $3,368/(GB/s) | New retail listing | Uses 0.285 GB/s maximum sustained transfer; retail is not fleet pricing |

HBM, server DRAM, and enterprise SSD contract prices are mostly paid or negotiated. Track public spot/retail figures as fixed-SKU proxies and preserve product, capacity, interface, condition, source, and observation date.

## Update Cadence

| Signal | Cadence | Source |
| --- | --- | --- |
| HBM generation premium / ASP trend | Quarterly or when reported | [TrendForce HBM research](https://www.dramexchange.com/WeeklyResearch/Post/2/12345.html) |
| DDR5 die spot price | Weekly snapshot | [TrendForce DRAM](https://www.trendforce.com/price/dram) |
| TLC / QLC NAND wafer contract trend | Monthly | [TrendForce NAND](https://www.trendforce.com/price/flash/wafer_contract) |
| Client SSD contract proxy | Quarterly | [TrendForce client SSD](https://www.trendforce.com/price/flash/pcc_oem_ssd_contract) |
| Fixed enterprise SSD and HDD SKUs | Monthly | [DiskPrices](https://diskprices.com/) |
| HDD reliability by model | Quarterly | [Backblaze Drive Stats](https://www.backblaze.com/cloud-storage/resources/hard-drive-test-data) |

Specifications: [Solidigm D5-P5430](https://www.solidigm.com/products/data-center/d5/p5430.html) and [Western Digital data-center HDDs](https://www.westerndigital.com/products/internal-drives/data-center-drives/ultrastar-dc-hc690-hdd).
