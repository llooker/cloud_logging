include: "/1_raw_lookml/raw_lookml.lkml"
include:  "/2_views/*.view.lkml"
view: audit_logs {

extends: [_all_logs]

##### Protopayload Metadata
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


}
