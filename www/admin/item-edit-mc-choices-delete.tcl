ad_page_contract {

  Deletes a choices of a multiple choice item

  @param  choice_id  specifies the choice

  @author timo@timohentschel.de

  @cvs-id $Id: item-swap.tcl

} {
    assessment_id:integer,notnull
    section_id:integer,notnull
    as_item_id:integer,notnull
    choice_id:integer,notnull
}

permission::require_permission -object_id $assessment_id -privilege admin

db_transaction {
    set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
    set new_section_id [as::section::new_revision -section_id $section_id]
    set new_item_id [as::item::new_revision -as_item_id $as_item_id]
    set new_mc_id [as::item_type_mc::new_revision -as_item_type_id $mc_id -with_choices_p f]
    db_dml update_section_in_assessment {}
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
    ad_return_error "Database error" "A database error occured:<pre>$errmsg</pre>"
    ad_script_abort
}

set section_id $new_section_id
set as_item_id $new_item_id
ad_returnredirect [export_vars -base item-edit {assessment_id section_id as_item_id}]
