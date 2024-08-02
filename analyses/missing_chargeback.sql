with globepay_report as (

    select *

    from PC_DBT_DB.DBT_BBECKETT.GLOBEPAY_REPORT
),

missing_chargeback as (

    select *

    from globepay_report

    where is_chargeback is null
)

select count(*) from missing_chargeback
