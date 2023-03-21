view: user_ip_stats {
  # this is used to determine if a user is using a new IP address compared to their historical use of IPs
  # it is meant to be joined back to the All Logs table for exploratory analysis
  # CSA 5.31

    derived_table: {
      sql:
          SELECT
              _all_logs.proto_payload.audit_log.authentication_info.principal_email  AS `principal_email`,
              _all_logs.proto_payload.audit_log.request_metadata.caller_ip  AS `caller_ip`,
              MIN(_all_logs.timestamp ) AS `first_instance`,
              MAX(_all_logs.timestamp ) AS `last_instance`,
              count(*) as count
          FROM `sd-uxr-001.looker._AllLogs`  AS _all_logs
          -- currently only pulls last 7 days
          WHERE ((( _all_logs.timestamp  ) >= ((TIMESTAMP_ADD(TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY), INTERVAL -5 DAY))) AND ( _all_logs.timestamp  ) < ((TIMESTAMP_ADD(TIMESTAMP_ADD(TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY), INTERVAL -5 DAY), INTERVAL 6 DAY))))
             ) AND (_all_logs.proto_payload.audit_log.authentication_info.principal_email ) IS NOT NULL AND (_all_logs.proto_payload.audit_log.request_metadata.caller_ip ) IS NOT NULL
          GROUP BY
              1,
              2
          ;;
    }
    dimension: principal_email {

      description: ""
    }
    dimension: caller_ip {
      description: ""
    }

    dimension: primary_key {
      hidden: yes
      primary_key: yes
      sql: CONCAT(${principal_email},${caller_ip}) ;;
    }
    dimension_group: first_instance {
      description: "First time user used the IP address"
      type: time
      timeframes: [date, time, raw]
    }
    dimension_group: last_instance {
      description: "Last time user used the IP address"
    type: time
      timeframes: [date, time, raw]
    }

    dimension: new_since_days {
      group_label: "Time New"
      description: "Num days the user had used the IP at the time of the event"
      type: duration_day
      sql_start: ${first_instance_raw} ;;
      sql_end: ${all_logs.timestamp_raw} ;;
    }

  dimension: new_since_minutes {
    group_label: "Time New"
    description: "Num minutes the user had used the IP at the time of the event"
    type: duration_minute
    sql_start: ${first_instance_raw} ;;
    sql_end: ${all_logs.timestamp_raw} ;;
  }

  dimension: new_since_hours {
    group_label: "Time New"
    description: "Num hours the user had used the IP at the time of the event"
    type: duration_hour
    sql_start: ${first_instance_raw} ;;
    sql_end: ${all_logs.timestamp_raw} ;;
  }

    parameter: hours_considered_new {
      description: "Use with 'Is New IP' field to control what is considered a 'new' IP address (in hours)"
      default_value: "24"
      type: number
    }

    dimension: is_new_ip {
      # CSA 5.31
      description: "If user event occurs within X hours of getting a new IP address then considered 'New'"
      label: "Is New IP for user"
      type: yesno
      sql: ${new_since_hours} <= {% parameter hours_considered_new %} ;;
    }

    measure: user_events_from_ip {
      type: sum
      sql: ${TABLE}.count ;;
    }

  measure: event_count_from_new_ips {
    #label: "Event Count from New IPs"
    description: "Events from a user with a new IP address"
    type: count
    filters: [is_new_ip: "Yes"]
  }
  }
