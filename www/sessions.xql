<?xml version="1.0"?>
<queryset>

	<rdbms><type>postgresql</type><version>7.1</version></rdbms>

	<fullquery name="sessions_of_assessment">
		<querytext>
			SELECT as_sessionsx.session_id, as_sessionsx.name, as_sessionsx.title, persons.first_names, persons.last_name
			FROM as_sessionsx INNER JOIN persons ON as_sessionsx.subject_id = persons.person_id
			WHERE as_sessionsx.assessment_id=:assessment_id
		</querytext>
	</fullquery>
	
</queryset>
