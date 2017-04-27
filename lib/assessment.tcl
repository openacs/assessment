ad_page_contract {

    This page allows to display an assessment with sections and items

    @author Eduardo Pérez Ureta (eperez@it.uc3m.es)
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-09-13
} -query {
    assessment_id:naturalnum,notnull
    {password:optional ""}
    {session_id:naturalnum,optional ""}
    {section_order:integer,optional ""}
    {item_order:integer,optional ""}
    {item_id:integer ""}
    {return_url:localurl,optional}
    response_to_item:array,optional,multiple,allhtml
    {next_asm:optional}
    {response:multiple,optional}
    {next_url ""}
    {single_section_id:integer ""}
    {show_title_p:boolean 1}
} -properties {
    context:onevalue
    page_title:onevalue
}

set user_id [ad_conn user_id]
set page_title "[_ assessment.Show_Items]"
set context [list $page_title]
set section_to ""
set item_to ""
set url ""

if { [info exists return_url] } {
    
    set url $return_url
} 

set return_url "$url"



# Get the assessment data
as::assessment::data -assessment_id $assessment_id
permission::require_permission -object_id $assessment_id -privilege read
if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    return
}

if { $assessment_data(publish_status) ne "live" } {
    ad_return_complaint 1 [_ assessment.Requested_assess_is_no_longer_available]
    return
}

set assessment_rev_id $assessment_data(assessment_rev_id)
set number_tries $assessment_data(number_tries)
db_1row total_tries {}
if {$number_tries ne "" && $number_tries > 0 && $number_tries <= $total_tries} {
    ad_returnredirect [export_vars -base session {assessment_id}]
}

set errors [as::assessment::check_session_conditions -assessment_id $assessment_rev_id -subject_id $user_id -password $password]

if {$errors ne ""} {
    ad_return_complaint 1 $errors
    ad_script_abort
}
set assessment_package_id $assessment_data(package_id)

