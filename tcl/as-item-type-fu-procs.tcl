ad_library {
    file upload item procs
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @creation-date 2005-06-24
}

namespace eval as::item_type_fu {}

ad_proc -public as::item_type_fu::new {
    {-title ""}
} {
    
    New File Upload Answers item to the data database
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]
    
    # Insert as_item_type_fu in the CR (and as_item_type_fu table) getting the revision_id (as_item_type_id)
    db_transaction {
        set item_item_type_fu_id [content::item::new -parent_id $folder_id -content_type {as_item_type_fu} -name [as::item::generate_unique_name]]
        set as_item_type_fu_id [content::revision::new    -item_id $item_item_type_fu_id  -content_type {as_item_type_fu} -title $title ]
	
    }
    return $as_item_type_fu_id
}

ad_proc -public as::item_type_fu::edit {
    -as_item_type_id:required
    {-title ""}
} {

    Edit File Upload Answers item to the data database
} {
    # Update as_item_type_fu in the CR (and as_item_type_fu table) getting the revision_id (as_item_type_id)
    db_transaction {
	set type_item_id [db_string type_item_id {}]
        set new_item_type_id [content::revision::new \
				  -item_id $type_item_id \
				  -content_type {as_item_type_fu} \
				  -title $title]
    }
    
    return $new_item_type_id
}

ad_proc -public as::item_type_fu::copy {
    -type_id:required
} {
    
    Copy a File Upload Type
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item_type_fu in the CR (and as_item_type_fu table) getting the revision_id (as_item_type_id)
    db_transaction {
	db_1row item_type_data {}

	set new_item_type_id [new -title $title ]
    }
    
    return $new_item_type_id
}

ad_proc -public as::item_type_fu::render {
    -type_id:required
    -section_id:required
    -as_item_id:required
    {-default_value ""}
    {-session_id ""}
    {-show_feedback ""}
} {

    Render a File Upload Type
} {
    if {$default_value ne ""} {
	array set values $default_value
	set default $values(text_answer)
    } else {
	set default ""
    }

    return $default
}

ad_proc -public as::item_type_fu::process {
    -type_id:required
    -session_id:required
    -as_item_id:required
    -section_id:required
    -subject_id:required
    {-staff_id ""}
    {-response "" }
    {-max_points 0}
    {-allow_overwrite_p t}
    {-package_id ""}
} {
    Process a Response to a File Upload Type
} {
    if {$package_id eq ""} {
	set package_id [ad_conn package_id]
    }
    set folder_id [as::assessment::folder_id -package_id $package_id]
    
    # Insert the file in the CR 
    db_transaction {
        set file_item_id [content::item::new -parent_id $folder_id -name "[lindex $response 0]$session_id"]
        set file_revision_id [content::revision::new  -item_id $file_item_id  -title [lindex $response 0] -tmp_filename [lindex $response 1]]
	set mime_type [cr_filename_to_mime_type -create [lindex $response 0]]
	set tmp_size [file size [lindex $response 1]]

        content::item::set_live_revision -revision_id $file_revision_id
	set as_item_data_id [as::item_data::new -session_id $session_id -subject_id $subject_id -staff_id $staff_id -as_item_id $as_item_id -section_id $section_id -text_answer [lindex $response 0] -points "" -allow_overwrite_p $allow_overwrite_p -package_id $package_id]
    }	
    db_dml update_item_data {}
    
}

ad_proc -public as::item_type_fu::results {
    -as_item_item_id:required
    -section_item_id:required
    -data_type:required
    -sessions:required
} {
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


ad_proc -private as::item_type_fu::add_to_assessment {
    -choices
    -correct_choices
    -assessment_id
    -section_id
    -as_item_id
    -title
    -after
    {-increasing_p "f"}
    {-allow_negative_p "f"}
} {
    Add the file upload item to an assessment. The creates the 
    as_item_type_fu object and associates the as_item_id
    with an assessment, or updates the assessment with the latest version

    @param assessment_id Assessment to attach question to
    @param section_id Section the question is in
    @param as_item_id Item object this multiple choice belongs to
    @param title Title of question/choice set for question library
    @param after Add this question after the queston number in the section

    @author Dave Bauer (dave@solutiongrove.com)
    @creation-date 2006-10-25
} {
	if {![as::item::get_item_type_info -as_item_id $as_item_id] \
                || $item_type_info(object_type) ne "as_item_type_fu"} {
	    set as_item_type_id [as::item_type_fu::new -title $title ]
	
	    if {![info exists object_type]} {
		# first item type mapped
		as::item_rels::new -item_rev_id $as_item_id -target_rev_id $as_item_type_id -type as_item_type_rel
	    } else {
		# old item type existing
		set as_item_id [as::item::new_revision -as_item_id $as_item_id]
		db_dml update_item_type {}
	    }
	} else {
	    # old fu item type existing
	    set as_item_id [as::item::new_revision -as_item_id $as_item_id]
	    set as_item_type_id [as::item_type_fu::edit \
				     -as_item_type_id $as_item_type_id \
				     -title $title \
				     -increasing_p $increasing_p \
				     -allow_negative_p $allow_negative_p]
	    
	    as::item::update_item_type \
                -item_type_id $as_item_type_id \
                -as_item_id $as_item_id
	}
    as::item_display_f::set_item_display_type \
            -assessment_id $assessment_id \
            -section_id $section_id \
            -as_item_id $as_item_id \
            -after $after
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
