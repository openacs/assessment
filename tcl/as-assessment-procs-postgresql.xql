<?xml version="1.0"?>
<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>
		
<fullquery name="as::assessment::check_session_conditions.cur_wait_time">
	<querytext>

	select round(date_part('epoch', now() - completed_datetime)) as cur_wait_time
	from as_sessions
	where session_id = :last_session_id

	</querytext>
</fullquery>

<fullquery name="as::assessment::new.update_clobs">
    <querytext>
      update as_assessments set
      instructions=:instructions, consent_page=:consent_page
      where assessment_id=:as_assessment_id
    </querytext>
</fullquery>

<fullquery name="as::assessment::edit.update_clobs">
    <querytext>
      update as_assessments set
      instructions=:instructions, consent_page=:consent_page
      where assessment_id=:new_rev_id
    </querytext>
</fullquery>
  
<fullquery name="as::assessment::new_revision.update_clobs">
    <querytext>
      update as_assessments set
      instructions=:instructions, consent_page=:consent_page
      where assessment_id=:new_rev_id
    </querytext>
</fullquery>

</queryset>
