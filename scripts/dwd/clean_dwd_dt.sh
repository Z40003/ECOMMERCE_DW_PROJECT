#!/bin/bash
set -e

source /opt/projects/ecommerce_dw/scripts/common.sh

TARGET_DT="$1"

if [ -z "${TARGET_DT}" ]; then
  echo "用法: bash clean_dwd_dt.sh 2026-04-26"
  exit 1
fi

check_date "${TARGET_DT}" || { echo "TARGET_DT 格式错误"; exit 1; }

echo "=================================="
echo "清理日期: ${TARGET_DT}"
echo "=================================="

echo "1. 关闭 HDFS Safe Mode..."
hdfs dfsadmin -safemode leave || true

echo "2. 删除 Hive 分区..."
hive -e "
USE ${HIVE_DB_DWD};

ALTER TABLE dim_category_info DROP IF EXISTS PARTITION (dt='${TARGET_DT}');
ALTER TABLE dim_product_info DROP IF EXISTS PARTITION (dt='${TARGET_DT}');
ALTER TABLE fact_order_detail DROP IF EXISTS PARTITION (dt='${TARGET_DT}');
ALTER TABLE fact_payment_info DROP IF EXISTS PARTITION (dt='${TARGET_DT}');
ALTER TABLE fact_user_action_log DROP IF EXISTS PARTITION (dt='${TARGET_DT}');
ALTER TABLE dwd_order_detail_wide DROP IF EXISTS PARTITION (dt='${TARGET_DT}');
"

echo "3. 删除 HDFS 物理目录（兜底）..."

TABLES=(
  dim_category_info
  dim_product_info
  fact_order_detail
  fact_payment_info
  fact_user_action_log
  dwd_order_detail_wide
)

for table in "${TABLES[@]}"
do
  TARGET_PATH="${DWD_HDFS_BASE}/${table}/dt=${TARGET_DT}"
  echo "删除: ${TARGET_PATH}"
  hdfs dfs -rm -r -f "${TARGET_PATH}" >/dev/null 2>&1 || true
done

echo "4. 查看 Safe Mode 状态..."
hdfs dfsadmin -safemode get || true

echo "=================================="
echo "已清理 DWD dt=${TARGET_DT}"
echo "=================================="
