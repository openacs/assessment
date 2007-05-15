<?xml version="1.0"?>
<queryset>

<fullquery name="as::session::delete.">
<querytext>

</querytext>
</fullquery>

<fullquery name="as::session::delete.get_data_ids">
<querytext>
select cr.item_id 
from as_item_data d, cr_revisions cr 
where cr.revision_id=d.item_data_id 
and d.session_id=:session_id
</querytext>
</fullquery>

<fullquery name="as::session::delete.get_result_ids">
<querytext>
select cr.item_id 
from as_session_results s, cr_revisions cr , cr_revisions cr2 
where cr.revision_id=s.result_id 
and s.target_id=cr2.revision_id 
and cr2.item_id=:item_id
</querytext>
</fullquery>

<fullquery name="as::session::delete.get_section_data_ids">
<querytext>
select cr.item_id 
from as_section_data d, cr_revisions cr 
where cr.revision_id=d.section_data_id 
and d.session_id=:session_id
</querytext>
</fullquery>

<fullquery name="as::session::delete.get_comments">
<querytext>
select g.comment_id
from general_comments g
where object_id=:session_id
</querytext>
</fullquery>


<fullquery name="as::session::unfinished_session_id.unfinished_session_id">
	<querytext>

	select max(s.session_id) as session_id
        from as_sessions s, cr_revisions cr
        where s.completed_datetime is null
        and cr.item_id = :assessment_id 
        and s.assessment_id = cr.revision_id
        and s.subject_id = :subject_id and s.subject_id <> 0

	</querytext>
</fullquery>

</queryset>



