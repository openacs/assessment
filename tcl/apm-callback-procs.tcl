ad_library {

    Procedures to do a new impl and aliases in the acs-sc.
    @creation date 2005-01-19
    @author Anny Flores (annyflores@viaro.net)
}

namespace eval inter_item_checks::apm_callback {}

ad_proc -private inter_item_checks::apm_callback::package_install { 
} {
    Does the integration whith the notifications package. 
} {
    db_transaction {

	# Create the impl and aliases for one as_inter_item_checks action
	set impl_id [create_as_inter_item_checks_impl]

	# Create the notification type for one specific action
	set type_id [create_as_inter_item_checks_type $impl_id]

	# Enable the delivery intervals and delivery methods for a specific AS_INTER_ITEM_CHECKS
	enable_intervals_and_methods $type_id

    }
}

ad_proc -private inter_item_checks::apm_callback::after_upgrade { 
    {-from_version_name:required}
    {-to_version_name:required}
} {
    Does the integration whith the notifications package. 
} {
    apm_upgrade_logic -from_version_name $from_version_name -to_version_name $to_version_name\
	-spec { 
	    0.07d 0.08d {
		
		db_transaction {
		    
		    # Create the impl and aliases for one as_inter_item_checks action
		    set impl_id [create_as_inter_item_checks_impl]
		    
		    # Create the notification type for one specific action
		    set type_id [create_as_inter_item_checks_type $impl_id]
		    
		    # Enable the delivery intervals and delivery methods for a specific AS_INTER_ITEM_CHECKS
		    enable_intervals_and_methods $type_id
		    
		}
		
	    }
	}
}

ad_proc -private inter_item_checks::apm_callback::package_uninstall {
} {
    Remove the integration whith the notification package
} {

    db_transaction {

        # Delete the type_id for a specific AS_INTER_ITEM_CHECKS
        notification::type::delete -short_name as_inter_item_checks_notif

        # Delete the implementation for the notification of one specific AS_INTER_ITEM_CHECKS
        delete_as_inter_item_checks_impl
	
	# Delete the type_id for all inter_item_checks
        notification::type::delete -short_name as_inter_item_checks_notif


    }  
}

ad_proc -public inter_item_checks::apm_callback::delete_as_inter_item_checks_impl {} {
    Unregister the NotificationType implementation for as_inter_item_checks_notif_type.
} {
    acs_sc::impl::delete \
        -contract_name "NotificationType" \
        -impl_name as_inter_item_checks_notif_type
}
ad_proc -public inter_item_checks::apm_callback::create_as_inter_item_checks_impl {} {
    Register the service contract implementation and return the impl_id
    @return impl_id of the created implementation 
} {
         return [acs_sc::impl::new_from_spec -spec {
	    name as_inter_item_checks_notif_type
	    contract_name NotificationType
	    owner as_inter_item_checks
	    aliases {
		GetURL inter_item_checks::notification::get_url
		ProcessReply inter_item_checks::notification::process_reply
	    }
	 }]
}

ad_proc -public inter_item_checks::apm_callback::create_as_inter_item_checks_type {impl_id} {
    Create the notification type for one specific AS_INTER_ITEM_CHECKS
    @return the type_id of the created type
} {
    return [notification::type::new \
		-sc_impl_id $impl_id \
		-short_name as_inter_item_checks_notif \
		-pretty_name "One AS_INTER_ITEM_CHECKS" \
		-description "Notification of execution  of one specific action in the as_inter_item_checks"]
}

ad_proc -public inter_item_checks::apm_callback::enable_intervals_and_methods {type_id} {
    Enable the intervals and delivery methods of a specific type
} {
    # Enable the various intervals and delivery method
    notification::type::interval_enable \
	-type_id $type_id \
	-interval_id [notification::interval::get_id_from_name -name instant]

    notification::type::interval_enable \
	-type_id $type_id \
	-interval_id [notification::interval::get_id_from_name -name hourly]

    notification::type::interval_enable \
	-type_id $type_id \
	-interval_id [notification::interval::get_id_from_name -name daily]

    # Enable the delivery methods
    notification::type::delivery_method_enable \
	-type_id $type_id \
	-delivery_method_id [notification::delivery::get_id -short_name email]
}


