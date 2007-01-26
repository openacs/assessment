<?xml version="1.0"?>
<queryset>

<fullquery name="sections_query">
      <querytext>
    select s.section_id, cr.title
    from as_sections s, cr_revisions cr, as_assessment_section_map asm
    where cr.revision_id = s.section_id
    and s.section_id = asm.section_id
    and asm.assessment_id = :assessment_rev_id
    order by asm.sort_order
      </querytext>
</fullquery>

</queryset>
