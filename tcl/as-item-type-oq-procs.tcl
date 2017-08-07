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
        set item_item_type_oq_id [content::item::new -parent_id $folder_id -content_type {as_item_type_oq} -name [as::item::generate_unique_name]]
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
    if {$default_value ne ""} {
	array set values $default_value
	set default $values(clob_answer)
    } else {
	array set type [util_memoize [list as::item_type_oq::data -type_id $type_id]]
	set default $type(default_value)
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
    {-package_id ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-11

    Process a Response to an Open Question Type
} {
    array set type [util_memoize [list as::item_type_oq::data -type_id $type_id]]


    if {[llength $type(keywords)] > 0} {
	set points 0
	foreach keyword $type(keywords) {
	    if {[regexp -nocase [string tolower $keyword] $response]} {
		incr points
	    }
	}
	set points [expr round($max_points * $points / [llength $type(keywords)])]
    } else {
	set points ""
    }

    set item_data_id [as::item_data::new -session_id $session_id -subject_id $subject_id -staff_id $staff_id -as_item_id $as_item_id -section_id $section_id -clob_answer $response -points $points -allow_overwrite_p $allow_overwrite_p -package_id $package_id]
    as::session_results::new -target_id $item_data_id -points $points
}

ad_proc -public as::item_type_oq::data {
    -type_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-04-08

    Return the Data of an Open Question Type
} {
    db_1row item_type_data {} -column_array type
    return [array get type]
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

ad_proc -private as::item_type_oq::add_to_assessment {
    -assessment_id
    -section_id
    -as_item_id
    -title
    -after
    {-feedback_text ""}
    {-reference_answer ""}
    {-keywords ""}
    {-default_value ""}
} {
    Add the open question (long answer/essay) item to an assessment. 
    This creates the  as_item_type_oq object and 
    associates the as_item_id
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
            || $item_type_info(object_type) ne "as_item_type_oq"} {
        set as_item_type_id [as::item_type_oq::new \
                                 -title $title \
                                 -default_value $default_value \
                                 -feedback_text $feedback_text \
                                 -reference_answer $reference_answer \
                                 -keywords $keywords]
	
        if {![info exists item_type_info(object_type)]} {
            # first item type mapped
            as::item_rels::new -item_rev_id $as_item_id -target_rev_id $as_item_type_id -type as_item_type_rel
        } else {
            # old item type existing
            set as_item_id [as::item::new_revision -as_item_id $as_item_id]
            db_dml update_item_type {}
        }
    } else {
        # old oq item type existing
        set as_item_id [as::item::new_revision -as_item_id $as_item_id]
        set as_item_type_id [as::item_type_oq::edit \
                                 -as_item_type_id $as_item_type_id \
                                 -title $title \
                                 -default_value $default_value \
                                 -feedback_text $feedback_text \
                                 -reference_answer $reference_answer \
                                 -keywords $keywords]
	
        as::item::update_item_type -item_type_id $as_item_type_id -as_item_id $as_item_id
    }
    as::item_display_ta::set_item_display_type \
        -as_item_id $as_item_id \
        -assessment_id $assessment_id \
        -section_id $section_id \
        -after $after

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
