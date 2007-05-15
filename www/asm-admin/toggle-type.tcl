ad_page_contract {
    Toggle type between 'survey' and 'test'
} {
    assessment_id:integer,notnull
}

permission::require_permission \
    -party_id [ad_conn user_id] \
    -object_id $assessment_id \
    -privilege "admin"

# assessment_id is really item_id. get the assessment_id
set revision_id [content::item::get_latest_revision -item_id $assessment_id]

db_dml toggle_type ""

ad_returnredirect [export_vars -base one-a {assessment_id}]