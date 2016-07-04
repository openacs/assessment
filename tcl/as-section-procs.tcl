ad_library {
    Section procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::section {}

ad_proc -public as::section::new {
    {-name ""}
    {-title:required}
    {-description ""}
    {-instructions ""}
    {-feedback_text ""}
    {-max_time_to_complete ""}
    {-num_items ""}
    {-display_type_id ""}
    {-points ""}
    {-package_id ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-07-26

    New section to the database
} {
    if {$package_id eq "" \
            && [ad_conn -connected_p]} {
        set package_id [ad_conn package_id]
    }
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_section in the CR (and as_sections table) getting the revision_id (as_section_id)
    db_transaction {
	set section_item_id [db_nextval acs_object_id_seq]
	if { $name ne "" && [db_0or1row item_exists {}] } {
	    set name "$section_item_id: $name"
	} elseif {$name eq ""} {
	    set name "SEC_$section_item_id"
	}
	set section_item_id [content::item::new -item_id $section_item_id -parent_id $folder_id -content_type {as_sections} -name $name]

	set as_section_id [content::revision::new \
			       -item_id $section_item_id \
			       -content_type {as_sections} \
			       -title $title \
			       -description $description \
			       -attributes [list [list max_time_to_complete $max_time_to_complete] \
						[list num_items $num_items] \
						[list display_type_id $display_type_id] \
						[list points $points] ] ]
    }

    db_dml update_clobs {} -clobs [list $instructions $feedback_text]
    return $as_section_id
}

ad_proc -public as::section::edit {
    {-section_id:required}
    {-title:required}
    {-description ""}
    {-instructions ""}
    {-feedback_text ""}
    {-max_time_to_complete ""}
    {-num_items ""}
    {-display_type_id ""}
    {-points ""}
    {-assessment_id:required}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-10-26

    Edit section in the database
} {
    # edit as_section in the CR
    set section_item_id [db_string section_item_id {}]

    db_transaction {
	set new_section_id [content::revision::new \
				-item_id $section_item_id \
				-content_type {as_sections} \
				-title $title \
				-description $description \
				-attributes [list \
						 [list max_time_to_complete $max_time_to_complete] \
						 [list num_items $num_items] \
						 [list display_type_id $display_type_id] \
						 [list points $points] ] ]

        db_dml update_clobs {} -clobs [list $instructions $feedback_text]
	copy_items -section_id $section_id -new_section_id $new_section_id
	as::assessment::check::copy_checks -section_id $section_id -new_section_id $new_section_id -assessment_id $assessment_id
    }

    return $new_section_id
}

ad_proc -public as::section::new_revision {
    {-section_id:required}
    {-assessment_id:required}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-11-07

    Creates a new revision of a section with all items
} {
    # edit as_section in the CR
    db_transaction {
	db_1row section_data {}
	set new_section_id [content::revision::new \
				-item_id $section_item_id \
				-content_type {as_sections} \
				-title $title \
				-description $description \
				-attributes [list \
						 [list max_time_to_complete $max_time_to_complete] \
						 [list num_items $num_items] \
						 [list display_type_id $display_type_id] \
						 [list points $points] ] ]

	copy_items -section_id $section_id -new_section_id $new_section_id
	as::assessment::copy_categories -from_id $section_id -to_id $new_section_id
	as::assessment::check::copy_checks -section_id $section_id -new_section_id $new_section_id -assessment_id $assessment_id
    }

    db_dml update_clobs {} -clobs [list $instructions $feedback_text]
    return $new_section_id
}

ad_proc -public as::section::latest {
    -section_id:required
    -assessment_rev_id:required
    {-default ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-13

    Returns the latest revision of a section
} {
    if {![db_0or1row get_latest_section_id {}] && $default ne ""} {
	return $default
    }
    return $section_id
}

ad_proc -public as::section::copy {
    {-section_id:required}
    {-name ""}
    {-assessment_id:required}
    {-required_p "0"}
} {
    @param required_p Should the new section be required or not? (1|0)
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-11-07

    Copies a section with all items
} {
    # edit as_section in the CR
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    db_transaction {
	db_1row section_data {}
	append title "[_ assessment.copy_appendix]"

	set section_item_id [db_nextval acs_object_id_seq]

	if {$name eq ""} {
	    set name "SEC_$section_item_id"
	}
	set section_item_id [content::item::new -item_id $section_item_id -parent_id $folder_id -content_type {as_sections} -name $name]
	set new_section_id [content::revision::new \
				-item_id $section_item_id \
				-content_type {as_sections} \
				-title $title \
				-description $description \
				-attributes [list [list instructions $instructions] \
						 [list feedback_text $feedback_text] \
						 [list max_time_to_complete $max_time_to_complete] \
						 [list num_items $num_items] \
						 [list required_p $required_p] \
						 [list display_type_id $display_type_id] \
						 [list points $points] ] ]

	copy_items -section_id $section_id -new_section_id $new_section_id
	as::assessment::copy_categories -from_id $section_id -to_id $new_section_id
	as::assessment::check::copy_checks -section_id $section_id -new_section_id $new_section_id -assessment_id $assessment_id
    }

    return $new_section_id
}

ad_proc as::section::copy_items {
    {-section_id:required}
    {-new_section_id:required}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-11-07

    Copies all items from section_id to new_section_id
} {
    db_dml copy_items {}
}

ad_proc as::section::items {
    {-section_id:required}
    {-session_id:required}
    {-sort_order_type ""}
    {-num_items ""}
    {-random_p "t"}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-14

    Returns all items of a section in the correct order.
    may vary from session to session
} {
    set item_list [db_list_of_lists get_sorted_items {}]

    if {[llength $item_list] > 0} {
	return $item_list
    }

    # get all items of section
    set open_positions ""
    set max_pos 0
    db_foreach section_items {} {
	set section_items($as_item_id) [list $name $title $description $subtext $required_p $max_time_to_complete $content_rev_id $content_filename $content_type $as_item_type_id $validate_block $question_text]
	if {$fixed_position ne "" && $fixed_position != 0} {
	    set fixed_positions($fixed_position) $as_item_id
	    if {$max_pos < $fixed_position} {
		set max_pos $fixed_position
	    }
	} else {
	    lappend open_positions [list $as_item_id $title]
	}
    }
    if {$max_pos < [array size section_items]} {
	set max_pos [array size section_items]
    }

    if {$random_p == "f"} {
	set sort_order_type "order_by_entry"
    }

    # sort item positions that are not fixed

    switch -exact $sort_order_type {
	alphabetical {
	    set open_positions [lsort -dictionary -index 1 $open_positions]
	}
	randomized {
	    set open_positions [util::randomize_list $open_positions]
	}
    }

    # generate list of sorted items
    set sorted_items ""
    for {set position 1} {$position <= $max_pos} {incr position} {
	if {[info exists fixed_position($position)]} {
	    lappend sorted_items $fixed_position($position)
	    array unset fixed_position $position
	} elseif {[llength $open_positions] > 0} {
	    lappend sorted_items [lindex $open_positions 0 0]
	    set open_positions [lreplace $open_positions 0 0]
	}
    }
    # set negative fixed positions relative to the end of the item list
    if {[array exists fixed_position]} {
	foreach position [lsort -integer [array names fixed_positions]] {
	    if {$position < 0} {
		lappend sorted_items $fixed_positions($position)
	    }
	}
    }
    
    if {$num_items ne "" && [llength $sorted_items] > $num_items} {
    	set sorted_items [lreplace $sorted_items $num_items end]
    }

    # save item order
    set count 0
    foreach as_item_id $sorted_items {
	incr count
	db_dml save_order {}
    }

    # generate returned item-list
    set item_list ""
    foreach as_item_id $sorted_items {
	lappend item_list [concat $as_item_id $section_items($as_item_id)]
    }

    return $item_list
}

ad_proc -public as::section::calculate {
    -section_id:required
    -assessment_id:required
    -session_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-14

    Award points to this section if all items are filled out in this section
} {
    if {![db_0or1row max_section_points {}]} {
	return
    }

    db_1row sum_of_item_points {}

    # Make sure we have valid points for the calculation
    if {(![info exists section_max_points] || $section_max_points eq "")} {
	set section_max_points 0
    }

    if {(![info exists item_points] || $item_points eq "")} {
	set item_points 0
    }

    if {(![info exists item_max_points] || $item_max_points eq "") || $item_max_points==0} {
	set item_max_points 100
    }

    set section_points [expr {round($section_max_points * $item_points / $item_max_points)}]
    as::session_results::new -target_id $section_data_id -points $section_points
    db_dml update_section_points {}
}

ad_proc -public as::section::skip {
    -section_id:required
    -session_id:required
    -subject_id:required
    {-staff_id ""}
    {-package_id ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-22

    Skip section in a session and award 0 points
} {
    db_transaction {
	as::section_data::new -section_id $section_id -session_id $session_id -subject_id $subject_id -staff_id $staff_id -package_id $package_id
	db_dml set_zero_points {}
    }
}

ad_proc -public as::section::close {
    -section_id:required
    -assessment_id:required
    -session_id:required
    -subject_id:required
    {-staff_id ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-22

    Close started section in a session and award 0 points with empty answers
    to all remaining items
} {
    db_transaction {
	set item_list [db_list remaining_items {}]
	foreach as_item_id $item_list {
	    as::item_data::new -session_id $session_id -subject_id $subject_id -staff_id $staff_id -as_item_id $as_item_id -section_id $section_id -points 0 -allow_overwrite_p f
	}

	calculate -section_id $section_id -assessment_id $assessment_id -session_id $session_id
    }
}


ad_proc -private as::section::checks_list {
    -assessment_id:required
    -section_id:required
} {
    Return a list of checks for the section within the assessment
    
    Allow caching of the choice_orientation as it is unlikely to change.
} {
    
    return [as::section::checks_list_not_cached -assessment_id $assessment_id -section_id $section_id]
}

ad_proc -private as::section::checks_list_not_cached {
    -assessment_id:required
    -section_id:required
} {
    Return a list of checks for the section within the assessment
    
} {
    return [db_list_of_lists checks_related {} ] 
}

ad_proc -private as::section::update_section_in_assessment {
    -new_section_id
    -old_section_id
    -new_assessment_rev_id
} {
    Update links to section
} {
    db_dml update_section_in_assessment {}
}

ad_proc -public as::section::add_to_assessment {
    -assessment_rev_id
    -section_id
    {-max_time_to_complete ""}
    {-sort_order ""}
    {-points ""}
} {
    Link a section to an assessment
} {
    db_dml add {}
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
