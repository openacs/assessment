ad_page_contract {

  Deletes a choices of a multiple choice item

  @param  choice_id  specifies the choice

  @author timo@timohentschel.de

  @cvs-id $Id: item-swap.tcl

} {
    assessment_id:naturalnum,notnull
    section_id:naturalnum,notnull
    as_item_id:naturalnum,notnull
    choice_id:naturalnum,notnull
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin

db_transaction {
    set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
    set new_section_id [as::section::new_revision -section_id $section_id -assessment_id $assessment_id]
    set new_item_id [as::item::new_revision -as_item_id $as_item_id]
    # HAM : querried the mc_id for the given choice id
    set mc_id [db_string get_mc_id {select mc_id from as_item_choices where choice_id = :choice_id}]
    #  ***********
    set new_mc_id [as::item_type_mc::new_revision -as_item_type_id $mc_id -with_choices_p f]
    as::section::update_section_in_assessment\
                -old_section_id $section_id \
                -new_section_id $new_section_id \
                -new_assessment_rev_id $new_assessment_rev_id
    db_dml update_item_in_section {}
    db_dml update_item_type_in_item {}

    db_1row get_sort_order_to_be_removed {}
    set choices [db_list get_choices {}]
    foreach old_choice_id $choices {
	if {$old_choice_id != $choice_id} {
	    set new_choice_id [as::item_choice::new_revision -choice_id $old_choice_id -mc_id $new_mc_id]
	}
    }
    db_dml move_up_choices {}
} on_error {
    ad_return_error "Database error" "A database error occurred:<pre>$errmsg</pre>"
    ad_script_abort
}

set section_id $new_section_id
set as_item_id $new_item_id
ad_returnredirect [export_vars -base item-edit {assessment_id section_id as_item_id}]

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
