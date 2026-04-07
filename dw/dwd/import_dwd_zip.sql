USE ecommerce_dwd;

SET hive.exec.dynamic.partition=false;
SET hive.auto.convert.join=false;

-- =====================================================
-- dim_user_info_zip
-- 从 ODS 每日用户快照构建用户拉链表
-- =====================================================
INSERT OVERWRITE TABLE dim_user_info_zip
SELECT
    result.user_id,
    result.username,
    result.phone,
    result.gender,
    result.birthday,
    result.city,
    result.register_time,
    result.user_level,
    result.user_status,
    result.create_time,
    result.update_time,
    result.start_date,
    result.end_date,
    result.is_current
FROM
(
    SELECT
        old.user_id,
        old.username,
        old.phone,
        old.gender,
        old.birthday,
        old.city,
        old.register_time,
        old.user_level,
        old.user_status,
        old.create_time,
        old.update_time,
        old.start_date,
        old.end_date,
        old.is_current
    FROM dim_user_info_zip old
    WHERE old.is_current = '0'

    UNION ALL

    SELECT
        old.user_id,
        old.username,
        old.phone,
        old.gender,
        old.birthday,
        old.city,
        old.register_time,
        old.user_level,
        old.user_status,
        old.create_time,
        old.update_time,
        old.start_date,
        CASE
            WHEN new.user_id IS NOT NULL
             AND (
                    NVL(old.username, '') <> NVL(new.username, '')
                 OR NVL(old.phone, '') <> NVL(new.phone, '')
                 OR NVL(old.gender, '') <> NVL(new.gender, '')
                 OR NVL(CAST(old.birthday AS STRING), '') <> NVL(CAST(new.birthday AS STRING), '')
                 OR NVL(old.city, '') <> NVL(new.city, '')
                 OR NVL(CAST(old.register_time AS STRING), '') <> NVL(CAST(new.register_time AS STRING), '')
                 OR NVL(old.user_level, '') <> NVL(new.user_level, '')
                 OR NVL(old.user_status, '') <> NVL(new.user_status, '')
                 OR NVL(CAST(old.create_time AS STRING), '') <> NVL(CAST(new.create_time AS STRING), '')
                 OR NVL(CAST(old.update_time AS STRING), '') <> NVL(CAST(new.update_time AS STRING), '')
                )
            THEN date_sub('${do_date}', 1)
            ELSE old.end_date
        END AS end_date,
        CASE
            WHEN new.user_id IS NOT NULL
             AND (
                    NVL(old.username, '') <> NVL(new.username, '')
                 OR NVL(old.phone, '') <> NVL(new.phone, '')
                 OR NVL(old.gender, '') <> NVL(new.gender, '')
                 OR NVL(CAST(old.birthday AS STRING), '') <> NVL(CAST(new.birthday AS STRING), '')
                 OR NVL(old.city, '') <> NVL(new.city, '')
                 OR NVL(CAST(old.register_time AS STRING), '') <> NVL(CAST(new.register_time AS STRING), '')
                 OR NVL(old.user_level, '') <> NVL(new.user_level, '')
                 OR NVL(old.user_status, '') <> NVL(new.user_status, '')
                 OR NVL(CAST(old.create_time AS STRING), '') <> NVL(CAST(new.create_time AS STRING), '')
                 OR NVL(CAST(old.update_time AS STRING), '') <> NVL(CAST(new.update_time AS STRING), '')
                )
            THEN '0'
            ELSE old.is_current
        END AS is_current
    FROM dim_user_info_zip old
    LEFT JOIN
    (
        SELECT
            user_id,
            username,
            phone,
            gender,
            CAST(birthday AS DATE) AS birthday,
            city,
            CAST(register_time AS TIMESTAMP) AS register_time,
            user_level,
            user_status,
            CAST(create_time AS TIMESTAMP) AS create_time,
            CAST(update_time AS TIMESTAMP) AS update_time
        FROM ecommerce_ods.ods_user_info
        WHERE dt = '${do_date}'
    ) new
    ON old.user_id = new.user_id
    WHERE old.is_current = '1'

    UNION ALL

    SELECT
        new.user_id,
        new.username,
        new.phone,
        new.gender,
        new.birthday,
        new.city,
        new.register_time,
        new.user_level,
        new.user_status,
        new.create_time,
        new.update_time,
        DATE '${do_date}' AS start_date,
        DATE '9999-12-31' AS end_date,
        '1' AS is_current
    FROM
    (
        SELECT
            user_id,
            username,
            phone,
            gender,
            CAST(birthday AS DATE) AS birthday,
            city,
            CAST(register_time AS TIMESTAMP) AS register_time,
            user_level,
            user_status,
            CAST(create_time AS TIMESTAMP) AS create_time,
            CAST(update_time AS TIMESTAMP) AS update_time
        FROM ecommerce_ods.ods_user_info
        WHERE dt = '${do_date}'
    ) new
    LEFT JOIN
    (
        SELECT *
        FROM dim_user_info_zip
        WHERE is_current = '1'
    ) old
    ON new.user_id = old.user_id
    WHERE old.user_id IS NULL
       OR (
            NVL(old.username, '') <> NVL(new.username, '')
         OR NVL(old.phone, '') <> NVL(new.phone, '')
         OR NVL(old.gender, '') <> NVL(new.gender, '')
         OR NVL(CAST(old.birthday AS STRING), '') <> NVL(CAST(new.birthday AS STRING), '')
         OR NVL(old.city, '') <> NVL(new.city, '')
         OR NVL(CAST(old.register_time AS STRING), '') <> NVL(CAST(new.register_time AS STRING), '')
         OR NVL(old.user_level, '') <> NVL(new.user_level, '')
         OR NVL(old.user_status, '') <> NVL(new.user_status, '')
         OR NVL(CAST(old.create_time AS STRING), '') <> NVL(CAST(new.create_time AS STRING), '')
         OR NVL(CAST(old.update_time AS STRING), '') <> NVL(CAST(new.update_time AS STRING), '')
          )

    UNION ALL

    SELECT
        base.user_id,
        base.username,
        base.phone,
        base.gender,
        base.birthday,
        base.city,
        base.register_time,
        base.user_level,
        base.user_status,
        base.create_time,
        base.update_time,
        DATE '${do_date}' AS start_date,
        DATE '9999-12-31' AS end_date,
        '1' AS is_current
    FROM
    (
        SELECT
            user_id,
            username,
            phone,
            gender,
            CAST(birthday AS DATE) AS birthday,
            city,
            CAST(register_time AS TIMESTAMP) AS register_time,
            user_level,
            user_status,
            CAST(create_time AS TIMESTAMP) AS create_time,
            CAST(update_time AS TIMESTAMP) AS update_time
        FROM ecommerce_ods.ods_user_info
        WHERE dt = '${do_date}'
    ) base
    WHERE NOT EXISTS (
        SELECT 1
        FROM dim_user_info_zip
        LIMIT 1
    )
) result;