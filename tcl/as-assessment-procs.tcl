ad_library {
    Assessment procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::assessment {}

ad_proc -public as::assessment::new {
    {-name:required}
    {-title:required}
    {-creator_id ""}
    {-description ""}
    {-instructions ""}
    {-mode ""}
    {-anonymous_p ""}
    {-secure_access_p ""}
    {-reuse_responses_p ""}
    {-show_item_name_p ""}
    {-entry_page ""}
    {-exit_page ""}
    {-consent_page ""}
    {-return_url ""}
    {-start_time ""}
    {-end_time ""}
    {-number_tries ""}
    {-wait_between_tries ""}
    {-time_for_response ""}
    {-show_feedback ""}
    {-section_navigation ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-07-26

    New assessment to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_assessment in the CR (and as_assessments table) getting the revision_id (as_assessment_id)
    set assessment_item_id [content::item::new -parent_id $folder_id -content_type {as_assessments} -name $name -title $title ]
    set as_assessment_id [content::revision::new -item_id $assessment_item_id -content_type {as_assessments} -title $title -description $description -attributes [list [list creator_id $creator_id] [list instructions $instructions] [list mode $mode] [list anonymous_p $anonymous_p] [list secure_access_p $secure_access_p] [list reuse_responses_p $reuse_responses_p] [list show_item_name_p $show_item_name_p] [list entry_page $entry_page] [list exit_page $exit_page] [list consent_page $consent_page] [list return_url $return_url] [list start_time $start_time] [list end_time $end_time] [list number_tries $number_tries] [list wait_between_tries $wait_between_tries] [list time_for_response $time_for_response] [list show_feedback $show_feedback] [list section_navigation $section_navigation] ] ]

    return $as_assessment_id
}
