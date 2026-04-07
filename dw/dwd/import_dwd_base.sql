USE ecommerce_dwd;

SET hive.exec.dynamic.partition=false;
SET hive.auto.convert.join=false;

-- =====================================================
-- 1. dim_category_info
-- =====================================================
INSERT OVERWRITE TABLE dim_category_info PARTITION(dt='${do_date}')
SELECT
    category_id,
    category_name,
    parent_category_id,
    CAST(create_time AS TIMESTAMP) AS create_time,
    CAST(update_time AS TIMESTAMP) AS update_time
FROM ecommerce_ods.ods_category_info
WHERE dt = '${do_date}';


-- =====================================================
-- 2. dim_product_info
-- =====================================================
INSERT OVERWRITE TABLE dim_product_info PARTITION(dt='${do_date}')
SELECT
    p.product_id,
    p.product_name,
    p.category_id,
    c.category_name,
    c.parent_category_id,
    p.brand_name,
    CAST(p.price AS DECIMAL(16,2)) AS price,
    p.product_status,
    CAST(p.create_time AS TIMESTAMP) AS create_time,
    CAST(p.update_time AS TIMESTAMP) AS update_time
FROM ecommerce_ods.ods_product_info p
LEFT JOIN ecommerce_ods.ods_category_info c
    ON p.category_id = c.category_id
   AND c.dt = '${do_date}'
WHERE p.dt = '${do_date}';


-- =====================================================
-- 3. fact_order_detail
-- =====================================================
INSERT OVERWRITE TABLE fact_order_detail PARTITION(dt='${do_date}')
SELECT
    od.order_detail_id,
    od.order_id,
    oi.user_id,
    od.product_id,
    od.product_num,
    CAST(od.product_price AS DECIMAL(16,2)) AS product_price,
    CAST(od.original_amount AS DECIMAL(16,2)) AS original_amount,
    CAST(oi.total_amount AS DECIMAL(16,2)) AS total_amount,
    CAST(oi.pay_amount AS DECIMAL(16,2)) AS pay_amount,
    oi.order_status,
    CAST(oi.order_time AS TIMESTAMP) AS order_time,
    CASE
        WHEN oi.pay_time = '' OR oi.pay_time IS NULL THEN NULL
        ELSE CAST(oi.pay_time AS TIMESTAMP)
    END AS pay_time,
    oi.province,
    oi.city,
    CAST(od.create_time AS TIMESTAMP) AS create_time
FROM ecommerce_ods.ods_order_detail od
LEFT JOIN ecommerce_ods.ods_order_info oi
    ON od.order_id = oi.order_id
   AND oi.dt = '${do_date}'
WHERE od.dt = '${do_date}';


-- =====================================================
-- 4. fact_payment_info
-- =====================================================
INSERT OVERWRITE TABLE fact_payment_info PARTITION(dt='${do_date}')
SELECT
    payment_id,
    order_id,
    user_id,
    payment_type,
    payment_status,
    CAST(payment_amount AS DECIMAL(16,2)) AS payment_amount,
    CASE
        WHEN payment_time = '' OR payment_time IS NULL THEN NULL
        ELSE CAST(payment_time AS TIMESTAMP)
    END AS payment_time,
    CAST(create_time AS TIMESTAMP) AS create_time
FROM ecommerce_ods.ods_payment_info
WHERE dt = '${do_date}';


-- =====================================================
-- 5. fact_user_action_log
-- =====================================================
INSERT OVERWRITE TABLE fact_user_action_log PARTITION(dt='${do_date}')
SELECT
    action_id,
    user_id,
    product_id,
    action_type,
    CAST(action_time AS TIMESTAMP) AS action_time
FROM ecommerce_ods.ods_user_action_log
WHERE dt = '${do_date}';