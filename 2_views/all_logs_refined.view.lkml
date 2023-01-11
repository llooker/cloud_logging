include: "/1_raw_lookml/raw_lookml.lkml"
view: +_all_logs {

# Filters and Parameters

  parameter: search_filter {
    # used for searching across columns in the table
    suggestable: no
    type: unquoted
  }


  ################### JSON FIELDS #######################################################################################################
  # Hide JSON fields and convert to strings
  # Looker currently cannot display the JSON datatype. So need to convert it to STRING to display.


  dimension: labels {
    hidden: yes
  }

  dimension: labels_string {
    label: "Labels"
    # Looker currently cannot display the JSON datatype. So need to convert it to STRING to display.
    type: string
    sql: TO_JSON_STRING(${labels}) ;;
  }

  dimension: json_payload {
    hidden: yes
  }

  dimension: json_payload_string {
    label: "JSON Payload"
    # Looker currently cannot display the JSON datatype. So need to convert it to STRING to display.
    type: string
    sql: TO_JSON_STRING(${json_payload}) ;;
  }

  dimension: proto_payload__audit_log__metadata {
    hidden: yes
  }

  dimension: proto_payload__audit_log__metadata_string {
    type: string
    sql: TO_JSON_STRING(${TABLE}.proto_payload.audit_log.metadata) ;;
    group_label: "Proto Payload Audit Log"
    group_item_label: "Metadata"
    label: "Metadata"
  }

  dimension: proto_payload__audit_log__request {
   hidden: yes
  }

  dimension: proto_payload__audit_log__request_string {
    type: string
    sql: TO_JSON_STRING(${TABLE}.proto_payload.audit_log.request) ;;
    group_label: "Proto Payload Audit Log"
    group_item_label: "Request"
    label: "Request"
  }

  dimension: proto_payload__audit_log__resource_original_state {
    hidden: yes
  }

  dimension: proto_payload__audit_log__resource_original_state_string {
    type: string
    sql: TO_JSON_STRING(proto_payload__audit_log__resource_original_state) ;;
    group_label: "Proto Payload Audit Log"
    group_item_label: "Resource Original State"
    label: "Original State"
  }

  dimension: proto_payload__audit_log__response {
    hidden: yes
  }

  dimension: proto_payload__audit_log__response_string {
    type: string
    sql: TO_JSON_STRING(${TABLE}.proto_payload.audit_log.response) ;;
    group_label: "Proto Payload Audit Log"
    group_item_label: "Response"
    label: "Response"
  }

  dimension: proto_payload__audit_log__service_data {
   hidden: yes
  }

  dimension: proto_payload__audit_log__service_data_string {
    type: string
    sql: TO_JSON_STRING(${TABLE}.proto_payload.audit_log.service_data) ;;
    group_label: "Proto Payload Audit Log"
    group_item_label: "Service Data"
    label: "Service Data"
  }

  dimension: proto_payload__audit_log__status__details {
    hidden: yes
  }

  dimension: proto_payload__audit_log__status__details_string {
    type: string
    sql: TO_JSON_STRING(${TABLE}.proto_payload.audit_log.status.details) ;;
    group_label: "Proto Payload Audit Log Status"
    group_item_label: "Details"
    label: "Details"
  }


  dimension: resource_attributes__labels {
    hidden: yes
  }

  dimension: resource_attributes__labels_string {
    type: string
    sql: TO_JSON_STRING(${TABLE}.resource_attributes.labels) ;;
    group_label: "Resource Attributes"
    group_item_label: "Labels"
    label: "Labels"
  }

  dimension: resource__labels {
    hidden: yes
  }

  dimension: resource__labels_string {
    group_label: "Resource"
    group_item_label: "Labels"
    label: "Labels"
    # Looker currently cannot display the JSON datatype. So need to convert it to STRING to display.
    type: string
    sql: TO_JSON_STRING(${resource__labels}) ;;
  }

# AUDIT LOGS
  dimension: is_audit_log {
    description: "Use to filter on Audit Logs"
    type: yesno
    sql:  log_name LIKE "%cloudaudit.googleapis.com%";;
  }

}

  # view: sec_ops {
  #   extends: [_all_logs]
  # }
