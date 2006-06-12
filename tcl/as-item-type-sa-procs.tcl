ad_library {
    Short answer item procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::item_type_sa {}

ad_proc -public as::item_type_sa::new {
    {-title ""}
    {-increasing_p ""}
    {-allow_negative_p ""}
    {-package_id ""}
} {
    @author Natalia Perez (nperper@it.uc3m.es)
    @creation-date 2004-09-29

    New Short Answer Answers item to the data database
} {
    if { ![exists_and_not_null package_id] } {
    	set package_id [ad_conn package_id]
    }
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item_type_sa in the CR (and as_item_type_sa table) getting the revision_id (as_item_type_id)
    db_transaction {
        set item_item_type_sa_id [content::item::new -parent_id $folder_id -content_type {as_item_type_sa} -name [as::item::generate_unique_name]]
        set as_item_type_sa_id [content::revision::new \
				-item_id $item_item_type_sa_id \
				-content_type {as_item_type_sa} \
				-title $title \
				-attributes [list [list increasing_p $increasing_p] \
						[list allow_negative_p $allow_negative_p] ] ]
    }

    return $as_item_type_sa_id
}

ad_proc -public as::item_type_sa::edit {
    -as_item_type_id:required
    {-title ""}
    {-increasing_p ""}
    {-allow_negative_p ""}    
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Edit Short Answer Answers item to the data database
} {
    # Update as_item_type_sa in the CR (and as_item_type_sa table) getting the revision_id (as_item_type_id)
    db_transaction {
	set type_item_id [db_string type_item_id {}]
        set new_item_type_id [content::revision::new \
				  -item_id $type_item_id \
				  -content_type {as_item_type_sa} \
				  -title $title \
				  -attributes [list [list increasing_p $increasing_p] \
						   [list allow_negative_p $allow_negative_p] ] ]
    }

    return $new_item_type_id
}

ad_proc -public as::item_type_sa::copy {
    -type_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Copy a Short Answer Type
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item_type_sa in the CR (and as_item_type_sa table) getting the revision_id (as_item_type_id)
    db_transaction {
	db_1row item_type_data {}

	set new_item_type_id [new -title $title \
				  -increasing_p $increasing_p \
				  -allow_negative_p $allow_negative_p]
    }

    return $new_item_type_id
}

ad_proc -public as::item_type_sa::render {
    -type_id:required
    -section_id:required
    -as_item_id:required
    {-default_value ""}
    {-session_id ""}
    {-show_feedback ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-10

    Render a Short Answer Type
} {
    if {![empty_string_p $default_value]} {
	array set values $default_value
	set default $values(text_answer)
    } else {
	set default ""
    }

    return [list $default ""]
}

ad_proc -public as::item_type_sa::process {
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

    Process a Response to a Short Answer Type
} {
    as::item_data::new -session_id $session_id -subject_id $subject_id -staff_id $staff_id -as_item_id $as_item_id -section_id $section_id -text_answer [lindex $response 0] -points "" -allow_overwrite_p $allow_overwrite_p
}

ad_proc -public as::item_type_sa::results {
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
	set results($session_id) $text_answer
    }

    if {[array exists results]} {
	return [array get results]
    } else {
	return
    }
}
