<?xml version="1.0"?>
<queryset>

<fullquery name="as::item_display_tb::edit.display_item_id">
      <querytext>

	select item_id
	from cr_revisions
	where revision_id = :as_item_display_id

      </querytext>
</fullquery>

<fullquery name="as::item_display_tb::copy.display_item_data">
      <querytext>

	select i.html_display_options, i.abs_size, i.item_answer_alignment
	from cr_revisions cr, as_item_display_tb i
	where cr.revision_id = :type_id
	and i.as_item_display_id = cr.revision_id

      </querytext>
</fullquery>

<fullquery name="as::item_display_tb::data_not_cached.display_item_data">
      <querytext>

	select html_display_options, abs_size, item_answer_alignment
	from as_item_display_tb
	where as_item_display_id = :type_id

      </querytext>
</fullquery>

<fullquery name="as::item_display_tb::set_item_display_type.item_display">
      <querytext>

	select r.target_rev_id as as_item_display_id, o.object_type
	from as_item_rels r, acs_objects o
	where r.item_rev_id = :as_item_id
	and r.rel_type = 'as_item_display_rel'
	and o.object_id = r.target_rev_id

      </querytext>
</fullquery>

<fullquery name="as::item_display_tb::set_item_display_type.update_section_in_assessment">
      <querytext>

		update as_assessment_section_map
		set section_id = :new_section_id
		where assessment_id = :new_assessment_rev_id
		and section_id = :section_id

      </querytext>
</fullquery>

<fullquery name="as::item_display_tb::set_item_display_type.move_down_items">
      <querytext>

	    update as_item_section_map
	    set sort_order = sort_order+1
	    where section_id = :new_section_id
	    and sort_order > :after

      </querytext>
</fullquery>

<fullquery name="as::item_display_tb::set_item_display_type.insert_new_item">
      <querytext>

	    insert into as_item_section_map
		(as_item_id, section_id, required_p, sort_order, max_time_to_complete,
		 fixed_position, points)
	    (select :as_item_id as as_item_id, :new_section_id as section_id,
		    required_p, :after as sort_order, max_time_to_complete,
		    0 as fixed_position, points
	     from as_items
	     where as_item_id = :as_item_id)

      </querytext>
</fullquery>

<fullquery name="as::item_display_tb::set_item_display_type.update_item_display">
      <querytext>

		update as_item_rels
		set target_rev_id = :as_item_display_id
		where item_rev_id = :as_item_id
		and rel_type = 'as_item_display_rel'

      </querytext>
</fullquery>

<fullquery name="as::item_display_tb::set_item_display_type.item_data">
      <querytext>

	    select required_p, max_time_to_complete, points
	    from as_items
	    where as_item_id = :as_item_id

      </querytext>
</fullquery>

<fullquery name="as::item_display_tb::set_item_display_type.update_item">
      <querytext>

	    update as_item_section_map
	    set as_item_id = :as_item_id,
	        required_p = :required_p,
	        max_time_to_complete = :max_time_to_complete,
	        points = :points
	    where as_item_id = :old_item_id
	    and section_id = :new_section_id

      </querytext>
</fullquery>

</queryset>
