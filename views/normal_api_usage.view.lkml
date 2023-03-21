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
              {% condition historical_date %} timestamp {% endcondition %}
              AND proto_payload.audit_log.authentication_info.principal_email IS NOT NULL
              AND proto_payload.audit_log.method_name NOT LIKE "storage.%.get"
              AND proto_payload.audit_log.method_name NOT LIKE "v1.compute.%.list"
              AND proto_payload.audit_log.method_name NOT LIKE "beta.compute.%.list"
              AND {% condition method_name %} proto_payload.audit_log.method_name {% endcondition %}
            GROUP BY
              proto_payload.audit_log.authentication_info.principal_email,
              day
              )
              )
              WHERE
                 {% condition date %} day {% endcondition %}
              ORDER BY
                counter DESC
   ;;
  }

  parameter: standard_deviation {
    label: "Number of Standard Deviations"
    description: "Choose stddev threshold that must be exceeded (i.e '3' for 3 Stddev)"
    type: number
    default_value: "0"
  }

  filter: date {
    label: "Current Date"
    description: "Compare current usage with this filter vs historical time period"
    type: date
    datatype: date
    default_value: "last 7 days"
  }

  filter: historical_date {
    description: "Calculate 'normal' usage over this historical time period"
    type: date_time
    default_value: "last 90 days"
  }

  filter: method_name {
    label: "Method / API Name"
    description: "Use to look for abnormal behavior on specific APIs"
    type: string
    suggest_explore: all_logs
    suggest_dimension: all_logs.proto_payload__audit_log__method_name

  }

  dimension: principal_email {
    link: {
      label: "User Lookup"
      url: "@{LOOKER_URL}/dashboards/cloud_logging::user_lookup"
    }
  }

  dimension: is_system_or_service_account {
    type: yesno
    sql: ${principal_email} like 'system:%' OR
      ${principal_email} like '%@%gserviceaccount.com';;
      }

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
    hidden: yes
    type: number
    sql: ${TABLE}.counter ;;
  }

  measure: total_log_events {
    type: sum
    sql: ${log_events} ;;
    drill_fields: [all_logs.timestamp_date, all_logs.proto_payload__audit_log__method_name, all_logs.proto_payload__audit_log__authentication_info__principal_email, all_logs.count]
  }

  dimension: log_actions {
    hidden: yes
    description: "List of all API methods used on that day"
    sql: ${TABLE}.actions ;;
  }

  dimension: normal_avg {
    type: number
    sql: ${TABLE}.avg ;;
    value_format_name: decimal_2
  }

  dimension: normal_stddev {
    type: number
    sql: ${TABLE}.stddev ;;
    value_format_name: decimal_2
  }

  dimension: sample_size {
    type: number
    sql: ${TABLE}.numSamples ;;
  }

  dimension: threshold {
    hidden: yes
    description: "Use Stddev Filter to enter the number of Stddev to use as a threshold"
    type: number
    sql: ${normal_avg} + {% parameter standard_deviation %} * ${normal_stddev} ;;
    value_format_name: decimal_2
  }

  measure: abnormal_threshold {
    type: max
    sql: ${threshold} ;;
    value_format_name: decimal_2
  }

  dimension: exceeds_threshold {
    type: yesno
    sql: ${log_events} > ${threshold}  ;;
  }


  }
