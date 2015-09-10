ad_page_contract {
    Form to add a multiple choice item.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:naturalnum,notnull
    section_id:naturalnum,notnull
    as_item_id:naturalnum,notnull
    after:integer
} -properties {
    context_bar:onevalue
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

set page_title [_ assessment.add_item_type_mc_existing]
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]
set folder_id [as::assessment::folder_id -package_id $package_id]

set choice_sets [db_list_of_lists existing_choice_sets {}]
set display_types [list]
foreach display_type [db_list display_types {}] {
    lappend display_types [list "[_ assessment.item_display_$display_type]" $display_type]
}


ad_form -name item_add_mc_existing -action item-add-mc-existing -export { assessment_id section_id after } -form {
    {as_item_id:key}
    {display_type:text(select) {label "[_ assessment.Display_Type]"} {options $display_types} {help_text "[_ assessment.Display_Type_help]"}}
    {mc_id:text(select),optional {label "[_ assessment.Choice_Sets]"} {options $choice_sets} {help_text "[_ assessment.Choice_Sets_help]"}}
} -edit_request {
    set display_type "rb"
    set mc_id ""
} -edit_data {
    db_transaction {
	if {![db_0or1row item_type {}] || $object_type ne "as_item_type_mc"} {
	    if {![info exists object_type]} {
		# first item type mapped
		as::item_rels::new -item_rev_id $as_item_id -target_rev_id $mc_id -type as_item_type_rel
	    } else {
		# old item type existing
		set as_item_id [as::item::new_revision -as_item_id $as_item_id]
		db_dml update_item_type {}
	    }
	} else {
	    # old mc item type existing
	    set as_item_id [as::item::new_revision -as_item_id $as_item_id]
	    db_dml update_item_type {}
	}
    }
} -after_submit {
    ad_returnredirect [export_vars -base "item-add-display-$display_type" {assessment_id section_id as_item_id after}]
    ad_script_abort
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
