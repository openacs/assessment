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

<fullquery name="as::session::delete.delete_choices">
<querytext>
DELETE FROM as_session_choices WHERE  session_id = :session_id;
</querytext>
</fullquery>

<fullquery name="as::session::delete.delete_session_items">
<querytext>
delete from as_session_items where session_id =  :session_id;
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

<fullquery name="as::session::response_as_email.session_items">
      <querytext>
      
    select i.as_item_id, i.subtext, cr.title, cr.description, ci.name,
	   ism.required_p, ism.section_id, ism.sort_order, i.feedback_right,
	   i.feedback_wrong, ism.max_time_to_complete, ism.points, s.subject_id
    from as_items i, cr_revisions cr, cr_items ci, as_item_section_map ism,
         as_session_items si, as_sessions s
    where ci.item_id = cr.item_id
    and cr.revision_id = i.as_item_id
    and i.as_item_id = ism.as_item_id
    and ism.section_id = si.section_id
    and ism.as_item_id = si.as_item_id
    and si.session_id = :session_id
    and s.session_id = si.session_id
    order by si.sort_order
    
      </querytext>
</fullquery>

</queryset>



