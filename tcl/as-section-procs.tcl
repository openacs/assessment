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
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-07-26

    New section to the database
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_section in the CR (and as_sections table) getting the revision_id (as_section_id)
    db_transaction {
	set section_item_id [db_nextval acs_object_id_seq]
	if {[empty_string_p $name]} {
	    set name "SEC_$section_item_id"
	}
	set section_item_id [content::item::new -item_id $section_item_id -parent_id $folder_id -content_type {as_sections} -name $name -title $title -description $description ]

	set as_section_id [content::revision::new \
			       -item_id $section_item_id \
			       -content_type {as_sections} \
			       -title $title \
			       -description $description \
			       -attributes [list [list instructions $instructions] \
						[list feedback_text $feedback_text] \
						[list max_time_to_complete $max_time_to_complete] \
						[list num_items $num_items] \
						[list display_type_id $display_type_id] \
						[list points $points] ] ]
    }

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
				-attributes [list [list instructions $instructions] \
						 [list feedback_text $feedback_text] \
						 [list max_time_to_complete $max_time_to_complete] \
						 [list num_items $num_items] \
						 [list display_type_id $display_type_id] \
						 [list points $points] ] ]

	copy_items -section_id $section_id -new_section_id $new_section_id
    }

    return $new_section_id
}

ad_proc -public as::section::new_revision {
    {-section_id:required}
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
				-attributes [list [list instructions $instructions] \
						 [list feedback_text $feedback_text] \
						 [list max_time_to_complete $max_time_to_complete] \
						 [list num_items $num_items] \
						 [list display_type_id $display_type_id] \
						 [list points $points] ] ]

	copy_items -section_id $section_id -new_section_id $new_section_id
	as::assessment::copy_categories -from_id $section_id -to_id $new_section_id
    }

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
    if {![db_0or1row get_latest_section_id {}] && ![empty_string_p $default]} {
	return $default
    }
    return $section_id
}

ad_proc -public as::section::copy {
    {-section_id:required}
    {-name ""}
} {
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
	if {[empty_string_p $name]} {
	    set name "SEC_$section_item_id"
	}
	set section_item_id [content::item::new -item_id $section_item_id -parent_id $folder_id -content_type {as_sections} -name $name -title $title -description $description ]
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
	set section_items($as_item_id) [list $name $title $description $subtext $required_p $max_time_to_complete $content_rev_id $content_filename $content_type]
	if {![empty_string_p $fixed_position] && $fixed_position != "0"} {
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
	    lappend sorted_items [lindex [lindex $open_positions 0] 0]
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

    if {![empty_string_p $num_items]} {
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
