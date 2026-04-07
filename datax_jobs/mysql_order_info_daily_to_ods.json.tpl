{
  "job": {
    "setting": {
      "speed": { "channel": 2 }
    },
    "content": [
      {
        "reader": {
          "name": "mysqlreader",
          "parameter": {
            "username": "__MYSQL_USER__",
            "password": "__MYSQL_PASSWORD__",
            "connection": [
              {
                "jdbcUrl": [
                  "jdbc:mysql://__MYSQL_HOST__:__MYSQL_PORT__/__MYSQL_DB__?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai&useSSL=false"
                ],
                "querySql": [
                  "select order_id, user_id, order_status, total_amount, pay_amount, order_time, pay_time, province, city, create_time, update_time from order_info where date(order_time) = '__BIZ_DATE__'"
                ]
              }
            ]
          }
        },
        "writer": {
          "name": "hdfswriter",
          "parameter": {
            "defaultFS": "__HDFS_FS__",
            "fileType": "text",
            "path": "/warehouse/ods/ods_order_info/dt=__LOAD_DT__",
            "fileName": "part",
            "column": [
              { "name": "order_id", "type": "int" },
              { "name": "user_id", "type": "int" },
              { "name": "order_status", "type": "string" },
              { "name": "total_amount", "type": "double" },
              { "name": "pay_amount", "type": "double" },
              { "name": "order_time", "type": "string" },
              { "name": "pay_time", "type": "string" },
              { "name": "province", "type": "string" },
              { "name": "city", "type": "string" },
              { "name": "create_time", "type": "string" },
              { "name": "update_time", "type": "string" }
            ],
            "writeMode": "truncate",
            "fieldDelimiter": ","
          }
        }
      }
    ]
  }
}
