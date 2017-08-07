ad_page_contract {
    This page deletes checks
    @author Anny Flores (annyflores@viaro.net) Viaro Networks
    @date 2005-01-17
} {
    inter_item_check_id:naturalnum,multiple
    section_id:naturalnum,notnull
    assessment_id:naturalnum,notnull
    by_item_p:boolean
    item_id:naturalnum,optional
  }

permission::require_permission \
    -object_id $assessment_id \
    -party_id [ad_conn user_id] \
    -privilege admin

set inter_item_check_id [split [lindex $inter_item_check_id 0] " "]

set count [llength $inter_item_check_id]

for { set i 0} { $i< $count } {incr i} {
    set check_id [lindex $inter_item_check_id $i]
    db_transaction {
	db_exec_plsql delete_check {}
    }
}
if {$by_item_p == 1} {
    ad_returnredirect "checks-admin?section_id=$section_id&assessment_id=$assessment_id&by_item_p=$by_item_p&item_id=$item_id"
} else {
    ad_returnredirect "checks-admin?section_id=$section_id&assessment_id=$assessment_id&by_item_p=$by_item_p"
}
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
