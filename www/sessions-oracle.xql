<?xml version="1.0"?>
<queryset>

	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="sessions_of_assessment">
		<querytext>
			SELECT s.session_id, s.completed_datetime, s.percent_score,
			       p.first_names || ' ' || p.last_name AS subject_name,
			       r.title AS assessment_name, s.subject_id
			FROM as_sessions s, cr_revisions r, persons p
			WHERE s.assessment_id = r.revision_id
			AND s.subject_id = p.person_id
			AND s.subject_id = :subject_id
			AND r.item_id = :assessment_id
			ORDER BY s.completed_datetime desc, s.creation_datetime desc
		</querytext>
	</fullquery>	

	<fullquery name="sessions_of_assessment_of_subject">
		<querytext>
			SELECT s.session_id, s.completed_datetime, s.percent_score,
			       p.first_names || ' ' || p.last_name AS subject_name,
			       r.title AS assessment_name, s.subject_id
			FROM as_sessions s, cr_revisions r, persons p
			WHERE s.assessment_id = r.revision_id
			AND s.subject_id = p.person_id
			AND r.item_id = :assessment_id
			ORDER BY s.completed_datetime desc, s.creation_datetime desc
		</querytext>
	</fullquery>	
	
</queryset>
