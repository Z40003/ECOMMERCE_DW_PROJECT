#!/bin/bash
set -e

source /opt/projects/ecommerce_dw/scripts/common.sh

START_DATE="$1"
END_DATE="$2"

if [ -z "${START_DATE}" ] || [ -z "${END_DATE}" ]; then
  echo "用法: bash import_ads.sh 2025-10-01 2025-10-07"
  exit 1
fi

check_date "${START_DATE}" || { echo "START_DATE 格式错误"; exit 1; }
check_date "${END_DATE}" || { echo "END_DATE 格式错误"; exit 1; }
check_file "${ADS_IMPORT_SQL}"

echo "=================================="
echo "Running ADS batch load"
echo "Start: ${START_DATE}"
echo "End  : ${END_DATE}"
echo "=================================="

current_date="${START_DATE}"

while [ "$(date -d "${current_date}" +%s)" -le "$(date -d "${END_DATE}" +%s)" ]; do
  echo "----------------------------------"
  echo "Processing date: ${current_date}"
  echo "----------------------------------"

  hive -hivevar do_date="${current_date}" -f "${ADS_IMPORT_SQL}"

  echo "Finished: ${current_date}"
  current_date=$(date_add_one "${current_date}")
done

echo "=================================="
echo "ADS batch load completed"
echo "=================================="
