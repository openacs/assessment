<?xml version="1.0"?>
<queryset>

<fullquery name="assessment_results_orig">
	<querytext>
	select s.session_id, s.subject_id, s.percent_score,
	       to_char(s.completed_datetime, :format) as completed_datetime,
	       p.last_name || ', ' || p.first_names AS subject_name,
	       :assessment_id as assessment_id
	from as_sessions s, persons p,
		(select max(s2.session_id) as session_id, s2.subject_id
		from as_sessions s2, cr_revisions r
		where r.item_id = :assessment_id
		and s2.assessment_id = r.revision_id
		and s2.completed_datetime is not null
		group by s2.subject_id) sub
	where s.session_id = sub.session_id
	and sub.subject_id = p.person_id
	$start_date_sql
	$end_date_sql
	order by s.completed_datetime
	</querytext>
</fullquery>

<fullquery name="get_session_score">
    <querytext>
        select sum(coalesce(points,0))
         from as_item_data where session_id=:session_id
    </querytext>
</fullquery>

<fullquery name="get_max_points">
    <querytext>
        select sum(coalesce(i.points,0)) from as_items i, as_item_data d where d.session_id = :session_id and i.as_item_id = d.as_item_id
    </querytext>
</fullquery>

</queryset>
