<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.7</version></rdbms>

<fullquery name="session_data">
      <querytext>
    SELECT percent_score, to_char(creation_datetime, :format) AS session_start,
           to_char(completed_datetime, :format) AS session_finish,
           round ((completed_datetime - creation_datetime)* 1440 ) as
      session_time
    FROM as_sessions s
    WHERE s.session_id = :session_id
      </querytext>
</fullquery>

<fullquery name="get_latest_session">
     <querytext>
	select * from (select max(o.creation_date), s.session_id 
        from as_sessions s, 
        acs_objects o,
        cr_revisions cr
	where s.subject_id=:user_id
        and s.assessment_id in (select revision_id from cr_revisions where item_id= :assessment_id)
	and o.object_id = cr.item_id
        and s.session_id = cr.revision_id
	group by assessment_id, subject_id, session_id)
	order by o.creation_date desc
	where rownum=1
    </querytext>
</fullquery>

</queryset>
