view: all_logs {
  # SCHEMA_NAME and LOG_TABLE_NAME are constants set in the manifest file
  sql_table_name: `@{PROJECT_NAME}.@{SCHEMA_NAME}.@{LOG_TABLE_NAME}` ;;

  # parameters

  parameter: search_filter {
    # used for searching across columns in the table
    suggestable: no
    type: unquoted
  }

  parameter: date_granularity {
    description: "Use to make visualizations with dynamic date granulairty"
    type: unquoted
    default_value: "day"
    allowed_value: {
      label: "Hour"
      value: "hour"
    }
    allowed_value: {
      label: "Day"
      value: "day"
    }
    allowed_value: {
      label: "Week"
      value: "week"
    }
    allowed_value: {
      label: "Month"
      value: "month"
    }
  }

  dimension: date {
    description: "For use with the 'Date Granularity' filter"
    sql:
    {% if date_granularity._parameter_value == 'hour' %}
      ${timestamp_hour_of_day}
    {% elsif date_granularity._parameter_value == 'day' %}
      ${timestamp_date}
    {% elsif date_granularity._parameter_value == 'week' %}
      ${timestamp_week}
    {% elsif date_granularity._parameter_value == 'month' %}
      ${timestamp_month}
    {% else %}
      ${timestamp_date}
    {% endif %};;
  }


################## MAIN/REQUIRED FIELDS #############################################################

  dimension: log_id {
    view_label: "1) All Logs"
    type: string
    sql: ${TABLE}.log_id ;;
  }

  dimension: log_type {
    description: "Cleaner version of Log ID"
    view_label: "1) All Logs"
    sql: REPLACE(${log_id}, '.googleapis.com/', ' - ') ;;

  }

  dimension: log_name {
    view_label: "1) All Logs"
    type: string
    sql: ${TABLE}.log_name ;;
  }

  dimension: insert_id {
    view_label: "1) All Logs"
    description: "A unique identifier for the log entry."
    type: string
    sql: ${TABLE}.insert_id ;;
  }

  dimension: resource__labels {
    view_label: "1) All Logs"
    hidden: yes
    type: string
    sql: ${TABLE}.resource.labels ;;
    group_label: "Resource"
    group_item_label: "Labels"
  }

  dimension: resource__labels_string {
    view_label: "1) All Logs"
    # Looker currently cannot display the JSON datatype. So need to convert it to STRING to display.
    type: string
    sql: TO_JSON_STRING(${resource__labels}) ;;
  }

  dimension: resource__type {
    type: string
    sql: ${TABLE}.resource.type ;;
    view_label: "1) All Logs"
  }

  dimension: severity {
    view_label: "1) All Logs"
    type: string
    sql: ${TABLE}.severity ;;
  }

  dimension: severity_number {
    view_label: "1) All Logs"
    type: number
    sql: ${TABLE}.severity_number ;;
  }

  dimension_group: timestamp {
    view_label: "1) All Logs"
    type: time
    timeframes: [
      raw,
      time,
      millisecond,
      hour_of_day,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.timestamp ;;
  }

  measure: min_timestamp {
    hidden: yes
    type: date_time
    sql: MIN(${timestamp_raw}) ;;
  }

  measure: max_timestamp {
    hidden: yes
    type: date_time
    sql: MAX(${timestamp_raw}) ;;
  }

  dimension: timestamp_unix_nanos {
    view_label: "1) All Logs"
    type: number
    sql: ${TABLE}.timestamp_unix_nanos ;;
  }


################################## HTTP Request #############################################

  dimension: http_request__cache_fill_bytes {
    type: number
    sql: ${TABLE}.http_request.cache_fill_bytes ;;
    view_label: "2) HTTP Request"
    group_item_label: "Cache Fill Bytes"
  }

  dimension: http_request__cache_hit {
    type: yesno
    sql: ${TABLE}.http_request.cache_hit ;;
    view_label: "2) HTTP Request"
    group_item_label: "Cache Hit"
  }

  dimension: http_request__cache_lookup {
    type: yesno
    sql: ${TABLE}.http_request.cache_lookup ;;
    view_label: "2) HTTP Request"
    group_item_label: "Cache Lookup"
  }

  dimension: http_request__cache_validated_with_origin_server {
    type: yesno
    sql: ${TABLE}.http_request.cache_validated_with_origin_server ;;
    view_label: "2) HTTP Request"
    group_item_label: "Cache Validated with Origin Server"
  }

  dimension: http_request__latency__nanos {
    type: number
    sql: ${TABLE}.http_request.latency.nanos ;;
    view_label: "2) HTTP Request"
    group_label: "HTTP Request Latency"
    group_item_label: "Nanos"
  }

  dimension: http_request__latency__seconds {
    type: number
    sql: ${TABLE}.http_request.latency.seconds ;;
    view_label: "2) HTTP Request"
    group_label: "HTTP Request Latency"
    group_item_label: "Seconds"
  }

  dimension: http_request__protocol {
    type: string
    sql: ${TABLE}.http_request.protocol ;;
    view_label: "2) HTTP Request"
    group_item_label: "Protocol"
  }

  dimension: http_request__referer {
    type: string
    sql: ${TABLE}.http_request.referer ;;
    view_label: "2) HTTP Request"
    group_item_label: "Referer"
  }

  dimension: http_request__remote_ip {
    type: string
    sql: ${TABLE}.http_request.remote_ip ;;
    view_label: "2) HTTP Request"
    group_item_label: "Remote IP"
  }

  dimension: http_request__request_method {
    type: string
    sql: ${TABLE}.http_request.request_method ;;
    view_label: "2) HTTP Request"
    group_item_label: "Request Method"
  }

  dimension: http_request__request_size {
    type: number
    sql: ${TABLE}.http_request.request_size ;;
    view_label: "2) HTTP Request"
    group_item_label: "Request Size"
  }

  dimension: http_request__request_url {
    type: string
    sql: ${TABLE}.http_request.request_url ;;
    view_label: "2) HTTP Request"
    group_item_label: "Request URL"
  }

  dimension: http_request__response_size {
    type: number
    sql: ${TABLE}.http_request.response_size ;;
    view_label: "2) HTTP Request"
    group_item_label: "Response Size"
  }

  dimension: http_request__server_ip {
    type: string
    sql: ${TABLE}.http_request.server_ip ;;
    view_label: "2) HTTP Request"
    group_item_label: "Server IP"
  }

  dimension: http_request__status {
    type: number
    sql: ${TABLE}.http_request.status ;;
    view_label: "2) HTTP Request"
    group_item_label: "Status"
  }

  dimension: http_request__user_agent {
    type: string
    sql: ${TABLE}.http_request.user_agent ;;
    view_label: "2) HTTP Request"
    group_item_label: "User Agent"
  }

###############################################################################

  dimension: json_payload {
    hidden: yes
    type: string
    sql: ${TABLE}.json_payload ;;
  }

  dimension: json_payload_string {
    label: "JSON Payload"
    # Looker currently cannot display the JSON datatype. So need to convert it to STRING to display.
    type: string
    sql: TO_JSON_STRING(${json_payload}) ;;
  }

  dimension: labels {
    hidden: yes
    type: string
    sql: ${TABLE}.labels ;;
  }

  dimension: labels_string {
    label: "Labels"
    # Looker currently cannot display the JSON datatype. So need to convert it to STRING to display.
    type: string
    sql: TO_JSON_STRING(${labels}) ;;
  }

  dimension: operation__first {
    type: yesno
    sql: ${TABLE}.operation.first ;;
    group_label: "Operation"
    group_item_label: "First"
  }

  dimension: operation__id {
    type: string
    sql: ${TABLE}.operation.id ;;
    group_label: "Operation"
    group_item_label: "ID"
  }

  dimension: operation__last {
    type: yesno
    sql: ${TABLE}.operation.last ;;
    group_label: "Operation"
    group_item_label: "Last"
  }

  dimension: operation__producer {
    type: string
    sql: ${TABLE}.operation.producer ;;
    group_label: "Operation"
    group_item_label: "Producer"
  }

#################################### PROTO PAYLOAD  ###########################################

  dimension: proto_payload__audit_log__authentication_info__authority_selector {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.authentication_info.authority_selector ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Authentication Info"
    group_item_label: "Authority Selector"
  }

  dimension: proto_payload__audit_log__authentication_info__principal_email {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.authentication_info.principal_email ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Authentication Info"
    group_item_label: "Principal Email"
    link: {
      label: "User Lookup Dashboard"
      url: "/dashboards/1782?Email={{ value | url_encode }}"
    }
  }

  dimension: is_system_or_service_account {
    type: yesno
    sql: ${proto_payload__audit_log__authentication_info__principal_email} like 'system:%' OR
         ${proto_payload__audit_log__authentication_info__principal_email} like '%@%gserviceaccount.com';;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Authentication Info"
  }

  dimension: is_admin {
    type: yesno
    sql: ${proto_payload__audit_log__authentication_info__principal_email} LIKE "admin%" ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Authentication Info"
  }

  dimension: is_email_in_company_domain {
    type: yesno
    sql: ${proto_payload__audit_log__authentication_info__principal_email} like '%@{COMPANY_DOMAIN}' ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Authentication Info"
  }

  dimension: proto_payload__audit_log__authentication_info__principal_subject {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.authentication_info.principal_subject ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Authentication Info"
    group_item_label: "Principal Subject"
  }

  # This field is hidden, which means it will not show up in Explore.
  # If you want this field to be displayed, remove "hidden: yes".

  dimension: proto_payload__audit_log__authentication_info__service_account_delegation_info {
    hidden: yes
    sql: ${TABLE}.proto_payload.audit_log.authentication_info.service_account_delegation_info ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Authentication Info"
    group_item_label: "Service Account Delegation Info"
  }

  dimension: proto_payload__audit_log__authentication_info__service_account_key_name {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.authentication_info.service_account_key_name ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Authentication Info"
    group_item_label: "Service Account Key Name"
  }

  dimension: proto_payload__audit_log__authentication_info__third_party_principal {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.authentication_info.third_party_principal ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Authentication Info"
    group_item_label: "Third Party Principal"
  }

  dimension: proto_payload__audit_log__authorization_info {
    hidden: yes
    sql: ${TABLE}.proto_payload.audit_log.authorization_info ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Main Fields"
    group_item_label: "Authorization Info"
  }

  dimension: proto_payload__audit_log__metadata {
    hidden: yes
    type: string
    sql: ${TABLE}.proto_payload.audit_log.metadata ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Main Fields"
    group_item_label: "Metadata"
  }

  dimension: proto_payload__audit_log__metadata_string {
    type: string
    sql: TO_JSON_STRING(${TABLE}.proto_payload.audit_log.metadata) ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Main Fields"
    group_item_label: "Metadata"
    label: "Metadata"
  }

  dimension: proto_payload__audit_log__method_name {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.method_name ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Main Fields"
    group_item_label: "Method Name"
  }

  measure: total_methods_used {
    type: count_distinct
    sql: ${proto_payload__audit_log__method_name} ;;
  }

  dimension: is_login {
    type: yesno
    sql: ${proto_payload__audit_log__service_name_long} = "login.googleapis.com"
         AND ${proto_payload__audit_log__method_name} LIKE "google.login.LoginService.%";;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Main Fields"
  }

  dimension: proto_payload__audit_log__num_response_items {
    type: number
    sql: ${TABLE}.proto_payload.audit_log.num_response_items ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Main Fields"
    group_item_label: "Num Response Items"
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: login_count {
    type: count
    filters: [is_login: "Yes"]
  }

  measure: login_from_admin {
    # CSA 1.01
    type: count
    filters: [
        is_login: "Yes",
        is_admin: "Yes"
      ]
  }

  measure: total_proto_payload__audit_log__num_response_items {
    type: sum
    sql: ${proto_payload__audit_log__num_response_items} ;;
  }

  measure: average_proto_payload__audit_log__num_response_items {
    type: average
    sql: ${proto_payload__audit_log__num_response_items} ;;
  }

  dimension: proto_payload__audit_log__policy_violation_info__org_policy_violation_info__payload {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.policy_violation_info.org_policy_violation_info.payload ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Policy Violation Info Org Policy Violation Info"
    group_item_label: "Payload"
  }

  dimension: proto_payload__audit_log__policy_violation_info__org_policy_violation_info__resource_tags {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.policy_violation_info.org_policy_violation_info.resource_tags ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Policy Violation Info Org Policy Violation Info"
    group_item_label: "Resource Tags"
  }

  dimension: proto_payload__audit_log__policy_violation_info__org_policy_violation_info__resource_type {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.policy_violation_info.org_policy_violation_info.resource_type ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Policy Violation Info Org Policy Violation Info"
    group_item_label: "Resource Type"
  }

  dimension: proto_payload__audit_log__policy_violation_info__org_policy_violation_info__violation_info {
    hidden: yes
    sql: ${TABLE}.proto_payload.audit_log.policy_violation_info.org_policy_violation_info.violation_info ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Policy Violation Info Org Policy Violation Info"
    group_item_label: "Violation Info"
  }

  dimension: proto_payload__audit_log__request {
    hidden: yes
    type: string
    sql: ${TABLE}.proto_payload.audit_log.request ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Main Fields"
    group_item_label: "Request"
  }

  dimension: proto_payload__audit_log__request_string {
    type: string
    sql: TO_JSON_STRING(${TABLE}.proto_payload.audit_log.request) ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Main Fields"
    group_item_label: "Request"
    label: "Request"
  }

  dimension: proto_payload__audit_log__request_metadata__caller_ip {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.caller_ip ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata"
    group_item_label: "Caller IP"
  }

  dimension: caller_ipv4 {
    #hidden: yes
    type: number
    sql: CASE
         WHEN ${TABLE}.proto_payload.audit_log.request_metadata.caller_ip = 'private' THEN 0
         WHEN REGEXP_CONTAINS(${TABLE}.proto_payload.audit_log.request_metadata.caller_ip, r":") THEN 0
         WHEN REGEXP_CONTAINS(${TABLE}.proto_payload.audit_log.request_metadata.caller_ip, r"-") THEN 0
         ELSE NET.IPV4_TO_INT64(NET.SAFE_IP_FROM_STRING(${TABLE}.proto_payload.audit_log.request_metadata.caller_ip))
         END;;
  }

  dimension: class_b {
    # sql: TRUNC(NET.IPV4_TO_INT64(NET.SAFE_IP_FROM_STRING(${caller_ip}))/(256*256));;
    sql:
    CASE
        WHEN ${TABLE}.proto_payload.audit_log.request_metadata.caller_ip = 'private' THEN 0
        WHEN REGEXP_CONTAINS(${TABLE}.proto_payload.audit_log.request_metadata.caller_ip, r":") THEN 0
         WHEN REGEXP_CONTAINS(${TABLE}.proto_payload.audit_log.request_metadata.caller_ip, r"-") THEN 0
    ELSE TRUNC(NET.IPV4_TO_INT64(NET.IP_FROM_STRING(${TABLE}.proto_payload.audit_log.request_metadata.caller_ip))/(256*256))
    END     ;;
    #hidden: yes
  }

  dimension: proto_payload__audit_log__request_metadata__caller_network {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.caller_network ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata"
    group_item_label: "Caller Network"
  }

  dimension: proto_payload__audit_log__request_metadata__caller_supplied_user_agent {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.caller_supplied_user_agent ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata"
    group_item_label: "Caller Supplied User Agent"
  }

  dimension: proto_payload__audit_log__request_metadata__destination_attributes__ip {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.destination_attributes.ip ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata Destination Attributes"
    group_item_label: "IP"
  }

  dimension: proto_payload__audit_log__request_metadata__destination_attributes__labels {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.destination_attributes.labels ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata Destination Attributes"
    group_item_label: "Labels"
  }

  dimension: proto_payload__audit_log__request_metadata__destination_attributes__port {
    type: number
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.destination_attributes.port ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata Destination Attributes"
    group_item_label: "Port"
  }

  dimension: proto_payload__audit_log__request_metadata__destination_attributes__principal {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.destination_attributes.principal ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata Destination Attributes"
    group_item_label: "Principal"
  }

  dimension: proto_payload__audit_log__request_metadata__destination_attributes__region_code {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.destination_attributes.region_code ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata Destination Attributes"
    group_item_label: "Region Code"
  }

  dimension: proto_payload__audit_log__request_metadata__request_attributes__auth__access_levels {
    hidden: yes
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.request_attributes.auth.access_levels ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata Request Attributes Auth"
    group_item_label: "Access Levels"
  }

  dimension: proto_payload__audit_log__service_data__policy_delta__binding_deltas {
    hidden: yes
    sql: ${TABLE}.proto_payload.audit_log.service_data.policyDelta.bindingDeltas ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Service Data Policy Delta Binding Deltas"
    group_item_label: "Binding Deltas"
  }

  dimension: proto_payload__audit_log__request_metadata__request_attributes__auth__audiences {
    hidden: yes
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.request_attributes.auth.audiences ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata Request Attributes Auth"
    group_item_label: "Audiences"
  }

  dimension: proto_payload__audit_log__request_metadata__request_attributes__auth__claims {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.request_attributes.auth.claims ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata Request Attributes Auth"
    group_item_label: "Claims"
  }

  dimension: proto_payload__audit_log__request_metadata__request_attributes__auth__presenter {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.request_attributes.auth.presenter ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata Request Attributes Auth"
    group_item_label: "Presenter"
  }

  dimension: proto_payload__audit_log__request_metadata__request_attributes__auth__principal {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.request_attributes.auth.principal ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata Request Attributes Auth"
    group_item_label: "Principal"
  }

  dimension: proto_payload__audit_log__request_metadata__request_attributes__headers {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.request_attributes.headers ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata Request Attributes"
    group_item_label: "Headers"
  }

  dimension: proto_payload__audit_log__request_metadata__request_attributes__host {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.request_attributes.host ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata Request Attributes"
    group_item_label: "Host"
  }

  dimension: proto_payload__audit_log__request_metadata__request_attributes__id {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.request_attributes.id ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata Request Attributes"
    group_item_label: "ID"
  }

  dimension: proto_payload__audit_log__request_metadata__request_attributes__method {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.request_attributes.method ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata Request Attributes"
    group_item_label: "Method"
  }

  dimension: proto_payload__audit_log__request_metadata__request_attributes__path {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.request_attributes.path ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata Request Attributes"
    group_item_label: "Path"
  }

  dimension: proto_payload__audit_log__request_metadata__request_attributes__protocol {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.request_attributes.protocol ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata Request Attributes"
    group_item_label: "Protocol"
  }

  dimension: proto_payload__audit_log__request_metadata__request_attributes__query {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.request_attributes.query ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata Request Attributes"
    group_item_label: "Query"
  }

  dimension: proto_payload__audit_log__request_metadata__request_attributes__reason {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.request_attributes.reason ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata Request Attributes"
    group_item_label: "Reason"
  }

  dimension: proto_payload__audit_log__request_metadata__request_attributes__scheme {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.request_attributes.scheme ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata Request Attributes"
    group_item_label: "Scheme"
  }

  dimension: proto_payload__audit_log__request_metadata__request_attributes__size {
    type: number
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.request_attributes.size ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata Request Attributes"
    group_item_label: "Size"
  }

  dimension_group: proto_payload__audit_log__request_metadata__request_attributes_ {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.request_attributes.time ;;
  }

  dimension: proto_payload__audit_log__request_metadata__request_attributes__time_unix_nanos {
    type: number
    sql: ${TABLE}.proto_payload.audit_log.request_metadata.request_attributes.time_unix_nanos ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Request Metadata Request Attributes"
    group_item_label: "Time Unix Nanos"
  }

  dimension: proto_payload__audit_log__resource_location__current_locations {
    hidden: yes
    sql: ${TABLE}.proto_payload.audit_log.resource_location.current_locations ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Resource Location"
    group_item_label: "Current Locations"
  }

  dimension: proto_payload__audit_log__resource_location__original_locations {
    hidden: yes
    sql: ${TABLE}.proto_payload.audit_log.resource_location.original_locations ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Resource Location"
    group_item_label: "Original Locations"
  }

  dimension: proto_payload__audit_log__resource_name {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.resource_name ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Main Fields"
    group_item_label: "Resource Name"
  }

  dimension: proto_payload__audit_log__resource_original_state {
    hidden: yes
    type: string
    sql: ${TABLE}.proto_payload.audit_log.resource_original_state ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Main Fields"
    group_item_label: "Resource Original State"
  }

  dimension: proto_payload__audit_log__resource_original_state_string {
    type: string
    sql: TO_JSON_STRING(proto_payload__audit_log__resource_original_state) ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Main Fields"
    group_item_label: "Resource Original State"
    label: "Original State"
  }

  dimension: proto_payload__audit_log__response {
    hidden: yes
    type: string
    sql: ${TABLE}.proto_payload.audit_log.response ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Main Fields"
    group_item_label: "Response"
  }

  dimension: proto_payload__audit_log__response_string {
    type: string
    sql: TO_JSON_STRING(${TABLE}.proto_payload.audit_log.response) ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Main Fields"
    group_item_label: "Response"
    label: "Response"
  }

  dimension: proto_payload__audit_log__service_data {
    hidden: yes
    type: string
    sql: ${TABLE}.proto_payload.audit_log.service_data ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Main Fields"
    group_item_label: "Service Data"
  }

  dimension: proto_payload__audit_log__service_data_string {
    type: string
    sql: TO_JSON_STRING(${TABLE}.proto_payload.audit_log.service_data) ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Main Fields"
    group_item_label: "Service Data"
    label: "Service Data"
  }

  dimension: proto_payload__audit_log__service_name_long {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.service_name ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Main Fields"
    group_item_label: "Service Name (Long)"
  }

  dimension: proto_payload__audit_log__service_name {
    type: string
    sql: SUBSTR(${proto_payload__audit_log__service_name_long}, 0, STRPOS(${proto_payload__audit_log__service_name_long}, ".") -1) ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Main Fields"
    group_item_label: "Service Name"
  }

  dimension: proto_payload__audit_log__status__code {
    type: number
    sql: ${TABLE}.proto_payload.audit_log.status.code ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Status"
    group_item_label: "Code"
  }

  dimension: proto_payload__audit_log__status__details {
    hidden: yes
    type: string
    sql: ${TABLE}.proto_payload.audit_log.status.details ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Status"
    group_item_label: "Details"
  }

  dimension: proto_payload__audit_log__status__details_string {
    type: string
    sql: TO_JSON_STRING(${TABLE}.proto_payload.audit_log.status.details) ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Status"
    group_item_label: "Details"
    label: "Details"
  }

  dimension: proto_payload__audit_log__status__message {
    type: string
    sql: ${TABLE}.proto_payload.audit_log.status.message ;;
    view_label: "3) Audit Log - Proto Payload"    group_label: "Status"
    group_item_label: "Message"
  }

  dimension: proto_payload__request_log__app_engine_release {
    type: string
    sql: ${TABLE}.proto_payload.request_log.app_engine_release ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "App Engine Release"
  }

  dimension: proto_payload__request_log__app_id {
    type: string
    sql: ${TABLE}.proto_payload.request_log.app_id ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "App ID"
  }

  dimension: proto_payload__request_log__cost {
    type: number
    sql: ${TABLE}.proto_payload.request_log.cost ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Cost"
  }

  dimension_group: proto_payload__request_log__end {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.proto_payload.request_log.end_time ;;
  }

  dimension: proto_payload__request_log__end_time_unix_nanos {
    type: number
    sql: ${TABLE}.proto_payload.request_log.end_time_unix_nanos ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "End Time Unix Nanos"
  }

  dimension: proto_payload__request_log__finished {
    type: yesno
    sql: ${TABLE}.proto_payload.request_log.finished ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Finished"
  }

  dimension: proto_payload__request_log__first {
    type: yesno
    sql: ${TABLE}.proto_payload.request_log.first ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "First"
  }

  dimension: proto_payload__request_log__host {
    type: string
    sql: ${TABLE}.proto_payload.request_log.host ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Host"
  }

  dimension: proto_payload__request_log__http_version {
    type: string
    sql: ${TABLE}.proto_payload.request_log.http_version ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "HTTP Version"
  }

  dimension: proto_payload__request_log__instance_id {
    type: string
    sql: ${TABLE}.proto_payload.request_log.instance_id ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Instance ID"
  }

  dimension: proto_payload__request_log__instance_index {
    type: number
    sql: ${TABLE}.proto_payload.request_log.instance_index ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Instance Index"
  }

  dimension: proto_payload__request_log__ip {
    type: string
    sql: ${TABLE}.proto_payload.request_log.ip ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "IP"
  }

  dimension: proto_payload__request_log__latency__nanos {
    type: number
    sql: ${TABLE}.proto_payload.request_log.latency.nanos ;;
    view_label: "4) Audit Log - Proto Payload Request Log"   group_label: "Latency"
    group_item_label: "Nanos"
  }

  dimension: proto_payload__request_log__latency__seconds {
    type: number
    sql: ${TABLE}.proto_payload.request_log.latency.seconds ;;
    view_label: "4) Audit Log - Proto Payload Request Log"   group_label: "Latency"
    group_item_label: "Seconds"
  }

  dimension: proto_payload__request_log__line {
    hidden: yes
    sql: ${TABLE}.proto_payload.request_log.line ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Line"
  }

  dimension: proto_payload__request_log__mega_cycles {
    type: number
    sql: ${TABLE}.proto_payload.request_log.mega_cycles ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Mega Cycles"
  }

  dimension: proto_payload__request_log__method {
    type: string
    sql: ${TABLE}.proto_payload.request_log.method ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Method"
  }

  dimension: proto_payload__request_log__module_id {
    type: string
    sql: ${TABLE}.proto_payload.request_log.module_id ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Module ID"
  }

  dimension: proto_payload__request_log__nickname {
    type: string
    sql: ${TABLE}.proto_payload.request_log.nickname ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Nickname"
  }

  dimension: proto_payload__request_log__pending_time__nanos {
    type: number
    sql: ${TABLE}.proto_payload.request_log.pending_time.nanos ;;
    view_label: "4) Audit Log - Proto Payload Request Log"   group_label: "Pending Time"
    group_item_label: "Nanos"
  }

  dimension: proto_payload__request_log__pending_time__seconds {
    type: number
    sql: ${TABLE}.proto_payload.request_log.pending_time.seconds ;;
    view_label: "4) Audit Log - Proto Payload Request Log"   group_label: "Pending Time"
    group_item_label: "Seconds"
  }

  dimension: proto_payload__request_log__referrer {
    type: string
    sql: ${TABLE}.proto_payload.request_log.referrer ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Referrer"
  }

  dimension: proto_payload__request_log__request_id {
    type: string
    sql: ${TABLE}.proto_payload.request_log.request_id ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Request ID"
  }

  dimension: proto_payload__request_log__resource {
    type: string
    sql: ${TABLE}.proto_payload.request_log.resource ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Resource"
  }

  dimension: proto_payload__request_log__response_size {
    type: number
    sql: ${TABLE}.proto_payload.request_log.response_size ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Response Size"
  }

  dimension: proto_payload__request_log__source_reference {
    hidden: yes
    sql: ${TABLE}.proto_payload.request_log.source_reference ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Source Reference"
  }

  dimension: proto_payload__request_log__span_id {
    type: string
    sql: ${TABLE}.proto_payload.request_log.span_id ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Span ID"
  }

  dimension_group: proto_payload__request_log__start {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.proto_payload.request_log.start_time ;;
  }

  dimension: proto_payload__request_log__start_time_unix_nanos {
    type: number
    sql: ${TABLE}.proto_payload.request_log.start_time_unix_nanos ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Start Time Unix Nanos"
  }

  dimension: proto_payload__request_log__status {
    type: number
    sql: ${TABLE}.proto_payload.request_log.status ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Status"
  }

  dimension: proto_payload__request_log__task_name {
    type: string
    sql: ${TABLE}.proto_payload.request_log.task_name ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Task Name"
  }

  dimension: proto_payload__request_log__task_queue_name {
    type: string
    sql: ${TABLE}.proto_payload.request_log.task_queue_name ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Task Queue Name"
  }

  dimension: proto_payload__request_log__trace_id {
    type: string
    sql: ${TABLE}.proto_payload.request_log.trace_id ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Trace ID"
  }

  dimension: proto_payload__request_log__trace_sampled {
    type: yesno
    sql: ${TABLE}.proto_payload.request_log.trace_sampled ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Trace Sampled"
  }

  dimension: proto_payload__request_log__url_map_entry {
    type: string
    sql: ${TABLE}.proto_payload.request_log.url_map_entry ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "URL Map Entry"
  }

  dimension: proto_payload__request_log__user_agent {
    type: string
    sql: ${TABLE}.proto_payload.request_log.user_agent ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "User Agent"
  }

  dimension: proto_payload__request_log__version_id {
    type: string
    sql: ${TABLE}.proto_payload.request_log.version_id ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Version ID"
  }

  dimension: proto_payload__request_log__was_loading_request {
    type: yesno
    sql: ${TABLE}.proto_payload.request_log.was_loading_request ;;
    view_label: "4) Audit Log - Proto Payload Request Log"    group_label: "Proto Payload Request Log"
    group_item_label: "Was Loading Request"
  }

  dimension: proto_payload__type {
    type: string
    sql: ${TABLE}.proto_payload.type ;;
    group_label: "Proto Payload"
    group_item_label: "Type"
  }

  dimension_group: receive_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.receive_timestamp ;;
  }

  dimension: receive_timestamp_unix_nanos {
    type: number
    sql: ${TABLE}.receive_timestamp_unix_nanos ;;
  }



  dimension: source_location__file {
    type: string
    sql: ${TABLE}.source_location.file ;;
    group_label: "Source Location"
    group_item_label: "File"
  }

  dimension: source_location__function {
    type: string
    sql: ${TABLE}.source_location.function ;;
    group_label: "Source Location"
    group_item_label: "Function"
  }

  dimension: source_location__line {
    type: number
    sql: ${TABLE}.source_location.line ;;
    group_label: "Source Location"
    group_item_label: "Line"
  }

  dimension: span_id {
    type: string
    sql: ${TABLE}.span_id ;;
  }

  dimension: split__index {
    type: number
    sql: ${TABLE}.split.index ;;
    group_label: "Split"
    group_item_label: "Index"
  }

  dimension: split__total_splits {
    type: number
    sql: ${TABLE}.split.total_splits ;;
    group_label: "Split"
    group_item_label: "Total Splits"
  }

  dimension: split__uid {
    type: string
    sql: ${TABLE}.split.uid ;;
    group_label: "Split"
    group_item_label: "Uid"
  }

  dimension: text_payload {
    type: string
    sql: ${TABLE}.text_payload ;;
  }



  dimension: trace {
    type: string
    sql: ${TABLE}.trace ;;
  }

  dimension: trace_sampled {
    type: yesno
    sql: ${TABLE}.trace_sampled ;;
  }

############# Derived Fields ############

  dimension: is_audit_log {
    description: "Use to filter on Audit Logs"
    type: yesno
    sql:  log_name LIKE "%cloudaudit.googleapis.com%";;
  }



  dimension: is_load_balancer_log {
    type: yesno
    sql: ${resource__type} = 'http_load_balancer' ;;
  }




##### Audit Log Metadata for VPC logs
  dimension: violation_reason {
    type: string
    sql:  JSON_VALUE(proto_payload.audit_log.metadata.violationReason);;
  }

  dimension: ingress_violations {
    sql: JSON_VALUE(proto_payload.audit_log.metadata.ingressViolations) ;;
  }

  dimension: violation_type {
    sql: IF(${ingress_violations} IS NULL, 'ingress', 'egress')  ;;
  }

  dimension: metadata_type {
    sql: JSON_VALUE(proto_payload.audit_log.metadata, '$."@type"') ;;
  }

  # Measures

  measure: count {
    label: "Event Count"
    type: count
    drill_fields: [detail*]
  }



  #####################################################
  ########## DATA ACCESS LOGS - DAL ###################
  #####################################################

  measure: count_dal_event {
    view_label: "Data Access Logs"
    label: "Count Data Access Events"
    type: count
    filters: [log_id: "cloudaudit.googleapis.com/data_access"]
  }

  ## BigQuery DAL

  dimension: is_bq_dal_event {
    #5.01 - BQ records duplicate events one with an old method name, and another with a v2 method name. So need to filter on the v2's to make sure you don't count dupes.
    view_label: "Data Access Logs"
    group_label: "BigQuery"
    label: "Is BigQuery Data Access Event"
    description: "Data Access Insert or Query"
    type: yesno
    sql: ${proto_payload__audit_log__method_name} = "google.cloud.bigquery.v2.JobService.InsertJob" OR
         ${proto_payload__audit_log__method_name} = "google.cloud.bigquery.v2.JobService.Query" ;;
  }

  dimension: job_config_type {
    view_label: "Data Access Logs"
    group_label: "BigQuery"
    sql: JSON_VALUE(proto_payload.audit_log.metadata.jobChange.job.jobConfig.type)  ;;
  }

  dimension: is_query_job {
    view_label: "Data Access Logs"
    group_label: "BigQuery"
    type: yesno
    sql: ${job_config_type} = "QUERY" ;;
  }

  measure: data_access_bq {
    view_label: "Data Access Logs"
    group_label: "BigQuery"
    # CSA 5.01 https://github.com/GoogleCloudPlatform/security-analytics/blob/main/src/5.01/5.01.md
    label: "Count Data Access - BigQuery"
    type: count
    filters: [log_id: "cloudaudit.googleapis.com/data_access", is_bq_dal_event: "Yes"]
  }

  measure: billed_bytes {
    view_label: "Data Access Logs"
    group_label: "BigQuery"
    # CSA 5.02
    type: sum
    value_format_name: decimal_2
    sql: CAST(JSON_VALUE(${TABLE}.proto_payload.audit_log.metadata.jobChange.job.jobStats.queryStats.totalBilledBytes) AS INT64) ;;
  }

  measure: billed_tb {
    view_label: "Data Access Logs"
    group_label: "BigQuery"
    label: "Billed TBs"
    description: "Billed Terabytes"
    type: number
    value_format_name: decimal_2
    sql: ${billed_bytes} / POWER(2, 40) ;;
    html: {{rendered_value}}  TB ;;
  }

  measure: billed_gb {
    view_label: "Data Access Logs"
    group_label: "BigQuery"
    label: "Billed GBs"
    description: "Billed Gigabytes"
    type: number
    value_format_name: decimal_2
    sql: ${billed_bytes} / POWER(2, 30) ;;
    html: {{rendered_value}} GB ;;
  }

#################################################
#### Demo Only - USERS table ####################
#################################################

  dimension: department {
    view_label: "Users"
    type: string
    sql: 'Finance' ;;
  }

  dimension: email {
    view_label: "Users"
    label: "Principal Email"
    type: string
    sql: ${proto_payload__audit_log__authentication_info__principal_email} ;;
  }

  dimension: employment_status {
    view_label: "Users"
    type: string
    sql: 'Active' ;;
  }

  dimension: image {
    view_label: "Users"
    type: string
    sql: CONCAT('https://moma-teams-photos.corp.google.com/photos/',${email}) ;;
    html: <img src="{{value}}"/>;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension: start_date {
    view_label: "Users"
    type: date_time
    sql: '2019-02-10' ;;
  }

  dimension: tenure {
    view_label: "Users"
    type: string
    sql: '3 years, 5 months' ;;
  }

  measure: user_count {
    view_label: "Users"
    type: count_distinct
    sql: ${proto_payload__audit_log__authentication_info__principal_email} ;;
  }



  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      log_name,
      proto_payload__request_log__nickname,
      proto_payload__audit_log__method_name,
      proto_payload__request_log__task_name,
      proto_payload__audit_log__service_name,
      proto_payload__audit_log__resource_name,
      proto_payload__request_log__task_queue_name,
      proto_payload__audit_log__authentication_info__service_account_key_name
    ]
  }
}

