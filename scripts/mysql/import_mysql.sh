#!/bin/bash
set -e

source /opt/projects/ecommerce_dw/scripts/common.sh

TABLES=(
  category_info
  product_info
  user_info
  order_info
  order_detail
  payment_info
  user_action_log
)

echo "Start importing CSV data..."

for table in "${TABLES[@]}"
do
  FILE="${DATA_DIR}/${table}.csv"

  if [ ! -f "${FILE}" ]; then
    echo "Missing file: ${FILE}"
    exit 1
  fi

  echo "Importing ${table} ..."

  mysql --local-infile=1 \
    -h"${MYSQL_HOST}" \
    -P"${MYSQL_PORT}" \
    -u"${MYSQL_USER}" \
    -p"${MYSQL_PASSWORD}" \
    "${MYSQL_DB}" <<EOF2
LOAD DATA LOCAL INFILE '${FILE}'
INTO TABLE ${table}
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
EOF2

  echo "${table} imported"
done

echo "All data imported."
