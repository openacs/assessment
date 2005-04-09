ad_library {
    Multiple choice item procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::item_type_mc {}


ad_proc -public as::item_type_mc::new {
    {-title ""}
    {-increasing_p ""}
    {-allow_negative_p ""}
    {-num_correct_answers ""}
    {-num_answers ""}
    {-choices ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-07-26

    New Multiple Choice item to the data database
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item_type_mc in the CR (and as_item_type_mc table) getting the revision_id (as_item_type_id)
    db_transaction {
        set item_item_type_mc_id [content::item::new -parent_id $folder_id -content_type {as_item_type_mc} -name [exec uuidgen]]
        set as_item_type_mc_id [content::revision::new \
				-item_id $item_item_type_mc_id \
				-content_type {as_item_type_mc} \
				-title $title \
				-attributes [list [list increasing_p $increasing_p] \
						[list allow_negative_p $allow_negative_p] \
						[list num_correct_answers $num_correct_answers] \
						[list num_answers $num_answers] ] ]
    }

    return $as_item_type_mc_id
}

ad_proc -public as::item_type_mc::edit {
    -as_item_type_id:required
    {-title ""}
    {-increasing_p ""}
    {-allow_negative_p ""}
    {-num_correct_answers ""}
    {-num_answers ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Edit Multiple Choice item to the data database
} {
    # Update as_item_type_mc in the CR (and as_item_type_mc table) getting the revision_id (as_item_type_id)
    db_transaction {
	set type_item_id [db_string type_item_id {}]
        set new_item_type_id [content::revision::new \
				  -item_id $type_item_id \
				  -content_type {as_item_type_mc} \
				  -title $title \
				  -attributes [list [list increasing_p $increasing_p] \
						   [list allow_negative_p $allow_negative_p] \
						   [list num_correct_answers $num_correct_answers] \
						   [list num_answers $num_answers] ] ]
    }

    return $new_item_type_id
}

ad_proc -public as::item_type_mc::new_revision {
    -as_item_type_id:required
    {-with_choices_p "t"}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Create new revision of Multiple Choice item in the data database
} {
    # Update as_item_type_mc in the CR (and as_item_type_mc table) getting the revision_id (as_item_type_id)
    db_transaction {
	db_1row item_type_data {}
        set new_item_type_id [content::revision::new \
				  -item_id $type_item_id \
				  -content_type {as_item_type_mc} \
				  -title $title \
				  -attributes [list [list increasing_p $increasing_p] \
						   [list allow_negative_p $allow_negative_p] \
						   [list num_correct_answers $num_correct_answers] \
						   [list num_answers $num_answers] ] ]

	if {$with_choices_p == "t"} {
	    set choices [db_list get_choices {}]
	    foreach choice_id $choices {
		set new_choice_id [as::item_choice::new_revision -choice_id $choice_id -mc_id $new_item_type_id]
	    }
	}
    }

    return $new_item_type_id
}

ad_proc -public as::item_type_mc::copy {
    -type_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Copy a Multiple Choice Type
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item_type_mc in the CR (and as_item_type_mc table) getting the revision_id (as_item_type_id)
    db_transaction {
	db_1row item_type_data {}

	set new_item_type_id [new -title $title \
				  -increasing_p $increasing_p \
				  -allow_negative_p $allow_negative_p \
				  -num_correct_answers $num_correct_answers \
				  -num_answers $num_answers]

	set choices [db_list get_choices {}]
	foreach choice_id $choices {
	    set new_choice_id [as::item_choice::copy -choice_id $choice_id -mc_id $new_item_type_id]
	}
    }

    return $new_item_type_id
}

ad_proc -public as::item_type_mc::render {
    -type_id:required
    -section_id:required
    -as_item_id:required
    {-default_value ""}
    {-session_id ""}
    {-show_feedback ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-10

    Render a Multiple Choice Type
} {
    set defaults ""
    if {![empty_string_p $default_value]} {
	array set values $default_value
	set defaults $values(choice_answer)
    }

    if {![empty_string_p $session_id]} {
	if {[empty_string_p $show_feedback] || $show_feedback == "none"} {
	    set choice_list ""
	    db_foreach get_sorted_choices {} {
		set title [as::assessment::display_content -content_id $content_rev_id -filename $content_filename -content_type $content_type -title $title]
		lappend choice_list [list $title $choice_id]
	    }
	} else {
	    # incorrect correct
	    set choice_list ""
	    db_foreach get_sorted_choices_with_feedback {} {
		set title [as::assessment::display_content -content_id $content_rev_id -filename $content_filename -content_type $content_type -title $title]
		set pos [lsearch -exact -integer $defaults $choice_id]
		if {$pos>-1 && $correct_answer_p == "t" && $show_feedback != "incorrect"} {
		    lappend choice_list [list "$title  <i>$feedback_text</i>" $choice_id]
		} elseif {$pos>-1 && $correct_answer_p == "f" && $show_feedback != "correct"} {
		    lappend choice_list [list "$title <img src=/resources/assessment/wrong.gif> <i>$feedback_text</i>" $choice_id]
		} else {		    
		    if {$correct_answer_p == "t" && $show_feedback != "incorrect" && $show_feedback != "correct"} {		    
		        lappend choice_list [list "$title <img src=/resources/assessment/wrong.gif>" $choice_id]			
		    } else {
		        lappend choice_list [list $title $choice_id]
		    }	
		}
	    }
	}
	
	if {[llength $choice_list] > 0} {
	    return [list $defaults $choice_list]
	}
    }

    db_1row item_type_data {}

    set display_choices [list]
    set correct_choices [list]
    set wrong_choices [list]
    set total 0
    db_foreach choices {} {
	incr total
	set title [as::assessment::display_content -content_id $content_rev_id -filename $content_filename -content_type $content_type -title $title]
	lappend display_choices [list $title $choice_id]
	if {$selected_p == "t"} {
	    lappend defaults $choice_id
	}
	if {![empty_string_p $fixed_position]} {
	    set fixed_pos($fixed_position) [list $title $choice_id]
	    if {![empty_string_p $num_answers]} {
		incr num_answers -1
	    }
	    if {$correct_answer_p == "t" && ![empty_string_p $num_correct_answers]} {
		incr num_correct_answers -1
	    }
	} else {
	    if {$correct_answer_p == "t"} {
		lappend correct_choices [list $title $choice_id]
	    } else {
		lappend wrong_choices [list $title $choice_id]
	    }
	}
    }

    if {[array exists fixed_pos]} {
	if {[empty_string_p $num_answers]} {
	    set num_answers [expr [llength $correct_choices] + [llength $wrong_choices]]
	}
	if {[empty_string_p $num_correct_answers]} {
	    set num_correct_answers [llength $correct_choices]
	}
    }

    if {![empty_string_p $num_answers] && $num_answers < $total} {
	# display fewer choices, select random
	set correct_choices [util::randomize_list $correct_choices]
	set wrong_choices [util::randomize_list $wrong_choices]

	if {![empty_string_p $num_correct_answers] && $num_correct_answers > 0 && $num_correct_answers < [llength $correct_choices]} {
	    # display fewer correct answers than there are
	    set display_choices [lrange $correct_choices 1 $num_correct_answers]
	} else {
	    # display all correct answers
	    set display_choices $correct_choices
	}

	# now fill up with wrong answers
	set display_choices [concat $display_choices [lrange $wrong_choices 0 [expr $num_answers - [llength $display_choices] -1]]]
	set display_choices [util::randomize_list $display_choices]
    }
    
    # now add fixed positions in result list
    if {[array exists fixed_pos]} {
	set max_pos [expr $num_answers + [array size fixed_pos]]
	set open_positions $display_choices
	set display_choices [list]

	for {set position 1} {$position <= $max_pos} {incr position} {
	    if {[info exists fixed_pos($position)]} {
		lappend display_choices $fixed_pos($position)
		array unset fixed_pos $position
	    } elseif {[llength $open_positions] > 0} {
		lappend display_choices [lindex $open_positions 0]
		set open_positions [lreplace $open_positions 0 0]
	    }
	}
	# set negative fixed positions relative to the end of the choice list
	if {[array exists fixed_pos]} {
	    foreach position [lsort -integer [array names fixed_pos]] {
		if {$position < 0} {
		    lappend display_choices $fixed_pos($position)
		}
	    }
	}
    }

    # save choice order
    if {![empty_string_p $session_id]} {
	set count 0
	foreach one_choice $display_choices {
	    util_unlist $one_choice title choice_id
	    incr count
	    db_dml save_order {}
	}
    }

    return [list $defaults $display_choices]
}

ad_proc -public as::item_type_mc::process {
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

    Process a Response to a Multiple Choice Type
} {
    array set type [util_memoize [list as::item_type_mc::data -type_id $type_id]]
    array set choices $type(choices)
    if {[info exists type(correct_choices)]} {
	array set correct_choices $type(correct_choices)
    }

    if {$type(increasing_p) == "t"} {
	# if not all correct answers are given, award fraction of the points
	set percent 0
	foreach choice_id $response {
	    incr percent $choices($choice_id)
	}
    } else {
	# award 100% points if and only if all correct answers are given
	if {[array exists correct_choices] && [lsort -integer $response] == [lsort -integer [array names correct_choices]]} {
	    set percent 100
	} else {
	    set percent 0
	}
    }

    if {$type(allow_negative_p) == "f" && $percent < 0} {
	# don't allow negative percentage
	set percent 0
    }
	
    set points [expr round($max_points * $percent / 100)]

    set item_data_id [as::item_data::new -session_id $session_id -subject_id $subject_id -staff_id $staff_id -as_item_id $as_item_id -section_id $section_id -choice_answer $response -points $points -allow_overwrite_p $allow_overwrite_p]
    as::session_results::new -target_id $item_data_id -points $points
}

ad_proc -public as::item_type_mc::data {
    -type_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-04-08

    Return the Data of a Multiple Choice Type
} {
    db_1row item_type_data {} -column_array type

    db_foreach check_choices {} {
	if {$correct_answer_p == "t"} {
	    set correct_choices($choice_id) $percent_score
	}
	set choices($choice_id) $percent_score
    }

    set type(choices) [array get choices]
    if {[array exists correct_choices]} {
	set type(correct_choices) [array get correct_choices]
    }

    return [array get type]
}

ad_proc -public as::item_type_mc::results {
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
	if {[empty_string_p $text_value]} {
	    lappend results($session_id) [as::assessment::quote_export -text $title]
	} else {
	    lappend results($session_id) [as::assessment::quote_export -text $text_value]
	}
    }

    foreach session_id [array names results] {
	set results($session_id) [join $results($session_id) ","]
    }

    if {[array exists results]} {
	return [array get results]
    } else {
	return
    }
}
