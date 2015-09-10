# 

ad_page_contract {
    
    Add sitewide category item
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2005-05-15
    @arch-tag: 1aaf171d-3d71-4e10-86e8-66731a80a1a5
    @cvs-id $Id$
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

set page_title [_ assessment.add_item_type_sa]
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]
set focus ""

set boolean_options [list [list "[_ assessment.yes]" t] [list "[_ assessment.no]" f]]
set display_types [as_item_type::get_display_types "swcat"]
set locale [ad_conn locale]
set category_trees [db_list_of_lists get_trees ""]

ad_form -name item-add-swcat -export { assessment_id section_id after } -form {
    {as_item_id:key}
    {tree_id:text(select) {label "[_ assessment.Category_Tree]"} {options $category_trees} {help_text "[_ assessment.Category_Tree_help]"}}
    {display_type:text(select) {label "[_ assessment.Display_Type]"} {options $display_types} {help_text "[_ assessment.Display_Type_help]"}}
} -edit_request
    set tree_id ""
    set display_type "sb"
} -edit_data {
    db_transaction {
	if {![db_0or1row item_type {}] || $object_type ne "as_item_type_swcat"} {
	    set as_item_type_id [as::item_type_sa::new \
                                     -tree_id $tree_id]
	
	    if {![info exists object_type]} {
		# first item type mapped
		as::item_rels::new -item_rev_id $as_item_id -target_rev_id $as_item_type_id -type as_item_type_rel
	    } else {
		# old item type existing
		set as_item_id [as::item::new_revision -as_item_id $as_item_id]
		db_dml update_item_type {}
	    }
	} else {
	    # old sa item type existing
	    set as_item_id [as::item::new_revision -as_item_id $as_item_id]
	    set as_item_type_id [as::item_type_swcat::edit \
				     -as_item_type_id $as_item_type_id \
                                     -tree_id $tree_id]
	    
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
