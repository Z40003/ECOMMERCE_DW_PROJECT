#!/bin/bash
set -e

source /opt/projects/ecommerce_dw/scripts/common.sh

check_file "${SCHEMA_FILE}"

echo "Initializing MySQL database..."

mysql -h"${MYSQL_HOST}" -P"${MYSQL_PORT}" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" <<EOF2
CREATE DATABASE IF NOT EXISTS ${MYSQL_DB}
DEFAULT CHARSET utf8mb4;

USE ${MYSQL_DB};

SOURCE ${SCHEMA_FILE};
EOF2

echo "Database initialization finished."
