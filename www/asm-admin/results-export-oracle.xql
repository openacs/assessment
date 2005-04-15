<?xml version="1.0"?>
<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<partialquery name="restrict_completed_date">
      <querytext>

	and s.completed_datetime >= $start_time
	and trunc(s.completed_datetime) <= $end_time

      </querytext>
</partialquery>

</queryset>
