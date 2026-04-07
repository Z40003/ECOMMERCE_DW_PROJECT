#!/bin/bash
set -e

source /opt/projects/ecommerce_dw/scripts/common.sh

check_file "${DWD_TABLES_SQL}"

echo "=================================="
echo "Initializing DWD tables..."
echo "SQL file: ${DWD_TABLES_SQL}"
echo "=================================="

hive -f "${DWD_TABLES_SQL}"

echo "=================================="
echo "DWD tables created successfully."
echo "=================================="

hive -e "
USE ${HIVE_DB_DWD};
SHOW TABLES;
"
