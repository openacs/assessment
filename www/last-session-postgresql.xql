<?xml version="1.0"?>
<queryset>

	<rdbms><type>postgresql</type><version>7.1</version></rdbms>

	<fullquery name="sessions_of_assessment">
		<querytext>
			SELECT s.session_id, s.name, s.title, s.completed_datetime, s.percent_score,
			       p.first_names || ' ' || p.last_name AS subject_name,
			       a.title AS assessment_name, s.subject_id, a.survey_p
			FROM as_sessionsx s, as_assessmentsx a, persons p
			WHERE s.assessment_id = a.assessment_id
			AND s.subject_id = p.person_id
			AND s.assessment_id = :assessment_id
			AND s.last_mod_datetime IN (
			    SELECT max(s.last_mod_datetime) as last_mod_datetime
			    FROM as_sessionsx s, as_assessmentsx a, persons p
			    WHERE s.assessment_id = a.assessment_id
			    AND s.subject_id = p.person_id
			    AND s.assessment_id = :assessment_id
			    GROUP BY s.subject_id
			) 			 
		</querytext>
	</fullquery>

	<fullquery name="sessions_of_assessment_of_subject">
		<querytext>
			SELECT s.session_id, s.name, s.title, s.completed_datetime, s.percent_score,
			       p.first_names || ' ' || p.last_name AS subject_name,
			       a.title AS assessment_name, s.subject_id, a.survey_p
			FROM as_sessionsx s, as_assessmentsx a, persons p
			WHERE s.assessment_id = a.assessment_id
			AND s.subject_id = p.person_id
			AND s.assessment_id = :assessment_id			
			AND s.subject_id = :subject_id
			AND s.last_mod_datetime IN (
			    SELECT max(s.last_mod_datetime) as last_mod_datetime
			    FROM as_sessionsx s, as_assessmentsx a, persons p
			    WHERE s.assessment_id = a.assessment_id
			    AND s.subject_id = p.person_id
			    AND s.assessment_id = :assessment_id
			    AND s.subject_id = :subject_id
			    GROUP BY s.subject_id
			)
		</querytext>
	</fullquery>	
</queryset>
