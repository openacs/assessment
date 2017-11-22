<?xml version="1.0"?>
<queryset>

<rdbms><type>postgresql</type><version>7.2</version></rdbms>

<fullquery name="as::assessment::check::action_log.get_next_val">
      <querytext>
      
      select nextval('as_actions_log_action_log_id')

      </querytext>
</fullquery>

<fullquery name="as::assessment::check::manual_action_log.get_next_val">
      <querytext>
      select nextval('as_actions_log_action_log_id')
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::delete_assessment_checks.delete_checks">
      <querytext>
	select as_inter_item_check__delete (:check_id)
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::delete_item_checks.delete_check">
      <querytext>
	select as_inter_item_check__delete (:check_id)
      </querytext>
</fullquery>

</queryset>
