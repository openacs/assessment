ad_library {
    @author Anny Flores (annyflores@viaro.net)
    @creation-date 2004-12-03

    Inter_Item_Check Library - Reply Handling
}


namespace eval inter_item_checks::notification_delivery {

    ad_proc -public do_notification {
        -inter_item_check_id
        -user_id
        -interval_id
    } {
    } {        
	db_1row select_inter_item_check_name {
            select inter_item_check_name
            from inter_item_checks
            where inter_item_check_id = :inter_item_check_id
        }
        
        # Notifies the users that requested notification for the specific INTER_ITEM_CHECK

	set method_id [notification::get_delivery_method_id -name "email"]
        set type_id [notification::type::get_type_id \
                         -short_name inter_item_check_notif]
        
	notification::new \
	    -type_id $type_id \
	    -object_id $inter_item_check_id \
	    -notif_subject "Testing notification"\
	    -notif_text "It works"
	
	notification::request::new \
	    -type_id $type_id \
	    -object_id $inter_item_check_id \
	    -user_id $user_id \
	    -interval_id $interval_id \
	    -delivery_method_id $method_id		
    }
    
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
