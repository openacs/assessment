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
	(select :new_assessment_id as assessment_id, section_id,
	        max_time_to_complete, sort_order, points
	 from as_assessment_section_map
	 where assessment_id = :assessment_id)

</querytext>
</fullquery>

<fullquery name="as::assessment::copy_categories.copy_categories">
<querytext>

	insert into category_object_map
	(select category_id, :to_id as object_id
	 from category_object_map
	 where object_id = :from_id)

</querytext>
</fullquery>

<fullquery name="as::assessment::sections.get_sorted_sections">
<querytext>

	select section_id
	from as_session_sections
	where session_id = :session_id
	order by sort_order

</querytext>
</fullquery>

<fullquery name="as::assessment::sections.assessment_sections">
<querytext>

	select m.section_id, r.title
	from as_assessment_section_map m, cr_revisions r
	where m.assessment_id = :assessment_id
	and r.revision_id = m.section_id
	order by m.sort_order

</querytext>
</fullquery>

<fullquery name="as::assessment::sections.save_order">
	<querytext>

	    insert into as_session_sections (session_id, section_id, sort_order)
	    values (:session_id, :section_id, :count)

	</querytext>
</fullquery>
	
</queryset>
