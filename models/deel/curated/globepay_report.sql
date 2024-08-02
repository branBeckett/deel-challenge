{{
    config(
    materialized = 'incremental',
    on_schema_change = 'sync_all_columns',
    unique_key = 'table_uuid'
    )
}}

{% set currencies = ['CAD', 'EUR', 'MXN', 'USD', 'SGD', 'AUD', 'GBP'] %}

with

globepay_acceptance as (

    select *

    from {{ ref('stg_globepay_acceptance_report') }}

    where
        status = true
),

globepay_chargeback as (

    select *

    from {{ ref('stg_globepay_chargeback_report') }}

    where status = true
),

globepay as (

    select
        globepay_acceptance.external_ref_id,
        globepay_acceptance.ref,
        globepay_acceptance.date_time,
        globepay_acceptance.country,
        globepay_acceptance.amt_gross_local,
        globepay_acceptance.currency,
        globepay_acceptance.acceptance_state,
        globepay_acceptance.exchange_rates,
        globepay_acceptance.is_cvv_provided,
        globepay_chargeback.is_chargeback


    from globepay_acceptance

    left join globepay_chargeback
        on globepay_acceptance.external_ref_id = globepay_chargeback.external_ref_id

    group by all
),

standardize_currency as (

    select
        external_ref_id,
        amt_gross_local,
        currency,
        date_time,
        -- loop through each currency and extract the exchange rate for each country at the given timestamp
        {% for currency in currencies %}
            exchange_rates:{{ currency }}::float as {{ currency }}_rate
            {% if not loop.last %} , {% endif %}
        {% endfor %}

    from globepay
),

currencies_converted as (

    select
        external_ref_id,
        amt_gross_local,
        currency,
        date_time,
        -- loop through each currency and extract the relevant exchange rate at the given timestamp
        case
            {% for currency in currencies %}
                when currency = '{{ currency }}' then {{ currency ~ '_rate' }}
            {% endfor %}
            else null
        end as usd_conversion_rate

    from standardize_currency
),

final as (

    select
        {{ generate_table_uuid(['globepay.external_ref_id']) }},
        globepay.external_ref_id                            as external_ref_id,
        globepay.ref                                        as ref,
        globepay.date_time                                  as date_time,
        globepay.country                                    as country,
        round(globepay.amt_gross_local
            / currencies_converted.usd_conversion_rate, 2)  as amt_gross_usd,
        globepay.acceptance_state                           as acceptance_state,
        globepay.is_cvv_provided                            as is_cvv_provided,
        globepay.is_chargeback                              as is_chargeback

    from globepay

    left join currencies_converted
        on globepay.external_ref_id = currencies_converted.external_ref_id
        and globepay.date_time = currencies_converted.date_time
)

select *

from final
