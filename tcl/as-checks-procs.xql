<?xml version="1.0"?>
<queryset>

<fullquery name="as::assessment::check::get_assessments.assessment">
      <querytext>
      select cr.title ,ci.item_id as assessment_id from cr_folders cf, cr_items ci, cr_revisions cr, as_assessments a where cr.revision_id = ci.latest_revision and a.assessment_id = cr.revision_id and ci.parent_id = cf.folder_id and cf.package_id = :package_id order by cr.title

      </querytext>
</fullquery>

<fullquery name="as::assessment::check::intervals.today">
      <querytext>
      select to_date(now(),'YYYY-MM-DD')
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::intervals.yesterday">
      <querytext>
      select to_date (to_date(now(),'YYYY-MM-DD')-1,'YYYY-MM-DD')
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::intervals.two_days">
      <querytext>
      select to_date (to_date(now(),'YYYY-MM-DD')-2,'YYYY-MM-DD')
      </querytext>
</fullquery>
<fullquery name="as::assessment::check::intervals.last_week">
      <querytext>
      select to_date (to_date(now(),'YYYY-MM-DD')-7,'YYYY-MM-DD')
      </querytext>
</fullquery>
<fullquery name="as::assessment::check::intervals.last_month">
      <querytext>
      select to_date (to_date(now(),'YYYY-MM-DD')-30,'YYYY-MM-DD')
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::get_max_order.get_max_order">
      <querytext>
      select max(am.order_by) from as_action_map am,as_inter_item_checks c
      where c.inter_item_check_id=am.inter_item_check_id and
      c.section_id_from = :section_id and am.action_perform=:action_perform
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::get_parameter_value.get_param_n">
      <querytext>
      select item_id from as_param_map where parameter_id=:parameter_id and inter_item_check_id=:check_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::get_parameter_value.get_param_q">
      <querytext>
      select value from as_param_map where parameter_id=:parameter_id and inter_item_check_id=:check_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::set_parameter_value.param_value_update_n">
      <querytext>
      update as_param_map set item_id=:value where parameter_id=:parameter_id and inter_item_check_id=:check_id

      </querytext>
</fullquery>
<fullquery name="as::assessment::check::set_parameter_value.param_value_insert_n">
      <querytext>
      insert into  as_param_map (parameter_id,inter_item_check_id,value,item_id) values (:parameter_id,:check_id,null,:value)

      </querytext>
</fullquery>

<fullquery name="as::assessment::check::set_parameter_value.param_value_insert_q">
      <querytext>
      insert into  as_param_map (parameter_id,inter_item_check_id,value,item_id) values (:parameter_id,:check_id,:value,null)

      </querytext>
</fullquery>

<fullquery name="as::assessment::check::set_parameter_value.param_value_update_q">
      <querytext>
      update as_param_map set value=:value where parameter_id=:parameter_id and inter_item_check_id=:check_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::re_order_actions.get_order_by">
      <querytext>
      select order_by from as_action_map where inter_item_check_id=:check_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::re_order_actions.next_order">
      <querytext>	
      select c.inter_item_check_id from as_inter_item_checks c,as_action_map am where c.inter_item_check_id=am.inter_item_check_id and c.section_id_from = :section_id and am.action_perform=:action_perform and am.order_by > :order_by 
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::re_order_actions.update_order">
      <querytext>
      update as_action_map set order_by=:order where inter_item_check_id=:inter_item_check_id

      </querytext>
</fullquery>

<fullquery name="as::assessment::check::swap_actions.get_swap_check">
      <querytext>
      select c.inter_item_check_id from as_inter_item_checks  c ,as_action_map am  where c.inter_item_check_id=am.inter_item_check_id and am.order_by=:order and c.section_id_from=:section_id and am.action_perform=:action_perform
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::swap_actions.update_1">
      <querytext>
      update as_action_map set order_by=:order where inter_item_check_id=:check_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::swap_actions.update_2">
      <querytext>
      update as_action_map set order_by=:order_by where inter_item_check_id=:swap_check_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::swap_actions.get_swap_check_e">
      <querytext>
      select c.inter_item_check_id from as_inter_item_checks c,as_action_map am  where c.inter_item_check_id=am.inter_item_check_id and am.order_by=:order and c.section_id_from=:section_id and am.action_perform=:action_perform
      </querytext>
