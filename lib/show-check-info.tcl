ad_page_contract {
    This page shows the check information to be deleted

    @author Anny Flores (annyflores@viaro.net) Viaro Networks
    @creation-date 2005-01-17
    
} {
    inter_item_check_id:naturalnum,multiple
    section_id:naturalnum,notnull
    assessment_id:naturalnum,notnull
    type_check
}

set inter_item_check_id [split $inter_item_check_id " "]
set count [llength $inter_item_check_id]
set display_info ""

for { set i 0} { $i< $count } {incr i} {
    set check_id [lindex $inter_item_check_id $i]
    append display_info [as::assessment::check::confirm_display -check_id $check_id -index $i]
}



# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
