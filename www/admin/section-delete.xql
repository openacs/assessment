<?xml version="1.0"?>
<queryset>

<fullquery name="section_title">
      <querytext>

	select title as section_title
	from cr_revisions
	where revision_id = :section_id

      </querytext>
</fullquery>

<fullquery name="get_sort_order_to_be_removed">
      <querytext>

		select sort_order
		from as_assessment_section_map
		where assessment_id = :new_assessment_rev_id
		and section_id = :section_id

      </querytext>
</fullquery>

<fullquery name="remove_section_from_assessment">
      <querytext>

		delete from as_assessment_section_map
		where assessment_id = :new_assessment_rev_id
		and section_id = :section_id

      </querytext>
</fullquery>

<fullquery name="move_up_sections">
      <querytext>

		update as_assessment_section_map
		set sort_order = sort_order-1
		where assessment_id = :new_assessment_rev_id
		and sort_order > :sort_order

      </querytext>
</fullquery>

</queryset>
