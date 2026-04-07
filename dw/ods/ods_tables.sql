CREATE DATABASE IF NOT EXISTS ecommerce_ods COMMENT '电商数仓ODS层';
USE ecommerce_ods;

-- 1. 用户表：维度，全量快照
DROP TABLE IF EXISTS ods_user_info;
CREATE EXTERNAL TABLE ods_user_info (
    user_id BIGINT COMMENT '用户ID',
    username STRING COMMENT '用户名',
    phone STRING COMMENT '手机号',
    gender STRING COMMENT '性别',
    birthday STRING COMMENT '生日',
    city STRING COMMENT '城市',
    register_time STRING COMMENT '注册时间',
    user_level STRING COMMENT '用户等级',
    user_status STRING COMMENT '用户状态',
    create_time STRING COMMENT '创建时间',
    update_time STRING COMMENT '更新时间'
)
COMMENT 'ODS用户表，按dt保存全量快照'
PARTITIONED BY (dt STRING COMMENT '分区日期')
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/warehouse/ods/ods_user_info';

-- 2. 商品表：维度，全量快照
DROP TABLE IF EXISTS ods_product_info;
CREATE EXTERNAL TABLE ods_product_info (
    product_id BIGINT COMMENT '商品ID',
    product_name STRING COMMENT '商品名称',
    category_id BIGINT COMMENT '类目ID',
    brand_name STRING COMMENT '品牌名称',
    price DECIMAL(16,2) COMMENT '价格',
    product_status STRING COMMENT '商品状态',
    create_time STRING COMMENT '创建时间',
    update_time STRING COMMENT '更新时间'
)
COMMENT 'ODS商品表，按dt保存全量快照'
PARTITIONED BY (dt STRING COMMENT '分区日期')
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/warehouse/ods/ods_product_info';

-- 3. 类目表：维度，全量快照
DROP TABLE IF EXISTS ods_category_info;
CREATE EXTERNAL TABLE ods_category_info (
    category_id BIGINT COMMENT '类目ID',
    category_name STRING COMMENT '类目名称',
    parent_category_id BIGINT COMMENT '父类目ID',
    create_time STRING COMMENT '创建时间',
    update_time STRING COMMENT '更新时间'
)
COMMENT 'ODS类目表，按dt保存全量快照'
PARTITIONED BY (dt STRING COMMENT '分区日期')
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/warehouse/ods/ods_category_info';

-- 4. 订单表：事实，按业务日期增量
DROP TABLE IF EXISTS ods_order_info;
CREATE EXTERNAL TABLE ods_order_info (
    order_id BIGINT COMMENT '订单ID',
    user_id BIGINT COMMENT '用户ID',
    order_status STRING COMMENT '订单状态',
    total_amount DECIMAL(16,2) COMMENT '订单原始金额',
    pay_amount DECIMAL(16,2) COMMENT '订单支付金额',
    order_time STRING COMMENT '下单时间',
    pay_time STRING COMMENT '支付时间',
    province STRING COMMENT '省份',
    city STRING COMMENT '城市',
    create_time STRING COMMENT '创建时间',
    update_time STRING COMMENT '更新时间'
)
COMMENT 'ODS订单表，按天增量'
PARTITIONED BY (dt STRING COMMENT '分区日期')
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/warehouse/ods/ods_order_info';

-- 5. 订单明细表：事实，按业务日期增量
DROP TABLE IF EXISTS ods_order_detail;
CREATE EXTERNAL TABLE ods_order_detail (
    order_detail_id BIGINT COMMENT '订单明细ID',
    order_id BIGINT COMMENT '订单ID',
    product_id BIGINT COMMENT '商品ID',
    product_num INT COMMENT '商品数量',
    product_price DECIMAL(16,2) COMMENT '商品单价',
    original_amount DECIMAL(16,2) COMMENT '原始金额',
    create_time STRING COMMENT '创建时间'
)
COMMENT 'ODS订单明细表，按天增量'
PARTITIONED BY (dt STRING COMMENT '分区日期')
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/warehouse/ods/ods_order_detail';

-- 6. 支付表：事实，按业务日期增量
DROP TABLE IF EXISTS ods_payment_info;
CREATE EXTERNAL TABLE ods_payment_info (
    payment_id BIGINT COMMENT '支付ID',
    order_id BIGINT COMMENT '订单ID',
    user_id BIGINT COMMENT '用户ID',
    payment_type STRING COMMENT '支付方式',
    payment_status STRING COMMENT '支付状态',
    payment_amount DECIMAL(16,2) COMMENT '支付金额',
    payment_time STRING COMMENT '支付时间',
    create_time STRING COMMENT '创建时间'
)
COMMENT 'ODS支付表，按天增量'
PARTITIONED BY (dt STRING COMMENT '分区日期')
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/warehouse/ods/ods_payment_info';

-- 7. 用户行为日志表：事实，按业务日期增量
DROP TABLE IF EXISTS ods_user_action_log;
CREATE EXTERNAL TABLE ods_user_action_log (
    action_id BIGINT COMMENT '行为ID',
    user_id BIGINT COMMENT '用户ID',
    product_id BIGINT COMMENT '商品ID',
    action_type STRING COMMENT '行为类型',
    action_time STRING COMMENT '行为时间'
)
COMMENT 'ODS用户行为日志表，按天增量'
PARTITIONED BY (dt STRING COMMENT '分区日期')
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/warehouse/ods/ods_user_action_log';