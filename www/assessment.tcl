ad_page_contract {

    This page allows to display an assessment with sections and items

    @author Eduardo Pérez Ureta (eperez@it.uc3m.es)
    @creation-date 2004-09-13
} -query {
    assessment_id:integer,notnull
    {session_id:integer,optional ""}
    {section_order:integer,optional ""}
    {item_order:integer,optional ""}
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
	# todo: check if there's an old session that could be continued
	set session_id [as::session::new -assessment_id $assessment_rev_id -subject_id $user_id]

	# update the creation_datetime col of as_sessions table to set the time when the subject initiated the Assessment
	db_dml session_start {}
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
    set item_list [as::section::items -section_id $section_id -session_id $session_id -sort_order_type $display(sort_order_type)]

    if {![empty_string_p $item_order]} {
	# show next items on section page
	set item_list [lreplace $item_list 0 [expr $item_order-1]]
    }
    if {![empty_string_p $display(num_items)]} {
	if {[llength $item_list] > $display(num_items)} {
	    # next page: more items of this section
	    if {[empty_string_p $item_order]} {
		set item_order 0
	    }
	    set item_order [expr $item_order + $display(num_items)]

	    # show only a few items per page
	    set item_list [lreplace $item_list $display(num_items) end]
	} else {
	    # next page: next section
	    set item_order ""
	    incr section_order
	}
    } else {
	# next page: next section
	incr section_order
    }

    if {$section_order == [llength $section_list]} {
	set section_order ""
    }

    # form for display an assessment with sections and items
    ad_form -name show_item_form -action process-response -html {enctype multipart/form-data} -export {assessment_id section_id section_order item_order} -form {
	{ session_id:text {value $session_id} }
    }

    multirow create items as_item_id name title description subtext required_p max_time_to_complete presentation_type html

    foreach one_item $item_list {
	util_unlist $one_item as_item_id name title description subtext required_p max_time_to_complete

	if {$assessment_data(reuse_reponses_p) == "t"} {
	    set default_value [as::item_data::get -subject_id $user_id -as_item_id $as_item_id]
	} else {
	    set default_value ""
	}

	# todo: pass required_p
	set presentation_type [as::item_form::add_item_to_form -name show_item_form -session_id $session_id -section_id $section_id -item_id $as_item_id -default_value $default_value]

	# Fill in the blank item. Replace all <textbox> that appear in the title by an <input> of type="text"
	if {$presentation_type == {tb}} {
	    regsub -all -line -nocase -- {<textbox as_item_choice_id=} $title "<input name=response_to_item.${as_item_id}_" html
	}
	set max_time_to_complete [as::assessment::pretty_time -seconds $max_time_to_complete]

	multirow append items $as_item_id $name $title $description $subtext $required_p $max_time_to_complete $presentation_type ""
    }
}

ad_return_template
