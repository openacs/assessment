ad_library {
    Session procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::session {}

ad_proc -public as::session::new {
    {-assessment_id:required}
    {-subject_id:required}
    {-staff_id ""}
    {-target_datetime ""}
    {-creation_datetime ""}
    {-first_mod_datetime ""}
    {-last_mod_datetime ""}
    {-completed_datetime ""}
    {-ip_address ""}
    {-percent_score ""}
    {-consent_timestamp ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-09-12

    New as_session to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

#    # Check to see if there's a session already to not submit another one
#    db_0or1row as_session_last {SELECT session_id AS as_session_id FROM as_sessionsx WHERE subject_id = :subject_id AND assessment_id = :assessment_id}
#    if { ! [info exists as_session_id] } {    
    # Insert as_session in the CR (and as_sessions table) getting the revision_id (session_id)
    set session_id [content::item::new -parent_id $folder_id -content_type {as_sessions} -name "$subject_id-$assessment_id-[ad_generate_random_string]" -title "$subject_id-$assessment_id-[ad_generate_random_string]" ]
    set as_session_id [content::revision::new -item_id $session_id -content_type {as_sessions} -title "$subject_id-$assessment_id-[ad_generate_random_string]" -attributes [list [list assessment_id $assessment_id] [list subject_id $subject_id] [list staff_id $staff_id] [list target_datetime $target_datetime] [list creation_datetime $creation_datetime] [list first_mod_datetime $first_mod_datetime] [list last_mod_datetime $last_mod_datetime] [list completed_datetime $completed_datetime] [list percent_score $percent_score] [list consent_timestamp $consent_timestamp] ] ]
#    }
    return $as_session_id
}
