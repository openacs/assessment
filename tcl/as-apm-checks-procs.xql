<?xml version="1.0"?>
<queryset>

    <fullquery name="inter_item_checks::notification_delivery::do_notification.select_inter_item_check_name">
        <querytext>
        select inter_item_check_name from 
        inter_item_checks where inter_item_check_id = :inter_item_check_id
        </querytext>
    </fullquery>

    <fullquery name="inter_item_checks::notification_delivery::do_notification.select_user_name">
        <querytext>
        select persons.first_names || ' ' || persons.last_name as name,
                                  parties.email        
                                  from persons, parties
                                  where person_id = :user_id
                                  and person_id = party_id
        </querytext>
    </fullquery>


</queryset>
