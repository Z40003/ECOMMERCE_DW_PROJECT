CREATE DATABASE IF NOT EXISTS ecommerce_ads;
USE ecommerce_ads;

-- =========================
-- 1. 每日GMV大盘表
-- =========================
DROP TABLE IF EXISTS ads_gmv_day;
CREATE EXTERNAL TABLE ads_gmv_day (
    gmv DECIMAL(16,2) COMMENT '当日GMV',
    order_count BIGINT COMMENT '当日下单次数',
    paid_order_count BIGINT COMMENT '当日支付订单数',
    paid_user_count BIGINT COMMENT '当日支付用户数',
    product_count BIGINT COMMENT '当日购买商品件数'
)
COMMENT 'ADS每日GMV大盘表'
PARTITIONED BY (dt STRING COMMENT '统计日期')
STORED AS ORC
LOCATION '/warehouse/ads/ads_gmv_day'
TBLPROPERTIES ('orc.compress'='SNAPPY');

-- =========================
-- 2. 每日热门商品排行表
-- =========================
DROP TABLE IF EXISTS ads_top_product;
CREATE EXTERNAL TABLE ads_top_product (
    product_id BIGINT COMMENT '商品ID',
    product_name STRING COMMENT '商品名称',
    category_id BIGINT COMMENT '类目ID',
    category_name STRING COMMENT '类目名称',
    brand_name STRING COMMENT '品牌名称',
    sale_count BIGINT COMMENT '销量',
    sale_amount DECIMAL(16,2) COMMENT '成交金额',
    paid_order_count BIGINT COMMENT '支付订单数',
    paid_user_count BIGINT COMMENT '支付用户数',
    rank_no BIGINT COMMENT '排名'
)
COMMENT 'ADS每日热门商品排行表'
PARTITIONED BY (dt STRING COMMENT '统计日期')
STORED AS ORC
LOCATION '/warehouse/ads/ads_top_product'
TBLPROPERTIES ('orc.compress'='SNAPPY');

-- =========================
-- 3. 每日热门类目排行表
-- =========================
DROP TABLE IF EXISTS ads_category_top;
CREATE EXTERNAL TABLE ads_category_top (
    category_id BIGINT COMMENT '类目ID',
    category_name STRING COMMENT '类目名称',
    sale_count BIGINT COMMENT '销量',
    sale_amount DECIMAL(16,2) COMMENT '成交金额',
    paid_order_count BIGINT COMMENT '支付订单数',
    paid_user_count BIGINT COMMENT '支付用户数',
    rank_no BIGINT COMMENT '排名'
)
COMMENT 'ADS每日热门类目排行表'
PARTITIONED BY (dt STRING COMMENT '统计日期')
STORED AS ORC
LOCATION '/warehouse/ads/ads_category_top'
TBLPROPERTIES ('orc.compress'='SNAPPY');

-- =========================
-- 4. 每日用户转化漏斗表
-- =========================
DROP TABLE IF EXISTS ads_user_conversion;
CREATE EXTERNAL TABLE ads_user_conversion (
    view_user_count BIGINT COMMENT '浏览用户数',
    cart_user_count BIGINT COMMENT '加购用户数',
    favor_user_count BIGINT COMMENT '收藏用户数',
    order_user_count BIGINT COMMENT '下单用户数',
    pay_user_count BIGINT COMMENT '支付用户数',
    view_to_cart_rate DECIMAL(16,4) COMMENT '浏览-加购转化率',
    cart_to_order_rate DECIMAL(16,4) COMMENT '加购-下单转化率',
    order_to_pay_rate DECIMAL(16,4) COMMENT '下单-支付转化率',
    view_to_pay_rate DECIMAL(16,4) COMMENT '浏览-支付转化率'
)
COMMENT 'ADS每日用户转化漏斗表'
PARTITIONED BY (dt STRING COMMENT '统计日期')
STORED AS ORC
LOCATION '/warehouse/ads/ads_user_conversion'
TBLPROPERTIES ('orc.compress'='SNAPPY');