db_transaction {
    if {$session_id eq ""} {

	# Check if there is an unfinished session lying around
	set session_id [db_string unfinished_session_id {}]
    }
    	if {$session_id eq ""} {
	    # start new session
	    set session_id [as::session::new -assessment_id $assessment_rev_id -subject_id $user_id -package_id $assessment_package_id]
	    if {$assessment_data(consent_page) eq ""} {
		# set the time when the subject initiated the Assessment
		db_dml session_start {}
	    } else {
		set consent_url [export_vars -base assessment-consent {assessment_id session_id password return_url next_asm single_section_id}]
	    }
	} else {
	    # pick up old session
	    if {$section_order eq ""} {
		db_1row unfinished_section_order {}
		if {$section_order eq ""} {
		    #		set consent_url [export_vars -base assessment-consent {assessment_id session_id password return_url next_asm single_section_id}]
		} else {
		    db_1row unfinished_section_id {}
		    db_1row unfinished_item_order {}
		if {$item_order ne ""} {
		    incr section_order -1
		    if {$item_order eq ""} {
			set item_order 0
		    } else {
			incr item_order -1
		    }		    
		}
		}

	    }
	}

    if {![info exists consent_url]} {
	db_1row session_time {}
	set assessment_data(elapsed_time) $elapsed_time
	if {$assessment_data(time_for_response) ne ""} {
	    set assessment_data(time_for_response) [expr {60 * $assessment_data(time_for_response)}]
	    set assessment_data(pretty_remaining_time) [as::assessment::pretty_time -seconds [expr {$assessment_data(time_for_response) - $assessment_data(elapsed_time)}]]
	}


	# get all sections of assessment in correct order
	set section_list [as::assessment::sections -assessment_id $assessment_rev_id -session_id $session_id -sort_order_type $assessment_data(section_navigation) -random_p $assessment_data(random_p)]
	if {$single_section_id eq ""} {
	    if {$section_order eq ""} {
		# start at the first section
		set section_order 0
		set section_id [lindex $section_list 0]
	    } else {
		# continue with given section
		set section_id [lindex $section_list $section_order]
		# hang onto the section_id since we only want to do this one
		# otherwise it'll go back to the first section.
	    }

	} else {
	    set section_id $single_section_id
	    # we check if the section order is greater than the current section, just in case we are presenting sections out of order
	    if {$section_order ne "" && $section_order > [lsearch $section_list $section_id]} {
		# we had more than one section in the whole assessment
		# but we are only doing one right now, so go to the next_url
		# we need to funnel through feedback page, in case there is per page feedback.
		ad_returnredirect [export_vars -base feedback {assessment_id session_id section_id return_url next_url {return_p 1} item_id_list:multiple }]
		ad_script_abort		
	    }
	    set section_list $single_section_id
	    set section_order 0
	}

	# check if we just wanted to do one section, if so go to the 
	# next_url
	if {$section_id eq ""} {
	    # we had more than one section in the whole assessment
	    # but we are only doing one right now, so go to the next_url
	    ad_returnredirect $next_url
	    ad_script_abort
	}

	as::section_data::new -section_id $section_id -session_id $session_id -subject_id $user_id -package_id $assessment_package_id
	db_1row section_data {} -column_array section
	set display_type_id $section(display_type_id)
	if {$display_type_id ne ""} {
	    db_1row display_data {} -column_array display
	} else {
	    array set display [list num_items "" adp_chunk "" branched_p f back_button_p t submit_answer_p f sort_order_type order_of_entry]
	}

	# get all items of section in correct order
	set item_list [as::section::items -section_id $section_id -session_id $session_id -sort_order_type $display(sort_order_type) -num_items $section(num_items) -random_p $assessment_data(random_p)]
	set item_id_list [list]

	# get total number of items
	set page_total_items [llength $item_list]
	# get preference for number of display items per page
	# since we are dividing here, we need to set per_page to the
	# total number of questions if its an empty string or 0
	set page_display_per_page [expr {[string equal "" $display(num_items)] ? $page_total_items : $display(num_items)}]
	# determine the total number of pages
	set page_total [expr {$page_total_items == 0 ? 0 : $page_total_items / $page_display_per_page}]

	set section(num_sections) [llength $section_list]
	set section(num_items) [llength $item_list]
	if {$section(max_time_to_complete) ne ""} {
	    set section(pretty_remaining_time) [as::assessment::pretty_time -seconds [expr {$section(max_time_to_complete) - $section(elapsed_time)}]]
	}

	if {$item_order ne ""} {
	    # show next items on section page
	    if {$display(num_items) ne ""} {
		# make sure to display correct section page
		set item_order [expr {$item_order - ($item_order % $display(num_items))}]
	    } elseif {$display(submit_answer_p) == "t"} {
		# show whole section when picking up a separate submit section
		set item_order 0
	    }
	}

	# determine on which page we are right now based on item_order
	if { (![info exists item_order] || $item_order eq "") } { set item_order 0 }
	# add 1 because we want to compare the 1 indexed display number
	# to the current page
	set current_page [expr {$item_order == 0 ? 0 : $item_order / $page_display_per_page + 1}]

	# strip away items on previous section pages
	set item_list [lreplace $item_list 0 [expr {$item_order-1}]]


	if {$display(num_items) ne ""} {
	    if {[llength $item_list] > $display(num_items)} {
		# show only a few items per page
		set item_list [lreplace $item_list $display(num_items) end]
		# next page: more items of this section
		set new_item_order $item_order
		set new_section_order $section_order
		if {$item_order eq ""} {
		    set new_item_order 0
		}
		set new_item_order [expr {$new_item_order + $display(num_items)}]
	    } else {
		# next page: next section
		set new_item_order ""
		set new_section_order [expr {$section_order + 1}]
	    }
	} else {
	    # next page: next section
	    set new_section_order [expr {$section_order + 1}]
	    set new_item_order ""
	}

	if {$new_section_order == [llength $section_list]} {
	    # last section
	    set new_section_order ""
	}

	foreach one_item $item_list {
	    lappend item_id_list [lindex $one_item 0]
	}

	# let's generate the list of page numbers 
	# for sections with a limited number of items per page
	if {$display(num_items) ne "" && $page_total > 1} {
	    set progress_bar_list [template::util::number_list $page_total 1]
	    set total_pages [llength $progress_bar_list]
	}
	if {![info exists show_progress]} {
	    set show_progress 0
	}
	# if we have multiple sections
	if {![info exists progress_bar_list] && [llength $section_list] > 1} {
	    set progress_bar_list [template::util::number_list [llength $section_list] 1]
	    set current_page [expr {[lsearch $section_list $section_id] +1 }]
	    set total_pages [llength $progress_bar_list]
	}
    }
}

