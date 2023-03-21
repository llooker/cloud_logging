  view: impossible_traveler {
    derived_table: {
      explore_source: all_logs {
        column: proto_payload__audit_log__authentication_info__principal_email {}
        column: timestamp_raw {}
        column: timestamp_date {}
        column: timestamp_time {}
        column: location { field: ip_to_geo_mapping.location }
        column: city_name { field: ip_to_geo_mapping.city_name }
        column: proto_payload__audit_log__request_metadata__caller_ip {}
        column: latitude { field: ip_to_geo_mapping.latitude }
        column: longitude { field: ip_to_geo_mapping.longitude }
        derived_column: prev_lat {
          sql: lag(latitude) over (partition by proto_payload__audit_log__authentication_info__principal_email, timestamp_date order by timestamp_time asc) ;;
        }
        derived_column: prev_long {
          sql: lag(longitude) over (partition by proto_payload__audit_log__authentication_info__principal_email, timestamp_date order by timestamp_time asc) ;;
        }
        derived_column: prev_timestamp {
          sql: lag(timestamp_raw) over (partition by proto_payload__audit_log__authentication_info__principal_email, timestamp_date order by timestamp_time asc) ;;
        }
        derived_column: prev_src_ip {
          sql: lag(proto_payload__audit_log__request_metadata__caller_ip) over (partition by proto_payload__audit_log__authentication_info__principal_email, timestamp_date order by timestamp_time asc) ;;
        }
        derived_column: prev_city_name {
          sql: lag(city_name) over (partition by proto_payload__audit_log__authentication_info__principal_email, timestamp_date order by timestamp_time asc) ;;
        }

        filters: {
          field: all_logs.timestamp_date
          value: "today"
        }
        filters: {
          field: all_logs.is_system_or_service_account
          value: "No"
        }
        # filters: {
        #   field: all_logs.proto_payload__audit_log__request_metadata__caller_ip
        #   value: "-NULL"
        # }
        filters: {
          field: all_logs.proto_payload__audit_log__authentication_info__principal_email
          value: "-NULL"
        }



      }
    }
    dimension: proto_payload__audit_log__authentication_info__principal_email {
      label: "Principal Email"
      description: ""
    }
    dimension_group: timestamp {
      description: ""
      type: time
      sql: ${TABLE}.timestamp_raw ;;
    }
    dimension: city_name {
      description: ""
    }
    dimension: proto_payload__audit_log__request_metadata__caller_ip {
      label: "Caller IP"
      description: ""
    }
    dimension: class_b {
      description: ""
    }
    dimension: latitude {
      description: ""
      type: number
    }
    dimension: longitude {
      description: ""
      type: number
    }
    dimension: location {
      type: location
      sql_latitude: ${latitude} ;;
      sql_longitude: ${longitude} ;;
    }
    dimension: prev_lat {}
    dimension: prev_long {}
    dimension: prev_city_name {}
    dimension: prev_location {
      type: location
      sql_latitude: ${prev_lat} ;;
      sql_longitude: ${prev_long} ;;
    }
    dimension: distance_between {
      type: distance
      units: miles
      start_location_field: prev_location
      end_location_field: location
    }
    dimension_group: prev_timestamp {
      type: time
      sql: ${TABLE}.prev_timestamp ;;
    }

    dimension: time_between {
      type: duration_minute
      sql_start: ${prev_timestamp_raw} ;;
      sql_end: ${timestamp_raw} ;;
    }

    dimension: prev_src_ip  {}

    dimension: ip_has_changed {
      type: yesno
      sql: ${proto_payload__audit_log__request_metadata__caller_ip} <> ${prev_src_ip} ;;
    }

    # parameter: time_between_events {
    #   default_value: "10"
    # }

    # parameter: distance_between_events {
    #   default_value: "10"
    # }

    # dimension: is_impossible_traveler {
    #   type: yesno
    #   sql: ${time_between} <= ${time_between_events} AND ${distance_between} >= ${distance_between_events} ;;

    # }

    }
