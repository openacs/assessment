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
	select inter_item_check_id,action_p,check_sql,postcheck_p,section_id_from,section_id_to,item_id,name,description,assessment_id from as_inter_item_checks where section_id_from=:section_id and assessment_id=:assessment_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::copy_checks.copy_check">
      <querytext>

 	select as_inter_item_check__new (null,:action_p,:section_id_from,null,:check_sql,:name,:description,:postcheck_p,null,:user_id,null,:assessment_id)	

      </querytext>
</fullquery>

<fullquery name="as::assessment::check::delete_assessment_checks.delete_checks">
      <querytext>
	select as_inter_item_check__delete (:check_id)
      </querytext>
</fullquery>
<fullquery name="as::assessment::check::intervals.intervals">
      <querytext>
      select to_date(now(),'YYYY-MM-DD') as today, to_date(to_date(now(),'YYYY-MM-DD')-1,'YYYY-MM-DD') as yesterday,  to_date (to_date(now(),'YYYY-MM-DD')-2,'YYYY-MM-DD') as two_days,to_date (to_date(now(),'YYYY-MM-DD')-7,'YYYY-MM-DD') as last_week, to_date (to_date(now(),'YYYY-MM-DD')-30,'YYYY-MM-DD') as last_month 
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::manual_action_exec.update_actions_log">
      <querytext>
      update as_actions_log set failed_p=:failed_p,date_processed=now(),finally_executed_by=:user_id,approved_p='t' where action_log_id=:action_log_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::action_log.insert_action">
      <querytext>	
      insert into as_actions_log (action_log_id,inter_item_check_id,action_id,date_requested,date_processed,approved_p,failed_p,finally_executed_by,session_id) values (:log_id,:check_id,:action_id,now(),now(),'t',:failed,:user_id,:session_id)
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::manual_action_log.insert_action">
      <querytext>
       insert into as_actions_log (action_log_id,inter_item_check_id,action_id,date_requested,date_processed,approved_p,failed_p,finally_executed_by,session_id) values (:log_id,:check_id,:action_id,now(),null,'f','f',null,:session_id)
      </querytext>
</fullquery>


</queryset>