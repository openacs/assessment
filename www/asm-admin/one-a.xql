<?xml version="1.0"?>
<queryset>

<fullquery name="assessment_sections">
      <querytext>
    select s.section_id, cr.title, ci.name, s.instructions, s.feedback_text,
           asm.max_time_to_complete, asm.sort_order, asm.points, s.display_type_id
    from as_sections s, cr_revisions cr, cr_items ci, as_assessment_section_map asm
    where ci.item_id = cr.item_id
    and cr.revision_id = s.section_id
    and s.section_id = asm.section_id
    and asm.assessment_id = :assessment_rev_id
    order by asm.sort_order
      </querytext>
</fullquery>
<fullquery name="has_privilege">

      <querytext>	
      select anonymous_p from as_assessments a where a.assessment_id=:assessment_rev_id 

      </querytext>
</fullquery>


</queryset>
