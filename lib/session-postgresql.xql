<?xml version="1.0"?>
<queryset>
	<rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="session_data">
      <querytext>
    SELECT percent_score, to_char(creation_datetime, :format) AS session_start,
           to_char(completed_datetime, :format) AS session_finish,
           round(date_part('epoch', completed_datetime - creation_datetime)) as session_time
    FROM as_sessions s
    WHERE s.session_id = :session_id
      </querytext>
</fullquery>

<fullquery name="get_latest_session">
     <querytext>
	select max(o.creation_date), s.session_id 
        from as_sessions s, 
        acs_objects o,
        cr_revisions cr
	where s.subject_id=:user_id
        and s.assessment_id in (select revision_id from cr_revisions where item_id= :assessment_id)
	and o.object_id = cr.item_id
        and s.session_id = cr.revision_id
	group by assessment_id, subject_id, session_id, o.creation_date
	order by o.creation_date desc
	limit 1
    </querytext>
</fullquery>

</queryset>
