<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="session_data">
      <querytext>
    SELECT percent_score, to_char(creation_datetime, :format) AS session_start,
           to_char(completed_datetime, :format) AS session_finish,
           round(86400 * (completed_datetime-creation_datetime)) AS session_time
    FROM as_sessions s
    WHERE s.session_id = :session_id
      </querytext>
</fullquery>

</queryset>
