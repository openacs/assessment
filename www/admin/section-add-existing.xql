<?xml version="1.0"?>
<queryset>

<fullquery name="section_list">
      <querytext>
      
	select s.section_id
	from cr_items ci, cr_revisions cr, as_sections s
	where cr.revision_id = ci.latest_revision
	and s.section_id = cr.revision_id
	and s.section_id not in (select m.section_id
				 from as_assessment_section_map m
				 where m.assessment_id = :assessment_rev_id)
	$orderby_clause
    
      </querytext>
</fullquery>

<fullquery name="unmapped_sections_to_assessment">
      <querytext>
      
    select s.section_id, cr.title
    from cr_items ci, cr_revisions cr, as_sections s
    where cr.revision_id = ci.latest_revision
    and s.section_id = cr.revision_id
    and s.section_id not in (select m.section_id
			     from as_assessment_section_map m
			     where m.assessment_id = :assessment_rev_id)
    $page_clause
    $orderby_clause
    
      </querytext>
</fullquery>

</queryset>
