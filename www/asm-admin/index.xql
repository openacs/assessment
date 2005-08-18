<?xml version="1.0"?>
<queryset>

<fullquery name="get_all_assessments">
      <querytext>
      
    select ci.item_id as assessment_id, cr.title
    from cr_items ci, cr_revisions cr
    where cr.revision_id = ci.latest_revision
    and ci.content_type = 'as_assessments'
    and ci.parent_id = :folder_id
    order by cr.title
    
      </querytext>
</fullquery>


<fullquery name="get_all_assessments_admin">
      <querytext>
    select ci.item_id as assessment_id, cr.title
    from cr_items ci, cr_revisions cr
    where cr.revision_id = ci.latest_revision
    and ci.content_type = 'as_assessments'
    and ci.parent_id = :folder_id
    and  ci.item_id in (select object_id from acs_permissions where 
    grantee_id=:user_id and privilege='admin')
    order by cr.title
    
      </querytext>
</fullquery>

 
</queryset>
