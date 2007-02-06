<?xml version="1.0"?>
<queryset>

<fullquery name="sections_query">
      <querytext>
    select s.section_id, cr.title, ci.name, s.instructions, s.feedback_text,
           asm.max_time_to_complete, asm.sort_order, asm.points, s.display_type_id
    from as_sections s, cr_revisions cr, cr_items ci, as_assessment_section_map asm
    where cr.revision_id = s.section_id
    and s.section_id = asm.section_id
    and cr.item_id = ci.item_id
    and asm.assessment_id = :assessment_rev_id
    order by asm.sort_order, s.section_id
--    select s.section_id, cr.title
--    from as_sections s, cr_revisions cr, as_assessment_section_map asm
--    where cr.revision_id = s.section_id
--    and s.section_id = asm.section_id
--    and asm.assessment_id = :assessment_rev_id
      </querytext>
</fullquery>

<fullquery name="max_sort_order">
      <querytext>
    select max(asm.sort_order)
    from as_sections s, cr_revisions cr, cr_items ci, as_assessment_section_map asm
    where ci.item_id = cr.item_id
    and cr.revision_id = s.section_id
    and s.section_id = asm.section_id
    and asm.assessment_id = :assessment_rev_id

      </querytext>
</fullquery>

</queryset>
