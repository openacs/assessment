ad_page_contract {
    Publish or unpublish an assessment
} {
    assessment_id:integer,notnull
}

permission::require_permission \
    -party_id [ad_conn user_id] \
    -object_id $assessment_id \
    -privilege "admin"

db_dml toggle_publish ""

ad_returnredirect [export_vars -base one-a {assessment_id}]