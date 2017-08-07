ad_page_contract {

  Swaps two items for a section, sort_order and sort_order - 1.

  @param  section_id  specifies the assessment section
  @param  sort_order  position of item to be moved up or down

  @author timo@timohentschel.de

  @cvs-id $Id: item-swap.tcl

} {
    assessment_id:naturalnum,notnull
    section_id:naturalnum,notnull
    sort_order:integer,notnull
    direction:notnull
    return_url:localurl,optional
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin
db_1row get_item_id {}
if { $direction=="up" } {
     set next_sort_order [expr { $sort_order - 1 }]
} else {
     set next_sort_order [expr { $sort_order + 1 }]
}

db_transaction {
    set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
    set new_section_id [as::section::new_revision -section_id $section_id -assessment_id $assessment_id]
    as::section::update_section_in_assessment\
                -old_section_id $section_id \
                -new_section_id $new_section_id \
                -new_assessment_rev_id $new_assessment_rev_id
    db_dml swap_items {}
} on_error {
    ad_return_error "Database error" "A database error occurred:<pre>$errmsg</pre>"
    ad_script_abort
}

if {![info exists return_url] || $return_url eq ""} {
    set return_url [export_vars -base questions {return_url assessment_id}]\#$as_item_id
}

ad_returnredirect $return_url
ad_script_abort


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
