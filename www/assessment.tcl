ad_page_contract {

    This page allows to display an assessment with sections and items

    @author Eduardo Pérez Ureta (eperez@it.uc3m.es)
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-09-13
} -query {
    assessment_id:integer,notnull
    {session_id:integer,optional ""}
    {section_order:integer,optional ""}
    {item_order:integer,optional ""}
    {item_id ""}
    response_to_item:array,optional,multiple,html
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

set user_id [ad_conn user_id]
set page_title "[_ assessment.Show_Items]"
set context_bar [ad_context_bar $page_title]
set section_to ""
set item_to ""
# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set assessment_rev_id $assessment_data(assessment_rev_id)
set errors [as::assessment::check_session_conditions -assessment_id $assessment_rev_id -subject_id $user_id]
if {![empty_string_p $errors]} {
    ad_return_complaint 1 $errors
    ad_script_abort
}

db_transaction {
    if {[empty_string_p $session_id]} {
	
	# Check if there is an unfinished session lying around
	set session_id [db_string unfinished_session_id {}]
	if {[empty_string_p $session_id]} {
	    # start new session
	    set session_id [as::session::new -assessment_id $assessment_rev_id -subject_id $user_id]
	    if {[empty_string_p $assessment_data(consent_page)]} {
		# set the time when the subject initiated the Assessment
		db_dml session_start {}
	    } else {
		set consent_url [export_vars -base assessment-consent {assessment_id session_id}]
	    }
	} else {
	    # pick up old session
	    db_1row unfinished_section_order {}
	    if {[empty_string_p $section_order]} {
		set consent_url [export_vars -base assessment-consent {assessment_id session_id}]
	    } else {
		db_1row unfinished_section_id {}
		db_1row unfinished_item_order {}
		incr section_order -1
		incr item_order -1
	    }
	}
    } else {
	# set time the subject initiated the assessment, if not already done
	db_dml session_start {}
    }

    if {![info exists consent_url]} {
	db_1row session_time {}
	set assessment_data(elapsed_time) $elapsed_time
	if {![empty_string_p $assessment_data(time_for_response)]} {
	    set assessment_data(time_for_response) [expr 60 * $assessment_data(time_for_response)]
	    set assessment_data(pretty_remaining_time) [as::assessment::pretty_time -seconds [expr $assessment_data(time_for_response) - $assessment_data(elapsed_time)]]
	}


	# get all sections of assessment in correct order
	set section_list [as::assessment::sections -assessment_id $assessment_rev_id -session_id $session_id -sort_order_type $assessment_data(section_navigation)]

	if {[empty_string_p $section_order]} {
	    # start at the first section
	    set section_order 0
	    set section_id [lindex $section_list 0]
	} else {
	    # continue with given section
	    set section_id [lindex $section_list $section_order]
	}


	as::section_data::new -section_id $section_id -session_id $session_id -subject_id $user_id
	db_1row section_data {} -column_array section
	set display_type_id $section(display_type_id)
	if {![empty_string_p $display_type_id]} {
	    db_1row display_data {} -column_array display
	} else {
	    array set display [list num_items "" adp_chunk "" branched_p f back_button_p t submit_answer_p f sort_order_type order_of_entry]
	}

	# get all items of section in correct order
	set item_list [as::section::items -section_id $section_id -session_id $session_id -sort_order_type $display(sort_order_type) -num_items $section(num_items)]
	set section(num_sections) [llength $section_list]
	set section(num_items) [llength $item_list]
	if {![empty_string_p $section(max_time_to_complete)]} {
	    set section(pretty_remaining_time) [as::assessment::pretty_time -seconds [expr $section(max_time_to_complete) - $section(elapsed_time)]]
	}

	if {![empty_string_p $item_order]} {
	    # show next items on section page
	    if {![empty_string_p $display(num_items)]} {
		# make sure to display correct section page
		set item_order [expr $item_order - (($item_order+1) % $display(num_items))]
	    } elseif {$display(submit_answer_p) == "t"} {
		# show whole section when picking up a seperate submit section
		set item_order 0
	    }
	    # strip away items on previous section pages
	    set item_list [lreplace $item_list 0 [expr $item_order-1]]
	}

	if {![empty_string_p $display(num_items)]} {
	    if {[llength $item_list] > $display(num_items)} {
		# next page: more items of this section
		set new_item_order $item_order
		set new_section_order $section_order
		if {[empty_string_p $item_order]} {
		    set new_item_order 0
		}
		set new_item_order [expr $new_item_order + $display(num_items)]

		# show only a few items per page
		set item_list [lreplace $item_list $display(num_items) end]
	    } else {
		# next page: next section
		set new_item_order ""
		set new_section_order [expr $section_order + 1]
	    }
	} else {
	    # next page: next section
	    set new_section_order [expr $section_order + 1]
	    set new_item_order ""
	}

	if {$new_section_order == [llength $section_list]} {
	    # last section
	    set new_section_order ""
	}
    }
}

if {[info exists consent_url]} {
    ad_returnredirect $consent_url
    ad_script_abort
}

set section(cur_section) [expr $section_order + 1]
set section(cur_first_item) [expr $item_order + 1]
set section(cur_last_item) [expr $item_order + [llength $item_list]]

# check if section or session time ran out
if {(![empty_string_p $assessment_data(time_for_response)] && $assessment_data(time_for_response) < $assessment_data(elapsed_time)) || (![empty_string_p $section(max_time_to_complete)] && $section(max_time_to_complete) < $section(elapsed_time))} {
    if {[empty_string_p $assessment_data(time_for_response)] || $assessment_data(time_for_response) >= $assessment_data(elapsed_time)} {
	# skip to next section
	set new_section_order [expr $section_order + 1]
	set new_item_order ""
	if {$new_section_order == [llength $section_list]} {
	    # last section
	    set new_section_order ""
	}
	
	# answer all remaining section items with empty string
	db_transaction {
	    as::section::close -section_id $section_id -assessment_id $assessment_rev_id -session_id $session_id -subject_id $user_id
	    #immediate checks execution
	    as::assessment::check::eval_i_checks -session_id $session_id -section_id $section_id 
	}
    } else {
	# skip entire session
	set new_section_order ""
	set new_item_order ""
	
	db_transaction {
	    # answer all remaining section items with empty string
	    as::section::close -section_id $section_id -assessment_id $assessment_rev_id -session_id $session_id -subject_id $user_id
	    # immediate checks execution
	    as::assessment::check::eval_i_checks -session_id $session_id -section_id $section_id 

	    set section_list [lreplace $section_list 0 [expr $section_order]]
	    foreach section_id $section_list {
		# skip remaining sections
		as::section::skip -section_id $section_id -session_id $session_id -subject_id $user_id
	    }
	}
    }

    if {![empty_string_p $new_section_order]} {
	# go to next section
	set section_order $new_section_order
	set item_order $new_item_order
	ad_returnredirect [export_vars -base assessment {assessment_id session_id section_order item_order}]
	ad_script_abort
    } else {
	# calculate session points at end of session
	as::assessment::calculate -session_id $session_id -assessment_id $assessment_rev_id
	db_dml session_finished {}
	as::assessment::check::eval_aa_checks -session_id $session_id -assessment_id $assessment_id
        as::assessment::check::eval_m_checks -session_id $session_id -assessment_id $assessment_id
	if {[empty_string_p $assessment_data(return_url)]} {
	    ad_returnredirect [export_vars -base finish {session_id assessment_id}]
	} else {
	    ad_returnredirect $assessment_data(return_url)
	}
	ad_script_abort
    }
}


# form for display an assessment with sections and items
ad_form -name show_item_form -action assessment -html {enctype multipart/form-data} -export {assessment_id section_id section_order item_order} -form {
    {session_id:text(hidden) {value $session_id}}
}

multirow create items as_item_id name title description subtext required_p max_time_to_complete presentation_type html submitted_p content

set unsubmitted_list [list]
set validate_list [list]
set required_count 0

foreach one_item $item_list {
    util_unlist $one_item as_item_id name title description subtext required_p max_time_to_complete content_rev_id content_filename content_type
    
    if {$required_p == "t"} {
	# make sure that mandatory items are answered
	lappend validate_list "response_to_item.$as_item_id {\[exists_and_not_null response_to_item($as_item_id)\]} \"\[_ assessment.form_element_required\]\""
	incr required_count
    }
    set default_value ""
    set submitted_p f

    if {$display(submit_answer_p) != "t"} {
	# no seperate submit of each item
	if {$assessment_data(reuse_responses_p) == "t"} {
	    set default_value [as::item_data::get -subject_id $user_id -as_item_id $as_item_id]
	}
	set presentation_type [as::item_form::add_item_to_form -name show_item_form -session_id $session_id -section_id $section_id -item_id $as_item_id -default_value $default_value -required_p $required_p]
	
    } else {
	# submit each item seperately
	set default_value [as::item_data::get -subject_id $user_id -as_item_id $as_item_id -session_id $session_id]
	if {![empty_string_p $default_value]} {
	    # value already submitted
	    set submitted_p t
	    set mode display
	    if {$required_p == "t"} {
		# correct count of mandatory items not yet answered (to display next-button)
		incr required_count -1
	    }
	} else {
	    # value not submitted yet. get older submitted value if necessary
	    set mode edit
	    if {$assessment_data(reuse_responses_p) == "t"} {
		set default_value [as::item_data::get -subject_id $user_id -as_item_id $as_item_id]
	    }
	    lappend unsubmitted_list $as_item_id
	}
	
	# create seperate submit form for each item
	ad_form -name show_item_form_$as_item_id -mode $mode -action assessment -html {enctype multipart/form-data} -export {assessment_id section_id section_order item_order} -form {
	    {session_id:text(hidden) {value $session_id}}
	    {item_id:text(hidden) {value $as_item_id}}
	}
	set presentation_type [as::item_form::add_item_to_form -name show_item_form_$as_item_id -session_id $session_id -section_id $section_id -item_id $as_item_id -default_value $default_value -required_p $required_p]
	
	# process single submit
	set on_submit "{
	    db_transaction {
		db_dml session_updated {}

		# save answer
		set response_item_id \$item_id
		db_1row process_item_type {}
		set item_type \[string range \$item_type end-1 end\]
		if {!\[info exists response_to_item(\$response_item_id)\]} {
		    set response_to_item(\$response_item_id) \"\"
		} else {

                   set section_to_tmp \[as::assessment::check::branch_checks -item_id_to \$response_item_id -response \$response_to_item(\$response_item_id) -session_id $session_id -assessment_id $assessment_id\ -section_id $section_id]
                   if { \$section_to_tmp != \"f\" && \$section_to_tmp != \"f\"} {
                           set section_to \$section_to_tmp
                    }
                }
		
		set points \[ad_decode \$points \"\" 0 \$points\]
		as::item_type_\$item_type\\::process -type_id \$item_type_id -session_id \$session_id -as_item_id \$response_item_id -section_id \$section_id -subject_id \$user_id -response \$response_to_item(\$response_item_id) -max_points \$points -allow_overwrite_p \$display(back_button_p)
	    }
	}"
	set after_submit "{
	    ad_returnredirect \[export_vars -base assessment {assessment_id session_id section_order item_order}\]
	    ad_script_abort
	}"
	
	eval ad_form -extend -name show_item_form_$as_item_id -validate "{$validate_list}" -on_submit $on_submit -after_submit $after_submit
	set validate_list [list]
    }
    
    # Fill in the blank item. Replace all <textbox> that appear in the title by an <input> of type="text"
    if {$presentation_type == {tb}} {
	regsub -all -line -nocase -- {<textbox as_item_choice_id=} $title "<input name=response_to_item.${as_item_id}_" html
    }
    set max_time_to_complete [as::assessment::pretty_time -seconds $max_time_to_complete]

    multirow append items $as_item_id $name $title $description $subtext $required_p $max_time_to_complete $presentation_type "" $submitted_p [as::assessment::display_content -content_id $content_rev_id -filename $content_filename -content_type $content_type]
}

