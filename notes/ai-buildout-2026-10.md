# AI Buildout: October 2026

Research summary as of **October 3, 2026**, drawing on July-September observations compiled in [a16z Growth's September State of Markets](https://d1lamhf6l6yk6d.cloudfront.net/uploads/2026/10/State-of-Markets-Sep-2026.pdf). Forecasts are distinguished from reported results. This is research, not investment advice.

## Summary

AI investment is being accompanied by expanding commercial demand. Hyperscaler capex expectations have risen, foundation-lab revenue run rates and cloud backlogs have grown, and more consumers are paying for AI. Falling inference costs are bringing additional workloads into economic reach without eliminating demand for older GPUs.

The distinction is between **evidence of demand** and **evidence of durable investment returns**. The former has strengthened. The latter remains dependent on utilization, margins, capital intensity, and cash collection. Enterprise deployment is broad, but publicly documented impact over time is still limited. The economic benefits are also uneven: skilled-labor demand is rising, while electricity-price effects depend on local infrastructure and how costs are allocated.

## Earnings And Capital Investment

Earnings strength extends beyond the largest technology companies. **93.6% of S&P 500 companies met or beat EPS estimates** in the Citi Wealth / Bloomberg snapshot dated August 10, rounded to 94%. This includes companies that merely met expectations; it is neither a beat-only rate nor earnings growth. The final reporting-quarter denominator is not specified, and performance against estimates does not independently establish cheap valuations or an AI-driven earnings effect.

Combined capex for **Alphabet, Amazon, Meta, Microsoft, and Oracle** rose from **$241B in 2024 to $416B in 2025**. The July 31 Bloomberg consensus, calculated by Vanguard, put **2026E at $777B**, an **86.8% increase** over 2025. Rounded annual estimates for 2027-2030 are **$1.1T, $1.2T, $1.1T, and $1.2T**. That is approximately $4.6T over those four years, not per year.

Successive CapIQ forecasts through September 18 show repeated upward revisions for the selected vintages. This supports the view that the buildout has exceeded earlier expectations, but it does not establish that current forecasts must also be too low. The newer CapIQ estimates and July Bloomberg estimates remain separate snapshots.

Hyperscaler capex is also approaching historic scale relative to US GDP. BofA's August comparison places the latest reading near roughly **1.6%-1.8%**, depending on lease treatment: around some telecom and shale-cycle peaks, but below the railroad and earlier oil-and-gas peaks shown. These comparisons illustrate magnitude, not the timing of a peak. Global spending, domestic GDP, leases, and fiscal periods require reconciliation. The much larger long-run compute-cycle opportunity is not an annual capex forecast.

More detail: [AI capex](ai-capex.md#five-hyperscaler-consensus-snapshot).

## Revenue, Backlogs, And Cash Flow

Combined OpenAI and Anthropic annualized revenue continues to expand. YipitData's September 18 estimate implies approximately **$130B-$140B at Q3 2026E**. This is a rough reading of a third-party run-rate estimate, not exact company-reported contracted ARR or recognized annual revenue. A separate comparison suggests the labs could add roughly **$100B in 2026**, versus **$63B for public software excluding clouds**, but the lab figure is explicitly tentative and the measurement bases are not reconciled. Rapid growth is supported; a like-for-like annual revenue comparison is not yet established.

Cloud contracts tell a similar demand story. Combined Microsoft RPO, Google Cloud backlog, and Amazon RPO reached approximately **$1.7T at the plotted Q2 2026 endpoint**. These measures cover different businesses and contract durations. A larger pipeline supports future demand visibility but is not current revenue, GPU utilization, or proof of a shortage in every region and product.

Heavy investment is suppressing near-term free cash flow. FactSet / Goldman Sachs consensus dated August 28 projects recovery around **2028**, followed by stronger cash generation in 2029-2030. This is a forecast across five hyperscalers, not realized AI-infrastructure ROI. Positive and negative company contributions need to be netted, and consolidated FCF includes non-cloud businesses. Its recovery depends on operating cash flow eventually outgrowing capex, lease payments, and working-capital needs.

More detail: [foundation labs](foundation-labs.md#revenue-growth-and-measurement-boundaries) and [cloud growth](cloud-growth.md#backlog-growth-and-the-cash-flow-outlook).

## Cheaper Intelligence And Resilient Compute Demand

New accelerator generations have not eliminated economic demand for older hardware. Silicon Data's September 7 rental endpoints were **$5.69 for B200, $3.29 for H200, $2.63 for H100, and $1.59 for A100 per GPU-hour**. Resilient rents support continued use across generations, although these benchmarks are not directly comparable with every provider's region, commitment, or service terms. Residual values inferred from those rents are modeled asset values, not used-hardware sale prices.

At the same time, token and quality-adjusted inference prices have fallen sharply. Cheaper successful tasks can enable more applications and more intensive agentic workloads. If the increase in workload volume exceeds the reduction in compute per workload, total compute consumption rises: a Jevons-style rebound.

That mechanism is consistent with periods of falling token prices and firm GPU rents, but the price curves alone do not prove causation. Rents also depend on supply constraints and transaction mix. Rebound demand can occur even if rental prices fall, and longer reasoning or context can offset a cheaper headline token price.

More detail: [GPU economics](gpu-prices.md#rental-resilience-and-inferred-gpu-value) and [memory-model implications](memory-storage.md#capital-allocation-and-memory-demand).

## Adoption Is Broad, Measurement Is Shallow

Enterprise use has spread faster than public evidence of sustained impact. In Apollo's September 11 snapshot of Q2 S&P 500 disclosures, **74% stated an AI plan, 69% cited a live deployment, 29% quantified a result, and 2% disclosed a metric tracked over time**. These are disclosure categories, not additive measures or proof that the other 98% do no internal measurement. Morgan Stanley's separate adopter survey also indicates rising quantified benefits, but represents a different sample.

Consumer monetization is expanding from a low base. PNC's July research shows **2.2% of households** at the latest plotted paid-AI participation endpoint and **$31 monthly spend among subscribing households** in May 2026. YipitData's September 8 observations show roughly **5x growth in observable paid subscriptions since 2025** and rising retention at later ages in desktop usage cohorts.

The combined evidence supports growing willingness to pay and repeat engagement. It does not make observed subscriptions a census of the US market or desktop usage retention a measure of paid renewal. Households, people, subscriptions, and selected transaction panels remain different denominators.

More detail: [AI adoption](ai-adoption.md#enterprise-breadth-versus-measured-depth).

## Jobs And Electricity

Data-center investment is increasing demand for skilled labor. Indeed's January-June 2026 posting sample reports **10%-64% annual-pay premiums** for the displayed data-center roles and **2%-42% hourly premiums**. These are advertised offers for comparable job titles, not realized wage increases for the same workers. A separate construction-employment comparison puts data-center-exposed categories more than **300K jobs above a broader construction trend**; that is not a count of jobs individually traced to AI.

BLS / Economist data likewise place several technical occupations above a broader hiring-trend counterfactual. This challenges a uniform job-destruction narrative while leaving room for displacement, weaker entry-level opportunities in particular roles, and changing task mixes. Employment levels and relative headcount shares do not independently identify jobs caused by AI adoption.

Electricity can also benefit from scale when large, steady loads help cover fixed grid costs. Watten, Bistline, and Blanford's August 24 study estimates **0.4% lower average residential retail prices per 10% increase in data-center capacity**, attributing roughly **6% lower rates** to capacity growth during 2019-2024. That is the authors' estimate as quoted in the source presentation, not a result independently replicated here. Local generation and transmission constraints, tariffs, and cost shifting can produce different outcomes; the historical estimate is not a promise of lower household bills everywhere.

More detail: [economic benefits and constraints](ai-capex.md#economic-benefits-and-local-constraints) and [technical employment](ai-adoption.md#technical-employment-evidence).

## Where The Capital Goes

BNP Paribas's August supply-chain illustration allocates each **$100 of AI capex** as follows:

| Use | Illustrative allocation |
| --- | --- |
| Semiconductor chips | $50 |
| Power | $20 |
| Networking equipment | $15 |
| Cooling | $7.50 |
| Facilities and construction | $7.50 |

Within chips, **$25 goes to accelerators and $15 to memory ICs**. The broader opportunity therefore extends into electrical equipment, networking, cooling, and construction, not just GPUs. This is an illustrative allocation, not an exact realized spending mix or an HBM-only estimate. Upstream allocations sit within the same chain and are not additional final expenditure.

More detail: [capex allocation](ai-capex.md#illustrative-allocation-of-each-100).

## Conclusion

The evidence strengthens the case for a large, multi-year AI buildout supported by commercial demand. It does not remove the risks of overinvestment, concentrated customers, weak returns, or cyclical supplier profits. Lower inference costs and rising use can coexist with high infrastructure spending; the investment outcome still depends on who captures the resulting cash flows.

## Sources

The following third-party research is reproduced or summarized in a16z Growth's September presentation. Source dates are retained; the underlying proprietary datasets and causal studies have not been independently replicated here.

- [Citi Wealth / Bloomberg Finance](https://d1lamhf6l6yk6d.cloudfront.net/uploads/2026/10/State-of-Markets-Sep-2026.pdf#page=9), August 10: EPS expectations.
- [Vanguard / Bloomberg](https://d1lamhf6l6yk6d.cloudfront.net/uploads/2026/10/State-of-Markets-Sep-2026.pdf#page=15), July 31; [CapIQ and BofA](https://d1lamhf6l6yk6d.cloudfront.net/uploads/2026/10/State-of-Markets-Sep-2026.pdf#page=16), September 18 and August: capex scale, revisions, and cycle comparisons.
- [YipitData / CapIQ](https://d1lamhf6l6yk6d.cloudfront.net/uploads/2026/10/State-of-Markets-Sep-2026.pdf#page=23), September 18: lab run rates and incremental-revenue estimates.
- [Company filings / FactSet / Goldman Sachs](https://d1lamhf6l6yk6d.cloudfront.net/uploads/2026/10/State-of-Markets-Sep-2026.pdf#page=24), Q2 observations and August 28 forecasts: backlog and FCF.
- [Silicon Data](https://d1lamhf6l6yk6d.cloudfront.net/uploads/2026/10/State-of-Markets-Sep-2026.pdf#page=26), September 7; [Goldman Sachs / Department of Commerce and Ornn / Silicon Data / Bloomberg via Citadel Securities](https://d1lamhf6l6yk6d.cloudfront.net/uploads/2026/10/State-of-Markets-Sep-2026.pdf#page=34), July 10 and August: GPU rents and inference-price comparisons.
- [Apollo and AlphaWise / Morgan Stanley](https://d1lamhf6l6yk6d.cloudfront.net/uploads/2026/10/State-of-Markets-Sep-2026.pdf#page=27), September 11 and July 27; [PNC and YipitData](https://d1lamhf6l6yk6d.cloudfront.net/uploads/2026/10/State-of-Markets-Sep-2026.pdf#page=38), July 13 and September 8: enterprise and consumer adoption.
- [Indeed / BLS / Haver / Goldman Sachs](https://d1lamhf6l6yk6d.cloudfront.net/uploads/2026/10/State-of-Markets-Sep-2026.pdf#page=20), August 19 and September 1; [BLS / The Economist and Revelio / Ramp](https://d1lamhf6l6yk6d.cloudfront.net/uploads/2026/10/State-of-Markets-Sep-2026.pdf#page=31), September: labor-market comparisons.
- [Watten, Bistline, and Blanford](https://d1lamhf6l6yk6d.cloudfront.net/uploads/2026/10/State-of-Markets-Sep-2026.pdf#page=21), August 24: residential electricity-price estimate.
- [BNP Paribas Equity Research](https://d1lamhf6l6yk6d.cloudfront.net/uploads/2026/10/State-of-Markets-Sep-2026.pdf#page=44), August: illustrative supply-chain allocation.