# The name of this view in Looker is " All Logs Proto Payload Request Log Line"
view: all_logs__proto_payload__request_log__line {
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Log Message" in Explore.

  dimension: log_message {
    type: string
    sql: ${TABLE}.log_message ;;
  }

  dimension: severity {
    type: string
    sql: ${TABLE}.severity ;;
  }

  dimension: severity_number {
    type: number
    sql: ${TABLE}.severity_number ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.


  dimension: source_location__file {
    type: string
    sql: ${TABLE}.source_location.file ;;
    group_label: "Source Location"
    group_item_label: "File"
  }

  dimension: source_location__function_name {
    type: string
    sql: ${TABLE}.source_location.function_name ;;
    group_label: "Source Location"
    group_item_label: "Function Name"
  }

  dimension: source_location__line {
    type: number
    sql: ${TABLE}.source_location.line ;;
    group_label: "Source Location"
    group_item_label: "Line"
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: time {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.time ;;
  }

  dimension: time_unix_nanos {
    type: number
    sql: ${TABLE}.time_unix_nanos ;;
  }
}

# The name of this view in Looker is " All Logs Proto Payload Audit Log Authorization Info"
view: all_logs__proto_payload__audit_log__authorization_info {
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Granted" in Explore.

  dimension: granted {
    type: yesno
    sql: ${TABLE}.granted ;;
  }

  dimension: permission {
    type: string
    sql: ${TABLE}.permission ;;
  }

  dimension: resource {
    type: string
    sql: ${TABLE}.resource ;;
  }

  dimension: resource_attributes__annotations {
    type: string
    sql: ${TABLE}.resource_attributes.annotations ;;
    group_label: "Resource Attributes"
    group_item_label: "Annotations"
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: resource_attributes__create {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.resource_attributes.create_time ;;
  }

  dimension: resource_attributes__create_time_unix_nanos {
    type: number
    sql: ${TABLE}.resource_attributes.create_time_unix_nanos ;;
    group_label: "Resource Attributes"
    group_item_label: "Create Time Unix Nanos"
  }



  dimension_group: resource_attributes__delete {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.resource_attributes.delete_time ;;
  }

  dimension: resource_attributes__delete_time_unix_nanos {
    type: number
    sql: ${TABLE}.resource_attributes.delete_time_unix_nanos ;;
    group_label: "Resource Attributes"
    group_item_label: "Delete Time Unix Nanos"
  }

  dimension: resource_attributes__display_name {
    type: string
    sql: ${TABLE}.resource_attributes.display_name ;;
    group_label: "Resource Attributes"
    group_item_label: "Display Name"
  }

  dimension: resource_attributes__etag {
    type: string
    sql: ${TABLE}.resource_attributes.etag ;;
    group_label: "Resource Attributes"
    group_item_label: "Etag"
  }

  dimension: resource_attributes__labels {
    hidden: yes
    type: string
    sql: ${TABLE}.resource_attributes.labels ;;
    group_label: "Resource Attributes"
    group_item_label: "Labels"
  }

  dimension: resource_attributes__labels_string {
    type: string
    sql: TO_JSON_STRING(${TABLE}.resource_attributes.labels) ;;
    group_label: "Resource Attributes"
    group_item_label: "Labels"
    label: "Labels"
  }

  dimension: resource_attributes__location {
    type: string
    sql: ${TABLE}.resource_attributes.location ;;
    group_label: "Resource Attributes"
    group_item_label: "Location"
  }

  dimension: resource_attributes__name {
    type: string
    sql: ${TABLE}.resource_attributes.name ;;
    group_label: "Resource Attributes"
    group_item_label: "Name"
  }

  dimension: resource_attributes__service {
    type: string
    sql: ${TABLE}.resource_attributes.service ;;
    group_label: "Resource Attributes"
    group_item_label: "Service"
  }

  dimension: resource_attributes__type {
    type: string
    sql: ${TABLE}.resource_attributes.type ;;
    group_label: "Resource Attributes"
    group_item_label: "Type"
  }

  dimension: resource_attributes__uid {
    type: string
    sql: ${TABLE}.resource_attributes.uid ;;
    group_label: "Resource Attributes"
    group_item_label: "Uid"
  }

  dimension_group: resource_attributes__update {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.resource_attributes.update_time ;;
  }

  dimension: resource_attributes__update_time_unix_nanos {
    type: number
    sql: ${TABLE}.resource_attributes.update_time_unix_nanos ;;
    group_label: "Resource Attributes"
    group_item_label: "Update Time Unix Nanos"
  }



}

# The name of this view in Looker is " All Logs Proto Payload Request Log Source Reference"
view: all_logs__proto_payload__request_log__source_reference {
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Repository" in Explore.

  dimension: repository {
    type: string
    sql: ${TABLE}.repository ;;
  }

  dimension: revision_id {
    type: string
    sql: ${TABLE}.revision_id ;;
  }
}

# The name of this view in Looker is " All Logs Proto Payload Audit Log Resource Location Current Locations"
view: all_logs__proto_payload__audit_log__resource_location__current_locations {
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called " All Logs Proto Payload Audit Log Resource Location Current Locations" in Explore.

  dimension: resource_location__current_locations {
    type: string
    sql: _all_logs__proto_payload__audit_log__resource_location__current_locations ;;
  }
}

# The name of this view in Looker is " All Logs Proto Payload Audit Log Resource Location Original Locations"
view: all_logs__proto_payload__audit_log__resource_location__original_locations {
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called " All Logs Proto Payload Audit Log Resource Location Original Locations" in Explore.

  dimension: resource_location__original_locations {
    type: string
    sql: _all_logs__proto_payload__audit_log__resource_location__original_locations ;;
  }
}

# The name of this view in Looker is " All Logs Proto Payload Audit Log Request Metadata Request Attributes Auth Audiences"
view: all_logs__proto_payload__audit_log__request_metadata__request_attributes__auth__audiences {
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called " All Logs Proto Payload Audit Log Request Metadata Request Attributes Auth Audiences" in Explore.

  dimension: request_metadata__request_attributes__auth__audiences {
    type: string
    sql: _all_logs__proto_payload__audit_log__request_metadata__request_attributes__auth__audiences ;;
  }
}

# The name of this view in Looker is " All Logs Proto Payload Audit Log Request Metadata Request Attributes Auth Access Levels"
view: all_logs__proto_payload__audit_log__request_metadata__request_attributes__auth__access_levels {
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called " All Logs Proto Payload Audit Log Request Metadata Request Attributes Auth Access Levels" in Explore.

  dimension: request_metadata__request_attributes__auth__access_levels {
    type: string
    sql: _all_logs__proto_payload__audit_log__request_metadata__request_attributes__auth__access_levels ;;
  }
}


view: all_logs__proto_payload__audit_log__service_data__policy_delta__binding_deltas {
  # manually added for audit log reporting

  dimension: service_data__policy_delta__binding_deltas {
    type: string
    sql: TO_JSON_STRING(bindingDelta) ;;
  }

  dimension: action {
    type: string
    sql: JSON_VALUE(bindingDelta.action)  ;;
  }

  dimension: role {
    type: string
    sql: JSON_VALUE(bindingDelta.role)  ;;
  }

  # IAM metrics

  measure: permissions_over_sa {
    # 2.20 https://github.com/GoogleCloudPlatform/security-analytics
    label: "Permissions Granted Over SA"
    description: "Permissions granted to any principal over a service account, for example, to impersonate a service account or create keys for that service account."
    type: count
    filters:
    [all_logs.resource__type: "service_account", all_logs.proto_payload__audit_log__method_name: "google.iam.admin.%.SetIAMPolicy", action: "ADD"]
  }

  measure: permissions_to_impersonate_sa {
    # 2.21 https://github.com/GoogleCloudPlatform/security-analytics
    label: "Permissions Granted to Impersonate SA"
    description: "Permissions granted to impersonate a service account"
    type: count
    filters:
    [all_logs.resource__type: "service_account", all_logs.proto_payload__audit_log__method_name: "google.iam.admin.%.SetIAMPolicy", action: "ADD", role: "roles/iam.serviceAccountTokenCreator,
    roles/iam.serviceAccountUser"]
  }
}

# The name of this view in Looker is " All Logs Proto Payload Audit Log Authentication Info Service Account Delegation Info"
view: all_logs__proto_payload__audit_log__authentication_info__service_account_delegation_info {
  view_label: "test"
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "First Party Principal Principal Email" in Explore.

  dimension: first_party_principal__principal_email {
    type: string
    sql: ${TABLE}.first_party_principal.principal_email ;;
    group_label: "First Party Principal"
    group_item_label: "Principal Email"
  }

  dimension: first_party_principal__service_metadata {
    type: string
    sql: ${TABLE}.first_party_principal.service_metadata ;;
    group_label: "First Party Principal"
    group_item_label: "Service Metadata"
  }

  dimension: principal_subject {
    type: string
    sql: ${TABLE}.principal_subject ;;
  }

  dimension: third_party_principal__third_party_claims {
    type: string
    sql: ${TABLE}.third_party_principal.third_party_claims ;;
    group_label: "Third Party Principal"
    group_item_label: "Third Party Claims"
  }
}

# The name of this view in Looker is " All Logs Proto Payload Audit Log Policy Violation Info Org Policy Violation Info Violation Info"
view: all_logs__proto_payload__audit_log__policy_violation_info__org_policy_violation_info__violation_info {
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Checked Value" in Explore.

  dimension: checked_value {
    type: string
    sql: ${TABLE}.checked_value ;;
  }

  dimension: constraint {
    type: string
    sql: ${TABLE}.constraint ;;
  }

  dimension: error_message {
    type: string
    sql: ${TABLE}.error_message ;;
  }

  dimension: policy_type {
    type: string
    sql: ${TABLE}.policy_type ;;
  }

  dimension: policy_type_number {
    type: number
    sql: ${TABLE}.policy_type_number ;;
  }


}
