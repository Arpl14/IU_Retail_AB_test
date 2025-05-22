{{ config(materialized='ephemeral') }}

with source_data as (
    select
        to_varchar(order_id) as order_id,
        to_varchar(user_id) as user_id,
        to_varchar(checkout_version) as checkout_version,
        cast(items_in_cart as integer) as items_in_cart,
        to_varchar(items_list) as items_list,
        cast(upsell_clicked as boolean) as upsell_clicked,
        cast(order_value as number(10,2)) as order_value,
        to_timestamp(date_of_purchase) as date_of_purchase,
        current_timestamp() as change_time
    from
        {{ source('snowflake_source', 'ab_test_orders') }}
)

select * from source_data