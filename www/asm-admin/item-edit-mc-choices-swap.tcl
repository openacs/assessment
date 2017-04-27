ad_page_contract {

  Swaps two choices of a multiple choice item, sort_order and sort_order - 1.

  @param  mc_id  specifies the multiple choice item
  @param  sort_order  position of choice to be moved up or down

  @author timo@timohentschel.de

  @cvs-id $Id: item-swap.tcl

} {
    assessment_id:naturalnum,notnull
    section_id:naturalnum,notnull
    as_item_id:naturalnum,notnull
    mc_id:naturalnum,notnull
    sort_order:integer,notnull
    direction:notnull
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin

if { $direction=="up" } {
     set next_sort_order [expr { $sort_order - 1 }]
} else {
     set next_sort_order [expr { $sort_order + 1 }]
}

db_transaction {
    set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
    set new_section_id [as::section::new_revision -section_id $section_id -assessment_id $assessment_id]
    set new_item_id [as::item::new_revision -as_item_id $as_item_id]
    as::assessment::check::copy_item_checks -assessment_id $assessment_id -section_id $new_section_id -as_item_id $as_item_id -new_item_id $new_item_id
    set new_mc_id [as::item_type_mc::new_revision -as_item_type_id $mc_id]
    as::section::update_section_in_assessment\
                -old_section_id $section_id \
                -new_section_id $new_section_id \
                -new_assessment_rev_id $new_assessment_rev_id
    db_dml update_item_in_section {}
    db_dml update_item_type_in_item {}
    db_dml swap_choices {}
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
