<?xml version="1.0"?>
<queryset>

<fullquery name="item_title">
      <querytext>

	select title as item_title
	from cr_revisions
	where revision_id = :as_item_id

      </querytext>
</fullquery>

<fullquery name="update_section_in_assessment">
      <querytext>

		update as_assessment_section_map
		set section_id = :new_section_id
		where assessment_id = :new_assessment_rev_id
		and section_id = :section_id

      </querytext>
</fullquery>

<fullquery name="get_sort_order_to_be_removed">
      <querytext>

		select sort_order
		from as_item_section_map
		where section_id = :new_section_id
		and as_item_id = :as_item_id

      </querytext>
</fullquery>

<fullquery name="remove_item_from_section">
      <querytext>

		delete from as_item_section_map
		where section_id = :new_section_id
		and as_item_id = :as_item_id

      </querytext>
</fullquery>

<fullquery name="move_up_items">
      <querytext>

		update as_item_section_map
		set sort_order = sort_order-1
		where section_id = :new_section_id
		and sort_order > :sort_order

      </querytext>
</fullquery>

</queryset>
