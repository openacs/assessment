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
	       s.display_type_id, s.points
	from cr_revisions cr, as_sections s
	where cr.revision_id = :section_id
	and s.section_id = cr.revision_id

      </querytext>
</fullquery>

<fullquery name="as::section::copy.section_data">
      <querytext>

	select cr.title, cr.description,
	       s.instructions, s.feedback_text, s.max_time_to_complete,
	       s.display_type_id, s.points
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

<fullquery name="as::section::items.get_sorted_items">
	<querytext>

	select s.as_item_id, ci.name, r.title, r.description, i.subtext, m.required_p,
	       m.max_time_to_complete
	from as_session_items s, as_items i, as_item_section_map m, cr_revisions r,
	     cr_items ci
	where s.session_id = :session_id
	and s.section_id = :section_id
	and i.as_item_id = s.as_item_id
	and r.revision_id = i.as_item_id
	and ci.item_id = r.item_id
	and m.as_item_id = s.as_item_id
	and m.section_id = s.section_id
	order by s.sort_order

	</querytext>
</fullquery>
	
<fullquery name="as::section::items.section_items">
	<querytext>

	select i.as_item_id, ci.name, cr.title, cr.description, i.subtext,
	       m.required_p, m.max_time_to_complete, m.fixed_position
	from as_item_section_map m, as_items i, cr_revisions cr, cr_items ci
	where cr.revision_id = i.as_item_id
	and i.as_item_id = m.as_item_id
	and m.section_id = :section_id
	and ci.item_id = cr.item_id
	order by m.sort_order

	</querytext>
</fullquery>
	
<fullquery name="as::section::items.save_order">
	<querytext>

	    insert into as_session_items (session_id, section_id, as_item_id, sort_order)
	    values (:session_id, :section_id, :as_item_id, :count)

	</querytext>
</fullquery>
	
</queryset>
