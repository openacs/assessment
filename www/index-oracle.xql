<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="asssessment_id_name_definition">
	<querytext>
	select cr.item_id as assessment_id, cr.title, cr.description,
	       to_char(a.start_time, 'YYYY-MM-DD HH24:MI:SS') as start_time,
	       to_char(a.end_time, 'YYYY-MM-DD HH24:MI:SS') as end_time,
	       to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS') as cur_time
	from as_assessments a, cr_revisions cr, cr_items ci
	where a.assessment_id = cr.revision_id
	and cr.revision_id = ci.latest_revision
	and ci.parent_id = :folder_id
	and exists (select 1
		from as_assessment_section_map asm, as_item_section_map ism
		where asm.assessment_id = a.assessment_id
		and ism.section_id = asm.section_id)
	</querytext>
</fullquery>
	
</queryset>