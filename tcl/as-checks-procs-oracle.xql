<?xml version="1.0"?>
<queryset>

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


<fullquery name="as::assessment::check::copy_checks.copy_check">
      <querytext>
	     declare begin
        :1 := as_inter_item_check.new (
		inter_item_check_id	=>     	 null,
		name			=> 	:name,
		action_p		=>	:action_p,
		section_id_from 	=>	:section_id_from,
		section_id_to		=>	:section_id_to,
		check_sql		=>	:check_sql,
		description		=>	:description,
		postcheck_p		=>	:postcheck_p,
		item_id			=>	null,
		assessment_id		=>	:assessment_id,
		creation_user		=>	:user_id,
		context_id		=>	null,
		object_type		=>	'as_inter_item_checks',
		creation_date		=>	:date
		);
	end;
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::delete_assessment_checks.delete_checks">
      <querytext>
	begin
	 as_inter_item_check.delete(:check_id);
	end;

      </querytext>
</fullquery>

<fullquery name="as::assessment::check::intervals.intervals">
      <querytext>
	
      select to_date(sysdate,'YYYY-MM-DD') as today, to_date(sysdate-1,'YYYY-MM-DD') as yesterday,  to_date (sysdate-2,'YYYY-MM-DD') as two_days,to_date (sysdate-7,'YYYY-MM-DD') as last_week, to_date (sysdate-30,'YYYY-MM-DD') as last_month from dual 
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


</queryset>