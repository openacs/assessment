ad_page_contract {

    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @creation_date 2005-01-19
    
} {
    inter_item_check_id:notnull
    request_id:multiple
    type_id     
    assessment_id
    section_id
} 

set request_count [llength $request_id]
for { set i 0} { $i < $request_count } { incr i } {
    db_transaction {
	set r_id [lindex $request_id $i]
	db_dml remove_notify { *SQL* }
    }
}

ad_returnredirect "request-notification?inter_item_check_id=$inter_item_check_id&type_id=$type_id&assessment_id=$assessment_id&section_id=$section_id"
