ad_library {
    Item Data procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::item_data {}

ad_proc -public as::item_data::new {
    {-session_id:required}
    {-event_id ""}
    {-subject_id ""}
    {-staff_id ""}
    {-as_item_id:required}
    {-choice_id_answer ""}
    {-boolean_answer ""}
    {-numeric_answer ""}
    {-integer_answer ""}
    {-text_answer ""}
    {-timestamp_answer ""}
    {-content_answer ""}
    {-signed_data ""}
    {-percent_score ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-09-12

    New as_item_data to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item_data in the CR (and as_item_data table) getting the revision_id (item_data_id)
    db_transaction {
        set item_data_id [content::item::new -parent_id $folder_id -content_type {as_item_data} -name "$as_item_id-$session_id-$choice_id_answer" -title "$as_item_id-$session_id-$choice_id_answer" ]
        set as_item_data_id [content::revision::new \
				-item_id $item_data_id \
				-content_type {as_item_data} \
				-title "$as_item_id-$session_id-$choice_id_answer" \
				-attributes [list [list session_id $session_id] \
						[list event_id $event_id] \
						[list subject_id $subject_id] \
						[list staff_id $staff_id] \
						[list as_item_id $as_item_id] \
						[list choice_id_answer $choice_id_answer] \
						[list boolean_answer $boolean_answer] \
						[list numeric_answer $numeric_answer] \
						[list integer_answer $integer_answer] \
						[list text_answer $text_answer] \
						[list timestamp_answer $timestamp_answer] \
						[list content_answer $content_answer] \
						[list signed_data $signed_data] \
						[list percent_score $percent_score] ] ]
    }

    return $as_item_data_id
}
