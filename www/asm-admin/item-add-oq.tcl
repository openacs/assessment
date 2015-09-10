ad_page_contract {
    Form to add an open question item.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:naturalnum,notnull
    section_id:naturalnum,notnull
    as_item_id:naturalnum,notnull
    after:integer
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

set page_title [_ assessment.add_item_type_oq]
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]
set type $assessment_data(type)

set display_types [list]
foreach display_type [db_list display_types {}] {
    lappend display_types [list "[_ assessment.item_display_$display_type]" $display_type]
}


ad_form -name item_add_oq -action item-add-oq -export { assessment_id section_id after } -form {
    {as_item_id:key}
    {title:text {label "[_ assessment.Title]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.oq_Title_help]"}}
}

if { $type > 1} {
    ad_form -extend -name item_add_oq -form {
    {default_value:text(textarea),optional,nospell {label "[_ assessment.Default_Value]"} {html {rows 5 cols 80}} {help_text "[_ assessment.Deafult_Value_help]"}}
    {feedback:text(textarea),optional {label "[_ assessment.Feedback]"} {html {rows 5 cols 80}} {help_text "[_ assessment.Feedback_help]"}}
    {reference_answer:text(textarea),optional {label "[_ assessment.oq_Reference_Answer]"} {html {rows 5 cols 80}} {help_text "[_ assessment.oq_Reference_Answer_help]"}}
    {keywords:text(textarea),optional {label "[_ assessment.oq_Keywords]"} {html {rows 5 cols 80}} {help_text "[_ assessment.oq_Keywords_help]"}}
    }
} else {
    ad_form -extend -name item_add_oq -form {
	{default_value:text(hidden) {value ""}}
	{feedback:text(hidden) {value ""}}
	{reference_answer:text(hidden) {value ""}}
	{keywords:text(hidden) {value ""}}
    }
}
ad_form -extend -name item_add_oq -form {
    {display_type:text(select) {label "[_ assessment.Display_Type]"} {options $display_types} {help_text "[_ assessment.Display_Type_help]"}}
} -edit_request {
    set title [db_string get_title {} -default ""]
    set default_value ""
    set feedback ""
    set reference_answer ""
    set keywords ""
    set display_type "tb"
} -on_submit {
    set keyword_list [list]
    foreach line [split $keywords "\n"] {
	lappend keyword_list [string trim $line]
    }
} -edit_data {
    db_transaction {
	if {![db_0or1row item_type {}] || $object_type ne "as_item_type_oq"} {
	    set as_item_type_id [as::item_type_oq::new \
				     -title $title \
				     -default_value $default_value \
				     -feedback_text $feedback \
				     -reference_answer $reference_answer \
				     -keywords $keyword_list]
	
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
				     -feedback_text $feedback \
				     -reference_answer $reference_answer \
				     -keywords $keyword_list]
	
	    db_dml update_item_type {}
	}
    }
} -after_submit {
    # now go to display-type specific form (i.e. textbox)
    ad_returnredirect [export_vars -base "item-add-display-$display_type" {assessment_id section_id as_item_id after}]
    ad_script_abort
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
