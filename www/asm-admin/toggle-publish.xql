<?xml version="1.0"?>
<queryset>

 <fullquery name="get_publish_status">
    <querytext>
	select publish_status from cr_items where item_id=:assessment_id
    </querytext>
 </fullquery>

 <fullquery name="count_questions">
    <querytext>
  -- group sections with item_counts, then select those sections with 0 items
  select title
    from (select asm.section_id, count(ism.as_item_id) as count, cr.title 
            from cr_items i, cr_revisions cr,
    as_assessment_section_map asm left join as_item_section_map ism
    on asm.section_id = ism.section_id
           where i.item_id=:assessment_id 
             and asm.assessment_id=i.latest_revision 
             and cr.revision_id = asm.section_id
           group by asm.section_id, cr.title) item_counts 
  where count = 0
    </querytext>
 </fullquery>

 <fullquery name="toggle_publish">
    <querytext>
        update cr_items set publish_status = (case when publish_status is null or publish_status <> 'live' then 'live' else null end) where item_id=:assessment_id        
    </querytext>
 </fullquery>
</queryset>
