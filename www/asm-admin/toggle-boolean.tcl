ad_page_contract {
    Toggle a boolean parameter
} {
    assessment_id:naturalnum,notnull
    param:sql_identifier,notnull
}

permission::require_permission \
    -party_id [ad_conn user_id] \
    -object_id $assessment_id \
    -privilege "admin"

# assessment_id is really item_id. get the assessment_id
set revision_id [content::item::get_latest_revision -item_id $assessment_id]

db_dml toggle_boolean ""

ad_returnredirect [export_vars -base one-a {assessment_id}]
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
