<?xml version="1.0"?>
<queryset>

	<rdbms><type>postgresql</type><version>7.1</version></rdbms>

	<fullquery name="sessions_of_assessment">
		<querytext>
			SELECT r.item_id as assessment_id, s.session_id, s.percent_score,
			       to_char(s.completed_datetime, :format) as completed_datetime,
			       p.first_names || ' ' || p.last_name AS subject_name,
			       r.title AS assessment_name, s.subject_id,
			       to_char(a.start_time, 'YYYY-MM-DD HH24:MI:SS') as start_time,
			       to_char(a.end_time, 'YYYY-MM-DD HH24:MI:SS') as end_time,
			       to_char(now(), 'YYYY-MM-DD HH24:MI:SS') as cur_time
			FROM as_sessions s, cr_revisions r, persons p, as_assessments a
			WHERE s.assessment_id = r.revision_id
			AND s.subject_id = p.person_id
			AND s.subject_id = :subject_id
			AND r.item_id = :assessment_id
			and a.assessment_id = :assessment_rev_id
			ORDER BY s.session_id desc
		</querytext>
	</fullquery>	

	<fullquery name="sessions_of_assessment_of_subject">
		<querytext>
			SELECT r.item_id as assessment_id, s.session_id, s.percent_score,
			       to_char(s.completed_datetime, :format) as completed_datetime,
			       p.first_names || ' ' || p.last_name AS subject_name,
			       r.title AS assessment_name, s.subject_id,
			       to_char(a.start_time, 'YYYY-MM-DD HH24:MI:SS') as start_time,
			       to_char(a.end_time, 'YYYY-MM-DD HH24:MI:SS') as end_time,
			       to_char(now(), 'YYYY-MM-DD HH24:MI:SS') as cur_time
			FROM as_sessions s, cr_revisions r, persons p, as_assessments a
			WHERE s.assessment_id = r.revision_id
			AND s.subject_id = p.person_id
			AND r.item_id = :assessment_id
			and a.assessment_id = :assessment_rev_id
			ORDER BY s.session_id desc
		</querytext>
	</fullquery>	

</queryset>
