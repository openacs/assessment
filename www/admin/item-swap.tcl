ad_page_contract {

  Swaps two items for a section, sort_order and sort_order - 1.

  @param  section_id  specifies the assessment section
  @param  sort_order  position of item to be moved up or down

  @author timo@timohentschel.de

  @cvs-id $Id: item-swap.tcl

} {
    assessment_id:integer,notnull
    section_id:integer,notnull
    sort_order:integer,notnull
    direction:notnull
}

ad_require_permission $assessment_id admin

if { $direction=="up" } {
     set next_sort_order [expr { $sort_order - 1 }]
} else {
     set next_sort_order [expr { $sort_order + 1 }]
}

db_transaction {
    set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
    set new_section_id [as::section::new_revision -section_id $section_id]
    db_dml update_section_in_assessment {}
    db_dml swap_items {}
} on_error {
    ad_return_error "Database error" "A database error occured:<pre>$errmsg</pre>"
    ad_script_abort
}

ad_returnredirect [export_vars -base one-a {assessment_id}]
