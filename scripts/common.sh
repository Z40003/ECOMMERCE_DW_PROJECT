#!/bin/bash
set -e

CONFIG_FILE="/opt/projects/ecommerce_dw/config/application.conf"

if [ ! -f "${CONFIG_FILE}" ]; then
  echo "配置文件不存在: ${CONFIG_FILE}"
  exit 1
fi

source "${CONFIG_FILE}"

check_file() {
  local file_path="$1"
  if [ ! -f "${file_path}" ]; then
    echo "文件不存在: ${file_path}"
    exit 1
  fi
}

check_date() {
  date -d "$1" +%F >/dev/null 2>&1
}

date_add_one() {
  date -d "$1 +1 day" +%F
}

date_add_days() {
  date -d "$1 +$2 day" +%F
}

date_diff_days() {
  echo $(( ($(date -d "$2" +%s) - $(date -d "$1" +%s)) / 86400 ))
}

if command -v python >/dev/null 2>&1; then
  PYTHON_BIN=python
elif command -v python3 >/dev/null 2>&1; then
  PYTHON_BIN=python3
else
  echo "未找到 python / python3"
  exit 1
fi

if [ -x "${DATAX_HOME}/bin/datax.py" ]; then
  DATAX_BIN="${DATAX_HOME}/bin/datax.py"
elif [ -x "${DATAX_HOME}/datax/bin/datax.py" ]; then
  DATAX_BIN="${DATAX_HOME}/datax/bin/datax.py"
else
  echo "找不到 datax.py，请检查 DATAX_HOME=${DATAX_HOME}"
  exit 1
fi