if {[info exists consent_url]} {
    ad_returnredirect $consent_url
    ad_script_abort
}

set section(cur_section) [expr {$section_order + 1}]
set section(cur_first_item) [expr {$item_order + 1}]
set section(cur_last_item) [expr {$item_order + [llength $item_list]}]

# check if section or session time ran out
if {($assessment_data(time_for_response) ne "" && $assessment_data(time_for_response) < $assessment_data(elapsed_time)) || ($section(max_time_to_complete) ne "" && $section(max_time_to_complete) < $section(elapsed_time))} {
    if {$assessment_data(time_for_response) eq "" || $assessment_data(time_for_response) >= $assessment_data(elapsed_time)} {
	# skip to next section
	set new_section_order [expr {$section_order + 1}]
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
	    set section_to_tmp [as::assessment::check::branch_checks -session_id $session_id -assessment_id $assessment_id -section_id $section_id]
	    if { $section_to_tmp != "f" && $section_to_tmp != "f"} {
		set section_to $section_to_tmp
	    }
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
	    set section_to_tmp [as::assessment::check::branch_checks -session_id $session_id -assessment_id $assessment_id -section_id $section_id]
	    if { $section_to_tmp != "f" && $section_to_tmp != "f"} {
		set section_to $section_to_tmp
	    }


	    set section_list [lreplace $section_list 0 [expr {$section_order}]]
	    foreach section_id $section_list {
		# skip remaining sections
		as::section::skip -section_id $section_id -session_id $session_id -subject_id $user_id
	    }
	}
    }

    if {$new_section_order ne ""} {
	# go to next section
	set section_order $new_section_order
	set item_order $new_item_order
#	ad_returnredirect [export_vars -base assessment {assessment_id session_id section_order item_order password return_url next_asm section_id item_id_list:multiple single_section_id}]
	ad_returnredirect [export_vars -base feedback {assessment_id session_id section_order item_order password return_url next_asm section_id item_id_list:multiple total_pages current_page}]
	ad_script_abort
    } else {
	# calculate session points at end of session
	as::assessment::calculate -session_id $session_id -assessment_id $assessment_rev_id
	db_dml session_finished {}
	as::assessment::check::eval_aa_checks -session_id $session_id -assessment_id $assessment_id
	# section based aa checks
	as::assessment::check::eval_sa_checks -session_id $session_id -assessment_id $assessment_id 
        as::assessment::check::eval_m_checks -session_id $session_id -assessment_id $assessment_id
	if {$assessment_data(return_url) eq ""} {
	    set return_url [export_vars -base finish {session_id assessment_id return_url next_asm total_pages current_page}]
	} else {
	    set return_url $assessment_data(return_url)
	}
	ad_returnredirect [export_vars -base feedback {assessment_id session_id section_id return_url {return_p 1} item_id_list:multiple total_pages current_page}]
	ad_script_abort
    }
}

lappend exports next_asm assessment_id section_id section_order item_order password return_url item_id_list single_section_id
# form for display an assessment with sections and items
ad_form -name show_item_form -action assessment -html {enctype multipart/form-data} -export $exports -form {
    {session_id:text(hidden) {value $session_id}}
} -has_submit 1

multirow create items as_item_id name title description subtext required_p max_time_to_complete presentation_type html submitted_p content as_item_type_id choice_orientation next_as_item_id validate_block next_pr_type question_text

set unsubmitted_list [list]
set validate_list [list]
set required_count 0

