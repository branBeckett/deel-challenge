with globepay_report as (

    select *

    from PC_DBT_DB.DBT_BBECKETT.GLOBEPAY_REPORT
),

daily_transactions as (

    select
        date(date_time)                                             as transaction_date,
        count(*)                                                    as num_of_total_transactions,
        count(case when acceptance_state = 'ACCEPTED' then 1 end)   as num_of_accepted_transactions

    from
        globepay_report

    group by
        transaction_date
),

acceptance_rate as (

    select

        transaction_date                        as transaction_date,
        num_of_accepted_transactions
            / num_of_total_transactions::float  as acceptance_rate

    from
        daily_transactions

    order by
        transaction_date
)

select * from acceptance_rate
