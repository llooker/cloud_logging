project_name: "block_gcp_cloud_logging"


################# Constants ################

## Used in cloud_logging.model connection param
constant: CONNECTION_NAME {
  value: "cloud_logging"
  export: override_required
}

## Used in _all_logs.view sql_table_name
constant: SCHEMA_NAME {
  value: "looker"
  #value: "demo_logs"
  export: override_required
}

## Used in _all_logs.view sql_table_name
constant: LOG_TABLE_NAME {
  value: "_AllLogs"
  export: override_optional
}
