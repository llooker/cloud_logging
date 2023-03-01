# Define the database connection to be used for this model.
connection: "@{CONNECTION_NAME}"

# include all the views
include: "/2_views/**/*.view"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: cloud_logging_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: cloud_logging_default_datagroup

explore: all_logs {

  always_filter: {
    # to reduce inadverent expensive queries, default all explore queries to last 1 day (today)
    filters: [all_logs.timestamp_date: "last 1 days"]
  }

  # this is used for Searching across columns
  sql_always_where:
  {% if all_logs.search_filter._in_query %}
  SEARCH(all_logs,"`{% parameter all_logs.search_filter %}`")
  {% else %}
  1=1
  {% endif %} ;;


  # Quick Start Queries

  query: all_logs_last_hour {
    description: "Show all logs for the last 1 hour"

    dimensions: [
      timestamp_time,
      severity,
      log_name,
      labels_string,
      proto_payload__request_log__resource  ]
    filters: [all_logs.timestamp_time: "1 hours"]
    limit: 500
  }

  join: ip_to_geo_mapping {
    type: left_outer
    relationship: many_to_one
    # note: this only works for IPv4 address right now, not IPv6
    sql_on:
    ${ip_to_geo_mapping.class_b} = ${all_logs.class_b} AND
    ${all_logs.caller_ipv4} BETWEEN ${ip_to_geo_mapping.start_ipv4_to_int64}
    and ${ip_to_geo_mapping.end_ipv4_int64};;
    }

  join: user_ip_stats {
    view_label: "User IP Stats"
    type: left_outer
    relationship: many_to_one
    sql_on: ${all_logs.proto_payload__audit_log__authentication_info__principal_email} = ${user_ip_stats.principal_email}
    AND ${all_logs.proto_payload__audit_log__request_metadata__caller_ip} = ${user_ip_stats.caller_ip}   ;;
  }

  join: all_logs__proto_payload__request_log__line {
    view_label: "All Logs: Proto Payload Request Log Line"
    sql: LEFT JOIN UNNEST(${all_logs.proto_payload__request_log__line}) as all_logs__proto_payload__request_log__line ;;
    relationship: one_to_many
  }

  join: all_logs__proto_payload__audit_log__authorization_info {
    view_label: "All Logs: Proto Payload Audit Log Authorization Info"
    sql: LEFT JOIN UNNEST(${all_logs.proto_payload__audit_log__authorization_info}) as all_logs__proto_payload__audit_log__authorization_info ;;
    relationship: one_to_many
  }

  join: all_logs__proto_payload__request_log__source_reference {
    view_label: "All Logs: Proto Payload Request Log Source Reference"
    sql: LEFT JOIN UNNEST(${all_logs.proto_payload__request_log__source_reference}) as all_logs__proto_payload__request_log__source_reference ;;
    relationship: one_to_many
  }

  join: all_logs__proto_payload__audit_log__resource_location__current_locations {
    view_label: "All Logs: Proto Payload Audit Log Resource Location Current Locations"
    sql: LEFT JOIN UNNEST(${all_logs.proto_payload__audit_log__resource_location__current_locations}) as all_logs__proto_payload__audit_log__resource_location__current_locations ;;
    relationship: one_to_many
  }

  join: all_logs__proto_payload__audit_log__resource_location__original_locations {
    view_label: "All Logs: Proto Payload Audit Log Resource Location Original Locations"
    sql: LEFT JOIN UNNEST(${all_logs.proto_payload__audit_log__resource_location__original_locations}) as all_logs__proto_payload__audit_log__resource_location__original_locations ;;
    relationship: one_to_many
  }

  join: all_logs__proto_payload__audit_log__request_metadata__request_attributes__auth__audiences {
    view_label: "All Logs: Proto Payload Audit Log Request Metadata Request Attributes Auth Audiences"
    sql: LEFT JOIN UNNEST(${all_logs.proto_payload__audit_log__request_metadata__request_attributes__auth__audiences}) as all_logs__proto_payload__audit_log__request_metadata__request_attributes__auth__audiences ;;
    relationship: one_to_many
  }

  join: all_logs__proto_payload__audit_log__request_metadata__request_attributes__auth__access_levels {
    view_label: "All Logs: Proto Payload Audit Log Request Metadata Request Attributes Auth Access Levels"
    sql: LEFT JOIN UNNEST(${all_logs.proto_payload__audit_log__request_metadata__request_attributes__auth__access_levels}) as all_logs__proto_payload__audit_log__request_metadata__request_attributes__auth__access_levels ;;
    relationship: one_to_many
  }

  join: all_logs__proto_payload__audit_log__service_data__policy_delta__binding_deltas {
    view_label: "All Logs: Proto Payload Audit Log Service Data Policy Delta Binding Deltas"
    sql: LEFT JOIN UNNEST(JSON_QUERY_ARRAY(${all_logs.proto_payload__audit_log__service_data__policy_delta__binding_deltas})) AS bindingDelta ;;
    relationship: one_to_many
  }

  join: all_logs__proto_payload__audit_log__authentication_info__service_account_delegation_info {
    view_label: "All Logs: Proto Payload Audit Log Authentication Info Service Account Delegation Info"
    sql: LEFT JOIN UNNEST(${all_logs.proto_payload__audit_log__authentication_info__service_account_delegation_info}) as all_logs__proto_payload__audit_log__authentication_info__service_account_delegation_info ;;
    relationship: one_to_many
  }

  join: all_logs__proto_payload__audit_log__policy_violation_info__org_policy_violation_info__violation_info {
    view_label: "All Logs: Proto Payload Audit Log Policy Violation Info Org Policy Violation Info Violation Info"
    sql: LEFT JOIN UNNEST(${all_logs.proto_payload__audit_log__policy_violation_info__org_policy_violation_info__violation_info}) as all_logs__proto_payload__audit_log__policy_violation_info__org_policy_violation_info__violation_info ;;
    relationship: one_to_many
  }
}

explore: impossible_traveler {}