with globepay_report as (

    select *

    from PC_DBT_DB.DBT_BBECKETT.GLOBEPAY_REPORT
),

declined_transactions as (

    select
        country             as country,
        sum(amt_gross_usd)  as total_declined_amount

    from globepay_report

    where acceptance_state = 'DECLINED'

    group by country
),

high_declined_countries as (

    select

        country                 as country,
        total_declined_amount   as total_declined_amount

    from declined_transactions

    where total_declined_amount > 25000000
)

select * from high_declined_countries
