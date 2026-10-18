# IT Ticket & SLA Performance Analysis

An end-to-end data analysis project on an IT support desk: **MySQL** for cleaning and analysis, **Power BI** for the dashboard.

## Business Problem
An IT support team needs to know how well it is meeting its **SLA (Service Level Agreement)**, which is the promised time limit for resolving a ticket. This project answers:

1. How many tickets came in, and what is the overall SLA compliance?
2. Which priority level breaches SLA the most?
3. Which topics bring the most tickets, and where is breach highest?
4. Which agents have the highest and lowest breach rates?

## Dataset
- **Source:** [Technical Support Dataset (Kaggle, by Suvradeep)](https://www.kaggle.com/)
- **Size:** 2,330 tickets, 22 columns
- **Key columns:** Priority, Topic, Agent Name, Agent Group, Created time, Resolution time, SLA For Resolution, Support Level
- The CSV is not included in this repo. Download it from Kaggle.

## Tools
- **MySQL:** staging table, data cleaning, analysis queries
- **Power BI:** DAX measures, dashboard
- **Excel / Notepad:** checking the raw file

## Approach
1. Loaded the raw CSV into a staging table (`tickets_raw`) with all columns as text, so the import never fails.
2. Built `tickets_clean`: converted text to `DATETIME`, turned blank values into `NULL`, trimmed text, and dropped latitude/longitude.
3. Validated the clean table (2,330 rows, no missing created dates).
4. Wrote simple `COUNT` + `GROUP BY` queries for each business question.
5. Connected Power BI to `tickets_clean` and built the dashboard.

## Key Findings
| Metric | Result |
|---|---|
| Total tickets | **2,330** |
| SLA compliance | **66.39%** (1,547 met, 783 breached) |

**By priority (breach %)**

| Priority | Tickets | Breach % |
|---|---|---|
| Medium | 722 | 35.04% |
| Low | 1,192 | 33.89% |
| High | 416 | 30.29% |

**By topic**
- **Product setup** has the most tickets (630), followed by **Pricing and licensing** (525). Together they are about half of all tickets.
- **Training request** has the highest breach rate (42.42%), but only 66 tickets.
- Among the big topics, **Pricing and licensing** has the highest breach (35.43%).

**By agent**
- Highest breach: **Connor Danielovitch** (38.33%)
- Lowest breach: **Heather Urry** (23.73%)
- A gap of about 15 points between agents suggests a chance to share good practices.

## Insights
- About **1 in 3 tickets breaches SLA**, so compliance has clear room to improve.
- Breach is similar across all priorities (30% to 35%), so the issue looks like the **overall process**, not one priority.
- High priority has the lowest breach rate, which suggests urgent tickets are handled better.

## Dashboard

The dashboard has KPI cards (Total Tickets, SLA Compliance %), SLA status by priority, tickets by topic, breach by agent, monthly ticket trend, and a priority slicer.

### DAX measures
```
Total Tickets = FORMAT(COUNTROWS('it_ticket_sla tickets_clean'), "0")

SLA Compliance % =
FORMAT(
    DIVIDE(
        CALCULATE(COUNTROWS('it_ticket_sla tickets_clean'), 'it_ticket_sla tickets_clean'[sla_resolution] = "Within SLA"),
        COUNTROWS('it_ticket_sla tickets_clean')
    ),
    "0.00%"
)
```

## Limitations
- Open and in-progress tickets can already be marked "SLA Violated" if their deadline has passed, so they are counted in the breach numbers.
- Resolution is measured on the SLA status given in the dataset, not recalculated with working hours.

## Repository Structure
```
IT-Ticket-SLA-Analysis/
├── dashboard/   Power BI file (.pbix)
├── images/      dashboard screenshot
├── sql/         IT_Ticket_SLA_Analysis.sql
└── README.md
```

## Author
**Pranjal**, Data Analyst (Fresher) | GitHub: [pranjalpatil2004](https://github.com/pranjalpatil2004)
