project_name: "block_gcp_cloud_logging"


################# Constants ################

## Used in cloud_logging.model connection param
constant: CONNECTION_NAME {
  value: "cloud_logging"
  export: override_required
}

## Used in all_logs.view sql_table_name
constant: PROJECT_NAME {
  value: "sd-uxr-001"
  export: override_required
}

## Used in all_logs.view sql_table_name
constant: SCHEMA_NAME {
  value: "looker"
  export: override_required
}

## Used in all_logs.view sql_table_name
constant: LOG_TABLE_NAME {
  value: "_AllLogs"
  export: override_optional
}

constant: COMPANY_DOMAIN {
  value: "@google.com"
  export: override_optional
}

constant: LOOKER_URL  {
  # full url of Looker instance - i.e. "https://acme.looker.com""
  value: "https://googlecloud.looker.com"
  export: override_required

}