</fullquery>
<fullquery name="as::assessment::check::swap_actions.update_1_e">
      <querytext>
	update as_action_map set order_by=:order where inter_item_check_id=:check_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::swap_actions.update_2_e">
      <querytext>
      update as_action_map set order_by=:order_by where inter_item_check_id=:swap_check_id
      </querytext>
</fullquery>


<fullquery name="as::assessment::check::action_log.action_id">
      <querytext>
      select am.action_id from as_inter_item_checks c,as_action_map am where c.inter_item_check_id=am.inter_item_check_id and c.inter_item_check_id=:check_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::action_log.insert_action">
      <querytext>	
      insert into as_actions_log (action_log_id,inter_item_check_id,action_id,date_requested,date_processed,approved_p,failed_p,finally_executed_by,session_id) values (:log_id,:check_id,:action_id,now(),now(),'t',:failed,:user_id,:session_id)
      </querytext>
</fullquery>


<fullquery name="as::assessment::check::manual_action_log.action_id">
      <querytext>
        select am.action_id from as_inter_item_checks c,as_action_map am where c.inter_item_check_id=am.inter_item_check_id and c.inter_item_check_id=:check_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::manual_action_log.insert_action">
      <querytext>
       insert into as_actions_log (action_log_id,inter_item_check_id,action_id,date_requested,date_processed,approved_p,failed_p,finally_executed_by,session_id) values (:log_id,:check_id,:action_id,now(),null,'f','f',null,:session_id)
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::action_exec.get_check_params">
      <querytext>
       select * from as_param_map where inter_item_check_id = :inter_item_check_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::action_exec.select_name">
      <querytext>
      select varname from as_action_params where parameter_id = :parameter_id
      </querytext>
</fullquery>
<fullquery name="as::assessment::check::action_exec.get_answer">
      <querytext>
      select item_data_id, boolean_answer, clob_answer, numeric_answer,
      integer_answer, text_answer, timestamp_answer, content_answer
      from as_item_data
      where session_id = :session_id
      and as_item_id = :item_id
      </querytext>
</fullquery>
<fullquery name="as::assessment::check::manual_action_exec.get_answer">
      <querytext>
      select item_data_id, boolean_answer, clob_answer, numeric_answer,
      integer_answer, text_answer, timestamp_answer, content_answer
      from as_item_data
      where session_id = :session_id
      and as_item_id = :item_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::action_exec.get_item_choice">
      <querytext>
      select idc.choice_id from as_item_data_choices idc,as_item_data id where id.as_item_id=:item_id and id.item_data_id=idc.item_data_id and id.session_id=:session_id
      </querytext>
</fullquery>


<fullquery name="as::assessment::check::action_exec.select_tcl">
      <querytext>
      select a.tcl_code from as_actions a,as_action_map am where am.action_id = a.action_id and am.inter_item_check_id = :inter_item_check_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::manual_action_exec.get_check_params">
      <querytext>
       select * from as_param_map where inter_item_check_id = :inter_item_check_id 
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::manual_action_exec.select_name">
      <querytext>
      select varname from as_action_params where parameter_id = :parameter_id
      </querytext>
</fullquery>
<fullquery name="as::assessment::check::manual_action_exec.get_item_choice">
	   
      <querytext>
      select idc.choice_id from as_item_data_choices idc,as_item_data id where id.as_item_id=:item_id and id.item_data_id=idc.item_data_id and id.session_id=:session_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::manual_action_exec.select_tcl">
      <querytext>
      select a.tcl_code from as_actions a,as_action_map am where am.action_id = a.action_id and inter_item_check_id = :inter_item_check_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::manual_action_exec.update_actions_log">
      <querytext>
      update as_actions_log set failed_p=:failed_p,date_processed=now(),finally_executed_by=:user_id,approved_p='t' where action_log_id=:action_log_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::eval_i_checks.section_checks">
      <querytext>
        select c.inter_item_check_id,c.check_sql,action_p from as_inter_item_checks c,as_action_map am where c.inter_item_check_id=am.inter_item_check_id and am.action_perform='i' and  section_id_from=:section_id order by am.order_by
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::branch_checks.section_checks">
      <querytext>
      select * from as_inter_item_checks where action_p = 'f' and section_id_from=:section_id 
      </querytext>
</fullquery>
<fullquery name="as::assessment::check::branch_checks.get_order">
      <querytext>
        select sort_order from as_assessment_section_map where section_id=:section_id_to and assessment_id=:new_assessment_revision
      </querytext>
</fullquery>
<fullquery name="as::assessment::check::eval_aa_checks.get_assessment_id">
      <querytext>
        select max(revision_id) from cr_revisions where item_id=:assessment_id
      </querytext>
