<?xml version="1.0"?>
<queryset>

<fullquery name="assessment_sections">
      <querytext>
    select s.section_id, cr.title, s.definition, s.instructions, s.required_p,
           s.feedback_text, s.max_time_to_complete, asm.sort_order
    from as_sections s, cr_revisions cr, as_assessment_section_map asm
    where cr.revision_id = s.section_id
    and s.section_id = asm.section_id
    and asm.assessment_id = :assessment_rev_id
    order by asm.sort_order
      </querytext>
</fullquery>

</queryset>
