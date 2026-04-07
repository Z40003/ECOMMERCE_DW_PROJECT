CREATE DATABASE IF NOT EXISTS ecommerce_dwd;
USE ecommerce_dwd;

-- =========================
-- 1. 类目维表
-- =========================
DROP TABLE IF EXISTS dim_category_info;
CREATE EXTERNAL TABLE dim_category_info (
    category_id BIGINT COMMENT '类目ID',
    category_name STRING COMMENT '类目名称',
    parent_category_id BIGINT COMMENT '父类目ID',
    create_time TIMESTAMP COMMENT '创建时间',
    update_time TIMESTAMP COMMENT '更新时间'
)
COMMENT '类目维表'
PARTITIONED BY (dt STRING COMMENT '分区日期')
STORED AS ORC
LOCATION '/warehouse/dwd/dim_category_info'
TBLPROPERTIES ('orc.compress'='SNAPPY');


-- =========================
-- 2. 商品维表
-- =========================
DROP TABLE IF EXISTS dim_product_info;
CREATE EXTERNAL TABLE dim_product_info (
    product_id BIGINT COMMENT '商品ID',
    product_name STRING COMMENT '商品名称',
    category_id BIGINT COMMENT '类目ID',
    category_name STRING COMMENT '类目名称',
    parent_category_id BIGINT COMMENT '父类目ID',
    brand_name STRING COMMENT '品牌名称',
    price DECIMAL(16,2) COMMENT '价格',
    product_status STRING COMMENT '商品状态',
    create_time TIMESTAMP COMMENT '创建时间',
    update_time TIMESTAMP COMMENT '更新时间'
)
COMMENT '商品维表'
PARTITIONED BY (dt STRING COMMENT '分区日期')
STORED AS ORC
LOCATION '/warehouse/dwd/dim_product_info'
TBLPROPERTIES ('orc.compress'='SNAPPY');


-- =========================
-- 3. 用户拉链维表
-- =========================
DROP TABLE IF EXISTS dim_user_info_zip;
CREATE EXTERNAL TABLE dim_user_info_zip (
    user_id BIGINT COMMENT '用户ID',
    username STRING COMMENT '用户名',
    phone STRING COMMENT '手机号',
    gender STRING COMMENT '性别',
    birthday DATE COMMENT '生日',
    city STRING COMMENT '城市',
    register_time TIMESTAMP COMMENT '注册时间',
    user_level STRING COMMENT '用户等级',
    user_status STRING COMMENT '用户状态',
    create_time TIMESTAMP COMMENT '创建时间',
    update_time TIMESTAMP COMMENT '更新时间',
    start_date DATE COMMENT '开始生效日期',
    end_date DATE COMMENT '结束失效日期',
    is_current STRING COMMENT '是否当前有效:1是0否'
)
COMMENT '用户拉链维表'
STORED AS ORC
LOCATION '/warehouse/dwd/dim_user_info_zip'
TBLPROPERTIES ('orc.compress'='SNAPPY');


-- =========================
-- 4. 订单明细事实表
-- =========================
DROP TABLE IF EXISTS fact_order_detail;
CREATE EXTERNAL TABLE fact_order_detail (
    order_detail_id BIGINT COMMENT '订单明细ID',
    order_id BIGINT COMMENT '订单ID',
    user_id BIGINT COMMENT '用户ID',
    product_id BIGINT COMMENT '商品ID',
    product_num INT COMMENT '商品数量',
    product_price DECIMAL(16,2) COMMENT '商品单价',
    original_amount DECIMAL(16,2) COMMENT '原始金额',
    total_amount DECIMAL(16,2) COMMENT '订单总金额',
    pay_amount DECIMAL(16,2) COMMENT '订单支付金额',
    order_status STRING COMMENT '订单状态',
    order_time TIMESTAMP COMMENT '下单时间',
    pay_time TIMESTAMP COMMENT '支付时间',
    province STRING COMMENT '省份',
    city STRING COMMENT '城市',
    create_time TIMESTAMP COMMENT '创建时间'
)
COMMENT '订单明细事实表'
PARTITIONED BY (dt STRING COMMENT '分区日期')
STORED AS ORC
LOCATION '/warehouse/dwd/fact_order_detail'
TBLPROPERTIES ('orc.compress'='SNAPPY');


-- =========================
-- 5. 支付事实表
-- =========================
DROP TABLE IF EXISTS fact_payment_info;
CREATE EXTERNAL TABLE fact_payment_info (
    payment_id BIGINT COMMENT '支付ID',
    order_id BIGINT COMMENT '订单ID',
    user_id BIGINT COMMENT '用户ID',
    payment_type STRING COMMENT '支付方式',
    payment_status STRING COMMENT '支付状态',
    payment_amount DECIMAL(16,2) COMMENT '支付金额',
    payment_time TIMESTAMP COMMENT '支付时间',
    create_time TIMESTAMP COMMENT '创建时间'
)
COMMENT '支付事实表'
PARTITIONED BY (dt STRING COMMENT '分区日期')
STORED AS ORC
LOCATION '/warehouse/dwd/fact_payment_info'
TBLPROPERTIES ('orc.compress'='SNAPPY');


-- =========================
-- 6. 用户行为事实表
-- =========================
DROP TABLE IF EXISTS fact_user_action_log;
CREATE EXTERNAL TABLE fact_user_action_log (
    action_id BIGINT COMMENT '行为ID',
    user_id BIGINT COMMENT '用户ID',
    product_id BIGINT COMMENT '商品ID',
    action_type STRING COMMENT '行为类型',
    action_time TIMESTAMP COMMENT '行为时间'
)
COMMENT '用户行为事实表'
PARTITIONED BY (dt STRING COMMENT '分区日期')
STORED AS ORC
LOCATION '/warehouse/dwd/fact_user_action_log'
TBLPROPERTIES ('orc.compress'='SNAPPY');


-- =========================
-- 7. 订单明细宽表
-- =========================
DROP TABLE IF EXISTS dwd_order_detail_wide;
CREATE EXTERNAL TABLE dwd_order_detail_wide (
    order_detail_id BIGINT COMMENT '订单明细ID',
    order_id BIGINT COMMENT '订单ID',
    user_id BIGINT COMMENT '用户ID',
    user_level STRING COMMENT '用户等级',
    user_city STRING COMMENT '用户城市',
    product_id BIGINT COMMENT '商品ID',
    product_name STRING COMMENT '商品名称',
    category_id BIGINT COMMENT '类目ID',
    category_name STRING COMMENT '类目名称',
    brand_name STRING COMMENT '品牌名称',
    product_num INT COMMENT '商品数量',
    product_price DECIMAL(16,2) COMMENT '商品单价',
    original_amount DECIMAL(16,2) COMMENT '原始金额',
    total_amount DECIMAL(16,2) COMMENT '订单总金额',
    pay_amount DECIMAL(16,2) COMMENT '订单支付金额',
    detail_pay_amount DECIMAL(16,2) COMMENT '明细分摊支付金额',
    order_status STRING COMMENT '订单状态',
    order_time TIMESTAMP COMMENT '下单时间',
    pay_time TIMESTAMP COMMENT '支付时间',
    province STRING COMMENT '省份',
    city STRING COMMENT '下单城市',
    create_time TIMESTAMP COMMENT '创建时间'
)
COMMENT '订单明细宽表'
PARTITIONED BY (dt STRING COMMENT '分区日期')
STORED AS ORC
LOCATION '/warehouse/dwd/dwd_order_detail_wide'
TBLPROPERTIES ('orc.compress'='SNAPPY');