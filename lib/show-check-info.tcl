ad_page_contract {
    This page shows the check information to be deleted

    @author Anny Flores (annyflores@viaro.net) Viaro Networks
    @date 2005-01-17
    
} {
    inter_item_check_id:multiple
    section_id
    assessment_id
    type_check
}

set inter_item_check_id [split $inter_item_check_id " "]
set count [llength $inter_item_check_id]
set display_info ""

for { set i 0} { $i< $count } {incr i} {
    set check_id [lindex $inter_item_check_id $i]
    append display_info [as::assessment::check::confirm_display -check_id $check_id -index $i]
}


