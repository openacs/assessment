ad_library {
    Item answer procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::item_answer {}

ad_proc -public as::item_answer::new {
    {-answer_id:required}
    {-title:required}
    {-data_type ""}
    {-case_sensitive_p ""}
    {-percent_score ""}
    {-compare_by ""}
    {-regexp_text ""}
    {-allowed_answerbox_list ""}
} {
    @author Natalia Perez (eperez@it.uc3m.es)
    @creation-date 2004-09-29

    New item answer to the data database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item_answer in the CR (and as_item_sa_answers table) getting the revision_id (as_item_answer_id)
    db_transaction {
        set item_answer_id [content::item::new -parent_id $folder_id -content_type {as_item_choices} -name [as::item::generate_unique_name]]
        set as_item_answer_id [content::revision::new \
				-item_id $item_answer_id \
				-content_type {as_item_sa_answers} \
				-title $title \
				-attributes [list [list answer_id $answer_id ] \
						[list data_type $data_type ] \
						[list case_sensitive_p $case_sensitive_p ] \
						[list percent_score $percent_score] \
						[list compare_by $compare_by] \
						[list regexp_text $regexp_text] \
						[list allowed_answerbox_list $allowed_answerbox_list] ] ]
    # FIXME too much code repetition here
    # maybe there are more efficient ways to to it (maybe using hashes to pass the values between functions)
    }

    return $as_item_answer_id
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
