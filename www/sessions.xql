<?xml version="1.0"?>
<queryset>

	<rdbms><type>postgresql</type><version>7.1</version></rdbms>

	<fullquery name="sessions_of_assessment">
		<querytext>
			SELECT as_sessionsx.session_id, as_sessionsx.name, as_sessionsx.title, as_sessionsx.completed_datetime, as_sessionsx.subject_id, persons.first_names || ' ' || persons.last_name AS subject_name, as_assessmentsx.title AS assessment_name
			FROM (as_sessionsx INNER JOIN as_assessments ON as_sessionsx.assessment_id = as_assessments.assessment_id) INNER JOIN persons ON as_sessionsx.subject_id = persons.person_id
			WHERE as_sessionsx.assessment_id=:assessment_id
		</querytext>
	</fullquery>
	
</queryset>
