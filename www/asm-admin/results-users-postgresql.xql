<?xml version="1.0"?>
<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<partialquery name="restrict_start_date">
      <querytext>

	and (s.completed_datetime >= $start_time
            or s.completed_datetime is null)
      </querytext>
</partialquery>

<partialquery name="restrict_end_date">
      <querytext>

	and (date_trunc('day', s.completed_datetime) <= $end_time
             or $end_time > now ())

      </querytext>
</partialquery>

</queryset>
