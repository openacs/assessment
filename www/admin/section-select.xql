<?xml version="1.0"?>
<queryset>

<fullquery name="get_sections">
<querytext>
    select cr.title,s.section_id
    from as_sections s, cr_revisions cr, cr_items ci, as_assessment_section_map asm
    where ci.item_id = cr.item_id
    and cr.revision_id = s.section_id
    and s.section_id = asm.section_id and s.section_id <> :section_id and
    asm.sort_order > (select sort_order from as_assessment_section_map where
    assessment_id = :new_assessment_revision and section_id = :section_id)
    and asm.assessment_id = :new_assessment_revision 
    order by asm.sort_order

</querytext>
</fullquery>

<fullquery name="update_check">
<querytext>
	update as_inter_item_checks set section_id_to =:section_id_to where
	inter_item_check_id = :inter_item_check_id
</querytext>
</fullquery>

<fullquery name="get_section">
<querytext>
	select section_id_to from as_inter_item_checks where inter_item_check_id=:inter_item_check_id
</querytext>
</fullquery>


</queryset>
