This repo contains a dbt project, [production model](https://github.com/branBeckett/deel-challenge/blob/main/models/deel/curated/globepay_report.sql), and all related files used to answer the following questions.

## 1. Acceptance rate over time

The SQL code for acceptance rate over time can be found [here](https://github.com/branBeckett/deel-challenge/blob/main/analyses/acceptance_rate_over_time.sql).

<img width="815" alt="Screenshot 2024-08-02 at 8 27 56 AM" src="https://github.com/user-attachments/assets/23f4b3f7-3383-475d-89dc-858764aeae33">


## 2. Countries where amount of declined transactions exceeded $25M

The following countries have declined transactions that exceeded $25M:

| Country | Amount in USD |
| -------- | -------- |
| FR |	$32,628,785.95 |
| AE |	$26,335,152.43 |
| US |	$25,125,669.78 |
| UK |	$27,489,496.65 |


The SQL code for declined transactions can be found [here](https://github.com/branBeckett/deel-challenge/blob/main/analyses/declined_transactions.sql).


## 3. Transactions missing chargeback data

There are currently no missing chargeback transactions.

The SQL code for missing chargeback can be found [here](https://github.com/branBeckett/deel-challenge/blob/main/analyses/missing_chargeback.sql).
