------------------------------------------------------------------------------------------------------
-- Macro: generate_table_uuid
--
-- OVERVIEW
--
-- This macro takes a list of fields as inputs and generates a unique table ID
--
-- EXAMPLE
--
-- generate_table_uuid(['reporting_date', 'id', 'code']) --defaults to table_uuid name
-- generate_table_uuid(['reporting_date', 'id', 'code'], "custom_name") --add your own custom name
------------------------------------------------------------------------------------------------------

{% macro generate_table_uuid(columns_to_concat, t_uuid="table_uuid") %}

hex_encode(md5(
    {% for column in columns_to_concat %}
        {{ column }}
        {% if not loop.last %} || {% endif %}
    {% endfor %}
    )) as {{ t_uuid }}

{% endmacro %}
