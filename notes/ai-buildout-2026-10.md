# AI Buildout: October 2026

Reading dated **October 3, 2026**, based on [a16z Growth's September 2026 State of Markets](https://d1lamhf6l6yk6d.cloudfront.net/uploads/2026/10/State-of-Markets-Sep-2026.pdf). The report combines source observations from different dates, largely July-September; these are not newly measured October results. Page references below use the PDF's numbered pages. This is research, not investment advice.

## Summary

The report's strongest argument is that AI investment is meeting expanding commercial demand, not just a technology narrative: capex forecasts have been revised upward, lab run rates and cloud backlogs have grown, and paid consumer use is increasing. Lower inference costs can expand the number and intensity of economically useful workloads while older GPUs retain rental demand.

The unresolved question is conversion into durable returns. Backlog is not revenue, run rate is not annual revenue, future FCF is still a forecast, and rental-implied asset value is not a resale transaction. Enterprise deployment appears broad, but publicly tracked impact remains sparse. Wage premiums and historical electricity-price estimates describe potential benefits, not a uniform causal outcome for every worker or ratepayer.

This is an investor presentation with a positive interpretation of the buildout, drawing on several third-party datasets. The notes preserve that evidence while separating it from the conclusions it does not yet establish.

## What The Reading Adds

### Earnings And The Size Of The Investment Cycle

- **Earnings breadth:** page 9's latest bar is **93.6% of S&P 500 companies meeting or beating EPS estimates**, rounded to 94% in the commentary. Source: Citi Wealth / Bloomberg Finance, **August 10, 2026**. This is not a 94% beat-only rate or a 94% earnings-growth rate. The exhibit does not explicitly identify the final reporting-quarter denominator, so retain the as-of date rather than invent one. Strong performance against estimates also does not by itself establish cheap valuations or AI causation.
- **Capex scale:** page 15 shows five-hyperscaler capex of **$416B in 2025** and **$777B in 2026E**, followed by rounded annual estimates of **$1.1T, $1.2T, $1.1T, and $1.2T for 2027-2030**. Source: Vanguard calculations / Bloomberg consensus, **July 31**; companies are Alphabet, Amazon, Meta, Microsoft, and Oracle. The 2026 estimate is 86.8% above 2025, but not an achieved full-year result. The adjacent compute-cycle illustration is a scale narrative, not a compatible annual spending forecast.
- **Revisions and cycle comparisons:** page 16's CapIQ snapshots through **September 18** show selected earlier estimates repeatedly revised upward. Its BofA comparison, dated **August**, puts the latest hyperscaler capex/GDP reading near some previous investment-cycle peaks, not above every past peak. Neither exhibit proves where the cycle ends or that today's consensus must also be too low.

Details: [AI capex](ai-capex.md#five-hyperscaler-consensus-snapshot). The Oracle-inclusive cohort and cash/lease definitions must be reconciled before replacing the older worksheet or the memory model's sensitivity input.

### Benefits, Costs, And Jobs

- **Premium posted pay:** page 20's Indeed sample, **January-June 2026**, reports annual-pay premiums of **10%-64%** across the displayed job titles and hourly premiums of **2%-42%**. The comparison is same-title advertised pay, not realized earnings or a fully controlled wage effect. Its separate construction chart shows more than 300K jobs above a comparison trend in data-center-exposed categories, not jobs individually traced to AI projects.
- **Electricity:** page 21 cites **Watten, Bistline, and Blanford, August 24**, for an estimated **0.4% reduction in average residential retail prices per 10% increase in data-center capacity** and roughly **6% lower rates attributable to capacity growth in 2019-2024**. This is the study's estimate as quoted by the report, not independently replicated here. The accompanying load/price scatterplot is not a causal test. Fixed-cost sharing may help when large loads fund required infrastructure; local tariffs, generation constraints, upgrades, and cost shifting can change the result.
- **Technical employment:** page 31's BLS / Economist exhibit, dated **September 4**, shows technical employment above a broader hiring-trend counterfactual. It is a modeled employment-stock comparison, not direct proof of AI-created jobs. The accompanying entry-level headcount-share comparison also depends on adoption selection and the comparison group. These findings challenge a blanket job-destruction story without ruling out displacement or weaker opportunities in specific roles.

Details: [capex benefits and constraints](ai-capex.md#economic-benefits-and-local-constraints) and [technical employment](ai-adoption.md#technical-employment-evidence).

### Commercial Demand And Investment Returns

- **Labs:** page 23's combined OpenAI/Anthropic ARR chart ends around **$130B-$140B at Q3 2026E**, an approximate visual reading of a **September 18 YipitData estimate**. It is not exact company-reported contracted ARR. The adjacent incremental-revenue comparison has a tentative **approximately $100B** lab figure for 2026E and a footnote saying the full year is unknown. Do not compare these figures with public-company recognized revenue without reconciling the measurement basis.
- **Backlog and FCF:** page 24 depicts approximately **$1.7T** of combined Microsoft RPO, Google Cloud backlog, and Amazon RPO at the plotted Q2 2026 endpoint. This supports growing contracted demand, but the components differ in scope and duration. The five-company FCF chart, sourced to FactSet / Goldman Sachs on **August 28**, projects recovery around 2028 and stronger cash generation thereafter. Positive and negative stacked contributions must be netted; future recovery is not realized ROI, nor a claim that every company turns positive together.
- **Older GPUs:** page 26's Silicon Data exhibit, dated **September 7**, labels rental endpoints of **$5.69 B200, $3.29 H200, $2.63 H100, and $1.59 A100 per GPU-hour**. These support continuing use of multiple hardware generations. Residual values in that exhibit are **inferred from rental rates**, not observed used-hardware sale prices, and cannot independently validate depreciation lives.
- **Cheaper intelligence and rebound demand:** page 34 shows steep token/quality-adjusted price declines and periods of firm or recovering H100 rentals. This is consistent with a Jevons-style response, not a causal estimate. Total compute depends on workload volume times compute per workload; rental prices also depend on supply, service terms, and workload mix. Lower token prices do not mechanically cause higher GPU rents.

Details: [foundation labs](foundation-labs.md#october-reading-revenue-growth-and-measurement-boundaries), [cloud growth](cloud-growth.md#backlog-growth-and-the-cash-flow-outlook), and [GPU economics](gpu-prices.md#rental-resilience-and-inferred-gpu-value). No raw Ornn index history or licensed feed was added.

### Adoption, Consumer Spending, And The Supply Chain

- **Enterprise depth:** page 27's Apollo snapshot, **September 11**, reports Q2 shares of **74% stating an AI plan, 69% citing a live deployment, 29% quantifying a result, and 2% disclosing a metric tracked over time**. The right reading is broad but shallow public evidence, not that only 2% measure AI internally. Morgan Stanley's separate adopter survey is a different sample.
- **Consumers:** page 38 shows **2.2%** at the latest plotted paid-household participation endpoint and **$31 monthly spend among subscribers** in May 2026, citing PNC internal data dated **July 13**. YipitData's **September 8** panels show rising later-age desktop retention curves and roughly **5x growth in observable paid subscriptions since 2025**. Observable subscriptions, unique subscribers, households, desktop usage retention, and paid renewals are not interchangeable denominators.
- **Where $100 goes:** page 44's **BNP Paribas August illustration** allocates **$50 to chips, $20 power, $15 networking, $7.50 cooling, and $7.50 facilities/construction**. Within chips, $25 is accelerators and $15 memory ICs. This is an exposure map, not an exact realized spending mix or justification for applying a 50% GPU-system share to total hyperscaler capex. Downstream allocations are not extra spending to add on top.

Details: [adoption and consumer evidence](ai-adoption.md#enterprise-breadth-versus-measured-depth), [capex allocation](ai-capex.md#illustrative-allocation-of-each-100), and [memory-model implications](memory-storage.md#october-3-reading-update).

## What To Track Next

| Question | Discriminating evidence |
| --- | --- |
| Are capex estimates still too low? | Same-cohort, same-definition forecast revisions for a fixed target year, followed by actual cash and lease spending; repeated downward revisions would challenge the extrapolation |
| Is backlog becoming productive demand? | Current versus long-dated RPO, customer concentration, revenue conversion, utilization, and cash collection |
| Does the FCF recovery survive the spending cycle? | Operating cash flow versus cash capex and lease payments; compare revisions to both sides rather than FCF alone |
| Are lower prices expanding total compute? | Fixed-quality cost per task, workload volume, GPU-hours per workload, utilization, and comparable rental pricing |
| Is adoption becoming deep and durable? | Longitudinal enterprise ROI, paid renewals, fixed-panel spending, and cohort retention with explicit denominators |
| Who receives the economic benefits? | Realized wages and hiring by role/region; residential tariffs, large-load cost allocation, and completed generation/transmission investment |

The six topic notes were updated without changing spreadsheet models, historical valuation snapshots, or the memory model's fleet assumptions. The [September 8 research snapshot](ai-buildout-2026-09.md) remains intact as a dated record. A later edit date is not evidence that every historical price or company metric was refreshed.