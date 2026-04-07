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
                  "select category_id, category_name, parent_category_id, create_time, update_time from category_info"
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
            "path": "/warehouse/ods/ods_category_info/dt=__LOAD_DT__",
            "fileName": "part",
            "column": [
              { "name": "category_id", "type": "int" },
              { "name": "category_name", "type": "string" },
              { "name": "parent_category_id", "type": "int" },
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
