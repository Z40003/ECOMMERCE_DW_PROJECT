#!/bin/bash
set -e

source /opt/projects/ecommerce_dw/scripts/common.sh

MODE="$1"
START_DATE="$2"
END_DATE="$3"

if [ -z "${MODE}" ] || [ -z "${START_DATE}" ] || [ -z "${END_DATE}" ]; then
  echo "用法:"
  echo "  bash import_dwd.sh base 2026-04-12 2026-04-12"
  echo "  bash import_dwd.sh zip  2026-03-01 2026-04-12"
  echo "  bash import_dwd.sh wide 2026-04-12 2026-04-12"
  exit 1
fi

check_date "${START_DATE}" || { echo "START_DATE 格式错误"; exit 1; }
check_date "${END_DATE}" || { echo "END_DATE 格式错误"; exit 1; }

case "${MODE}" in
  base)
    SQL_FILE="${DWD_BASE_SQL}"
    ;;
  zip)
    SQL_FILE="${DWD_ZIP_SQL}"
    ;;
  wide)
    SQL_FILE="${DWD_WIDE_SQL}"
    ;;
  *)
    echo "MODE 只能是 base / zip / wide"
    exit 1
    ;;
esac

check_file "${SQL_FILE}"

current_date="${START_DATE}"

while [ "$(date -d "${current_date}" +%s)" -le "$(date -d "${END_DATE}" +%s)" ]; do
  echo "##################################################"
  echo "处理模式：${MODE}"
  echo "处理日期：dt=${current_date}"
  echo "执行文件：${SQL_FILE}"
  echo "##################################################"

  hive -hivevar do_date="${current_date}" -f "${SQL_FILE}"
  current_date=$(date_add_one "${current_date}")
done

echo "DWD ${MODE} 导入完成"
