ad_page_contract {
    Form to add an item with radiobutton display.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:naturalnum,notnull
    section_id:naturalnum,notnull
    as_item_id:naturalnum,notnull
    after:integer
    {type ""}
} -properties {
    context:onevalue
    page_title:onevalue
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id


if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set page_title [_ assessment.add_item_display_rb]
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]
set type $assessment_data(type)

if { $type == 1} {
    set html_options ""
    set choice_orientation "vertical"
    set label_orientation "top"
    set order_type "order_of_entry"
    set answer_alignment "besideright"

    db_transaction {
	set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
	set section_id [as::section::latest -section_id $section_id -assessment_rev_id $new_assessment_rev_id]
	set new_section_id [as::section::new_revision -section_id $section_id -assessment_id $assessment_id]
	as::section::update_section_in_assessment\
                -old_section_id $section_id \
                -new_section_id $new_section_id \
                -new_assessment_rev_id $new_assessment_rev_id
	set old_item_id $as_item_id

	if {![db_0or1row item_display {}] || $object_type ne "as_item_display_rb"} {
	    set as_item_display_id [as::item_display_rb::new \
					-html_display_options $html_options \
					-choice_orientation $choice_orientation \
					-choice_label_orientation $label_orientation \
					-sort_order_type $order_type \
					-item_answer_alignment $answer_alignment]

	    if {![info exists object_type]} {
		# first item display mapped
		as::item_rels::new -item_rev_id $as_item_id -target_rev_id $as_item_display_id -type as_item_display_rel
	    } else {
		# old item display existing
		set as_item_id [as::item::new_revision -as_item_id $as_item_id]
	    }
	} else {
	    # old rb item display existing
	    set as_item_id [as::item::new_revision -as_item_id $as_item_id]
	    set as_item_display_id [as::item_display_rb::edit \
					-as_item_display_id $as_item_display_id \
					-html_display_options $html_options \
					-choice_orientation $choice_orientation \
					-choice_label_orientation $label_orientation \
					-sort_order_type $order_type \
					-item_answer_alignment $answer_alignment]
	}

	set old_item_id [as::item::latest -as_item_id $old_item_id -section_id $new_section_id -default 0]
	if {$old_item_id == 0} {
	    db_dml move_down_items {}
	    incr after
	    db_dml insert_new_item {}
	} else {
	    db_dml update_item_display {}
	    db_1row item_data {}
	    db_dml update_item {}
	}
    }
    ad_returnredirect [export_vars -base one-a {assessment_id}]\#$as_item_id
    ad_script_abort
}

set choice_or_types [list]
foreach choice_or_type [list horizontal vertical] {
    lappend choice_or_types [list "[_ assessment.$choice_or_type]" $choice_or_type]
}

set label_or_types [list]
foreach label_or_type [list top left right bottom] {
    lappend label_or_types [list "[_ assessment.$label_or_type]" $label_or_type]
}

set order_types [list]
foreach one_order_type [list alphabetical randomized order_of_entry] {
    lappend order_types [list "[_ assessment.$one_order_type]" $one_order_type]
}

set alignment_types [list]
foreach alignment_type [list besideleft besideright below above] {
    lappend alignment_types [list "[_ assessment.$alignment_type]" $alignment_type]
}

ad_form -name item_add_display_rb -action item-add-display-rb -export { assessment_id section_id after } -form {
    {as_item_id:key}
    {html_options:text,optional,nospell {label "[_ assessment.Html_Options]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.Html_Options_help]"}}
    {choice_orientation:text(select) {label "[_ assessment.Choice_Orientation]"} {options $choice_or_types} {help_text "[_ assessment.Choice_Orientation_help]"}}
    {label_orientation:text(hidden)}
    {order_type:text(select) {label "[_ assessment.Order_Type]"} {options $order_types} {help_text "[_ assessment.Order_Type_help]"}}
    {answer_alignment:text(hidden)}
} -edit_request {
    set html_options ""
    set choice_orientation "vertical"
    set label_orientation "top"
    set order_type "order_of_entry"
    set answer_alignment "besideright"
} -validate {
    {html_options {[as::assessment::check_html_options -options $html_options]} "[_ assessment.error_html_options]"}
} -edit_data {
    db_transaction {
	set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
	set section_id [as::section::latest -section_id $section_id -assessment_rev_id $new_assessment_rev_id]
	set new_section_id [as::section::new_revision -section_id $section_id -assessment_id $assessment_id]
	as::section::update_section_in_assessment\
                -old_section_id $section_id \
                -new_section_id $new_section_id \
                -new_assessment_rev_id $new_assessment_rev_id
	set old_item_id $as_item_id

	if {![db_0or1row item_display {}] || $object_type ne "as_item_display_rb"} {
	    set as_item_display_id [as::item_display_rb::new \
					-html_display_options $html_options \
					-choice_orientation $choice_orientation \
					-choice_label_orientation $label_orientation \
					-sort_order_type $order_type \
					-item_answer_alignment $answer_alignment]

	    if {![info exists object_type]} {
		# first item display mapped
		as::item_rels::new -item_rev_id $as_item_id -target_rev_id $as_item_display_id -type as_item_display_rel
	    } else {
		# old item display existing
		set as_item_id [as::item::new_revision -as_item_id $as_item_id]
	    }
	} else {
	    # old rb item display existing
	    set as_item_id [as::item::new_revision -as_item_id $as_item_id]
	    set as_item_display_id [as::item_display_rb::edit \
					-as_item_display_id $as_item_display_id \
					-html_display_options $html_options \
					-choice_orientation $choice_orientation \
					-choice_label_orientation $label_orientation \
					-sort_order_type $order_type \
					-item_answer_alignment $answer_alignment]
	}

	set old_item_id [as::item::latest -as_item_id $old_item_id -section_id $new_section_id -default 0]
	if {$old_item_id == 0} {
	    db_dml move_down_items {}
	    incr after
	    db_dml insert_new_item {}
	} else {
	    db_dml update_item_display {}
	    db_1row item_data {}
	    db_dml update_item {}
	}
    }
} -after_submit {
    # now go to assessment-page
    ad_returnredirect [export_vars -base one-a {assessment_id}]&\#$as_item_id
    ad_script_abort
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
