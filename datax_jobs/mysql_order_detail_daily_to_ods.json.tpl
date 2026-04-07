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
                  "select order_detail_id, order_id, product_id, product_num, product_price, original_amount, create_time from order_detail where date(create_time) = '__BIZ_DATE__'"
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
            "path": "/warehouse/ods/ods_order_detail/dt=__LOAD_DT__",
            "fileName": "part",
            "column": [
              { "name": "order_detail_id", "type": "int" },
              { "name": "order_id", "type": "int" },
              { "name": "product_id", "type": "int" },
              { "name": "product_num", "type": "int" },
              { "name": "product_price", "type": "double" },
              { "name": "original_amount", "type": "double" },
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
