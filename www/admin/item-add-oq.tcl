ad_page_contract {
    Form to add an open question item.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:integer
    section_id:integer
    as_item_id:integer
    after:integer
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

permission::permission_p -object_id $assessment_id -privilege admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set page_title [_ assessment.add_item_type_oq]
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]

set display_types [list]
foreach display_type [db_list display_types {}] {
    lappend display_types [list "[_ assessment.item_display_$display_type]" $display_type]
}


ad_form -name item_add_oq -action item-add-oq -export { assessment_id section_id after } -form {
    {as_item_id:key}
    {title:text {label "[_ assessment.Title]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.oq_Title_help]"}}
    {default_value:text(textarea),optional,nospell {label "[_ assessment.Default_Value]"} {html {rows 5 cols 80}} {help_text "[_ assessment.Deafult_Value_help]"}}
    {feedback:text(textarea),optional {label "[_ assessment.Feedback]"} {html {rows 5 cols 80}} {help_text "[_ assessment.Feedback_help]"}}
    {display_type:text(select) {label "[_ assessment.Display_Type]"} {options $display_types} {help_text "[_ assessment.Display_Type_help]"}}
} -edit_request {
    set title ""
    set default_value ""
    set feedback ""
    set display_type "tb"
} -edit_data {
    db_transaction {
	if {![db_0or1row item_type {}] || $object_type != "as_item_type_oq"} {
	    set as_item_type_id [as::item_type_oq::new \
				     -title $title \
				     -default_value $default_value \
				     -feedback_text $feedback]
	
	    if {![info exists object_type]} {
		# first item type mapped
		as::item_rels::new -item_rev_id $as_item_id -target_rev_id $as_item_type_id -type as_item_type_rel
	    } else {
		# old item type existing
		set as_item_id [as::item::new_revision -as_item_id $as_item_id]
		db_dml update_item_type {}
	    }
	} else {
	    # old oq item type existing
	    set as_item_id [as::item::new_revision -as_item_id $as_item_id]
	    set as_item_type_id [as::item_type_oq::edit \
				     -as_item_type_id $as_item_type_id \
				     -title $title \
				     -default_value $default_value \
				     -feedback_text $feedback]
	
	    db_dml update_item_type {}
	}
    }
} -after_submit {
    # now go to display-type specific form (i.e. textbox)
    ad_returnredirect [export_vars -base "item-add-display-$display_type" {assessment_id section_id as_item_id after}]
    ad_script_abort
}

ad_return_template
