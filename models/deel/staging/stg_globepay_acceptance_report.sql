{{
    config(materialized='table')
}}

with

acceptance_report_raw as (

    select *

    from {{ source('deel', 'GLOBEPAY_ACCEPTANCE_REPORT') }}
),

acceptance_report_formatted as (

    select
        amount              as amt_gross_local,
        country             as country,
        currency            as currency,
        cvv_provided        as is_cvv_provided,
        date_time           as date_time,
        external_ref        as external_ref_id,
        parse_json(rates)   as exchange_rates,
        ref                 as ref,
        source              as source,
        state               as acceptance_state,
        status              as status

    from acceptance_report_raw

    group by all
),

final as (

    select
        {{ generate_table_uuid(['external_ref_id']) }},
        amt_gross_local                     as amt_gross_local,
        country                             as country,
        currency                            as currency,
        is_cvv_provided                     as is_cvv_provided,
        date_time                           as date_time,
        external_ref_id                     as external_ref_id,
        exchange_rates                      as exchange_rates,
        ref                                 as ref,
        source                              as source,
        acceptance_state                    as acceptance_state,
        status                              as status

    from acceptance_report_formatted
)

select *

from final
