<?xml version="1.0"?>
<queryset>

<fullquery name="as::section::edit.section_item_id">
      <querytext>

	select item_id
	from cr_revisions
	where revision_id = :section_id

      </querytext>
</fullquery>

<fullquery name="as::section::new_revision.section_data">
      <querytext>

	select cr.item_id as section_item_id, cr.title, cr.description,
	       s.instructions, s.feedback_text, s.max_time_to_complete,
	       s.display_type_id, s.points, s.num_items
	from cr_revisions cr, as_sections s
	where cr.revision_id = :section_id
	and s.section_id = cr.revision_id

      </querytext>
</fullquery>

<fullquery name="as::section::latest.get_latest_section_id">
      <querytext>

	select m.section_id
	from as_assessment_section_map m, cr_revisions r, cr_revisions s
	where m.assessment_id = :assessment_rev_id
	and m.section_id = r.revision_id
	and s.revision_id = :section_id
	and s.item_id = r.item_id

      </querytext>
</fullquery>

<fullquery name="as::section::copy.section_data">
      <querytext>

	select cr.title, cr.description,
	       s.instructions, s.feedback_text, s.max_time_to_complete,
	       s.display_type_id, s.points, s.num_items
	from cr_revisions cr, as_sections s
	where cr.revision_id = :section_id
	and s.section_id = cr.revision_id

      </querytext>
</fullquery>

<fullquery name="as::section::copy_items.copy_items">
      <querytext>

	insert into as_item_section_map
	(select as_item_id, :new_section_id, required_p, max_time_to_complete,
	        sort_order, fixed_position, points
	 from as_item_section_map
	 where section_id = :section_id)

      </querytext>
</fullquery>

<fullquery name="as::section::items.save_order">
	<querytext>

	    insert into as_session_items (session_id, section_id, as_item_id, sort_order)
	    values (:session_id, :section_id, :as_item_id, :count)

	</querytext>
</fullquery>
	
<fullquery name="as::section::calculate.sum_of_item_points">
	<querytext>

	select sum(m.points) as item_max_points, sum(d.points) as item_points
	from as_item_data d, as_item_section_map m, as_session_item_map sm
	where m.section_id = :section_id
	and d.section_id = m.section_id
	and d.as_item_id = m.as_item_id
	and d.session_id = :session_id
	and sm.session_id = d.session_id
	and sm.item_data_id = d.item_data_id

	</querytext>
</fullquery>
	
<fullquery name="as::section::close.remaining_items">
	<querytext>

	select i.as_item_id
	from as_session_items i
	where i.session_id = :session_id
	and i.section_id = :section_id
	and i.as_item_id not in (select d.as_item_id
				from as_item_data d
				where d.session_id = :session_id
				and d.section_id = :section_id)

	</querytext>
</fullquery>
	
</queryset>
