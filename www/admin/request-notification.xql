<?xml version="1.0"?>
<queryset>

    <fullquery name="notify_users">
        <querytext>
        select p.first_names || ' ' || p.last_name as name,nr.request_id,
        (select name from notification_intervals where interval_id=
        nr.interval_id) as interval_name ,(select short_name from
        notification_delivery_methods where
        delivery_method_id=nr.delivery_method_id) as delivery_name
                                  from persons p, notification_requests nr
                                  where p.person_id = nr.user_id and
                                  nr.object_id = :inter_item_check_id

        </querytext>
    </fullquery>

    <fullquery name="get_name">
        <querytext>
	  select name from as_inter_item_checks where inter_item_check_id=:inter_item_check_id
        </querytext>
    </fullquery>



</queryset>
