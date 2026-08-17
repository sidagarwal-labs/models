# Research Notes

Monthly observations and working forecasts.

## AI CapEx

### August 2026

#### FY2026 Guidance

| Company | CapEx guidance | Change vs. Q1 guidance |
| --- | ---: | --- |
| AMZN | ~$220B | Increased by ~$20B |
| GOOGL | ~$200B | Increased by ~$15B |
| MSFT | ~$190B | Maintained |
| META | $130B-$145B | Maintained |
| TSLA | ~$25B | Increased |
| **Total** | **~$750B** | |

#### Future Forecast

##### FY2027 Company Estimates

| Company | CapEx estimate |
| --- | ---: |
| GOOGL | ~$280B |
| AMZN | ~$250B |
| MSFT | ~$210B |
| META | ~$185B |
| **Total** | **~$1T** |

##### FY2028-FY2031 Estimates

| Fiscal year | CapEx estimate |
| --- | ---: |
| FY2028 | ~$1.2T |
| FY2029 | ~$1.4T |
| FY2030 | ~$1.6T |
| FY2031 | ~$1.65T |

## Cloud Growth

### August 2026

| Company | Platform | Q2 revenue | Q2 growth | FY2026 guidance |
| --- | --- | ---: | ---: | ---: |
| AMZN | AWS | $42B | 37% y/y | $175B |
| GOOGL | GCP | $25B | 82% y/y | $110B |
| MSFT | Cloud | $40B | 32% y/y | $160B |

## GPU & Memory Prices

| Area | Metrics |
| --- | --- |
| GPU | FP8/BF16 throughput, tokens/s, power, $/GPU-hour, tokens/$ |
| Memory | Type, capacity, bandwidth, $/GB, $/GB-hour |
| Contract | Provider, region, on-demand/spot/reserved, GPU count |
| Availability | Regions/zones, access mode, minimum GPU count, launch or reservation status |
| Usage | GPU-hours, GPU utilization, memory utilization, tokens/s, $/1M tokens |

### August 2026

#### Specialist Clouds

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

### August 2026 Reference Prices

Sorted by company, model, then price low to high.

#### Accelerators

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

### Price History

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
