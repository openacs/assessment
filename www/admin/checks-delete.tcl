ad_page_contract {
    This page deletes checks
    @author Anny Flores (annyflores@viaro.net) Viaro Networks
    @date 2005-01-17
} {
    inter_item_check_id:multiple
    section_id
    assessment_id
  }
set count [llength $inter_item_check_id]

for { set i 0} { $i< $count } {incr i} {
    set check_id [lindex $inter_item_check_id $i]
    db_transaction {
	db_exec_plsql delete_check {}
    }
}
ad_returnredirect "checks-admin?assessment_id=$assessment_id&section_id=$section_id"