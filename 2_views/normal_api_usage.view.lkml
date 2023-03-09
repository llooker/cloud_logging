view: normal_api_usage {
  derived_table: {
    sql:
            SELECT
              *
            FROM (
            SELECT
            *,
            AVG(counter) OVER (
              PARTITION BY principal_email
              ORDER BY day
              ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS avg,
            STDDEV(counter) OVER (
              PARTITION BY principal_email
              ORDER BY day
              ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS stddev,
            COUNT(*) OVER (
              PARTITION BY principal_email
              RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS numSamples
          FROM (
            SELECT
              proto_payload.audit_log.authentication_info.principal_email,
              EXTRACT(DATE FROM timestamp) AS day,
              ARRAY_AGG(DISTINCT proto_payload.audit_log.method_name IGNORE NULLS) AS actions,
              COUNT(*) AS counter
            FROM `@{PROJECT_NAME}.@{SCHEMA_NAME}.@{LOG_TABLE_NAME}`
            WHERE
              timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 60 DAY)
              AND proto_payload.audit_log.authentication_info.principal_email IS NOT NULL
              AND proto_payload.audit_log.method_name NOT LIKE "storage.%.get"
              AND proto_payload.audit_log.method_name NOT LIKE "v1.compute.%.list"
              AND proto_payload.audit_log.method_name NOT LIKE "beta.compute.%.list"
            GROUP BY
              proto_payload.audit_log.authentication_info.principal_email,
              day
              )
              )
              WHERE
                counter > avg + {% parameter standard_deviation %} * stddev
                AND {% condition date %} day {% endcondition %}
              ORDER BY
                counter DESC
   ;;
  }

  parameter: standard_deviation {
    label: "Number of Standard Deviations"
    description: "Choose stddev threshold that must be exceeded"
    type: number
    default_value: "0"
  }

  filter: date {
    type: date
    datatype: date
    default_value: "last 7 days"
  }

  dimension: principal_email {}

  dimension: history_date {
    type: date
    datatype: date
    sql: ${TABLE}.day ;;
  }

  dimension: pk {
    hidden: yes
    type: string
    primary_key: yes
    sql: CONCAT(${principal_email}, ${history_date}) ;;
  }


  dimension: log_events {
    type: number
    sql: ${TABLE}.counter ;;
  }

  dimension: log_actions {
    sql: ${TABLE}.actions ;;
  }

  dimension: normal_avg {
    type: number
    sql: ${TABLE}.avg ;;
  }

  dimension: normal_stddev {
    type: number
    sql: ${TABLE}.stddev ;;
  }

  dimension: sample_size {
    type: number
    sql: ${TABLE}.numSamples ;;
  }

  dimension: threshold {
    type: number
    sql: ${normal_avg} + 3 * ${normal_stddev} ;;
  }

  dimension: exceeds_3_stddev {
    type: yesno
    sql: ${log_events} > ${threshold}  ;;
  }


  }
