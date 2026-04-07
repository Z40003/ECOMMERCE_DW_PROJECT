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
                  "select payment_id, order_id, user_id, payment_type, payment_status, payment_amount, payment_time, create_time from payment_info where date(payment_time) = '__BIZ_DATE__'"
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
            "path": "/warehouse/ods/ods_payment_info/dt=__LOAD_DT__",
            "fileName": "part",
            "column": [
              { "name": "payment_id", "type": "int" },
              { "name": "order_id", "type": "int" },
              { "name": "user_id", "type": "int" },
              { "name": "payment_type", "type": "string" },
              { "name": "payment_status", "type": "string" },
              { "name": "payment_amount", "type": "double" },
              { "name": "payment_time", "type": "string" },
              { "name": "create_time", "type": "string" }
            ],
            "writeMode": "truncate",
            "fieldDelimiter": ","
          }
        }
      }
    ]
  }
}
