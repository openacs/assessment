ad_page_contract {

    This page allows to display an assessment with sections and items

    @author Eduardo Pérez Ureta (eperez@it.uc3m.es)
    @creation-date 2004-09-13
} -query {
    assessment_id:integer,notnull
    {session_id:integer,optional ""}
    {section_order:integer,optional ""}
    {item_order:integer,optional ""}
    {as_item_id ""}
    response_to_item:array,optional,multiple,html
} -properties {
    session_id
    context:onevalue
}

set user_id [ad_conn user_id]
set context [list "[_ assessment.Show_Items]"]

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set assessment_rev_id $assessment_data(assessment_rev_id)

db_transaction {
    if {[empty_string_p $session_id]} {
	if {![db_0or1row unfinished_session_id {}]} {
	    # todo: check if there's an old session that could be continued
	    set session_id [as::session::new -assessment_id $assessment_rev_id -subject_id $user_id]

	    # update the creation_datetime col of as_sessions table to set the time when the subject initiated the Assessment
	    db_dml session_start {}
	}
    }

    # get all sections of assessment in correct order
    set section_list [as::assessment::sections -assessment_id $assessment_rev_id -session_id $session_id -sort_order_type $assessment_data(section_navigation)]

    if {[empty_string_p $section_order]} {
	set section_order 0
	set section_id [lindex $section_list 0]
    } else {
	set section_id [lindex $section_list $section_order]
    }


    db_1row section_data {} -column_array section
    set display_type_id $section(display_type_id)
    if {![empty_string_p $display_type_id]} {
	db_1row display_data {} -column_array display
    } else {
	array set display [list num_items "" adp_chunk "" branched_p f back_button_p t submit_answer_p f sort_order_type order_of_entry]
    }


    # get all items of section in correct order
    set item_list [as::section::items -section_id $section_id -session_id $session_id -sort_order_type $display(sort_order_type) -num_items $section(num_items)]

    if {![empty_string_p $item_order]} {
	# show next items on section page
	set item_list [lreplace $item_list 0 [expr $item_order-1]]
    }

    if {![empty_string_p $display(num_items)]} {
	if {[llength $item_list] > $display(num_items)} {
	    # next page: more items of this section
	    if {[empty_string_p $item_order]} {
		set new_item_order 0
	    }
	    set new_item_order [expr $item_order + $display(num_items)]

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
    }

    if {$new_section_order == [llength $section_list]} {
	set new_section_order ""
    }
}


# form for display an assessment with sections and items
ad_form -name show_item_form -action assessment -html {enctype multipart/form-data} -export {assessment_id section_id section_order item_order} -form {
    { session_id:text(hidden) {value $session_id} }
}

multirow create items as_item_id name title description subtext required_p max_time_to_complete presentation_type html submitted_p content

foreach one_item $item_list {
    util_unlist $one_item as_item_id name title description subtext required_p max_time_to_complete content_rev_id content_filename content_type

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
	} else {
	    # value not submitted yet. get older submitted value if necessary
	    set mode edit
	    if {$assessment_data(reuse_responses_p) == "t"} {
		set default_value [as::item_data::get -subject_id $user_id -as_item_id $as_item_id]
	    }
	}
	ad_form -name show_item_form_$as_item_id -mode $mode -action assessment -html {enctype multipart/form-data} -export {assessment_id section_id section_order item_order} -form {
	    { session_id:text(hidden) {value $session_id} }
	}
	set presentation_type [as::item_form::add_item_to_form -name show_item_form_$as_item_id -session_id $session_id -section_id $section_id -item_id $as_item_id -default_value $default_value -required_p $required_p]

	# process single submit
	ad_form -extend -name show_item_form_$as_item_id -on_submit {
	    db_transaction {
		db_dml session_updated {}

		set response_item_id $as_item_id
		db_1row process_item_type {}
		set item_type [string range $item_type end-1 end]
		if {![info exists response_to_item($as_item_id)]} {
		    set response_to_item($as_item_id) ""
		}

		as::item_type_$item_type\::process -type_id $item_type_id -session_id $session_id -as_item_id $response_item_id -subject_id $user_id -response $response_to_item($as_item_id) -max_points $points
	    }
	} -after_submit {
	    if {![empty_string_p $section_order]} {
		ad_returnredirect [export_vars -base assessment {assessment_id session_id section_order item_order}]
		ad_script_abort
	    } else {
		db_dml session_finished {}
		ad_returnredirect [export_vars -base finish {session_id assessment_id}]
		ad_script_abort
	    }
	}
    }

    # Fill in the blank item. Replace all <textbox> that appear in the title by an <input> of type="text"
    if {$presentation_type == {tb}} {
	regsub -all -line -nocase -- {<textbox as_item_choice_id=} $title "<input name=response_to_item.${as_item_id}_" html
    }
    set max_time_to_complete [as::assessment::pretty_time -seconds $max_time_to_complete]

    multirow append items $as_item_id $name $title $description $subtext $required_p $max_time_to_complete $presentation_type "" $submitted_p [as::assessment::display_content -content_id $content_rev_id -filename $content_filename -content_type $content_type]
}

if {$display(submit_answer_p) != "t"} {
    foreach one_item $item_list {
	util_unlist $one_item as_item_id
	append validate_list "\{response_to_item.$as_item_id \{\[exist_and_not_null \$response_to_item.$as_item_id\]\} \"Answer missing\"\}\n"
    }
    # process multiple submit
    eval ad_form -extend -name show_item_form -validate "{$validate_list}"
    ad_form -extend -name show_item_form -on_submit {
	db_transaction {
	    db_dml session_updated {}

	    foreach response_item_id [array names response_to_item] {
		db_1row process_item_type {}
		set item_type [string range $item_type end-1 end]

		as::item_type_$item_type\::process -type_id $item_type_id -session_id $session_id -as_item_id $response_item_id -subject_id $user_id -response $response_to_item($response_item_id) -max_points $points
	    }
	}
    } -after_submit {
	if {![empty_string_p $new_section_order]} {
	    set section_order $new_section_order
	    set item_order $new_item_order
	    ad_returnredirect [export_vars -base assessment {assessment_id session_id section_order item_order}]
	    ad_script_abort
	} else {
	    db_dml session_finished {}
	    ad_returnredirect [export_vars -base finish {session_id assessment_id}]
	    ad_script_abort
	}
    }
}

ad_return_template
