<?xml version="1.0"?>
<queryset>

<fullquery name="section_display_data">
      <querytext>

	select cr.title, cr.description, d.num_items, d.adp_chunk, d.branched_p,
	       d.back_button_p, d.submit_answer_p, d.sort_order_type
	from as_section_display_types d, cr_revisions cr
	where cr.revision_id = d.display_type_id
	and d.display_type_id = :display_type_id

      </querytext>
</fullquery>

<fullquery name="add_display_to_section">
      <querytext>

	    update as_sections
	    set display_type_id = :display_id
	    where section_id = :section_id

      </querytext>
</fullquery>

</queryset>
