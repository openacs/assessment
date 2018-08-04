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
    {-allow_other_p "f"}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-07-26

    New Multiple Choice item to the data database
} {
    set package_id [ad_conn package_id]
    set folder_id [as::assessment::folder_id -package_id $package_id]

    # Insert as_item_type_mc in the CR (and as_item_type_mc table) getting the revision_id (as_item_type_id)
    db_transaction {
        set item_item_type_mc_id [content::item::new -parent_id $folder_id -content_type {as_item_type_mc} -name [as::item::generate_unique_name]]
        set as_item_type_mc_id [content::revision::new \
				-item_id $item_item_type_mc_id \
				-content_type {as_item_type_mc} \
				-title $title \
				-attributes [list [list increasing_p $increasing_p] \
                                                 [list allow_negative_p $allow_negative_p] \
                                                 [list num_correct_answers $num_correct_answers] \
                                                 [list num_answers $num_answers] \
                                                 [list allow_other_p $allow_other_p] ] ]
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
    {-allow_other_p "f"}
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
						   [list num_answers $num_answers] \
                                                   [list allow_other_p $allow_other_p] ] ]
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
						   [list num_answers $num_answers] \
                                                   [list allow_other_p $allow_other_p] ] ]

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
    {-copy_correct_answer_p "t"}
    -new_title
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
        if {[info exists new_title]} {
	    set title $new_title
	}
	if {[string is false $copy_correct_answer_p]} {
	    set num_correct_answers 0
	}
	set new_item_type_id [new -title $title \
				  -increasing_p $increasing_p \
				  -allow_negative_p $allow_negative_p \
				  -num_correct_answers $num_correct_answers \
				  -num_answers $num_answers \
                                  -allow_other_p $allow_other_p]

	set choices [db_list get_choices {}]
	foreach choice_id $choices {
	    set new_choice_id [as::item_choice::copy -choice_id $choice_id -mc_id $new_item_type_id -copy_correct_answer_p $copy_correct_answer_p]
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
    set allow_other_p [as::item_type_mc::allow_other_p -item_type_id $type_id]
    
    set defaults ""
    if {$default_value ne ""} {
        array set values $default_value
	set defaults $values(choice_answer)
        if {$allow_other_p} {
            set defaults [list $defaults $values(clob_answer)]
        }
    }
    if {$session_id ne ""} {
	if {$show_feedback eq "" || $show_feedback eq "none"} {
	    set choice_list ""
	    db_foreach get_sorted_choices {} {
		if {$content_value ne ""} {
		    db_1row get_content_value ""
		    set title [as::assessment::display_content -content_id $content_rev_id -filename $content_filename -content_type $content_type -title $title]
		}
		lappend choice_list [list $title $choice_id]
	    }
	} else {
	    # incorrect correct
	    set choice_list ""

	    db_foreach get_sorted_choices_with_feedback {} {
		if {$content_value ne ""} {
		    db_1row get_content_value ""
		    set title [as::assessment::display_content -content_id $content_rev_id -filename $content_filename -content_type $content_type -title $title]
		}
		set pos [lsearch -exact $defaults $choice_id]
		if {$pos>-1 && $correct_answer_p == "t" && $show_feedback ne "incorrect"} {
		    lappend choice_list [list "$title <img src=/resources/assessment/correct.gif> <i>$feedback_text</i>" $choice_id]
		} elseif {$pos>-1 && $correct_answer_p == "f" && $show_feedback ne "correct"} {
		    lappend choice_list [list "$title <img src=/resources/assessment/wrong.gif> <i>$feedback_text</i>" $choice_id]
		} else {		    
		    if {[llength $defaults] && $correct_answer_p == "t" && $show_feedback ne "incorrect" && $show_feedback ne "correct"} {		    
		        lappend choice_list [list "$title <img src=/resources/assessment/correct.gif>" $choice_id]			
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
	if {$content_value ne ""} {
	    db_1row get_content_value ""
	    set title [as::assessment::display_content -content_id $content_rev_id -filename $content_filename -content_type $content_type -title $title]
	}
	if {$show_feedback ne "" && $show_feedback ne "none"} {
		set pos [lsearch -exact $defaults $choice_id]
	    if {$pos > -1 && $correct_answer_p == "t" && $show_feedback ne "incorrect"} {
		lappend display_choices [list "$title <img src=/resources/assessment/correct.gif> <i>$feedback_text</i>" $choice_id]
	    } elseif {$pos>-1 && $correct_answer_p == "f" && $show_feedback ne "correct"} {
		lappend display_choices [list "$title <img src=/resources/assessment/wrong.gif> <i>$feedback_text</i>" $choice_id]
	    } else {		    
		if {$correct_answer_p == "t" && $show_feedback ne "incorrect" && $show_feedback ne "correct"} {		    
		    lappend display_choices [list "$title <img src=/resources/assessment/correct.gif>" $choice_id]			
		} else {
		    lappend display_choices [list $title $choice_id]
		}	
	    }
	} else {
	    lappend display_choices [list $title $choice_id]
	}
    
#	lappend display_choices [list $title $choice_id]
	if {$selected_p == "t"} {
	    lappend defaults $choice_id
	}
	if {$fixed_position ne ""} {
	    set fixed_pos($fixed_position) [list $title $choice_id]
	    if {$num_answers ne ""} {
		incr num_answers -1
	    }
	    if {$correct_answer_p == "t" && $num_correct_answers ne ""} {
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
	if {$num_answers eq ""} {
	    set num_answers [expr {[llength $correct_choices] + [llength $wrong_choices]}]
	}
	if {$num_correct_answers eq ""} {
	    set num_correct_answers [llength $correct_choices]
	}
    }

    if {$num_answers ne "" && $num_answers < $total} {
	# display fewer choices, select random
	set correct_choices [util::randomize_list $correct_choices]
	set wrong_choices [util::randomize_list $wrong_choices]

	if {$num_correct_answers ne "" && $num_correct_answers > 0 && $num_correct_answers < [llength $correct_choices]} {
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
	set max_pos [expr {$num_answers + [array size fixed_pos]}]
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
    if {$session_id ne ""} {
	set count 0
	foreach one_choice $display_choices {
	    lassign $one_choice title choice_id
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
    {-package_id ""}
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
	set count_correct 0
	if {[array exists correct_choices] && [lsort -integer $response] == [lsort -integer [array names correct_choices]]} {
	    set points $max_points
	} elseif {[array size correct_choices] > 0} {
	    # FIXME !! create setting for partial credit or use existing one
	    foreach elm $response {
		if {[lsearch [array names correct_choices] $elm] > -1} {
		    incr count_correct
		}
	    }
	    set points [expr {$count_correct / (0.0 + [array size correct_choices]) * $max_points}]
	} else {
	    set points 0
	}
    }

    if {$type(allow_negative_p) == "f" && $points < 0} {
	# don't allow negative percentage
	set points 0
    }

    if {$type(allow_other_p)} {
        # this is a pain we need display type to get the value
        set widget [as::item_type_mc::form_widget -type_id $type_id]
        set response_value [template::util::${widget}_text::get_property ${widget}_value $response]
        set response_text [template::util::${widget}_text::get_property text_value $response]
        set item_data_id [as::item_data::new -session_id $session_id -subject_id $subject_id -staff_id $staff_id -as_item_id $as_item_id -section_id $section_id -choice_answer $response_value -points $points -allow_overwrite_p $allow_overwrite_p -package_id $package_id -clob_answer $response_text]
    } else {
        set item_data_id [as::item_data::new -session_id $session_id -subject_id $subject_id -staff_id $staff_id -as_item_id $as_item_id -section_id $section_id -choice_answer $response -points $points -allow_overwrite_p $allow_overwrite_p -package_id $package_id]
    }
    as::session_results::new -target_id $item_data_id -points $points -package_id $package_id
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
    {-data_type ""}
    -sessions:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-26

    Return the results of a given item in a given list of sessions as an array
} {
    
    db_foreach get_results {} {
	if {$text_value eq ""} {
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

ad_proc -private as::item_type_mc::add_choices_to_form {
    -form_id 
    -num_choices
    -choice_array_name
    -correct_choice_array_name
} {
    Add form elements for multiple choice question choices

    @param form_id Form builder form_id of the form to add the elements to. Error if form does not exist
    @param num_choices Number of choice form elements to add
    @param choice_array_name Name of array in callers scope to look for existing choices
    @param correct_choice_array_name Name of array in the caller's scope to check for correct choices

    @return empty string

    @author Dave Bauer (dave@solutiongrove.com)
    @creation-date 2006-10-25

} {
    upvar choice $choice_array_name
    upvar correct $correct_choice_array_name

    set correct_options [list [list "[_ assessment.yes]" t]]

    for {set i 1} {$i <= $num_choices} {incr i} {
        if {[info exists choice($i)]} {
            ad_form -extend -name $form_id  -form [list [list choice.$i:text,optional,nospell {label "[_ assessment.Choice] $i"} {html {style {width: 80%;} maxlength 1000}} {value "$choice($i)"}]]
        } else {
            ad_form -extend -name $form_id -form [list [list choice.$i:text,optional,nospell {label "[_ assessment.Choice] $i"} {html {style {width: 80%;} maxlength 1000}}]]
        }
        
        if {[info exists correct($i)]} {
            ad_form -extend -name $form_id -form [list [list correct.$i:text(checkbox),optional {label "[_ assessment.Correct_Answer_Choice] $i"} {options $correct_options} {values t }]]
        } else {
            ad_form -extend -name $form_id -form [list [list correct.$i:text(checkbox),optional {label "[_ assessment.Correct_Answer_Choice] $i"} {options $correct_options}]]
        }
    }
}

ad_proc -private as::item_type_mc::add_to_assessment {
    -choices
    -correct_choices
    -assessment_id
    -section_id
    -as_item_id
    -title
    -after
    {-display_type "rb"}
    {-increasing_p "f"}
    {-allow_negative_p "f"}
    {-allow_other_p "f"}
} {
    Add the multiple choice item to an assessment. The creates the 
    as_item_type_mc object and all the choices and associates the as_item_id
    with an assessment, or updates the assessment with the latest version

    @param choices List in array get format of choice number/choice
    @param correct_choices List in array get format of choice number/t. Elements appear in this list if choice number is one of the correct choices
    @param assessment_id Assessment to attach question to
    @param section_id Section the question is in
    @param as_item_id Item object this multiple choice belongs to
    @param title Title of question/choice set for question library
    @param after Add this question after the queston number in the section

    @author Dave Bauer (dave@solutiongrove.com)
    @creation-date 2006-10-25
} {
    array set choice $choices
    array set correct $correct_choices

    set num_answers 0
    set num_correct_answers 0

    foreach c [array names choice] {
        if {$choice($c) ne ""} {
            incr num_answers
        }
    }
    foreach c [array names correct] {
        if {$correct($c) == "t"} {
            incr num_correct_answers 
        }
    }
    
    if {![as::item::get_item_type_info -as_item_id $as_item_id] \
            || $item_type_info(object_type) ne "as_item_type_mc"} {
	# always set mc title to empty on new mc question
	# we ask for a title for the mc answer set separately if
	# required
        set mc_id [as::item_type_mc::new \
                       -title $title \
                       -increasing_p $increasing_p \
                       -allow_negative_p $allow_negative_p \
                       -num_correct_answers $num_correct_answers \
                       -num_answers $num_answers \
                       -allow_other_p $allow_other_p]
        
        if {![info exists item_type_info(object_type)]} {
            # first item type mapped
            as::item_rels::new -item_rev_id $as_item_id -target_rev_id $mc_id -type as_item_type_rel
        } else {
            # old item type existing
            set as_item_id [as::item::new_revision -as_item_id $as_item_id]
            db_dml update_item_type {}
        }
    } else {
        # old mc item type existing
        set mc_id [as::item_type_mc::edit \
                       -as_item_type_id $as_item_type_id \
                       -title $title \
                       -increasing_p $increasing_p \
                       -allow_negative_p $allow_negative_p \
                       -num_correct_answers $num_correct_answers \
                       -num_answers $num_answers]
        
        as::item::update_item_type -item_type_id $mc_id -as_item_id $as_item_id
    }

    set count 0
    foreach i [lsort -integer [array names choice]] {
        if {$choice($i) ne ""} {
            incr count
            set choice_id [as::item_choice::new -mc_id $mc_id \
                               -title $choice($i) \
                               -numeric_value "" \
                               -text_value "" \
                               -content_value "" \
                               -feedback_text "" \
                               -selected_p "" \
                               -correct_answer_p [ad_decode [info exists correct($i)] 0 f t] \
                               -sort_order $count \
                               -percent_score ""]

        }
    }
    #FIXME add a select one/select all that apply option
    as::item_display_${display_type}::set_item_display_type \
        -assessment_id $assessment_id \
        -section_id $section_id \
        -as_item_id $as_item_id \
        -after $after

    return $mc_id
}

ad_proc -public as::item_type_mc::existing_choices {
    as_item_id
} {
    Get choices to fill edit form
} {
    return [db_list_of_lists existing_choices {}]
}

ad_proc -private as::item_type_mc::add_existing_choices_to_edit_form {
    -form_id 
    -existing_choices
    -choice_array_name
    -correct_choice_array_name
} {
    Add form elements for multiple choice question choices

    @param form_id Form builder form_id of the form to add the elements to. Error if form does not exist
    @param num_choices Number of choice form elements to add
    @param choice_array_name Name of array in callers scope to look for existing choices
    @param correct_choice_array_name Name of array in the caller's scope to check for correct choices

    @return empty string

    @author Dave Bauer (dave@solutiongrove.com)
    @creation-date 2006-10-25

} {
    upvar choice $choice_array_name
    upvar correct $correct_choice_array_name

    set correct_options [list [list "[_ assessment.yes]" t]]
    set i 0
    foreach c $existing_choices {
        lassign $c value id correct_p
        if {![string match "__new*" $id]} {
            if {$i > 0} {
                ad_form -extend -name $form_id -form \
                    [list \
                         [list move_up.$id:text(submit) {label "Move Up"}]]
            }
            if {$i < [llength $existing_choices]} {
                ad_form -extend -name $form_id -form \
                    [list \
                         [list move_down.$id:text(submit) {label "Move Down"}]]
            }
            ad_form -extend -name $form_id -form \
                [list \
                     [list delete.$id:text(submit) {label "Delete"}]]
        }
         ad_form -extend -name $form_id  -form [list [list choice.$id:text,optional,nospell {label "[_ assessment.Choice] $id"} {html {style {width: 60%;} maxlength 1000}} {value "$value"} ]]

        if {[info exists correct($id)]} {
            ad_form -extend -name $form_id -form [list [list correct.$id:text(checkbox),optional {label "[_ assessment.Correct_Answer_Choice] $id"} {options $correct_options} {values t} ]]
        } else {
            ad_form -extend -name $form_id -form [list [list correct.$id:text(checkbox),optional {label "[_ assessment.Correct_Answer_Choice] $id"} {options $correct_options} ]]
        }
        incr i
    }
}

ad_proc -private as::item_type_mc::choices_swap {
    -assessment_id
    -section_id
    -as_item_id
    -mc_id
    -sort_order
    -direction
} {
    Switch order of two choices
} {

if { $direction=="up" } {
     set next_sort_order [expr { $sort_order - 1 }]
} else {
     set next_sort_order [expr { $sort_order + 1 }]
}

db_transaction {
    set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
    set new_section_id [as::section::new_revision -section_id $section_id -assessment_id $assessment_id]
    set new_item_id [as::item::new_revision -as_item_id $as_item_id]
    as::assessment::check::copy_item_checks -assessment_id $assessment_id -section_id $new_section_id -as_item_id $as_item_id -new_item_id $new_item_id
    set new_mc_id [as::item_type_mc::new_revision -as_item_type_id $mc_id]

    as::section::update_section_in_assessment \
        -old_section_id $section_id \
        -new_section_id $new_section_id \
        -new_assessment_rev_id $new_assessment_rev_id

    as::item::update_item_in_section \
        -new_section_id $new_section_id \
        -old_item_id $as_item_id \
        -new_item_id $new_item_id

    as::item::update_item_type_in_item \
        -new_item_id $new_item_id \
        -old_item_type_id $mc_id \
        -new_item_type_id $new_mc_id

    db_dml swap_choices {}
}
return [list as_item_id $new_item_id section_id $new_section_id assessment_rev_id $new_assessment_rev_id]
}

ad_proc -private as::item_type_mc::choice_delete {
    -assessment_id
    -section_id
    -as_item_id
    -choice_id
} {
    Delete a choice
} {
db_transaction {
    set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
    set new_section_id [as::section::new_revision -section_id $section_id -assessment_id $assessment_id]
    set new_item_id [as::item::new_revision -as_item_id $as_item_id]
    # HAM : querried the mc_id for the given choice id
    set mc_id [db_string get_mc_id {select mc_id from as_item_choices where choice_id=:choice_id}]
    #  ***********
    set new_mc_id [as::item_type_mc::new_revision -as_item_type_id $mc_id -with_choices_p f]
    as::section::update_section_in_assessment \
        -old_section_id $section_id \
        -new_section_id $new_section_id \
        -new_assessment_rev_id $new_assessment_rev_id

    as::item::update_item_in_section \
        -new_section_id $new_section_id \
        -old_item_id $as_item_id \
        -new_item_id $new_item_id

    as::item::update_item_type_in_item \
        -new_item_id $new_item_id \
        -old_item_type_id $mc_id \
        -new_item_type_id $new_mc_id

    db_1row get_sort_order_to_be_removed {}
    set choices [db_list get_choices {}]
    foreach old_choice_id $choices {
	if {$old_choice_id != $choice_id} {
	    set new_choice_id [as::item_choice::new_revision -choice_id $old_choice_id -mc_id $new_mc_id]
	}
    }
    db_dml move_up_choices {}
}
return [list as_item_id $new_item_id section_id $new_section_id assessment_rev_id $new_assessment_rev_id]
}


ad_proc -private as::item_type_mc::allow_other_p {
    {-display_type_id ""}
    {-item_type_id ""}
} {
    Find out if we allow the user to enter a text option as other
} {
    if {$item_type_id ne ""} {
        return [db_string allow_other_p "select mc.allow_other_p from as_item_type_mc mc where as_item_type_id=:item_type_id" -default "f"]
    }
    return [db_string allow_other_p "select mc.allow_other_p from as_item_type_mc mc, as_item_rels r1, as_item_rels r2, cr_items ci where ci.latest_revision = r1.item_rev_id and r1.item_rev_id=r2.item_rev_id and r1.target_rev_id=mc.as_item_type_id and r1.rel_type = 'as_item_type_rel' and r2.target_rev_id=:display_type_id and r2.rel_type='as_item_display_rel'" -default "f"]
}

ad_proc -private as::item_type_mc::form_widget {
    -type_id
} {
    Get what form widget we used
} {
    set display_type [db_string allow_other_p "select object_type from acs_objects, as_item_rels r1, as_item_rels r2, cr_items ci where r1.item_rev_id = ci.latest_revision and r1.item_rev_id=r2.item_rev_id and r1.target_rev_id=:type_id and r1.rel_type='as_item_type_rel' and r2.target_rev_id=object_id and r2.rel_type='as_item_display_rel'"]
    set display_type [string range $display_type [string length $display_type]-2 end]

    return [string map {rb radio cb checkbox sb selet} $display_type]
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
