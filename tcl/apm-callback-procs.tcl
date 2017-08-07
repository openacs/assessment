ad_library {

    Procedures to do a new impl and aliases in the acs-sc.
    @creation-date 2004-11-24
    @author Anny Flores (annyflores@viaro.net)
}

namespace eval inter_item_checks::apm_callback {}

ad_proc -private inter_item_checks::apm_callback::package_install { 
} {
    Does the integration whith the notifications package. 
} {
    db_transaction {

	# Create the impl and aliases for one inter_item_check action
	set impl_id [create_inter_item_check_impl]

	# Create the notification type for one specific action
	set type_id [create_inter_item_check_type $impl_id]

	# Enable the delivery intervals and delivery methods for a specific INTER_ITEM_CHECK
	enable_intervals_and_methods $type_id
    
    # Service contract implementations - fts 
    as::sc::register_implementations
    }
}

ad_proc -private inter_item_checks::apm_callback::package_uninstall {
} {
    Remove the integration whith the notification package
} {

    db_transaction {

        # Delete the type_id for a specific INTER_ITEM_CHECK
        notification::type::delete -short_name inter_item_check_notif

        # Delete the implementation for the notification of one specific INTER_ITEM_CHECK
        delete_inter_item_check_impl

        # Delete service contract implementation
        as::sc::unregister_implementations
    }
}

ad_proc -public inter_item_checks::apm_callback::delete_inter_item_check_impl {} {
    Unregister the NotificationType implementation for inter_item_check_notif_type.
} {
    acs_sc::impl::delete \
        -contract_name "NotificationType" \
        -impl_name inter_item_check_notif_type
}
ad_proc -public inter_item_checks::apm_callback::create_inter_item_check_impl {} {
    Register the service contract implementation and return the impl_id
    @return impl_id of the created implementation 
} {
         return [acs_sc::impl::new_from_spec -spec {
	    name inter_item_check_notif_type
	    contract_name NotificationType
	    owner inter_item_check
	    aliases {
		GetURL inter_item_checks::notification::get_url
		ProcessReply inter_item_checks::notification::process_reply
	    }
	 }]
}

ad_proc -public inter_item_checks::apm_callback::create_inter_item_check_type {impl_id} {
    Create the notification type for one specific INTER_ITEM_CHECK
    @return the type_id of the created type
} {
    return [notification::type::new \
		-sc_impl_id $impl_id \
		-short_name inter_item_check_notif \
		-pretty_name "One INTER_ITEM_CHECK" \
		-description "Notification of execution  of one specific action in the inter_item_check"]
}

ad_proc -public inter_item_checks::apm_callback::enable_intervals_and_methods {type_id} {
    Enable the intervals and delivery methods of a specific type
} {
    # Enable the various intervals and delivery method

    notification::type::interval_enable \
	-type_id $type_id \
	-interval_id [notification::interval::get_id_from_name -name hourly]

    notification::type::interval_enable \
	-type_id $type_id \
	-interval_id [notification::interval::get_id_from_name -name daily]

    notification::type::interval_enable \
	-type_id $type_id \
	-interval_id [notification::interval::get_id_from_name -name instant]
    # Enable the delivery methods
    notification::type::delivery_method_enable \
	-type_id $type_id \
	-delivery_method_id [notification::delivery::get_id -short_name email]
}





# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
