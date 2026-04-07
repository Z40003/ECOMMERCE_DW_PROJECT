#!/bin/bash
set -e

source /opt/projects/ecommerce_dw/scripts/common.sh

ODS_SCRIPT="${SCRIPT_DIR}/import_ods.sh"
DWD_SCRIPT="${SCRIPT_DIR}/import_dwd.sh"
DWS_SCRIPT="${SCRIPT_DIR}/import_dws.sh"
ADS_SCRIPT="${SCRIPT_DIR}/import_ads.sh"

START_BIZ_DATE="$1"
END_BIZ_DATE="$2"
START_LOAD_DT="${3:-$1}"

if [ -z "${START_BIZ_DATE}" ] || [ -z "${END_BIZ_DATE}" ]; then
  echo "用法: bash run_daily_etl.sh 2025-10-01 2025-10-07 [start_load_dt]"
  echo "示例1: bash run_daily_etl.sh 2025-10-01 2025-10-07"
  echo "示例2: bash run_daily_etl.sh 2025-10-01 2025-10-07 2026-04-03"
  exit 1
fi

check_date "${START_BIZ_DATE}" || { echo "START_BIZ_DATE 格式错误"; exit 1; }
check_date "${END_BIZ_DATE}" || { echo "END_BIZ_DATE 格式错误"; exit 1; }
check_date "${START_LOAD_DT}" || { echo "START_LOAD_DT 格式错误"; exit 1; }

check_file "${ODS_SCRIPT}"
check_file "${DWD_SCRIPT}"
check_file "${DWS_SCRIPT}"
check_file "${ADS_SCRIPT}"

offset_days=$(date_diff_days "${START_BIZ_DATE}" "${END_BIZ_DATE}")
END_LOAD_DT=$(date_add_days "${START_LOAD_DT}" "${offset_days}")

echo "=================================="
echo "开始执行离线 ETL 总流程"
echo "业务开始日期: ${START_BIZ_DATE}"
echo "业务结束日期: ${END_BIZ_DATE}"
echo "ODS 起始入仓分区: ${START_LOAD_DT}"
echo "ODS 结束入仓分区: ${END_LOAD_DT}"
echo "=================================="

echo
echo "========== 1. ODS =========="
bash "${ODS_SCRIPT}" "${START_BIZ_DATE}" "${END_BIZ_DATE}" "${START_LOAD_DT}"

echo
echo "========== 2. DWD BASE =========="
bash "${DWD_SCRIPT}" base "${START_LOAD_DT}" "${END_LOAD_DT}"

echo
echo "========== 3. DWD ZIP =========="
bash "${DWD_SCRIPT}" zip "${START_LOAD_DT}" "${END_LOAD_DT}"

echo
echo "========== 4. DWD WIDE =========="
bash "${DWD_SCRIPT}" wide "${START_LOAD_DT}" "${END_LOAD_DT}"

echo
echo "========== 5. DWS =========="
bash "${DWS_SCRIPT}" "${START_LOAD_DT}" "${END_LOAD_DT}"

echo
echo "========== 6. ADS =========="
bash "${ADS_SCRIPT}" "${START_LOAD_DT}" "${END_LOAD_DT}"

echo
echo "=================================="
echo "离线 ETL 全流程执行完成"
echo "=================================="
