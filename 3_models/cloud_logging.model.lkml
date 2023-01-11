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


explore: +_all_logs {
  # refined explore
  # base explore definition found in "/1_raw_lookml/raw_lookml.lkml""

  always_filter: {
    # to reduce inadverent expensive queries, default all explore queries to last 1 day (today)
    filters: [_all_logs.timestamp_date: "last 1 days"]
  }

  # this is used for Searching across columns
  sql_always_where:
  {% if _all_logs.search_filter._in_query %}
  SEARCH(_all_logs,"`{% parameter _all_logs.search_filter %}`")
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
    filters: [_all_logs.timestamp_time: "1 hours"]
    limit: 500
  }


}

explore: audit_logs {
  always_filter: {
    # to reduce inadverent expensive queries, default all explore queries to last 1 day (today)
    filters: [audit_logs.timestamp_date: "last 1 days"]
  }

  # this is used for Searching across columns
  sql_always_where:
  {% if audit_logs.search_filter._in_query %}
  SEARCH(audit_logs,"`{% parameter audit_logs.search_filter %}`")
  {% else %}
  1=1
  {% endif %} ;;
}
