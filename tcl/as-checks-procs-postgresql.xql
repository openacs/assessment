<?xml version="1.0"?>
<queryset>

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

<fullquery name="as::assessment::check::copy_checks.get_checks">
      <querytext>
	select inter_item_check_id,action_p,check_sql,postcheck_p,section_id_from,section_id_to,item_id,name,description from as_inter_item_checks where section_id_from=:section_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::copy_checks.copy_check">
      <querytext>

 	select as_inter_item_check__new (null,:action_p,:section_id_from,null,:check_sql,:name,:description,:postcheck_p,null,:user_id,null)	

      </querytext>
</fullquery>

<fullquery name="as::assessment::check::delete_assessment_checks.delete_checks">
      <querytext>
	select as_inter_item_check__delete (:check_id)
      </querytext>
</fullquery>

</queryset>