if {$display(submit_answer_p) != "t"} {
    # process multiple submit
    set template "assessment-section-submit"

    set on_submit "{
	db_transaction {
	    db_dml session_updated {}

	    # save answers
	    foreach one_response \$item_list {
		util_unlist \$one_response response_item_id
		db_1row process_item_type {}
		set item_type \[string range \$item_type end-1 end\]
		if {!\[info exists response_to_item(\$response_item_id)\]} {
		    set response_to_item(\$response_item_id) \"\"
		} else {

                   set item_to \$response_item_id
                   set section_to_tmp \[as::assessment::check::branch_checks -item_id_to \$item_to -response \$response_to_item(\$response_item_id) -session_id \$session_id -assessment_id \$assessment_id -section_id \$section_id\]
                   if { \$section_to_tmp != \"f\" && \$section_to_tmp != \"f\"} {
                           set section_to \$section_to_tmp
                    }
                }

		set points \[ad_decode \$points \"\" 0 \$points\]
		as::item_type_\$item_type\\::process -type_id \$item_type_id -session_id \$session_id -as_item_id \$response_item_id -section_id \$section_id -subject_id \$user_id -response \$response_to_item(\$response_item_id) -max_points \$points -allow_overwrite_p \$display(back_button_p)
	    }

	    if {\$section_order != \$new_section_order} {
		# calculate section points at end of section
		as::section::calculate -section_id \$section_id -assessment_id \$assessment_rev_id -session_id \$session_id
		# immediate checks execution
		as::assessment::check::eval_i_checks -session_id $session_id -section_id $section_id 
	    }
	}
    }"
    set after_submit "{
	if {!\[empty_string_p \$new_section_order\]} {
	    # go to next section
            if { \$section_to != \"\"} {
                set section_order \$section_to
             } else {
	    set section_order \$new_section_order
            }
	    set item_order \$new_item_order

	    ad_returnredirect \[export_vars -base assessment {assessment_id session_id section_order item_order}\]
	    ad_script_abort
	} else {
	    # calculate session points at end of session
	    as::assessment::calculate -session_id \$session_id -assessment_id \$assessment_rev_id
	    db_dml session_finished {}
            as::assessment::check::eval_aa_checks -session_id $session_id -assessment_id $assessment_id
            as::assessment::check::eval_m_checks -session_id $session_id -assessment_id $assessment_id
	    if {\[empty_string_p \$assessment_data(return_url)\]} {
		ad_returnredirect \[export_vars -base finish {session_id assessment_id}\]
	    } else {
		ad_returnredirect \$assessment_data(return_url)
	    }
	    ad_script_abort
	}
    }"

    eval ad_form -extend -name show_item_form -validate "{$validate_list}" -on_submit $on_submit -after_submit $after_submit

} else {

    # process next button in seperate submit mode
    set template "assessment-single-submit"
    ad_form -extend -name show_item_form -on_submit {
	db_transaction {
	    # save empty answer for unanswered optional items
	    foreach response_item_id $unsubmitted_list {
		db_1row process_item_type {}
		set item_type [string range $item_type end-1 end]

		set points [ad_decode $points "" 0 $points]
		as::item_type_$item_type\::process -type_id $item_type_id -session_id $session_id -as_item_id $response_item_id -section_id $section_id -subject_id $user_id -response "" -max_points $points -allow_overwrite_p $display(back_button_p)
	    }

	    if {$section_order != $new_section_order} {
		# calculate section points at end of section
		as::section::calculate -section_id $section_id -assessment_id $assessment_rev_id -session_id $session_id
		# immediate checks execution
		as::assessment::check::eval_i_checks -session_id $session_id -section_id $section_id 
	    }
	}
    } -after_submit {
	if {![empty_string_p $new_section_order]} {
	    # go to next section
	    set section_order $new_section_order
	    set item_order $new_item_order
	    ad_returnredirect [export_vars -base assessment {assessment_id session_id section_order item_order}]
	    ad_script_abort
	} else {
	    # calculate session points at end of session
	    as::assessment::calculate -session_id $session_id -assessment_id $assessment_rev_id
	    db_dml session_finished {}
	    as::assessment::check::eval_aa_checks -session_id $session_id -assessment_id $assessment_id
            as::assessment::check::eval_m_checks -session_id $session_id -assessment_id $assessment_id
	    if {[empty_string_p $assessment_data(return_url)]} {
		ad_returnredirect [export_vars -base finish {session_id assessment_id}]
	    } else {
		ad_returnredirect $assessment_data(return_url)
	    }
	    ad_script_abort
	}
    }
}

ad_return_template $template
