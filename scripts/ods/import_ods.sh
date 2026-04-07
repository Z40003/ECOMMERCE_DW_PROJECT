#!/bin/bash
set -e

source /opt/projects/ecommerce_dw/scripts/common.sh

mkdir -p "${JOB_RENDER_DIR}"

render_job() {
  local tpl_file="$1"
  local out_file="$2"
  local biz_date="$3"
  local load_dt="$4"

  sed \
    -e "s#__MYSQL_HOST__#${MYSQL_HOST}#g" \
    -e "s#__MYSQL_PORT__#${MYSQL_PORT}#g" \
    -e "s#__MYSQL_DB__#${MYSQL_DB}#g" \
    -e "s#__MYSQL_USER__#${MYSQL_USER}#g" \
    -e "s#__MYSQL_PASSWORD__#${MYSQL_PASSWORD}#g" \
    -e "s#__HDFS_FS__#${HDFS_FS}#g" \
    -e "s#__BIZ_DATE__#${biz_date}#g" \
    -e "s#__LOAD_DT__#${load_dt}#g" \
    "$tpl_file" > "$out_file"
}

add_partition() {
  local table_name="$1"
  local load_dt="$2"
  hive -e "USE ${HIVE_DB_ODS}; ALTER TABLE ${table_name} ADD IF NOT EXISTS PARTITION (dt='${load_dt}');"
}

run_one() {
  local tpl_name="$1"
  local table_name="$2"
  local biz_date="$3"
  local load_dt="$4"
  local tpl_file="${JOB_TEMPLATE_DIR}/${tpl_name}"
  local out_file="${JOB_RENDER_DIR}/${tpl_name%.tpl}_${load_dt}.json"
  local target_path="${ODS_HDFS_BASE}/${table_name}/dt=${load_dt}"

  check_file "${tpl_file}"

  echo "=================================================="
  echo "开始处理: ${table_name}"
  echo "业务日期: ${biz_date}"
  echo "入仓分区: ${load_dt}"
  echo "目标路径: ${target_path}"
  echo "=================================================="

  hdfs dfs -rm -r -f "${target_path}" >/dev/null 2>&1 || true
  hdfs dfs -mkdir -p "${target_path}"

  render_job "${tpl_file}" "${out_file}" "${biz_date}" "${load_dt}"
  ${PYTHON_BIN} "${DATAX_BIN}" "${out_file}"
  add_partition "${table_name}" "${load_dt}"
}

START_BIZ_DATE="$1"
END_BIZ_DATE="$2"
START_LOAD_DT="${3:-$(date +%F)}"

if [ -z "${START_BIZ_DATE}" ] || [ -z "${END_BIZ_DATE}" ]; then
  echo "用法: bash import_ods.sh 2025-10-01 2025-10-07 2026-03-25"
  exit 1
fi

check_date "${START_BIZ_DATE}" || { echo "START_BIZ_DATE 格式错误"; exit 1; }
check_date "${END_BIZ_DATE}" || { echo "END_BIZ_DATE 格式错误"; exit 1; }
check_date "${START_LOAD_DT}" || { echo "START_LOAD_DT 格式错误"; exit 1; }

current_biz_date="${START_BIZ_DATE}"
current_load_dt="${START_LOAD_DT}"

while [ "$(date -d "${current_biz_date}" +%s)" -le "$(date -d "${END_BIZ_DATE}" +%s)" ]; do
  echo "##################################################"
  echo "处理日期：biz_date=${current_biz_date}, load_dt=${current_load_dt}"
  echo "##################################################"

  run_one "mysql_user_info_full_to_ods.json.tpl" "ods_user_info" "${current_biz_date}" "${current_load_dt}"
  run_one "mysql_product_info_full_to_ods.json.tpl" "ods_product_info" "${current_biz_date}" "${current_load_dt}"
  run_one "mysql_category_info_full_to_ods.json.tpl" "ods_category_info" "${current_biz_date}" "${current_load_dt}"

  run_one "mysql_order_info_daily_to_ods.json.tpl" "ods_order_info" "${current_biz_date}" "${current_load_dt}"
  run_one "mysql_order_detail_daily_to_ods.json.tpl" "ods_order_detail" "${current_biz_date}" "${current_load_dt}"
  run_one "mysql_payment_info_daily_to_ods.json.tpl" "ods_payment_info" "${current_biz_date}" "${current_load_dt}"
  run_one "mysql_user_action_log_daily_to_ods.json.tpl" "ods_user_action_log" "${current_biz_date}" "${current_load_dt}"

  current_biz_date=$(date_add_one "${current_biz_date}")
  current_load_dt=$(date_add_one "${current_load_dt}")
done

echo "ODS 全部导入完成"
