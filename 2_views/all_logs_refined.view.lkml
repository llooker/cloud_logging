include: "/1_raw_lookml/raw_lookml.lkml"
view: +_all_logs {

  parameter: search_filter {
    # used for searching across columns in the table
    suggestable: no
    type: unquoted
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

  dimension: labels {
    hidden: yes
  }

  dimension: labels_string {
    label: "Labels"
    # Looker currently cannot display the JSON datatype. So need to convert it to STRING to display.
    type: string
    sql: TO_JSON_STRING(${labels}) ;;
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
}

  # view: sec_ops {
  #   extends: [_all_logs]
  # }
