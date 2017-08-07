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
    {-section_id:required}
    {-choice_answer ""}
    {-boolean_answer ""}
    {-clob_answer ""}
    {-numeric_answer ""}
    {-integer_answer ""}
    {-text_answer ""}
    {-timestamp_answer ""}
    {-content_answer ""}
    {-signed_data ""}
    {-allow_overwrite_p t}
    {-points ""}
    {-package_id ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-09-12

    New as_item_data to the database
} {
    if {$package_id eq ""} {
	set package_id [ad_conn package_id]
    }
    set folder_id [as::assessment::folder_id -package_id $package_id]
    set name "$as_item_id-$section_id-$session_id"
    set new_p 1

    # Insert as_item_data in the CR (and as_item_data table) getting the revision_id (item_data_id)
    set transaction_successful_p 0

    while { ! $transaction_successful_p } {
	db_transaction {
	    if {[db_0or1row old_item_id {}]} {
		if {$allow_overwrite_p == "f"} {
		    set as_item_data_id $latest_revision
		    set transaction_successful_p 1
		    return
		}
		set new_p 0
	    } else {
		set item_data_id [content::item::new -parent_id $folder_id -content_type {as_item_data} -name $name]
	    }

	    set as_item_data_id [content::revision::new \
				     -item_id $item_data_id \
				     -content_type {as_item_data} \
				     -title $name \
				     -attributes [list [list session_id $session_id] \
						      [list subject_id $subject_id] \
						      [list staff_id $staff_id] \
						      [list as_item_id $as_item_id] \
						      [list section_id $section_id] \
						      [list boolean_answer $boolean_answer] \
						      [list numeric_answer $numeric_answer] \
						      [list integer_answer $integer_answer] \
						      [list text_answer $text_answer] \
						      [list timestamp_answer $timestamp_answer] \
						      [list content_answer $content_answer] \
						      [list signed_data $signed_data] \
						      [list points $points ] ] ]

		db_dml update_clobs "" -clobs [list $clob_answer]

	    foreach choice_id $choice_answer {
		db_dml save_choice_answer {}
	    }

	    if {$new_p} {
		db_dml insert_session_map {}
	    } else {
		db_dml update_session_map {}
	    }

	    set transaction_successful_p 1
	} on_error {
	    ns_log notice "as::item_data::new: Transaction Error: $errmsg\nFull info: $::errorInfo"
	}
    }

    return $as_item_data_id
}

ad_proc -public as::item_data::get {
    {-subject_id:required}
    {-as_item_id:required}
    {-session_id ""}
    {-section_id ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-24

    Get as_item_data from the database
} {
    if {$session_id eq ""} {
	set last_sessions [db_list_of_lists last_sessions {}]
	set session_id [lindex $last_sessions 0 0]
	set as_item_id [lindex $last_sessions 0 1]
    }

    if {$session_id ne "" && [db_0or1row response {} -column_array response]} {
	# response found in session
	set item_data_id $response(item_data_id)
	set response(choice_answer) [db_list mc_response {}]
	return [array get response]
    } else {
	# no response given in that session
	return ""
    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
