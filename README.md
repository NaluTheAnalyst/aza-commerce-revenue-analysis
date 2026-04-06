# Aza Commerce — Revenue & Growth Analysis

## Project Overview

Aza Commerce is a fictional pan-African e-commerce platform operating across Nigeria, Kenya, Ghana, and South Africa. This project analyses Aza Commerce's full-year 2023 data to uncover revenue trends, profitability patterns, customer behaviour, and operational issues — the kind of analysis a Revenue or Growth Analyst would present to a client or senior leadership.

The entire analysis was performed using **SQL Server 2019** across a dataset of 541 orders and 5 tables.

---

## Dataset

| Table | Description | Rows |
|---|---|---|
| `products` | Every product — name, category, price, cost price | 30 |
| `customers` | Every registered customer — country, segment, signup date | 200 |
| `orders` | Every order placed — date, country, delivery status | 541 |
| `order_items` | Individual products inside each order | 1,396 |
| `returns` | Orders returned by customers — reason and date | 34 |

---

## Key Findings

1. **Ghana leads revenue** — Ghana is the top market at 30.36% despite not being the largest country by population
2. **Fashion dominates** — Fashion is the top revenue category at 23.59% and delivers the strongest profit margins above 60%
3. **Fulfilment crisis** — Only 68.76% of orders were successfully delivered. The 15.71% cancellation rate is well above the industry standard of 5%
4. **VIP segment underperforming** — VIP customers have the lowest average order value at NGN 76,500 — less than Regular customers at NGN 90,301
5. **Strong retention** — 86.96% of Q1 customers came back to order again, well above the industry benchmark of 25-40%
6. **Ghana return problem** — Ghana has the highest return rate at 8.14%, more than double Nigeria's 3.52%

---

## Strategic Recommendations

| Priority | Recommendation | Based On |
|---|---|---|
| 1 | Fix order fulfilment — reduce 15.71% cancellation rate immediately | Q3 |
| 2 | Expand Fashion inventory — highest revenue and strongest margins | Q2, Q5 |
| 3 | Redesign VIP programme — VIP customers spend less than Regular customers | Q6 |
| 4 | Investigate Ghana delivery partners — highest return rate at 8.14% | Q9 |
| 5 | Plan Q4 inventory and logistics capacity early — December drove 22% of annual revenue | Q4 |

---

## Tools Used

- SQL Server 2019
- SQL Server Management Studio (SSMS)
- Power BI Desktop
