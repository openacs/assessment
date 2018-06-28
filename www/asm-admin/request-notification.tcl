ad_page_contract {

    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @creation-date 2005-01-19

} {
  inter_item_check_id:naturalnum,notnull
  assessment_id:naturalnum,notnull
  section_id:naturalnum,notnull
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin
as::assessment::data -assessment_id $assessment_id
set title "$assessment_data(title)"


set context [list [list "one-a?assessment_id=$assessment_id" $title] [list "checks-admin?assessment_id=$assessment_id&section_id=$section_id" "$title [_ assessment.Administration]"] "[_ assessment.Request] [_ assessment.Notification]"]

form create notify
set type "inter_item_check_notif"
set type_id [notification::type::get_type_id -short_name $type]
set intervals [notification::get_intervals -type_id $type_id]
set delivery_methods [notification::get_delivery_methods -type_id $type_id]


element create notify assessment_id\
    -widget hidden\
    -value $assessment_id
element create notify section_id\
    -widget hidden\
    -value $section_id
element create notify inter_item_check_id\
    -widget hidden\
    -value $inter_item_check_id
element create notify party_id \
    -widget party_search \
    -datatype party_search \
    -label User
element create notify interval_id\
    -widget select\
    -datatype text\
    -label  "[_ notifications.lt_Notification_Interval]"\
    -options $intervals

element create notify delivery_method_id\
    -datatype integer \
    -widget select\
    -label  "[_ notifications.Delivery_Method]"\
    -options $delivery_methods\
    -value [lindex $delivery_methods 0 1]


if {[template::form is_valid notify]} {
    template::form get_values notify party_id interval_id assessment_id section_id delivery_method_id
 # Add the subscribe
    notification::request::new \
            -type_id $type_id \
            -user_id $party_id \
            -object_id $inter_item_check_id \
            -interval_id $interval_id \
            -delivery_method_id $delivery_method_id

    ad_returnredirect [export_vars -base request-notification {assessment_id section_id inter_item_check_id}]
    ad_script_abort
}

template::list::create -name notify_users\
    -multirow notify_users \
    -key request_id \
    -bulk_actions {
	"\#assessment.unsubscribe\#" "unsubscribe" "\#assessment.unsubscribe_user\#"
    } \
    -bulk_action_method post -bulk_action_export_vars {
	inter_item_check_id
	type_id
	assessment_id
	section_id
    } \
    -no_data "\#assessment.there_are_no_users\#" \
    -row_pretty_plural "notify_users" \
    -elements {
	name {
	    label "[_ assessment.User_ID] [_ assessment.Name]"
	}
	interval_name {
	    label "[_ notifications.lt_Notification_Interval]"
	}
	delivery_name {
	    label "[_ notifications.Delivery_Method]"
	}
    }

db_multirow -extend {name} notify_users notify_users {
    select nr.user_id,
           (select name from notification_intervals
             where interval_id = nr.interval_id) as interval_name,
           (select short_name from notification_delivery_methods
             where delivery_method_id = nr.delivery_method_id) as delivery_name
      from notification_requests nr
     where nr.object_id = :inter_item_check_id
} {
    set name [person::name -person_id $user_id]
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
