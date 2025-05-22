{{ config(
    materialized = 'incremental',
    unique_key = 'order_id',
    alias = 'processed_ab_test_orders'
) }}

with incremental_data as (

    select
        order_id,
        user_id,
        checkout_version,
        items_in_cart,
        items_list,
        upsell_clicked,
        order_value,
        date_of_purchase,
        change_time,
        split(items_list, ',') as items_array,
        year(date_of_purchase) as purchase_year,
        month(date_of_purchase) as purchase_month,
        day(date_of_purchase) as purchase_day

    from {{ ref('stg_ab_test_orders') }}

    {% if is_incremental() %}
      where change_time > (select coalesce(max(change_time), to_timestamp('1900-01-01', 'YYYY-MM-DD')) from {{ this }})
    {% endif %}

)

select * from incremental_data