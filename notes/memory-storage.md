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

## Demand to Memory Bottleneck

This is an order-of-magnitude planning model, not a forecast. A useful volume anchor is Google's July 2026 disclosure that its models process [22B API tokens per minute](https://blog.google/company-news/inside-google/message-ceo/alphabet-earnings-q2-2026/), equal to `31.7T tokens/day`. This is not automatically physical compute demand because vendor counters can mix cached input, uncached prefill, output, and hidden reasoning tokens. Industry volume is higher because the disclosure excludes other providers, consumer surfaces, private inference, training, and non-text models.

### Conversion Chain

`users and agents -> tokens/day -> inference throughput -> accelerators -> HBM -> host DRAM and storage -> power`

- `average tokens/s = tokens/day / 86,400`
- `compute FLOP/s ~= 2 * active parameters * tokens/s`
- `compute-floor GPUs = FLOP/s / effective GPU FLOP/s`
- `practical fleet = tokens/s / achieved tokens/s/GPU * peak factor / schedulable fraction`
- `HBM = practical fleet * HBM/GPU`

The compute formula uses **active** parameters; HBM must hold **total** model weights plus KV cache. This distinction makes large mixture-of-experts models memory-heavy even when only a fraction of their parameters execute for each token.

For a first-pass conversion, treat one output or hidden-reasoning token as one compute-equivalent token, then discount cached and highly parallel input tokens based on observed serving cost. As demand intuition, `1B MAU * 20% DAU * 5K tokens/day` is only `1T tokens/day`, while `100M agents * 10 tokens/s` is `86.4T tokens/day`. Persistent agents can therefore overtake human chat without another billion users.

### Reference Assumptions

