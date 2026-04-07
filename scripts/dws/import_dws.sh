#!/bin/bash
set -e

source /opt/projects/ecommerce_dw/scripts/common.sh

START_DATE="$1"
END_DATE="$2"

if [ -z "${START_DATE}" ] || [ -z "${END_DATE}" ]; then
  echo "用法: bash import_dws.sh 2026-03-01 2026-03-02"
  exit 1
fi

check_date "${START_DATE}" || { echo "START_DATE 格式错误"; exit 1; }
check_date "${END_DATE}" || { echo "END_DATE 格式错误"; exit 1; }
check_file "${DWS_IMPORT_SQL}"

current_date="${START_DATE}"

while [ "$(date -d "${current_date}" +%s)" -le "$(date -d "${END_DATE}" +%s)" ]; do
  echo "=================================="
  echo "Importing DWS data for dt=${current_date}"
  echo "SQL file: ${DWS_IMPORT_SQL}"
  echo "=================================="

  hive -hivevar do_date="${current_date}" -f "${DWS_IMPORT_SQL}"

  echo "DWS import finished for dt=${current_date}"
  current_date=$(date_add_one "${current_date}")
done

echo "=================================="
echo "All DWS imports completed."
echo "=================================="
