#!/bin/bash
set -e

source /opt/projects/ecommerce_dw/scripts/common.sh

check_file "${ADS_TABLES_SQL}"

echo "=================================="
echo "Initializing ADS tables..."
echo "SQL file: ${ADS_TABLES_SQL}"
echo "=================================="

hive -f "${ADS_TABLES_SQL}"

echo "=================================="
echo "ADS tables created successfully."
echo "=================================="

hive -e "
USE ${HIVE_DB_ADS};
SHOW TABLES;
"
