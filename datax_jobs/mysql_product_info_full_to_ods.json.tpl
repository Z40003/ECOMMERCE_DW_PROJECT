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
                  "select product_id, product_name, category_id, brand_name, price, product_status, create_time, update_time from product_info"
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
            "path": "/warehouse/ods/ods_product_info/dt=__LOAD_DT__",
            "fileName": "part",
            "column": [
              { "name": "product_id", "type": "int" },
              { "name": "product_name", "type": "string" },
              { "name": "category_id", "type": "int" },
              { "name": "brand_name", "type": "string" },
              { "name": "price", "type": "double" },
              { "name": "product_status", "type": "string" },
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
