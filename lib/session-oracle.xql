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

</queryset>
