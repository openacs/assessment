<?xml version="1.0"?>
<queryset>

	<rdbms><type>postgresql</type><version>7.1</version></rdbms>

	<fullquery name="sessions_of_assessment">
		<querytext>
			SELECT s.session_id, s.name, s.title, s.completed_datetime, s.percent_score,
			       p.first_names || ' ' || p.last_name AS subject_name,
			       a.title AS assessment_name, s.subject_id
			FROM as_sessionsx s INNER JOIN as_assessmentsx a USING (assessment_id)
			INNER JOIN persons p ON (s.subject_id = p.person_id)
			WHERE s.assessment_id = :assessment_rev_id
			AND s.subject_id = :subject_id
			ORDER BY s.completed_datetime desc, s.creation_datetime desc
		</querytext>
	</fullquery>	

	<fullquery name="sessions_of_assessment_of_subject">
		<querytext>
			SELECT s.session_id, s.name, s.title, s.completed_datetime, s.percent_score,
			       p.first_names || ' ' || p.last_name AS subject_name,
			       a.title AS assessment_name, s.subject_id
			FROM as_sessionsx s INNER JOIN as_assessmentsx a USING (assessment_id)
			INNER JOIN persons p ON (s.subject_id = p.person_id)
			WHERE s.assessment_id = :assessment_rev_id
			ORDER BY s.completed_datetime desc, s.creation_datetime desc
		</querytext>
	</fullquery>	

</queryset>