foreach one_item $item_list {
    lassign $one_item as_item_id name title description subtext required_p max_time_to_complete content_rev_id content_filename content_type as_item_type_id validate_block question_text

    foreach {check_expr check_message} [split $validate_block \n] {
	regsub -all {%answer%} $check_expr \$response_to_item($as_item_id) check_expr
	regsub -all {%answer%} [lang::util::localize $check_message] \$response_to_item($as_item_id) check_message
	lappend validate_list "response_to_item.$as_item_id { $check_expr } { $check_message }"
    }

    set default_value ""
    set submitted_p f
    if {$display(submit_answer_p) != "t"} {
	# no separate submit of each item
	if {$assessment_data(reuse_responses_p) == "t"} {
	    set default_value [as::item_data::get -subject_id $user_id -as_item_id $as_item_id -section_id $section_id]
	}
	set presentation_type [as::item_form::add_item_to_form -name show_item_form -session_id $session_id -section_id $section_id -item_id $as_item_id -default_value $default_value -required_p $required_p -random_p $assessment_data(random_p)]
        if {$required_p == "t"} {
            # make sure that mandatory items are answered
            if {[lsearch {rbo sbo cbo} $presentation_type] > -1} {
                lappend validate_list "response_to_item.$as_item_id {\$\{response_to_item.$as_item_id\} ne \"\" || \[ns_queryget response_to_item.${as_item_id}\.text\] ne \"\"} \"\[_ assessment.form_element_required\]\""                
            } else {
               lappend validate_list "response_to_item.$as_item_id {\[exists_and_not_null response_to_item($as_item_id)\]} \"\[_ assessment.form_element_required\]\""
            }
            incr required_count
        }

    } else {
	# submit each item separately
	set default_value [as::item_data::get -subject_id $user_id -as_item_id $as_item_id -session_id $session_id -section_id $section_id]
	if {$default_value ne ""} {
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
		set default_value [as::item_data::get -subject_id $user_id -as_item_id $as_item_id -section_id $section_id]
	    }
	    lappend unsubmitted_list $as_item_id
	}
	
	# create separate submit form for each item
	ad_form -name show_item_form_$as_item_id -mode $mode -action assessment -html {enctype multipart/form-data} -export {assessment_id section_id section_order item_order password return_url next_asm} -form {
	    {session_id:text(hidden) {value $session_id}}
	    {item_id:text(hidden) {value $as_item_id}}
	}
	set presentation_type [as::item_form::add_item_to_form -name show_item_form_$as_item_id -session_id $session_id -section_id $section_id -item_id $as_item_id -default_value $default_value -required_p $required_p]
        if {$required_p == "t"} {
            # make sure that mandatory items are answered
            if {[lsearch {rbo sbo cbo} $presentation_type] > -1} {
                lappend validate_list "response_to_item.$as_item_id {\[exists_and_not_null response_to_item($as_item_id)\] || \[exists_and_not_null response_to_item($as_item_id)\.text\]} \"\[_ assessment.form_element_required\]\""                
            } else {
               lappend validate_list "response_to_item.$as_item_id {\[exists_and_not_null response_to_item($as_item_id)\]} \"\[_ assessment.form_element_required\]\""
            }
            incr required_count
        }
	
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

                   set section_to_tmp \[as::assessment::check::branch_checks -session_id $session_id -assessment_id $assessment_id\ -section_id $section_id]
                   if { \$section_to_tmp != \"f\" && \$section_to_tmp != \"f\"} {
                           set section_to \$section_to_tmp
                    }
                }
		
		set points \[ad_decode \$points \"\" 0 \$points\]

                set response \$response_to_item(\$response_item_id)

                if { \$item_type == \"fu\" } {
                    set response \[list  \$response_to_item(\$response_item_id) \$response_to_item(\${response_item_id}.tmpfile)  \$response_to_item(\${response_item_id}.content-type)\]
                }

		as::item_type_\$item_type\\::process -type_id \$item_type_id -session_id \$session_id -as_item_id \$response_item_id -section_id \$section_id -subject_id \$user_id -response \$response -max_points \$points -allow_overwrite_p \$display(back_button_p) -package_id \$assessment_package_id
	    }
	}"
	set after_submit "{
        
\#	ad_returnredirect \[export_vars -base assessment {assessment_id session_id section_order item_order password return_url next_asm section_id item_id_list:multiple single_section_id}\]
	ad_returnredirect \[export_vars -base feedback {assessment_id session_id section_order item_order password return_url next_asm section_id item_id_list:multiple single_section_id total_pages current_page}\]
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

    if {$presentation_type eq "rb" || $presentation_type eq "cb"} {
	array set item [as::item::item_data -as_item_id $as_item_id]
	array set type [as::item_display_$presentation_type\::data -type_id $item(display_type_id)]
	set choice_orientation $type(choice_orientation)
	array unset item
	array unset type
    } else {
	set choice_orientation ""
    }

    multirow append items $as_item_id $name $title $description $subtext $required_p $max_time_to_complete $presentation_type "" $submitted_p [as::assessment::display_content -content_id $content_rev_id -filename $content_filename -content_type $content_type] $as_item_type_id $choice_orientation "" "" "" $question_text

}

