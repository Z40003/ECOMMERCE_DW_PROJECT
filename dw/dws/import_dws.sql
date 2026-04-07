USE ecommerce_dws;

SET hive.exec.dynamic.partition=false;
SET hive.auto.convert.join=false;

INSERT OVERWRITE TABLE dws_product_sales_day PARTITION(dt='${do_date}')
SELECT
    product_id,
    product_name,
    category_id,
    category_name,
    brand_name,
    COUNT(DISTINCT order_id),
    COUNT(DISTINCT user_id),
    SUM(product_num),
    CAST(SUM(detail_pay_amount) AS DECIMAL(16,2))
FROM ecommerce_dwd.dwd_order_detail_wide
WHERE dt='${do_date}'
  AND order_status='paid'
GROUP BY
    product_id,
    product_name,
    category_id,
    category_name,
    brand_name
;

INSERT OVERWRITE TABLE dws_user_order_day PARTITION(dt='${do_date}')
SELECT
    user_id,
    user_level,
    user_city,
    COUNT(DISTINCT order_id) AS order_count,
    COUNT(DISTINCT CASE WHEN order_status='paid' THEN order_id END) AS paid_order_count,
    SUM(product_num) AS product_count,
    SUM(CASE WHEN order_status='paid' THEN product_num ELSE 0 END) AS paid_product_count,
    CAST(SUM(original_amount) AS DECIMAL(16,2)) AS order_amount,
    CAST(SUM(CASE WHEN order_status='paid' THEN detail_pay_amount ELSE 0 END) AS DECIMAL(16,2)) AS pay_amount
FROM ecommerce_dwd.dwd_order_detail_wide
WHERE dt='${do_date}'
GROUP BY
    user_id,
    user_level,
    user_city
;

INSERT OVERWRITE TABLE dws_category_sales_day PARTITION(dt='${do_date}')
SELECT
    category_id,
    category_name,
    COUNT(DISTINCT order_id),
    COUNT(DISTINCT user_id),
    SUM(product_num),
    CAST(SUM(detail_pay_amount) AS DECIMAL(16,2))
FROM ecommerce_dwd.dwd_order_detail_wide
WHERE dt='${do_date}'
  AND order_status='paid'
GROUP BY
    category_id,
    category_name
;

INSERT OVERWRITE TABLE dws_user_action_day PARTITION(dt='${do_date}')
SELECT
    COUNT(DISTINCT CASE WHEN action_type='view' THEN user_id END) AS view_user_count,
    COUNT(DISTINCT CASE WHEN action_type='cart' THEN user_id END) AS cart_user_count,
    COUNT(DISTINCT CASE WHEN action_type='favor' THEN user_id END) AS favor_user_count,
    COUNT(DISTINCT CASE WHEN action_type='order' THEN user_id END) AS order_user_count,
    COUNT(DISTINCT CASE WHEN action_type='pay' THEN user_id END) AS pay_user_count
FROM ecommerce_dwd.fact_user_action_log
WHERE dt='${do_date}'
;