# AI Buildout: September 2026

Research snapshot through **September 8, 2026**. Reported results, prospective guidance, current price observations, and working interpretations are labeled separately. This is not investment advice.

## What Changed

### Supplier Revenue Is One Test Of The Spending Story

[NVIDIA's August 26 release](https://nvidianews.nvidia.com/news/nvidia-announces-financial-results-for-second-quarter-fiscal-2027) reports FY2027 Q2 Data Center revenue of **$89.0B**, up **117% y/y**. Its **$108B +/-2%** next-quarter outlook is for total company revenue, not just Data Center. [Broadcom's September 2 release](https://investors.broadcom.com/news-releases/news-release-details/broadcom-inc-announces-third-quarter-fiscal-year-2026-financial) reports **$16.7B** of AI semiconductor revenue, up **221% y/y**, with management expecting **$21.7B** next quarter.

**Interpretation:** spending is reaching both GPU suppliers and custom-accelerator/networking suppliers. That supports a broader infrastructure-demand story, but does not prove that customers earn adequate returns. The categories and fiscal quarters differ, so this is not a clean market-share comparison.

**Next test:** cash conversion, inventory, customer concentration, and guidance revisions. A deterioration in cash generation or customer utilization would weaken a revenue-only interpretation. [Detailed results](foundation-labs.md#new-supplier-evidence).

### Adoption And Cost Need Separate Measurements

[OpenAI's September 8 update](https://openai.com/index/the-work-now-within-reach/) reports product reach above **1B weekly active users** and **2.5M businesses**. These are not interchangeable with ChatGPT-only users, paid seats, or enterprise contracts.

[Anthropic's September 1 release](https://www.anthropic.com/claude-fable-and-mythos-5-1) cuts Fable 5.1 cache reads by **75% to $0.25 per million tokens**, while ordinary input/output rates stay **$10/$50**. Its claimed workload savings depend on the cache and task mix; they are not guaranteed savings for every application.

**Interpretation:** adoption and effective inference costs can improve without a comparable change in headline token pricing or GPU rental rates. More usage is not automatically more paid revenue, and more efficient inference does not establish that total compute demand falls.

**Next test:** cost per successful task at fixed quality, paid usage, retention, cache hit rates, and gross margin. [Adoption definitions](ai-adoption.md) and [lab economics](foundation-labs.md#effective-inference-cost).

### Price Signals Are Not All The Same Kind Of Price

On September 8, [CoreWeave](https://www.coreweave.com/pricing) lists an eight-H100 node at **$19.71/hour spot versus $49.24/hour on demand**, or approximately **$2.464 versus $6.155 per GPU-hour**. The eight-B200 node is **$34.11 versus $68.80/hour**, or **$4.264 versus $8.600 per GPU-hour**. Those spreads are about **60.0%** and **50.4%**, respectively. Spot interruption and capacity terms matter; these are advertised prices, not executed transactions.

[TrendForce's September 8 observation](https://www.trendforce.com/price/dram/dram_spot) puts DDR5 16Gb 4800/5600 at **$54.333 per die**, **3.03% above** the August 4 endpoint in these notes. This is not an HBM price or a finished server-memory-module price.

**Interpretation:** different parts of the infrastructure chain can show different pricing conditions. A GPU spot discount and a rising DDR5 chip price can coexist. Neither alone demonstrates industry-wide excess capacity or a universal shortage.

**Next test:** fixed-configuration time series and deployment availability. CoreWeave/Lambda on-demand prices checked here were unchanged at the prior displayed precision, and Ramp's latest labeled release remained July, so neither is counted as a new decline or adoption jump.

### Where Ornn Fits

[Ornn Data](https://ornn.com/product/ornn-data) is a candidate transaction-based benchmark alongside provider offers, rather than a drop-in replacement for a cloud price list. [Ornn Compute](https://ornn.com/product/ornn-compute) separately provides capacity access. Comparing them requires matching hardware, region, commitment, timing, and service terms.

Ornn's [published terms](https://ornn.com/terms-of-use) restrict external data republication and systematic collection without prior written authorization. No Ornn index values, screenshots, or price history are reproduced here. The [GPU note](gpu-prices.md#ornn-a-separate-market-benchmark) records the source links, methodological questions, and permission requirements before adding a numeric series.

## Corrections To Existing Notes

- **Cloud scope:** Microsoft's $39.306B Intelligent Cloud segment is not its $59.3B Microsoft Cloud measure. The latter spans reporting segments. [Definitions](cloud-growth.md).
- **Spending scope:** Microsoft's July transcript gives approximately $175B of calendar-2026 capex after a finance-to-operating-lease reclassification; it says underlying investment expectations were unchanged outside that impact. The older $190B worksheet entry should not override that disclosure. Other unsourced capex entries are preserved as unverified historical inputs, not guidance. [Sources and periods](ai-capex.md).
- **Compute math:** the memory model's base raw floor is about 174K H100-equivalents. Applying 2x peak demand and 70% schedulability gives approximately 496K provisioned compute units. The practical serving scenario remains 1.65M. The old column mixed those definitions; the $750B funding envelope is now explicitly a sensitivity input, not a verified industry total. [Model](memory-storage.md#2026-inference-scenarios).

## Next Review Checklist

| Track | Next observation | Evidence that would change the interpretation |
| --- | --- | --- |
| Adoption | Dated paid usage and retention, with a stable denominator | Reach grows but paid use or retention weakens |
| Model economics | Repeatable cost per successful task at fixed quality | Savings disappear after retries, context, or tool costs |
| Cloud investment | Comparable capex, lease commitments, cloud margins and backlog conversion | Accounting changes explain a headline move rather than more productive capacity |
| GPU market | Same-node spot/on-demand series; Ornn only within authorized access/publication scope | Lower prices accompany weaker utilization rather than better efficiency |
| Memory | Same-part DDR5 series, dated HBM supply disclosures | Verified capacity/bit growth outpaces the stated demand scenarios |

Every follow-up should retain the source URL, observation period, publication date, unit, scope, and whether the value is reported, estimated, or forecast. A new Git commit is an edit date, not proof that every figure was rechecked.