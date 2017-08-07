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

<fullquery name="as::assessment::check::manual_action_exec.update_actions_log">
      <querytext>
      update as_actions_log set failed_p=:failed_p,date_processed=now(),finally_executed_by=:user_id,approved_p='t' where action_log_id=:action_log_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::action_log.insert_action">
      <querytext>	
      insert into as_actions_log (action_log_id,inter_item_check_id,action_id,date_requested,date_processed,approved_p,failed_p,finally_executed_by,session_id,error_txt) values (:log_id,:check_id,:action_id,now(),now(),'t',:failed,:user_id,:session_id,:message)
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::manual_action_log.insert_action">
      <querytext>
       insert into as_actions_log (action_log_id,inter_item_check_id,action_id,date_requested,date_processed,approved_p,failed_p,finally_executed_by,session_id,error_txt) values (:log_id,:check_id,:action_id,now(),null,'f','f',null,:session_id,:message)
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::delete_item_checks.delete_check">
      <querytext>
	select as_inter_item_check__delete (:check_id)
      </querytext>
</fullquery>


</queryset>
