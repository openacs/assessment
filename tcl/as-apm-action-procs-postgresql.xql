<?xml version="1.0"?>
<queryset>

    <fullquery name="as::actions::insert_actions.insert_default">
        <querytext>
		  select as_action__default_actions ($package_id,$user_id,$package_id)
        </querytext>
    </fullquery>


    <fullquery name="as::actions::insert_actions_after_upgrade.after_upgrade">
        <querytext>
		  select as_action__create_action_object ()
        </querytext>
    </fullquery>
</queryset>
