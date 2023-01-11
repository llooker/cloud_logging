include: "/1_raw_lookml/raw_lookml.lkml"
include:  "/2_views/*.view.lkml"
view: audit_logs {

extends: [_all_logs]




  # measure: access_denials {
  #   description: "Count of Access Grants being Denied by a Service"
  #   type: count
  #   filters: [activity_authorization_info.granted : "No"]
  #   drill_fields: [drill1*]
  # }


}
