{{
    config(materialized='table')
}}

with

chargeback_report_raw as (

    select *

    from {{ source('deel', 'GLOBEPAY_CHARGEBACK_REPORT') }}
),

chargeback_report_formatted as (

    select
        chargeback      as is_chargeback,
        external_ref    as external_ref_id,
        source          as source,
        status          as status

    from chargeback_report_raw

    group by all
),

final as (

    select
        {{ generate_table_uuid([
            'external_ref_id',
            'is_chargeback']) }},
        external_ref_id                                     as external_ref_id,
        source                                              as source,
        is_chargeback                                       as is_chargeback,
        status                                              as status

    from chargeback_report_formatted
)

select *

from final
