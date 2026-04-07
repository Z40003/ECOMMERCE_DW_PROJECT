#!/bin/bash
set -e

source /opt/projects/ecommerce_dw/scripts/common.sh

check_file "${DWS_TABLES_SQL}"

echo "=================================="
echo "Initializing DWS tables..."
echo "SQL file: ${DWS_TABLES_SQL}"
echo "=================================="

hive -f "${DWS_TABLES_SQL}"

echo "=================================="
echo "DWS tables created successfully."
echo "=================================="

hive -e "
USE ${HIVE_DB_DWS};
SHOW TABLES;
"
