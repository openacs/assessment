<?xml version="1.0"?>
<queryset>

	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="sessions_of_assessment">
		<querytext>
			SELECT s.session_id, s.name, s.title, s.completed_datetime,
			       p.first_names || ' ' || p.last_name AS subject_name,
			       a.title AS assessment_name, s.subject_id
			FROM as_sessionsx s, as_assessmentsx a, persons p
			WHERE s.assessment_id = :assessment_id
			AND s.assessment_id = a.assessment_id
			AND s.subject_id = p.person_id
		</querytext>
	</fullquery>

	<fullquery name="sessions_of_assessment_of_subject">
		<querytext>
			SELECT s.session_id, s.name, s.title, s.completed_datetime,
			       p.first_names || ' ' || p.last_name AS subject_name,
			       a.title AS assessment_name, s.subject_id
			FROM as_sessionsx s, as_assessmentsx a, persons p
			WHERE s.assessment_id = :assessment_id
			AND s.assessment_id = a.assessment_id
			AND s.subject_id = p.person_id
			AND s.subject_id = :subject_id
		</querytext>
	</fullquery>
	
</queryset>
