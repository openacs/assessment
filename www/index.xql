<?xml version="1.0"?>
<queryset>

	<fullquery name="asssessment_id_name_definition">
		<querytext>
			select cr.item_id as assessment_id, cr.title, cr.description
			from as_assessments a, cr_revisions cr, cr_items ci
			where a.assessment_id = cr.revision_id
			and cr.revision_id = ci.latest_revision
			and exists (select 1 from as_assessment_section_map asm
		where asm.assessment_id = a.assessment_id)
		</querytext>
	</fullquery>
	
</queryset>
