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
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

    # Insert as_item_type_mc in the CR (and as_item_type_mc table) getting the revision_id (as_item_type_id)
    db_transaction {
        set item_item_type_mc_id [content::item::new -parent_id $folder_id -content_type {as_item_type_mc} -name [exec uuidgen] -title $title ]
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
    set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

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
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-10

    Render a Multiple Choice Type
} {
    db_1row item_type_data {}

    set defaults ""
    set display_choices [list]
    set correct_choices [list]
    set wrong_choices [list]
    set total 0
    db_foreach choices {} {
	incr total
	lappend display_choices [list $title $choice_id]
	if {$selected_p == "t"} {
	    lappend defaults $choice_id
	}
	if {$correct_answer_p == "t"} {
	    lappend correct_choices [list $title $choice_id]
	} else {
	    lappend wrong_choices [list $title $choice_id]
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
    
    return [list $defaults $display_choices]
}

ad_proc -public as::item_type_sa::process {
    -type_id:required
    -session_id:required
    -as_item_id:required
    -subject_id:required
    {-staff_id ""}
    {-response ""}
    {-max_points 0}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-11

    Process a Response to a Multiple Choice Type
} {
    db_1row item_type_data {}

    db_foreach check_choices {} {
	if {$correct_answer_p == "t"} {
	    set correct_choices($choice_id) $percent_score
	} else {
	    set wrong_choices($choice_id) $percent_score
	}
    }

    if {$increasing_p == "t"} {
	# if not all correct answers are given, award fraction of the points
	set percent 0
	if {[array exists correct_choices]} {
	    set wrong_p 0
	    foreach choice_id $response {
		if {[exists_and_not_null correct_choices($choice_id)]} {
		    incr percent $correct_choices($choice_id)
		}
		if {![info exists correct_choices($choice_id)] && $allow_negative_p != "t"} {
		    set wrong_p 1
		}
	    }
	    if {$wrong_p} {
		# reset points to 0 if wrong answers given and no negative allowed
		set percent 0
	    }
	    if {$allow_negative_p == "t" && [array exists wrong_choices]} {
		foreach choice_id $response {
		    if {[exists_and_not_null wrong_choices($choice_id)]} {
			incr percent $wrong_choices($choice_id)
		    }
		}
	    }
	}
    } else {
	# award 100% points if all correct answers are given
	if {[array exists correct_choices] && [lsort -integer $response] == [lsort -integer [array names correct_choices]]} {
	    set percent 100
	} else {
	    if {$allow_negative_p == "t"} {
		# wrong answers, calculate points by adding percentages for wrong answers
		set percent 0
		if {[array exists wrong_choices]} {
		    foreach choice_id $response {
			if {[exists_and_not_null wrong_choices($choice_id)]} {
			    incr percent $wrong_choices($choice_id)
			}
		    }
		}
	    } else {
		# wrong answers, no negative points allowed => 0 points
		set percent 0
	    }
	}
    }

    set points [expr round($max_points * percent / 100)]
    as::item_data::new -session_id $session_id -subject_id $subject_id -staff_id $staff_id -as_item_id $as_item_id -choice_answer $response -points $points
}
