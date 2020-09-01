<?xml version="1.0"?>
<queryset>

    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="as::actions::insert_actions.insert_default">
        <querytext>
		begin 
		  as_action.default_actions($package_id,$user_id);
		end;
        </querytext>
    </fullquery>


    <fullquery name="as::actions::insert_actions_after_upgrade.after_upgrade">
        <querytext>
		  begin
		  as_action.create_action_object ();
		  end;
        </querytext>
    </fullquery>
</queryset>
