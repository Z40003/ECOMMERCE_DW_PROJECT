#!/bin/bash
set -e

source /opt/projects/ecommerce_dw/scripts/common.sh

check_file "${ODS_SQL}"

echo "=================================="
echo "Initializing ODS tables..."
echo "SQL file: ${ODS_SQL}"
echo "=================================="

hive -f "${ODS_SQL}"

echo "=================================="
echo "ODS tables created successfully."
echo "=================================="

hive -e "
USE ${HIVE_DB_ODS};
SHOW TABLES;
"
