ad_page_contract {

  Swaps two sections for an assessment, sort_order and sort_order - 1.

  @param  assessment_id  specifies the assessment
  @param  sort_order  position of section to be moved up or down

  @author timo@timohentschel.de

  @cvs-id $Id: section-swap.tcl

} {
    assessment_id:integer,notnull
    sort_order:integer,notnull
    direction:notnull
}

permission::permission_p -object_id $assessment_id -privilege admin

if { $direction=="up" } {
     set next_sort_order [expr { $sort_order - 1 }]
} else {
     set next_sort_order [expr { $sort_order + 1 }]
}

db_transaction {
    set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
    db_dml swap_sections {}
} on_error {
    ad_return_error "Database error" "A database error occured:<pre>$errmsg</pre>"
    ad_script_abort
}

ad_returnredirect [export_vars -base one-a {assessment_id}]
