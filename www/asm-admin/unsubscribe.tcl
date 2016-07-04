ad_page_contract {

    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @creation_date 2005-01-19
    
} {
    inter_item_check_id:naturalnum,notnull
    request_id:naturalnum,multiple
    type_id:naturalnum,notnull     
    assessment_id:naturalnum,notnull
    section_id:naturalnum,notnull
} 

permission::require_permission \
    -object_id $assessment_id \
    -party_id [ad_conn user_id] \
    -privilege "admin"

set request_count [llength $request_id]
for { set i 0} { $i < $request_count } { incr i } {
    db_transaction {
	set r_id [lindex $request_id $i]
	db_dml remove_notify {}
    }
}

ad_returnredirect "request-notification?inter_item_check_id=$inter_item_check_id&type_id=$type_id&assessment_id=$assessment_id&section_id=$section_id"

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