| Input | Planning value | Basis |
| --- | ---: | --- |
| H100-equivalent HBM | 80 GB; 3.35 TB/s | [NVIDIA H100](https://www.nvidia.com/en-us/data-center/h100/) |
| Effective arithmetic throughput | 400 TFLOP/s | Conservative fraction of peak FP8/BF16 after serving overhead |
| Peak / average demand | 2.0x | Diurnal and burst headroom assumption |
| Schedulable fleet | 70% | Allows for fragmentation, maintenance, failures, and reserved headroom |
| Host DRAM / accelerator | 250 GB | [DGX B200](https://www.nvidia.com/en-us/data-center/dgx-b200/) design point: 2 TB per eight GPUs |
| Local NVMe / accelerator | 3.84 TB | DGX B200 design point: 30.72 TB per eight GPUs |
| Allocated node IT power | 1.5 kW / accelerator | Planning value below DGX B200's 14.3 kW / eight-GPU maximum; excludes PUE |

Achieved throughput is deliberately modeled as a range. Decode is usually memory-bandwidth bound, and latency targets, context length, model routing, quantization, and batching can change tokens/GPU-second by more than 10x. NVIDIA likewise distinguishes parallel prefill from memory-bound autoregressive [decode](https://developer.nvidia.com/blog/mastering-llm-techniques-inference-optimization/).

### 2026 Inference Scenarios

| Scenario | Compute-equivalent tokens/day | Average active parameters | Achieved tokens/s per H100-equivalent | Compute floor | Practical serving fleet | HBM | Node IT power |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Low / routed models | 32T | 10B | 5,000 | 53K | 0.21M | 17 PB | 0.32 GW |
| Base / mixed workloads | 100T | 30B | 2,000 | 0.50M | 1.65M | 132 PB | 2.48 GW |
| High / reasoning-heavy | 300T | 70B | 750 | 3.47M | 13.2M | 1.06 EB | 19.8 GW |

The practical fleet includes the 2x peak and 70% schedulable assumptions; it excludes training, embeddings, image/video generation, and disaster-recovery replicas. The gap between the compute floor and practical fleet is the size of the serving penalty from HBM bandwidth, latency, batching limits, and utilization.

### Downstream Memory Footprint

| Scenario | Host DRAM at 250 GB/GPU | Local NVMe at 3.84 TB/GPU | Interpretation |
| --- | ---: | ---: | --- |
| Low | 53 PB | 0.81 EB | Large but readily tiered across regions |
| Base | 0.41 EB | 6.35 EB | Material demand for server DDR5 and enterprise SSDs |
| High | 3.31 EB | 50.8 EB | Requires major datacenter and storage-fleet expansion |

These DRAM and NVMe figures are DGX-like design points, not unavoidable ratios. Disaggregated storage, shared model caches, and CPU-light serving can reduce them. HBM is much less optional because weights and active KV cache must remain close to the accelerator for low-latency inference.

### Why HBM Binds Before Peak FLOPs

- A 70B model occupies about `70 GB` at FP8 or `140 GB` at BF16 before runtime buffers and KV cache. It barely fits, or does not fit, on one 80 GB H100.
- A Llama-2-like 70B model with grouped-query attention uses about `0.33 MB` of BF16 KV cache per token. One 128K-token live context is therefore about `42 GB`; concurrent contexts multiply this requirement.
- Reading 70 GB of FP8 weights against 3.35 TB/s gives a batch-1 ceiling near `48 decode steps/s` per H100-equivalent before kernels, communication, KV reads, and other overhead. Batching amortizes weight reads but consumes more KV memory and can worsen latency.
- Quantization roughly halves weight traffic from BF16 to FP8. Continuous batching and paged KV caches raise throughput, but they do not make bandwidth or capacity free.

### Demand Versus Supply Envelope

The [tracked FY2026 capex](ai-capex.md) is about `$750B` across the largest buyers. If `15-25%` funds accelerator-bearing systems at `$50K-$80K` per physical slot, the spending envelope is roughly **1.4M-3.8M new high-end accelerator slots**. At `80-180 GB HBM/slot`, those systems embody roughly **0.11-0.68 EB of HBM**.

This is a financing envelope, not verified fab output. Physical H100, B200, TPU, and custom-ASIC slots are not performance-equivalent, and training competes for the same supply. Still, it gives a useful scale comparison:

| Scenario | Fleet versus 1.4M-3.8M annual slot envelope | HBM versus 0.11-0.68 EB envelope |
| --- | ---: | ---: |
| Low | 6-15% | 3-15% |
| Base | 44-118% | 20-117% |
| High | 3.5-9.4x | 1.6-9.4x |

### Supplier Response

| Supplier | 2026 supply / expansion signal | Bottleneck effect |
| --- | --- | --- |
| Samsung | [HBM4 and SOCAMM2 mass-product sales](https://news.samsung.com/global/samsung-electronics-announces-first-quarter-2026-results); increasing HBM4 base-die supply amid limited memory availability | Direct HBM relief, but no public stack-volume target |
| SK hynix / Solidigm | [HBM4 mass shipments began in Q2](https://news.skhynix.com/en/q2-2026-business-results/) with an H2 ramp; M15X accelerated and Yongin Phase 1 cleanroom planned for early 2027 | Strongest near-term HBM response; company still says demand exceeds supply capability |
| Micron | [HBM4 in high-volume shipment](https://www.sec.gov/Archives/edgar/data/723125/000072312526000013/a2026q3ex991-pressrelease.htm), HBM4E planned for 2027, and $7.1B net capex in FQ3 2026 | Direct HBM relief; next large product step arrives in 2027 |
| Kioxia + Sandisk | Customer agreements cover [~50% of FY2027 bits and ~two-thirds of FY2028 bits](https://www.sandisk.com/company/newsroom/press-releases/2026/2026-08-13-sandisk-investor-day-2026); BiCS10 QLC targets 60% higher bit density than BiCS8 | Expands NAND/SSD supply, not accelerator HBM; much future output is already committed |
| Western Digital + Seagate | WD is HDD-only after the Sandisk separation; Seagate's [44TB Mozaic 4+](https://www.seagate.com/stories/articles/seagate-delivers-industrys-highest-capacity-hard-drives-with-next-generation-mozaic-4) is qualified and in production with two hyperscalers | Improves corpus and archive economics but does not relieve online decode or KV-cache limits |

Supplier language therefore supports a tight rather than loose HBM market. Newer accelerators improve throughput, but they also increase HBM per package and rack power.

### Bottleneck Ranking

| Layer | 2026 tightness | Reason |
| --- | --- | --- |
| HBM capacity and bandwidth | Very high | Weight fit, KV cache, and decode bandwidth all bind; qualified stacks are allocated with GPUs |
| Deployable accelerator systems | Very high | Advanced packaging, networking, liquid cooling, racks, and power must arrive together |
| Grid and datacenter power | Very high | Base text inference alone implies ~2.5 GW IT load, or ~3.0 GW at 1.2 PUE |
| GPU arithmetic | High, but not first | Practical serving needs ~3.3x the base-case FLOP floor |
| Server DDR5 | Medium-high | Roughly 2-4x HBM capacity per node and competes for DRAM wafers |
| Enterprise SSD | Medium | Several TB/GPU is useful, but storage can be shared and disaggregated |
| HDD | Low for online inference | Important for corpora and archives, but outside the token-generation latency path |

**Working conclusion:** the base case is tight but plausible; it consumes an order-one share of one year's high-end deployment envelope. A 3x increase from hidden reasoning or agent loops raises the base case to about `5M H100-equivalents`, `0.40 EB HBM`, and `7.4 GW` of node IT power. At that point, supply is clearly constrained unless routing, quantization, caching, and newer accelerators improve effective tokens per watt and per HBM byte at a similar rate.

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

Specifications: [Solidigm D5-P5430](https://www.solidigm.com/products/data-center/d5/p5430.html) and [Western Digital data-center HDDs](https://www.westerndigital.com/products/internal-drives/data-center-drives/ultrastar-dc-hc690-hdd).
