ad_library {
    Open Question item procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::item_type_oq {}

ad_proc -public as::item_type_oq::new {
    {-title ""}
    {-default_value ""}
    {-feedback_text ""}
    {-reference_answer ""}
    {-keywords ""}
} {
    @author Natalia Perez (nperper@it.uc3m.es)
    @creation-date 2004-09-29

    New Open Question item to the data database
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item_type_oq in the CR (and as_item_type_oq table) getting the revision_id (as_item_type_id)
    db_transaction {
        set item_item_type_oq_id [content::item::new -parent_id $folder_id -content_type {as_item_type_oq} -name [exec uuidgen]]
        set as_item_type_oq_id [content::revision::new \
				    -item_id $item_item_type_oq_id \
				    -content_type {as_item_type_oq} \
				    -title $title \
				    -attributes [list [list default_value $default_value] \
						     [list feedback_text $feedback_text] \
						     [list reference_answer $reference_answer] \
						     [list keywords $keywords] ] ]
    }

    return $as_item_type_oq_id
}

ad_proc -public as::item_type_oq::edit {
    -as_item_type_id:required
    {-title ""}
    {-default_value ""}
    {-feedback_text ""}    
    {-reference_answer ""}
    {-keywords ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Edit Open Question item to the data database
} {
    # Update as_item_type_oq in the CR (and as_item_type_oq table) getting the revision_id (as_item_type_id)
    db_transaction {
	set type_item_id [db_string type_item_id {}]
        set new_item_type_id [content::revision::new \
				  -item_id $type_item_id \
				  -content_type {as_item_type_oq} \
				  -title $title \
				  -attributes [list [list default_value $default_value] \
						   [list feedback_text $feedback_text] \
						   [list reference_answer $reference_answer] \
						   [list keywords $keywords] ] ]
    }

    return $new_item_type_id
}

ad_proc -public as::item_type_oq::copy {
    -type_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Copy an Open Question Type
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item_type_oq in the CR (and as_item_type_oq table) getting the revision_id (as_item_type_id)
    db_transaction {
	db_1row item_type_data {}

	set new_item_type_id [new -title $title \
				  -default_value $default_value \
				  -feedback_text $feedback_text \
				  -reference_answer $reference_answer \
				  -keywords $keywords]
    }

    return $new_item_type_id
}

ad_proc -public as::item_type_oq::render {
    -type_id:required
    -section_id:required
    -as_item_id:required
    {-default_value ""}
    {-session_id ""}
    {-show_feedback ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-10

    Render an Open Question Type
} {
    if {![empty_string_p $default_value]} {
	array set values $default_value
	set default $values(clob_answer)
    } else {
	db_1row item_type_data {}
    }

    return [list $default ""]
}

ad_proc -public as::item_type_oq::process {
    -type_id:required
    -session_id:required
    -as_item_id:required
    -section_id:required
    -subject_id:required
    {-staff_id ""}
    {-response ""}
    {-max_points 0}
    {-allow_overwrite_p t}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-11

    Process a Response to an Open Question Type
} {
    db_1row item_type_data {}
    set response [lindex $response 0]

    if {[llength $keywords] > 0} {
	set points 0
	foreach keyword $keywords {
	    if {[regexp $keyword $response]} {
		incr points
	    }
	}
	set points [expr round($max_points * $points / [llength $keywords])]
    } else {
	set points ""
    }

    as::item_data::new -session_id $session_id -subject_id $subject_id -staff_id $staff_id -as_item_id $as_item_id -section_id $section_id -clob_answer $response -points $points -allow_overwrite_p $allow_overwrite_p
}

ad_proc -public as::item_type_oq::results {
    -as_item_item_id:required
    -section_item_id:required
    -data_type:required
    -sessions:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-26

    Return the results of a given item in a given list of sessions as an array
} {
    db_foreach get_results {} {
	set results($session_id) $clob_answer
    }

    if {[array exists results]} {
	return [array get results]
    } else {
	return
    }
}
