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
                  "select user_id, username, phone, gender, birthday, city, register_time, user_level, user_status, create_time, update_time from user_info"
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
            "path": "/warehouse/ods/ods_user_info/dt=__LOAD_DT__",
            "fileName": "part",
            "column": [
              { "name": "user_id", "type": "int" },
              { "name": "username", "type": "string" },
              { "name": "phone", "type": "string" },
              { "name": "gender", "type": "string" },
              { "name": "birthday", "type": "string" },
              { "name": "city", "type": "string" },
              { "name": "register_time", "type": "string" },
              { "name": "user_level", "type": "string" },
              { "name": "user_status", "type": "string" },
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
