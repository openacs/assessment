<?xml version="1.0"?>
<queryset>

<fullquery name="as::assessment::data.lookup_assessment_id">
<querytext>

	select assessment_id
	  from as_assessment_section_map
	 where section_id = :section_id	

</querytext>
</fullquery>

<fullquery name="as::assessment::edit.assessment_revision">
<querytext>

	select latest_revision
	from cr_items
	where item_id = :assessment_id

</querytext>
</fullquery>

<fullquery name="as::assessment::copy_sections.copy_sections">
<querytext>

	insert into as_assessment_section_map
	(select :new_assessment_id as assessment_id, section_id, feedback_text,
	        max_time_to_complete, sort_order
	 from as_assessment_section_map
	 where assessment_id = :assessment_id)

</querytext>
</fullquery>

</queryset>
