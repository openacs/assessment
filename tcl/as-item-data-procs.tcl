ad_library {
    Item Data procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::item_data {}

ad_proc -public as::item_data::new {
    {-session_id:required}
    {-subject_id ""}
    {-staff_id ""}
    {-as_item_id:required}
    {-choice_answer ""}
    {-boolean_answer ""}
    {-clob_answer ""}
    {-numeric_answer ""}
    {-integer_answer ""}
    {-text_answer ""}
    {-timestamp_answer ""}
    {-content_answer ""}
    {-signed_data ""}
    {-points ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-09-12

    New as_item_data to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item_data in the CR (and as_item_data table) getting the revision_id (item_data_id)
    db_transaction {
        set item_data_id [content::item::new -parent_id $folder_id -content_type {as_item_data} -name "$as_item_id-$session_id" -title "$as_item_id-$session_id" ]
        set as_item_data_id [content::revision::new \
				 -item_id $item_data_id \
				 -content_type {as_item_data} \
				 -title "$as_item_id-$session_id" \
				 -attributes [list [list session_id $session_id] \
						  [list subject_id $subject_id] \
						  [list staff_id $staff_id] \
						  [list as_item_id $as_item_id] \
						  [list boolean_answer $boolean_answer] \
						  [list clob_answer $clob_answer] \
						  [list numeric_answer $numeric_answer] \
						  [list integer_answer $integer_answer] \
						  [list text_answer $text_answer] \
						  [list timestamp_answer $timestamp_answer] \
						  [list content_answer $content_answer] \
						  [list signed_data $signed_data] \
						  [list points $points] ] ]

	foreach choice_id $choice_answer {
	    db_dml save_choice_answer {}
	}
    }

    return $as_item_data_id
}

ad_proc -public as::item_data::get {
    {-subject_id:required}
    {-as_item_id:required}
    {-session_id ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-24

    Get as_item_data from the database
} {
    if {[empty_string_p $session_id]} {
	db_1row last_session {}
    }

    if {![empty_string_p $session_id] && [db_0or1row response {} -column_array response]} {
	# response found in session
	set item_data_id $response(item_data_id)
	set response(choice_answer) [db_list mc_response {}]
	return [array get response]
    } else {
	# no response given in that session
	return ""
    }
}