for {set i 1; set j 2} {$i <= ${items:rowcount}} {incr i; incr j} {
    upvar 0 items:$i this
    if {$i < ${items:rowcount}} {
	upvar 0 items:$j next
	set this(next_as_item_id) $next(as_item_id)
	set this(next_pr_type) $next(presentation_type)
    } else {
	set this(next_as_item_id) ""
	set this(next_pr_type) ""
    }
}

ad_form -extend -name show_item_form -on_request {
    as::assessment::check::eval_or_checks -session_id $session_id -section_id $section_id 
}

if {$display(submit_answer_p) != "t"} {
    # process multiple submit
    set template "/packages/assessment/www/assessment-section-submit"

    set on_submit "{
	db_transaction {
            \# check if we already submitted this section!
            if {\[db_string count_submitted_session \"select count(*) from as_section_data where session_id = :session_id and section_id = :section_id and completed_datetime is not null\" -default 0\] == 0} {

	    db_dml session_updated {}
	    # save answers
	    foreach one_response \$item_list {
		lassign \$one_response response_item_id
		db_1row process_item_type {}
		set item_type \[string range \$item_type end-1 end\]
		if {!\[info exists response_to_item(\$response_item_id)\]} {
		    set response_to_item(\$response_item_id) \"\"
		} else {

                   set item_to \$response_item_id
                   set section_to_tmp \[as::assessment::check::branch_checks  -session_id \$session_id -assessment_id \$assessment_id -section_id \$section_id\]
                   if { \$section_to_tmp != \"f\" && \$section_to_tmp != \"f\"} {
                           set section_to \$section_to_tmp
                    }
                }

		set points \[ad_decode \$points \"\" 0 \$points\]
                set response \$response_to_item(\$response_item_id)                 

                if { \$item_type == \"fu\" } {
                    set response \[list  \$response_to_item(\$response_item_id) \$response_to_item(\${response_item_id}.tmpfile)  \$response_to_item(\${response_item_id}.content-type)\]
                }

		as::item_type_\$item_type\\::process -type_id \$item_type_id -session_id \$session_id -as_item_id \$response_item_id -section_id \$section_id -subject_id \$user_id -response \$response -max_points \$points -allow_overwrite_p \$display(back_button_p) -package_id \$assessment_package_id
	    }
            as::session::update_elapsed_time -session_id $session_id -section_id $section_id
            set message \"\"
        } else {
            set message \"\#assessment.Section_previously_submitted\#\"
        }
	    if {\$section_order != \$new_section_order} {
		# calculate section points at end of section
		as::section::calculate -section_id \$section_id -assessment_id \$assessment_rev_id -session_id \$session_id
		# immediate checks execution
		as::assessment::check::eval_i_checks -session_id $session_id -section_id $section_id 
                set section_to_tmp \[as::assessment::check::branch_checks -session_id $session_id -assessment_id $assessment_id\ -section_id $section_id]
                   if { \$section_to_tmp != \"f\" && \$section_to_tmp != \"f\"} {
                           set section_to \$section_to_tmp
                    }


	    }
	}
    }"

    set after_submit "{
\# NOTE the code just incrementes section order so when the section order
\# is greate than the number of items in the list of sections
\# we know we are done and should finish the assessment
	if {!\[empty_string_p \$new_section_order\] && \$new_section_order <= \[llength \$section_list\]} {
	    # go to next section
            if { \$section_to != \"\"} {
                set section_order \$section_to
             } else {
	    set section_order \$new_section_order
            }
	    set item_order \$new_item_order
\#	ad_returnredirect \[export_vars -base assessment {assessment_id session_id section_order item_order password return_url next_asm section_id item_id_list:multiple single_section_id}\]
	ad_returnredirect -message \$message \[export_vars -base feedback {assessment_id session_id section_order item_order password return_url next_asm section_id item_id_list:multiple next_url total_pages current_page}\]
	    ad_script_abort
	} else {
	    # calculate session points at end of session
	    as::assessment::calculate -session_id \$session_id -assessment_id \$assessment_rev_id
	    db_dml session_finished {}
            as::assessment::check::eval_aa_checks -session_id $session_id -assessment_id $assessment_id
            # section based aa checks
            as::assessment::check::eval_sa_checks -session_id $session_id -assessment_id $assessment_id 
            as::assessment::check::eval_m_checks -session_id $session_id -assessment_id $assessment_id
	if {\[empty_string_p \$assessment_data(return_url)\]} {
	    set return_url \[export_vars -base finish {session_id assessment_id return_url next_asm total_pages current_page}\]
	} else {
	    set return_url \$assessment_data(return_url)
	}
	ad_returnredirect -message \$message \[export_vars -base feedback {assessment_id session_id section_id return_url {return_p 1} item_id_list:multiple total_pages current_page}\]
	    ad_script_abort
	}
    }"

    eval ad_form -extend -name show_item_form -validate "{$validate_list}" -on_submit $on_submit -after_submit $after_submit

} else {

    # process next button in separate submit mode
    set template "assessment-single-submit"
    ad_form -extend -name show_item_form -on_submit {
	db_transaction {
	    # save empty answer for unanswered optional items
	    foreach response_item_id $unsubmitted_list {
		db_1row process_item_type {}
		set item_type [string range $item_type end-1 end]

		set points [ad_decode $points "" 0 $points]
		set response \$response_to_item(\$response_item_id)\
		    
		if { \$item_type == \"fu\" } {
                    set response \[list  \$response_to_item(\$response_item_id) \$response_to_item(\${response_item_id}.tmpfile)  \$response_to_item(\${response_item_id}.content-type)\]
                }

		as::item_type_\$item_type\\::process -type_id \$item_type_id -session_id \$session_id -as_item_id \$response_item_id -section_id \$section_id -subject_id \$user_id -response \$response -max_points \$points -allow_overwrite_p \$display(back_button_p) -package_id \$assessment_package_id

	    }

	    if {$section_order != $new_section_order} {
		# calculate section points at end of section
		as::section::calculate -section_id $section_id -assessment_id $assessment_rev_id -session_id $session_id
		# immediate checks execution
		as::assessment::check::eval_i_checks -session_id $session_id -section_id $section_id 
	    }
	}
    } -after_submit {
	if {$next_url ne ""} {
	    ad_returnredirect $next_url
	    ad_script_abort
	}
	if {$new_section_order ne ""} {
	    # go to next section
	    set section_order $new_section_order
	    set item_order $new_item_order
\#	ad_returnredirect [export_vars -base assessment {assessment_id session_id section_order item_order password return_url next_asm section_id item_id_list:multiple single_section_id}]
	    ad_returnredirect [export_vars -base feedback {assessment_id session_id section_order item_order password return_url next_asm section_id item_id_list:multiple next_url total_pages current_page}]
	    ad_script_abort
	} else {
	    # calculate session points at end of session
	    as::assessment::calculate -session_id $session_id -assessment_id $assessment_rev_id
	    db_dml session_finished {}
	    as::assessment::check::eval_aa_checks -session_id $session_id -assessment_id $assessment_id
	    # section based aa checks
	    as::assessment::check::eval_sa_checks -session_id $session_id -assessment_id $assessment_id 
            as::assessment::check::eval_m_checks -session_id $session_id -assessment_id $assessment_id
	    if {$assessment_data(return_url) eq ""} {
		set return_url [export_vars -base finish {session_id assessment_id return_url next_asm total_pages current_page}]
	    } else {
		set return_url $assessment_data(return_url)
	    }
#	ad_returnredirect [export_vars -base assessment {assessment_id session_id section_order item_order password return_url next_asm section_id item_id_list:multiple single_section_id}]
	    ad_returnredirect [export_vars -base feedback {assessment_id session_id section_id return_url {return_p 1} item_id_list:multiple next_url total_pages current_page}]
	    ad_script_abort
	}
    }
}

set form_is_submit [template::form::is_submission show_item_form]
set form_is_valid [template::form::is_valid show_item_form]

ad_return_template $template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
