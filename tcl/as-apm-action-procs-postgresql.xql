<?xml version="1.0"?>
<queryset>

    <rdbms><type>postgresql</type><version>7.2</version></rdbms>


    <fullquery name="as::actions::get_admin_user_id.select_user_id">
        <querytext>
            select user_id
            from users
            where acs_permission__permission_p(:context_root_id, user_id, 'admin') = 't'
            limit 1  
        </querytext>
    </fullquery>

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
