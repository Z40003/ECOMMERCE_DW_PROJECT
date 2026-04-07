CREATE DATABASE IF NOT EXISTS ecommerce_dws;
USE ecommerce_dws;

-- =========================
-- 1. 商品销售日汇总表
-- =========================
DROP TABLE IF EXISTS dws_product_sales_day;
CREATE EXTERNAL TABLE dws_product_sales_day (
    product_id BIGINT COMMENT '商品ID',
    product_name STRING COMMENT '商品名称',
    category_id BIGINT COMMENT '类目ID',
    category_name STRING COMMENT '类目名称',
    brand_name STRING COMMENT '品牌名称',
    paid_order_count BIGINT COMMENT '支付订单数',
    paid_user_count BIGINT COMMENT '支付用户数',
    sale_count BIGINT COMMENT '销量',
    sale_amount DECIMAL(16,2) COMMENT '成交金额'
)
COMMENT 'DWS商品销售日汇总表'
PARTITIONED BY (dt STRING COMMENT '统计日期')
STORED AS ORC
LOCATION '/warehouse/dws/dws_product_sales_day'
TBLPROPERTIES ('orc.compress'='SNAPPY');

-- =========================
-- 2. 用户下单日汇总表
-- =========================
DROP TABLE IF EXISTS dws_user_order_day;
CREATE EXTERNAL TABLE dws_user_order_day (
    user_id BIGINT COMMENT '用户ID',
    user_level STRING COMMENT '用户等级',
    user_city STRING COMMENT '用户城市',
    order_count BIGINT COMMENT '下单次数',
    paid_order_count BIGINT COMMENT '支付订单数',
    product_count BIGINT COMMENT '下单商品件数',
    paid_product_count BIGINT COMMENT '支付商品件数',
    order_amount DECIMAL(16,2) COMMENT '原始下单金额',
    pay_amount DECIMAL(16,2) COMMENT '实际支付金额'
)
COMMENT 'DWS用户下单日汇总表'
PARTITIONED BY (dt STRING COMMENT '统计日期')
STORED AS ORC
LOCATION '/warehouse/dws/dws_user_order_day'
TBLPROPERTIES ('orc.compress'='SNAPPY');

-- =========================
-- 3. 类目销售日汇总表
-- =========================
DROP TABLE IF EXISTS dws_category_sales_day;
CREATE EXTERNAL TABLE dws_category_sales_day (
    category_id BIGINT COMMENT '类目ID',
    category_name STRING COMMENT '类目名称',
    paid_order_count BIGINT COMMENT '支付订单数',
    paid_user_count BIGINT COMMENT '支付用户数',
    sale_count BIGINT COMMENT '销量',
    sale_amount DECIMAL(16,2) COMMENT '成交金额'
)
COMMENT 'DWS类目销售日汇总表'
PARTITIONED BY (dt STRING COMMENT '统计日期')
STORED AS ORC
LOCATION '/warehouse/dws/dws_category_sales_day'
TBLPROPERTIES ('orc.compress'='SNAPPY');

-- =========================
-- 4. 用户行为日汇总表
-- =========================
DROP TABLE IF EXISTS dws_user_action_day;
CREATE EXTERNAL TABLE dws_user_action_day (
    view_user_count BIGINT COMMENT '浏览用户数',
    cart_user_count BIGINT COMMENT '加购用户数',
    favor_user_count BIGINT COMMENT '收藏用户数',
    order_user_count BIGINT COMMENT '下单用户数',
    pay_user_count BIGINT COMMENT '支付用户数'
)
COMMENT 'DWS用户行为日汇总表'
PARTITIONED BY (dt STRING COMMENT '统计日期')
STORED AS ORC
LOCATION '/warehouse/dws/dws_user_action_day'
TBLPROPERTIES ('orc.compress'='SNAPPY');