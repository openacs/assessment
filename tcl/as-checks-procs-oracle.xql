<?xml version="1.0"?>
<queryset>

<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="as::assessment::check::action_log.get_next_val">
      <querytext>
      
      select action_log_id_seq.nextval from dual

      </querytext>
</fullquery>

<fullquery name="as::assessment::check::manual_action_log.get_next_val">
      <querytext>
	      select action_log_id_seq.nextval from dual

      </querytext>
</fullquery>

<fullquery name="as::assessment::check::delete_assessment_checks.delete_checks">
      <querytext>
	begin
	 as_inter_item_check.del(:check_id);
	end;

      </querytext>
</fullquery>

<fullquery name="as::assessment::check::manual_action_exec.update_actions_log">
      <querytext>
      update as_actions_log set failed_p=:failed_p,date_processed=(select sysdate from dual),finally_executed_by=:user_id,approved_p='t' where action_log_id=:action_log_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::action_log.insert_action">
      <querytext>	
      insert into as_actions_log (action_log_id,inter_item_check_id,action_id,date_requested,date_processed,approved_p,failed_p,finally_executed_by,session_id,error_txt) values (:log_id,:check_id,:action_id,(select sysdate from dual),(select sysdate from dual),'t',:failed,:user_id,:session_id,:message)
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::manual_action_log.insert_action">
      <querytext>
       insert into as_actions_log (action_log_id,inter_item_check_id,action_id,date_requested,date_processed,approved_p,failed_p,finally_executed_by,session_id,error_txt) values (:log_id,:check_id,:action_id,(select sysdate from dual),null,'f','f',null,:session_id,:message)
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::delete_item_checks.delete_check">
      <querytext>
	begin
	 as_inter_item_check.del(:check_id);
	end;
      </querytext>
</fullquery>



</queryset>
