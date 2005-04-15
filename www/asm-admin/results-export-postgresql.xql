<?xml version="1.0"?>
<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<partialquery name="restrict_completed_date">
      <querytext>

	and s.completed_datetime >= $start_time
	and date_trunc('day', s.completed_datetime) <= $end_time

      </querytext>
</partialquery>

</queryset>
