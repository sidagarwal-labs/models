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

## Provider Supply and Expansion

Supply is not reported on one common basis. For DRAM and NAND, track bit shipments, node mix, HBM allocation, wafer capacity, and capex. For HDDs, track nearline exabytes, units, average TB per drive, and the highest capacity qualified for volume production.

| Provider | Supply position | Current production signal | Expansion / timing | Source type |
| --- | --- | --- | --- | --- |
| Samsung | DRAM, HBM, NAND, and eSSD; 39% Q2 2026 DRAM revenue share | HBM4 and SOCAMM2 mass-product sales started in Q1 2026 despite limited memory supply | Increase HBM4 base-die supply and expand DDR5, SOCAMM2, GDDR7, and AI-oriented TLC SSD sales during 2026; absolute capacity not disclosed | [Company earnings](https://news.samsung.com/global/samsung-electronics-announces-first-quarter-2026-results); market share is an analyst estimate |
| SK hynix / Solidigm | DRAM, HBM, NAND, and eSSD; 26% Q2 2026 DRAM revenue share | HBM4 mass shipments began in Q2 with a larger H2 ramp; 321-layer NAND is the largest production share | Target 321-layer NAND at ~50% of domestic capacity by year-end; accelerate M15X and open Yongin Phase 1 cleanroom in early 2027; P&T7 and M17 follow in phases | [Company earnings](https://news.skhynix.com/en/q2-2026-business-results/); announced plan |
| Micron (MU) | DRAM, HBM, NAND, and SSD; 25% Q2 2026 DRAM revenue share | HBM4, G9 PCIe Gen6 SSDs, and 245TB QLC SSDs are in high-volume shipment or initial shipment | $7.1B net capex in FQ3 2026; HBM4E volume production expected in 2027; no HBM stack volume disclosed | [SEC-filed company release](https://www.sec.gov/Archives/edgar/data/723125/000072312526000013/a2026q3ex991-pressrelease.htm); reported plus guidance |
| Kioxia + Sandisk (SNDK) | Joint NAND manufacturing with separate product portfolios; do not count the same JV wafers twice | Sandisk's Q4 volume growth contributed about one-third of its 51% sequential revenue increase | Customer agreements cover ~50% of FY2027 bits and ~two-thirds of FY2028 bits; BiCS10 QLC targets 60% more bit density than BiCS8, while 9th-gen 2Tb QLC reaches 4.8Gb/s | [Sandisk Investor Day](https://www.sandisk.com/company/newsroom/press-releases/2026/2026-08-13-sandisk-investor-day-2026) and [technology release](https://www.sandisk.com/company/newsroom/press-releases/2026/2026-08-12-kioxia-and-sandisk-unveil-new-high-performance-qlc-3d-flash-memory-for-ai-and-data-intensive-apps); reported plus targets |
| Western Digital (WDC) | HDD supplier after the February 2025 Sandisk separation; no NAND supply in continuing operations | Q4 FY2026 revenue was $3.75B; the release does not disclose units or nearline exabytes | UltraSMR, ePMR, and HAMR portfolio plus High Bandwidth Drive and dual-pivot technologies targeting 4x HDD throughput; volume ramp not quantified | [Company earnings](https://www.westerndigital.com/company/newsroom/press-releases/2026/2026-08-05-wd-reports-fiscal-fourth-quarter-and-fiscal-year-2026-financial-results) and [Computex roadmap](https://www.westerndigital.com/company/newsroom/press-releases/2026/2026-06-01-wd-at-computex-2026); reported plus projection |
| Seagate (STX) | Nearline HDD and mass-capacity storage; HAMR is the main density expansion path | Mozaic 4+ is qualified and in production with two hyperscale customers at capacities up to 44TB | Ramp 4TB-per-platter HAMR to raise exabytes per shipped drive; public release does not provide wafer-like capacity or a unit ramp | [Company product release](https://www.seagate.com/stories/articles/seagate-delivers-industrys-highest-capacity-hard-drives-with-next-generation-mozaic-4); reported qualification and production status |

The Samsung, SK hynix, and Micron percentages are DRAM **revenue** shares from [Counterpoint Research](https://counterpointresearch.com/en/insights/ai-demand-reshapes-dram-rankings-in-q2-2026), not wafer starts, bit output, or HBM share. Revenue share moves with product mix and price, so use it as market position rather than physical supply.

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

## August 2026 Baseline and Endpoints

Latency is an order-of-magnitude access class, not a directly comparable benchmark. This table compares prior-year and current endpoints; it is not a monthly history. Prior-year values marked **derived** divide the August 2026 endpoint by its reported year-over-year multiplier and are not observed historical quotes.

| Date | Type of memory / storage | Storage / capacity | Latency | Price | Source type |
| --- | --- | ---: | --- | ---: | --- |
| Jul 2025 | HBM3 12-Hi stack | 24 GB | ~100 ns class; system-dependent | ~$192/stack ($8.01/GB) | Derived prior-year endpoint from [reported indicative allocation pricing](https://memoryindex.io/hbm-price) |
| Jul 2026 | HBM3 12-Hi stack | 24 GB | ~100 ns class; system-dependent | ~$200/stack ($8.33/GB) | Reported indicative allocation level; no open spot market |
| Jul 2025 | HBM3e 12-Hi stack | 36 GB | ~100 ns class; system-dependent | ~$263/stack ($7.31/GB) | Derived prior-year endpoint from [reported indicative allocation pricing](https://memoryindex.io/hbm-price) |
| Jul 2026 | HBM3e 12-Hi stack | 36 GB | ~100 ns class; system-dependent | ~$300/stack ($8.33/GB) | Reported indicative allocation level; no open spot market |
| Aug 4, 2025 | DDR5 16Gb 4800/5600 die | 2 GB | Tens of ns; platform-dependent | ~$9.09/die ($4.55/GB) | Derived prior-year endpoint from the reported +480% YoY move |
| Aug 4, 2026 | DDR5 16Gb 4800/5600 die | 2 GB | Tens of ns; platform-dependent | $52.733/die ($26.37/GB) | [TrendForce](https://www.trendforce.com/price/dram/dram_spot) spot print; not a server RDIMM |
| Q2 2025 | Enterprise QLC NVMe SSD | 30.72 TB | ~0.1 ms class; workload-dependent | ~$1,755/drive ($57/TB) | Modeled prior-year endpoint from an estimated series |
| Q2 2026 | Enterprise QLC NVMe SSD | 30.72 TB | ~0.1 ms class; workload-dependent | ~$4,650/drive ($151/TB) | [TrendForce-based](https://memoryindex.io/ssd-prices) contract estimate |
| Aug 5, 2025 | Retail NVMe SSD market average | 2 TB | ~0.1 ms class; model mix | ~$118/drive ($59/TB) | Derived prior-year endpoint from the reported +220% YoY move |
| Aug 5, 2026 | Retail NVMe SSD market average | 2 TB | ~0.1 ms class; model mix | $378/drive ($189/TB) | [Retail tracker](https://rampricehistory.com/ssd/us/2tb-nvme); reported market average |
| Aug 2026 | Solidigm D5-P5430 QLC NVMe | 7.68 TB | ~0.1 ms read class | $2,944 ($383/TB) | New retail listing; not fleet contract pricing |
| Aug 2026 | Seagate Exos X24 HDD | 24 TB | 4.16 ms rotational; seek extra | $960 ($40/TB) | New retail listing; not fleet contract pricing |

`Reported` means the cited source printed the endpoint, `derived` is arithmetic on reported inputs, and `estimate` has no public transaction print. HBM and enterprise SSD contracts are negotiated; retail figures are fixed-product or market-basket proxies. Preserve the product, capacity, interface, condition, source, and observation date on every update.

## Update Cadence

| Signal | Cadence | Source |
| --- | --- | --- |
| HBM generation premium / ASP trend | Quarterly or when reported | [TrendForce HBM research](https://www.dramexchange.com/WeeklyResearch/Post/2/12345.html) |
| DDR5 die spot price | Weekly snapshot | [TrendForce DRAM](https://www.trendforce.com/price/dram) |
| TLC / QLC NAND wafer contract trend | Monthly | [TrendForce NAND](https://www.trendforce.com/price/flash/wafer_contract) |
| Client SSD contract proxy | Quarterly | [TrendForce client SSD](https://www.trendforce.com/price/flash/pcc_oem_ssd_contract) |
| Fixed enterprise SSD and HDD SKUs | Monthly | [DiskPrices](https://diskprices.com/) |
| HDD reliability by model | Quarterly | [Backblaze Drive Stats](https://www.backblaze.com/cloud-storage/resources/hard-drive-test-data) |
| Provider bit growth, HBM allocation, node mix, and capex | Quarterly | Company earnings and investor presentations |
| Fab, packaging, NAND-density, and HDD qualification milestones | Event-driven | Company newsrooms and regulatory filings |

Specifications: [Solidigm D5-P5430](https://www.solidigm.com/products/data-center/d5/p5430.html) and [Western Digital data-center HDDs](https://www.westerndigital.com/products/internal-drives/data-center-drives/ultrastar-dc-hc690-hdd).
