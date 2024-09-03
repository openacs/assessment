<?xml version="1.0"?>
<queryset>

<fullquery name="answered_assessments">
	<querytext>
	select cr.item_id as assessment_id, cr.title, cr.description
	from as_assessments a, cr_revisions cr, cr_items ci
	where a.assessment_id = cr.revision_id
	and cr.revision_id = ci.latest_revision
	and ci.parent_id = :folder_id
	and exists (select 1
		from as_sessions s
		where s.assessment_id = a.assessment_id
		and s.subject_id = :user_id
		and s.completed_datetime is not null)
	order by lower(cr.title)
	</querytext>
</fullquery>
	
</queryset>
