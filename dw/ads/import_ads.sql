USE ecommerce_ads;

SET hive.exec.dynamic.partition=false;
SET hive.auto.convert.join=false;

-- =========================
-- 1. ads_gmv_day
-- =========================
INSERT OVERWRITE TABLE ads_gmv_day PARTITION(dt='${do_date}')
SELECT
    CAST(SUM(pay_amount) AS DECIMAL(16,2)) AS gmv,
    SUM(order_count) AS order_count,
    SUM(paid_order_count) AS paid_order_count,
    COUNT(DISTINCT CASE WHEN paid_order_count > 0 THEN user_id END) AS paid_user_count,
    SUM(paid_product_count) AS product_count
FROM ecommerce_dws.dws_user_order_day
WHERE dt='${do_date}'
;

-- =========================
-- 2. ads_top_product
-- =========================
INSERT OVERWRITE TABLE ads_top_product PARTITION(dt='${do_date}')
SELECT
    product_id,
    product_name,
    category_id,
    category_name,
    brand_name,
    sale_count,
    sale_amount,
    paid_order_count,
    paid_user_count,
    rank_no
FROM
(
    SELECT
        product_id,
        product_name,
        category_id,
        category_name,
        brand_name,
        sale_count,
        sale_amount,
        paid_order_count,
        paid_user_count,
        ROW_NUMBER() OVER (
            ORDER BY sale_amount DESC, sale_count DESC, product_id ASC
        ) AS rank_no
    FROM ecommerce_dws.dws_product_sales_day
    WHERE dt='${do_date}'
) t
WHERE rank_no <= 10
;

-- =========================
-- 3. ads_category_top
-- =========================
INSERT OVERWRITE TABLE ads_category_top PARTITION(dt='${do_date}')
SELECT
    category_id,
    category_name,
    sale_count,
    sale_amount,
    paid_order_count,
    paid_user_count,
    rank_no
FROM
(
    SELECT
        category_id,
        category_name,
        sale_count,
        sale_amount,
        paid_order_count,
        paid_user_count,
        ROW_NUMBER() OVER (
            ORDER BY sale_amount DESC, sale_count DESC, category_id ASC
        ) AS rank_no
    FROM ecommerce_dws.dws_category_sales_day
    WHERE dt='${do_date}'
) t
WHERE rank_no <= 10
;

-- =========================
-- 4. ads_user_conversion
-- =========================
INSERT OVERWRITE TABLE ads_user_conversion PARTITION(dt='${do_date}')
SELECT
    view_user_count,
    cart_user_count,
    favor_user_count,
    order_user_count,
    pay_user_count,
    CASE
        WHEN view_user_count = 0 THEN CAST(0 AS DECIMAL(16,4))
        ELSE CAST(cart_user_count * 1.0 / view_user_count AS DECIMAL(16,4))
    END AS view_to_cart_rate,
    CASE
        WHEN cart_user_count = 0 THEN CAST(0 AS DECIMAL(16,4))
        ELSE CAST(order_user_count * 1.0 / cart_user_count AS DECIMAL(16,4))
    END AS cart_to_order_rate,
    CASE
        WHEN order_user_count = 0 THEN CAST(0 AS DECIMAL(16,4))
        ELSE CAST(pay_user_count * 1.0 / order_user_count AS DECIMAL(16,4))
    END AS order_to_pay_rate,
    CASE
        WHEN view_user_count = 0 THEN CAST(0 AS DECIMAL(16,4))
        ELSE CAST(pay_user_count * 1.0 / view_user_count AS DECIMAL(16,4))
    END AS view_to_pay_rate
FROM ecommerce_dws.dws_user_action_day
WHERE dt='${do_date}'
;