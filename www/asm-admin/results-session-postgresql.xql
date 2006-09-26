<?xml version="1.0"?>
<queryset>
	<rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="session_data">
      <querytext>
    SELECT percent_score, creation_datetime, completed_datetime,
           round(date_part('epoch', completed_datetime - creation_datetime)) as session_time
    FROM as_sessions s
    WHERE s.session_id = :session_id
      </querytext>
</fullquery>

</queryset>