</fullquery>
<fullquery name="as::assessment::check::eval_aa_checks.sections">
      <querytext>
        select s.section_id from as_sections s, cr_revisions cr, cr_items ci, as_assessment_section_map asm where ci.item_id = cr.item_id and cr.revision_id = s.section_id and s.section_id = asm.section_id and asm.assessment_id =:assessment_rev_id order by asm.sort_order
      </querytext>
</fullquery>
<fullquery name="as::assessment::check::eval_aa_checks.section_checks">
      <querytext>
        select c.inter_item_check_id as check from as_inter_item_checks c,as_action_map am where c.inter_item_check_id=am.inter_item_check_id and am.action_perform='aa' and  section_id_from=:section_id order by am.order_by
      </querytext>
</fullquery>
<fullquery name="as::assessment::check::eval_aa_checks.check_info">
      <querytext>
        select * from as_inter_item_checks c,as_action_map am where
      c.inter_item_check_id=am.inter_item_check_id and am.action_perform='aa'
      and  section_id_from=:section_id and c.inter_item_check_id=:check order by am.order_by 
      </querytext>
</fullquery>


<fullquery name="as::assessment::check::eval_m_checks.get_assessment_id">
      <querytext>
      select max(revision_id) from cr_revisions where item_id=:assessment_id
      </querytext>
</fullquery>
<fullquery name="as::assessment::check::eval_m_checks.sections">
      <querytext>
        select s.section_id from as_sections s, cr_revisions cr, cr_items ci, as_assessment_section_map asm where ci.item_id = cr.item_id and cr.revision_id = s.section_id and s.section_id = asm.section_id and asm.assessment_id =:assessment_rev_id order by asm.sort_order
      </querytext>
</fullquery>
<fullquery name="as::assessment::check::eval_m_checks.section_checks">
      <querytext>
      select * from as_inter_item_checks c,as_action_map am where c.inter_item_check_id=am.inter_item_check_id and am.action_perform='m' and  section_id_from=:section_id order by am.order_by 
      </querytext>
</fullquery>
<fullquery name="as::assessment::check::confirm_display.get_check_info">
      <querytext>
      select * from as_inter_item_checks where inter_item_check_id=:check_id
      </querytext>
</fullquery>
<fullquery name="as::assessment::check::confirm_display.get_check_info_a">
      <querytext>
        select a.name as action_name from as_actions a, as_action_map am where inter_item_check_id=:check_id and a.action_id=am.action_id
      </querytext>
</fullquery>
<fullquery name="as::assessment::check::confirm_display.parameters">
      <querytext>
        select * from as_param_map pm,as_action_params p where pm.parameter_id=p.parameter_id and pm.inter_item_check_id=:check_id 
      </querytext>
</fullquery>
<fullquery name="as::assessment::check::confirm_display.get_section_name">
      <querytext>
        select cr.title from cr_revisions cr,as_sections s where cr.revision_id=s.section_id and s.section_id=:section_id_to
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::copy_checks.get_action_map">
      <querytext>
	select action_id,order_by,user_message,action_perform from as_action_map where inter_item_check_id=:inter_item_check_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::copy_checks.insert_action_map">
      <querytext>
	insert into as_action_map (inter_item_check_id,action_id,order_by,user_message,action_perform) values  
        (:insert_p,:action_id,:order_by,:user_message,:action_perform)
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::copy_checks.parameters">
      <querytext>
	select parameter_id,value,item_id from as_param_map 
	where inter_item_check_id=:inter_item_check_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::copy_checks.copy_parameter">
      <querytext>
	insert into as_param_map (parameter_id,value,item_id,inter_item_check_id) values (:parameter_id,:value,:item_id,:insert_p)
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::update_checks.checks">
      <querytext>
	select inter_item_check_id from as_inter_item_checks where section_id_to =:section_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::update_checks.update_check">
      <querytext>
	update as_inter_item_checks set section_id_to=:new_section_id where inter_item_check_id=:check_id
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::delete_assessment_checks.assessment_checks">
      <querytext>
        select inter_item_check_id from as_inter_item_checks where section_id_from in (select s.section_id from as_sections s, cr_revisions cr, cr_items ci, as_assessment_section_map asm where ci.item_id = cr.item_id and cr.revision_id = s.section_id and s.section_id = asm.section_id and asm.assessment_id =:assessment_rev_id)
      </querytext>
</fullquery>

</queryset>
