<?xml version="1.0"?>

<queryset>

    <fullquery name="assessment::notification_delivery::do_notification.select_assessment_name">
        <querytext>
        select assessment_name from 
        as_assessments where assessment_id = :assessment_id
        </querytext>
    </fullquery>

    <fullquery name="assessment::notification_delivery::do_notification.select_user_name">
        <querytext>
        select persons.first_names || ' ' || persons.last_name as name,
                                  parties.email        
                                  from persons, parties
                                  where person_id = :user_id
                                  and person_id = party_id
        </querytext>
    </fullquery>


</queryset>
