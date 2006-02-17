<?xml version="1.0"?>
<queryset>

<fullquery name="update_start_time">
<querytext>

	    update as_assessments
	    set start_time = $start_time
	    where assessment_id = :assessment_rev_id

</querytext>
</fullquery>

<fullquery name="update_end_time">
<querytext>

	    update as_assessments
	    set end_time = $end_time
	    where assessment_id = :assessment_rev_id

</querytext>
</fullquery>

</queryset>
