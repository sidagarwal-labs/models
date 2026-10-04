# Foundation Labs

Research as of October 3, 2026. Lab revenue run rates are growing rapidly while inference costs fall, but third-party estimates, company disclosures, and recognized revenue remain distinct. July run-rate and August valuation baselines below retain their original dates.

## Revenue Growth And Measurement Boundaries

Combined OpenAI and Anthropic annualized revenue reaches approximately **$130B-$140B at Q3 2026E** in [YipitData's September 18, 2026 estimates](https://d1lamhf6l6yk6d.cloudfront.net/uploads/2026/10/State-of-Markets-Sep-2026.pdf#page=23), compiled by a16z Growth. The source labels this **ARR**, but the value is an approximate visual reading of a third-party run-rate estimate, not an exact reported number, a completed-quarter actual, or contracted recurring revenue. It cannot be reliably allocated between the labs from this evidence alone.

The direction supports rapid commercial expansion beyond the older baselines below. It does not establish profitability, cash collection, the absence of customer incentives, or an adequate return on compute commitments. The combined run-rate estimate is not a replacement for annual recognized-revenue scenarios or historical valuation multiples.

### Incremental Revenue Is Not Total Revenue

Lab revenue additions could exceed those of public software companies excluding hyperscalers, although the available estimates do not establish a common revenue basis:

| Year | Public software additions, excluding clouds | OpenAI plus Anthropic additions | Status |
| --- | ---: | ---: | --- |
| 2025 | $49B | $23B | Historical amounts labeled in the exhibit; measurement bases need reconciliation |
| 2026E | $63B | Approximately $100B, shown with a question mark | Estimates, not reported annual results |

CapIQ supplies the public-software revenues and estimates; YipitData supplies the lab estimates. The source records $74B of lab additions as of September 18, but the full year is unknown. The approximately $100B projection is explicitly tentative. Without a reconciled recognized-revenue basis, this supports a growth comparison, not the claim that the labs have already recognized more 2026 revenue, or more total revenue, than all public software.

### Falling Inference Prices Can Expand Use

AI inference prices have fallen far more quickly than PC prices did over their earlier investment cycle. [Goldman Sachs / Department of Commerce research dated July 10](https://d1lamhf6l6yk6d.cloudfront.net/uploads/2026/10/State-of-Markets-Sep-2026.pdf#page=34) compares a token-price basket and a quality-adjusted model-price measure with the PC price index, finding similarly large price deflation over roughly three years for AI versus roughly fifteen years for PCs. These are differently constructed baskets indexed to their respective cycle starts, not identical products or a measured elasticity of demand.

Cheaper successful tasks can bring new uses into scope while reasoning and agentic workloads increase total consumption. **Cost per successful task at fixed quality**, paid usage, and gross profit determine the commercial effect. A price index alone does not show how much margin remains with labs versus customers or infrastructure providers. See [GPU demand and the Jevons hypothesis](gpu-prices.md#cheaper-tokens-and-compute-demand) and [consumer/enterprise adoption](ai-adoption.md).

## September Operating Update

- [OpenAI's September 8 CFO update](https://openai.com/index/the-work-now-within-reach/) reports product reach above 1B weekly active users and 2.5M businesses. These are not paid subscriptions, recognized revenue, or contracted ARR. See [AI adoption](ai-adoption.md) for the separate denominators.
- [Anthropic's September 1 Fable 5.1 announcement](https://www.anthropic.com/claude-fable-and-mythos-5-1) lists cache reads at **$0.25 per million tokens**, 75% below the preceding rate. Ordinary input/output prices remain **$10/$50 per million tokens**. The distinction matters: a cache-heavy agent can become cheaper without a comparable change in the headline input/output price.
- Anthropic reports roughly 25% lower typical workload cost and up to roughly 45% for highly agentic workloads. These are vendor-measured workload results, not a guaranteed customer saving. Cache mix, reasoning effort, retries, context length, and task success all affect the result.

### Effective Inference Cost

`cost per successful task = total billed cost across attempts / successfully completed tasks`

At a fixed task set and quality threshold, this captures the cost of retries as well as completed work. Uncached input, cache reads/writes, output tokens, tool costs, latency, success rate, and reasoning settings all affect the result. A cheaper token does not necessarily mean a cheaper successful task, and a higher leaderboard score does not establish commercial margins or justify higher revenue projections on its own.

## Revenue Run Rate

Selected reported annualized revenue run-rate milestones. These are not contracted ARR or recognized annual revenue.

| Company | 2024-12 | 2025-05/06 | 2025-08 | 2025-12 | 2026-03/05 | 2026-07 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| OpenAI | $6B | $10B (Jun) | $13B | >$20B | >$25B (Mar) | $40B |
| Anthropic | ~$1B | $3B (May) | >$5B | ~$9B | $47B (May) | >$65B |

_OpenAI's $40B was confirmed by CNBC from investor slides. Anthropic's latest $65B is sourced reporting of investor updates; its last company-published figure was $47B in May._

## Working Revenue Projections

Calendar-year recognized revenue scenarios retained from the August note. These are research ranges, not newly verified company guidance.

| Company | CY2026 | CY2027 | CY2028 | Basis |
| --- | ---: | ---: | ---: | --- |
| OpenAI | $35B-$40B | $60B-$75B | $100B-$120B | $40B July run rate; prior internal plan implied ~$30B / ~$60B / ~$100B |
| Anthropic | $50B-$60B | $100B-$130B | $190B-$200B | $4.8B Q1, >=$10.9B Q2, >$65B July run rate; FY2028 company projection |

OpenAI's prior internal plan is increasingly stale but remains the best public year-by-year anchor. Anthropic's CY2027 scenario is informed by an external forecast of ~$115B run rate by May 2027; that run-rate forecast is not the same as recognized calendar-year revenue.

## Codex User Growth

| Date | Users | Status |
| --- | ---: | --- |
| 2026-02-05 | 1M | Reported by Baker |
| 2026-03-06 | 2M | Reported by Baker |
| 2026-04-01 | 3M | Reported by Baker |
| 2026-04-21 | 4M | Reported by Baker |
| 2026-05-31 | 5M | Reported by Baker |
| 2026-07-12 | 6M | Reported by Baker |
| 2026-07-13 | 7M | Reported by Baker |
| 2026-07-14 | 8M | Reported by Baker |
| 2026-07-16 | 9M | Reported by Baker |
| 2026-07-21 | 10M | Reported by Baker |

Source: [Gavin Baker on X](https://x.com/GavinSBaker), transcribed from his milestone post. "Users" is retained as stated because the active-user period and methodology were not independently specified.

The prior August 2 projection of 15M users remains unverified and is excluded from the observed-milestone table. It must not be treated as a realized observation merely because its date has passed.

## Valuation Snapshot

| Company | Run rate (date) | Valuation (date) | Value/run rate | Profitability signal |
| --- | ---: | ---: | ---: | --- |
| OpenAI | $40B (2026-07) | $852B post-money (2026-03) | 21.3x | ~33% estimated gross margin; ~$27B estimated 2026 cash burn |
| Anthropic | >$65B (2026-07) | $965B post-money (2026-05) | ~14.8x | ~$559M projected Q2 operating profit; gross margin not disclosed |

_Multiples are directional because the revenue and valuation dates differ._

## Mega-Cap Benchmarks

Historical snapshot: market caps at the August 17, 2026 close; financials as recorded then. This is not a current valuation table. NVIDIA's August 26 earnings below postdate it, so do not combine a new earnings denominator with these old market caps without explicitly rebuilding the comparison.

| Company | Market cap | Revenue | Growth | Gross margin | Net income | P/S |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| [NVIDIA](https://stockanalysis.com/stocks/nvda/statistics/) | $5.45T | $253.5B | 70.7% | 74.2% | $159.6B | 21.5x |
| [Apple](https://stockanalysis.com/stocks/aapl/statistics/) | $4.46T | $466.8B | 14.2% | 48.7% | $128.9B | 9.6x |
| [Alphabet](https://stockanalysis.com/stocks/googl/statistics/) | $4.21T | $445.9B | 20.1% | 60.9% | $244.1B | 9.4x |
| [Microsoft](https://stockanalysis.com/stocks/msft/statistics/) | $3.57T | $331.8B | 17.8% | 67.9% | $133.7B | 10.8x |
| [Amazon](https://stockanalysis.com/stocks/amzn/statistics/) | $2.82T | $775.7B | 15.8% | 50.8% | $135.3B | 3.6x |
| [Meta](https://stockanalysis.com/stocks/meta/statistics/) | $1.45T | $228.2B | 27.7% | 81.8% | $68.1B | 6.4x |

Private run rates and public GAAP revenue are not like-for-like. Lab gross margins, losses, and compute commitments are needed before treating public-company multiples as direct comps.

## New Supplier Evidence

These observations concern infrastructure suppliers, not revenue earned by the foundation-model labs. They help test whether announced spending is reaching vendors but do not establish return on investment for the customers.

| Release | Period and reported result | Forward guidance | Source |
| --- | --- | --- | --- |
| NVIDIA, August 26 | FY2027 Q2 ended July 26: total revenue $96.221B; Data Center $89.0B, +117% y/y; GAAP gross margin 75.0%; free cash flow $21.341B | FY2027 Q3 total revenue $108B +/-2%, not Data Center-only guidance | [NVIDIA release](https://nvidianews.nvidia.com/news/nvidia-announces-financial-results-for-second-quarter-fiscal-2027) |
| Broadcom, September 2 | FY2026 Q3 ended August 2: total revenue $29.591B; AI semiconductor revenue $16.7B, +221% y/y; free cash flow $13.665B | FY2026 Q4 AI semiconductor revenue $21.7B; total revenue $34.8B | [Broadcom release](https://investors.broadcom.com/news-releases/news-release-details/broadcom-inc-announces-third-quarter-fiscal-year-2026-financial) |

NVIDIA's Data Center category and Broadcom's AI semiconductor category are not identical market definitions. Guidance is prospective, not achieved revenue. Compare cash conversion and working capital alongside revenue rather than extrapolating one fast-growth quarter into perpetual demand.

Lab sources: [OpenAI July run rate](https://www.cnbc.com/2026/08/14/openai-cfo-friar-tells-investors-that-enterprise-bigger-than-consumer.html), [OpenAI historical plan](https://epoch.ai/gradient-updates/openai-is-projecting-unprecedented-revenue-growth), [OpenAI estimates](https://sacra.com/c/openai/), [Anthropic official May update](https://www.anthropic.com/news/series-h), [Anthropic July run rate](https://www.reuters.com/technology/anthropic-revenue-run-rate-tops-65-billion-source-says-2026-08-17/), [Anthropic FY2028 projection](https://www.reuters.com/business/anthropic-ipo-valuation-hinges-190-200-billion-2028-revenue-forecast-sources-say-2026-08-15/), and [external forecasts](https://futuresearch.ai/anthropic-financial-forecast/).
