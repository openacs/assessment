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
	       s.definition, s.instructions, s.feedback_text, s.max_time_to_complete,
	       s.required_p, s.section_display_type_id
	from cr_revisions cr, as_sections s
	where cr.revision_id = :section_id
	and s.section_id = cr.revision_id

      </querytext>
</fullquery>

<fullquery name="as::section::copy.section_data">
      <querytext>

	select cr.title, cr.description,
	       s.definition, s.instructions, s.feedback_text, s.max_time_to_complete,
	       s.required_p, s.section_display_type_id
	from cr_revisions cr, as_sections s
	where cr.revision_id = :section_id
	and s.section_id = cr.revision_id

      </querytext>
</fullquery>

<fullquery name="as::section::copy_items.copy_items">
      <querytext>

	insert into as_item_section_map
	(select as_item_id, :new_section_id, enabled_p, required_p, item_default,
	        content_value, numeric_value, feedback_text, max_time_to_complete,
	        adp_chunk, sort_order
	 from as_item_section_map
	 where section_id = :section_id)

      </querytext>
</fullquery>

</queryset>
