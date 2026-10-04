# GPU & Memory Prices

Research as of October 3, 2026. Rental demand remains resilient across several GPU generations even as inference prices fall. Provider prices last checked September 8 and the August worksheet retain their own dates. Advertised rates, transaction benchmarks, modeled asset values, and forward capacity prices answer different questions.

## Rental Resilience And Inferred GPU Value

Older GPUs continue to command rental revenue despite the arrival of newer hardware. [Silicon Data's September 7, 2026 pricing](https://d1lamhf6l6yk6d.cloudfront.net/uploads/2026/10/State-of-Markets-Sep-2026.pdf#page=26), compiled in a16z Growth's September State of Markets, reports the following rental endpoints alongside residual values **inferred from those rents**:

| GPU | Rental rate, USD/GPU-hour | Evidence classification |
| --- | ---: | --- |
| B200 | $5.69 | Secondary-source endpoint, not a fresh provider quote |
| H200 | $3.29 | Secondary-source endpoint, not a fresh provider quote |
| H100 | $2.63 | Secondary-source endpoint, not a fresh provider quote |
| A100 | $1.59 | Secondary-source endpoint, not a fresh provider quote |

The series show continuing economic use of older GPUs and periods of stable or recovering rents despite newer hardware arriving. They do not all rise monotonically, and the chart does not establish that every older GPU appreciates. These benchmarks do not specify the same region, contract, node size, memory, service level, and interruption terms as the CoreWeave, Lambda, and Azure observations below. Do not splice them into those provider time series or infer a same-product price change from a difference between sources.

**Residual value is modeled, not an observed used-GPU sale price.** Capitalizing expected rental income depends on utilization, power/cooling and service costs, remaining economic life, downtime, and discount rates. Rental resilience is evidence against immediate economic obsolescence, not proof of a longer depreciation schedule or profitable resale after operating costs. Keep executed resale prices, book values, and income-implied values separate.

## Cheaper Tokens And Compute Demand

Falling token prices have coincided with periods of firm or recovering H100 rents. [Ornn, Silicon Data, and Bloomberg data compiled by Citadel Securities through August 2026](https://d1lamhf6l6yk6d.cloudfront.net/uploads/2026/10/State-of-Markets-Sep-2026.pdf#page=34) compare **Ornn H100 rental pricing** with a **Silicon Data token-price expenditure index**. There is also a period in which both decline. This is consistent with rebound demand, but does not estimate demand elasticity or identify the cause of a rental-price move. No Ornn numeric time series is reproduced here; the publication limits below still apply.

Lower cost per successful task can enable additional workloads, increasing total compute consumption enough to offset efficiency gains. In a fixed-quality, comparable-workload model:

`total GPU-hours = completed workloads * GPU-hours per workload`

If GPU-hours per workload halve, workload volume must more than double for aggregate GPU-hours to increase. This is a sensitivity relationship, not an estimate from the chart. Token prices are not the same as physical GPU-hours per workload: model mix, routing, cache reads, prefill versus decode, reasoning length, latency, and provider margins all intervene.

**Jevons-style rebound does not require rental prices to rise.** Prices depend on supply as well as demand; a rise can also reflect power/capacity constraints or changes in the transaction mix. Cheaper inference plus rising rentals is suggestive, not sufficient causal proof. The [memory model](memory-storage.md#demand-to-memory-bottleneck) remains a scenario framework rather than an extrapolation of this price comparison.

## September 8 Provider Check

[CoreWeave's North America price list](https://www.coreweave.com/pricing), observed September 8. Raw prices are for an **eight-GPU instance per hour**; normalized columns divide by eight. Spot capacity has different availability and interruption terms from on-demand capacity.

| GPU | GPUs/instance | On-demand $/instance-hour | Spot $/instance-hour | Normalized on-demand $/GPU-hour | Normalized spot $/GPU-hour |
| --- | ---: | ---: | ---: | ---: | ---: |
| HGX H100, 80 GB | 8 | $49.24 | $19.71 | $6.155 | $2.464 |
| HGX H200, 141 GB | 8 | $50.44 | $20.93 | $6.305 | $2.616 |
| HGX B200, 180 GB | 8 | $68.80 | $34.11 | $8.600 | $4.264 |
| HGX B300, 270 GB | 8 | Contact sales | $35.84 | Not quoted | $4.480 |

These are advertised observations, not executed trades or guaranteed availability. CoreWeave's separate single-GPU inference price column is restricted to its inference-platform customers; dividing an instance price by eight does not establish that one GPU can be rented independently at that rate. [Spot terms](https://docs.coreweave.com/policies/spot-tos).

[Lambda's displayed eight-GPU instance rates](https://lambda.ai/service/gpu-cloud) remain $3.99 per H100 GPU-hour and $6.69 per B200 GPU-hour, matching the August entries at displayed precision. CoreWeave's corresponding on-demand rates are also unchanged at the prior two-decimal precision. Record this as **checked, unchanged**, not a fresh price decline.

The new measurement is the **spot/on-demand spread**: about 60.0% for CoreWeave H100 and 50.4% for B200 on this observation. It is not a month-over-month move; no comparable earlier spot observation is recorded here. Compare like-for-like nodes, regions, access rights, and interruption terms before interpreting a spread as excess supply.

## Ornn: A Separate Market Benchmark

[Ornn Data](https://ornn.com/product/ornn-data) describes OCPI as a GPU compute benchmark based on executed transactions, rather than scraped rental offers. Its public product material identifies hardware-specific coverage including H100, H200, B200, and B300. [Ornn Compute](https://ornn.com/product/ornn-compute) is the related capacity-access marketplace; a reservation there is distinct from an index observation.

| Source category | What it measures | How to use it |
| --- | --- | --- |
| CoreWeave / Lambda list prices | Advertised provider offers for specified configurations | Estimate a particular deployment's advertised cost |
| Ornn OCPI | Transaction-based reference benchmark, according to Ornn | Candidate signal for market price direction; confirm the exact series definition before comparison |
| Ornn capacity offers / forwards | Capacity commitments or future delivery terms | Keep separate from a current spot benchmark and on-demand rental |

The [public data portal](https://data.ornn.com/) and [documentation](https://docs.ornn.com/introduction) are useful research starting points. Index weights, eligible transaction terms, geographic scope, historical revisions, and publication frequency need to be established from the applicable methodology before treating OCPI as an apples-to-apples provider comparison. Marketing descriptions alone do not settle those details.

**Publication limit:** Ornn's [Terms of Use, sections 2, 3, and 6](https://ornn.com/terms-of-use), reviewed September 8, require prior written authorization for external republication of its data and restrict systematic collection. This public note therefore links to Ornn but does not reproduce index values, charts, historical series, or API outputs, and does not implement a scraper. Account or API access alone is not republication permission.

A benchmark is not an executable rental quote. Hardware, memory, region, commitment, node size, service level, and methodology determine comparability; the homepage's illustrative animation is not a current observed price.

## Price And Performance Measures

Hardware generation, model quality, caching, and utilization can change deployment economics without changing the list price. The relevant measures cover more than dollars per GPU-hour:

| Area | Metrics |
| --- | --- |
| GPU | FP8/BF16 throughput, tokens/s, power, $/GPU-hour, tokens/$ |
| Memory | Type, capacity, bandwidth, $/GB, $/GB-hour |
| Contract | Provider, region, on-demand/spot/reserved, GPU count |
| Availability | Regions/zones, access mode, minimum GPU count, launch or reservation status |
| Usage | GPU-hours, GPU utilization, memory utilization, tokens/s, $/1M tokens |

## August 2026 Baseline

### Specialist Clouds

USD on-demand rates. CoreWeave multi-GPU instances are normalized per GPU.

| GPU | Memory/GPU | CoreWeave $/GPU-hr ($/GB-hr) | Lambda $/GPU-hr ($/GB-hr) |
| --- | ---: | ---: | ---: |
| GB300 NVL72 | 279 GB | Quote | - |
| GB200 NVL72 | 186 GB | $10.50 ($0.056) | - |
| B300 | 270 GB | Quote | - |
| B200 | 180 GB | $8.60 ($0.048) | $6.69 ($0.037) |
| RTX PRO 6000 Blackwell | 96 GB | $2.50 ($0.026) | - |
| H200 | 141 GB | $6.31 ($0.045) | - |
| H100 | 80 GB | $6.16 ($0.077) | $3.99 ($0.050) |
| GH200 | 96 GB | $6.50 ($0.068) | - |
| L40S | 48 GB | $2.25 ($0.047) | - |
| L40 | 48 GB | $1.25 ($0.026) | - |
| A100 | 80 GB | $2.70 ($0.034) | $2.79 ($0.035) |
| A100 | 40 GB | - | $1.99 ($0.050) |
| V100 | 16 GB | - | $0.79 ($0.049) |

## August 2026 Reference Prices

Sorted by company, model, then price low to high.

### Accelerators

| Accelerator | Company | Provider | $/accelerator-hr | Month | Access | Region | Offering |
| --- | --- | --- | ---: | --- | --- | --- | --- |
| MI300X | AMD | Azure | $6.000 | 2026-08 | On-demand | eastus2 | ND96is_MI300X_v5 |
| Ironwood TPU | Google | GCP | $12.000 | 2026-08 | On-demand | us-central1 | Per chip |
| Trillium TPU | Google | GCP | $2.700 | 2026-08 | On-demand | us-east1 | Per chip |
| TPU v5e | Google | GCP | $1.200 | 2026-08 | On-demand | us-central1 | Per chip |
| TPU v5p | Google | GCP | $4.200 | 2026-08 | On-demand | us-east5 | Per chip |
| A100 80GB | NVIDIA | Azure | $3.670 | 2026-08 | On-demand | eastus | NC24ads_A100_v4 |
| B200 | NVIDIA | Lambda | $6.690 | 2026-08 | On-demand | US | B200 SXM6 |
| B200 | NVIDIA | GCP | $8.055 | 2026-08 | DWS Flex-start | us-central1 | a4-highgpu-8g |
| B200 | NVIDIA | CoreWeave | $8.600 | 2026-08 | On-demand | North America | HGX B200 |
| B200 | NVIDIA | AWS | $12.355 | 2026-08 | Capacity Block | us-east-2 | p6-b200.48xlarge |
| B200 (GB200) | NVIDIA | Azure | $27.040 | 2026-08 | On-demand | eastus2 | ND128isr_NDR_GB200_v6 |
| B300 | NVIDIA | AWS | $14.040 | 2026-08 | Capacity Block | us-west-2 | p6-b300.48xlarge |
| H100 | NVIDIA | Azure | $1.290 | 2026-08 | Spot | eastus | NC40ads_H100_v5 |
| H100 | NVIDIA | Lambda | $3.990 | 2026-08 | On-demand | US | H100 SXM |
| H100 | NVIDIA | AWS | $5.191 | 2026-08 | Capacity Block | us-east-1 | p5.4xlarge |
| H100 | NVIDIA | CoreWeave | $6.160 | 2026-08 | On-demand | North America | HGX H100 |
| H100 | NVIDIA | Azure | $6.980 | 2026-08 | On-demand | eastus | NC40ads_H100_v5 |
| H100 | NVIDIA | Azure | $11.061 | 2026-08 | On-demand | eastus2 | ND96is_H100_v5 |
| H100 | NVIDIA | GCP | $11.061 | 2026-08 | On-demand | us-central1 | a3-highgpu-8g |
| H200 | NVIDIA | AWS | $5.970 | 2026-08 | Capacity Block | us-east-2 | p5e.48xlarge |
| H200 | NVIDIA | Azure | $10.600 | 2026-08 | On-demand | eastus2 | ND96isr_H200_v5 |
| H200 | NVIDIA | GCP | $10.601 | 2026-08 | On-demand | us-central1 | a3-ultragpu-8g |

_One accelerator-hour is one billed GPU or TPU chip for one hour. It does not imply equivalent performance. Capacity Block and DWS rates are not on-demand._

## Price History

Azure Linux on-demand rates, normalized per GPU. Rates are carried forward until superseded; `-` means the accelerator was not yet listed.

| Accelerator | Offering | 2022-06 | 2023-06 | 2024-06 | 2025-06 | 2026-08 |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| A100 80GB | NC24ads_A100_v4 | $3.670 | $3.670 | $3.670 | $3.670 | $3.670 |
| H100 80GB | NC40ads_H100_v5 | - | - | $6.980 | $6.980 | $6.980 |
| H200 141GB | ND96isr_H200_v5 | - | - | - | $10.600 | $10.600 |
| B200 186GB | ND128isr_NDR_GB200_v6 | - | - | - | $27.040 | $27.040 |
| MI300X 192GB | ND96is_MI300X_v5 | - | - | - | - | $6.000 |

Monthly spot signal for one fixed offering:

| Month | Accelerator | Offering | Region | $/GPU-hr | MoM |
| --- | --- | --- | --- | ---: | ---: |
| 2026-07 | H100 80GB | NC40ads_H100_v5 | eastus | $1.403 | - |
| 2026-08 | H100 80GB | NC40ads_H100_v5 | eastus | $1.290 | -8.1% |

Price sources: [CoreWeave](https://www.coreweave.com/pricing), [Lambda](https://lambda.ai/service/gpu-cloud), [AWS Capacity Blocks](https://aws.amazon.com/ec2/capacityblocks/pricing/), [Azure Retail Prices API](https://learn.microsoft.com/en-us/rest/api/cost-management/retail-prices/azure-retail-prices), [GCP GPU pricing](https://cloud.google.com/products/compute/pricing/accelerator-optimized), and [GCP TPU pricing](https://cloud.google.com/tpu/pricing).

History: [AWS Price List API](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/using-the-aws-price-list-bulk-api.html).

Specs and benchmarks: [NVIDIA GPUs](https://resources.nvidia.com/l/en-us-gpu), [AMD Instinct](https://www.amd.com/en/products/accelerators/instinct.html), and [MLPerf](https://mlcommons.org/benchmarks/).
