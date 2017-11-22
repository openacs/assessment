<?xml version="1.0"?>
<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>
	
<fullquery name="as::assessment::check_session_conditions.cur_wait_time">
	<querytext>

	select round(86400 * (sysdate - completed_datetime)) as cur_wait_time
	from as_sessions
	where session_id = :last_session_id

	</querytext>
</fullquery>
	
<fullquery name="as::assessment::new.update_clobs">
    <querytext>
      update as_assessments set
      instructions=empty_clob(),consent_page=empty_clob()
      where assessment_id=:as_assessment_id
      returning instructions, consent_page into :1, :2
    </querytext>
</fullquery>

<fullquery name="as::assessment::edit.update_clobs">
    <querytext>
      update as_assessments set
      instructions=empty_clob(),consent_page=empty_clob()
      where assessment_id=:new_rev_id
      returning instructions, consent_page into :1, :2
    </querytext>
</fullquery>
  
<fullquery name="as::assessment::new_revision.update_clobs">
    <querytext>
      update as_assessments set
      instructions=empty_clob(),consent_page=empty_clob()
      where assessment_id=:new_rev_id
      returning instructions, consent_page into :1, :2
    </querytext>
</fullquery>
  
</queryset>
