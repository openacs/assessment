<?xml version="1.0"?>
<queryset>

<fullquery name="update_section_in_assessment">
      <querytext>

		update as_assessment_section_map
		set section_id = :new_section_id
		where assessment_id = :new_assessment_rev_id
		and section_id = :section_id

      </querytext>
</fullquery>

<fullquery name="update_item_in_section">
      <querytext>

		update as_item_section_map
		set as_item_id = :new_item_id
		where section_id = :new_section_id
		and as_item_id = :as_item_id

      </querytext>
</fullquery>

<fullquery name="update_item_type_in_item">
      <querytext>

		update as_item_rels
		set target_rev_id = :new_mc_id
		where item_rev_id = :new_item_id
		and target_rev_id = :mc_id
		and rel_type = 'as_item_type_rel'

      </querytext>
</fullquery>

<fullquery name="get_sort_order_to_be_removed">
      <querytext>

		select mc_id, sort_order
		from as_item_choices
		where choice_id = :choice_id

      </querytext>
</fullquery>

<fullquery name="get_choices">
      <querytext>

	    select choice_id
	    from as_item_choices
	    where mc_id = :mc_id

      </querytext>
</fullquery>

<fullquery name="move_up_choices">
      <querytext>

		update as_item_choices
		set sort_order = sort_order-1
		where mc_id = :new_mc_id
		and sort_order > :sort_order

      </querytext>
</fullquery>

</queryset>
