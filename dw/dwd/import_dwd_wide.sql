USE ecommerce_dwd;

SET hive.exec.dynamic.partition=false;
SET hive.auto.convert.join=false;

-- =====================================================
-- dwd_order_detail_wide
-- =====================================================
INSERT OVERWRITE TABLE dwd_order_detail_wide PARTITION(dt='${do_date}')
SELECT
    f.order_detail_id,
    f.order_id,
    f.user_id,
    u.user_level,
    u.city AS user_city,
    f.product_id,
    p.product_name,
    p.category_id,
    p.category_name,
    p.brand_name,
    f.product_num,
    f.product_price,
    f.original_amount,
    f.total_amount,
    f.pay_amount,

    CAST(
        CASE
            WHEN f.total_amount IS NULL OR f.total_amount = 0 THEN 0
            WHEN f.pay_amount IS NULL THEN 0
            ELSE f.original_amount / f.total_amount * f.pay_amount
        END
    AS DECIMAL(16,2)) AS detail_pay_amount,

    f.order_status,
    f.order_time,
    f.pay_time,
    f.province,
    f.city,
    f.create_time
FROM fact_order_detail f
LEFT JOIN dim_product_info p
    ON f.product_id = p.product_id
   AND p.dt = '${do_date}'
LEFT JOIN dim_user_info_zip u
    ON f.user_id = u.user_id
   AND TO_DATE(f.order_time) >= u.start_date
   AND TO_DATE(f.order_time) <= u.end_date
WHERE f.dt = '${do_date}';