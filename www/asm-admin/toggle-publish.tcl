ad_page_contract {
    Publish or unpublish an assessment
} {
    assessment_id:integer,notnull
    {return_url ""}
}

permission::require_permission \
    -party_id [ad_conn user_id] \
    -object_id $assessment_id \
    -privilege "admin"

# find current publish_status
set publish_status [db_string get_publish_status ""]
if { $publish_status ne "live" } {
    set publish_status ""
}

# returns list of empty sections
set empty_sections [db_list count_questions ""]

if { ($empty_sections eq "") || ($publish_status eq "live") } {
    # if no empty sections, or if we're un-publishing, then proceed
    db_dml toggle_publish ""
    set message ""
} else {
    set message [_ assessment.Publish_failed_Following_section_s_have_no_questions]
}

if {$return_url eq ""} {
    set return_url [export_vars -base one-a {assessment_id}]
}
ad_returnredirect -message $message $return_url
