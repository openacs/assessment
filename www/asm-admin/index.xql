<?xml version="1.0"?>
<queryset>

<fullquery name="get_all_assessments">
      <querytext>
      
    select ci.item_id as assessment_id, cr.title
    from cr_folders cf, cr_items ci, cr_revisions cr, as_assessments a
    where cr.revision_id = ci.latest_revision
    and a.assessment_id = cr.revision_id
    and ci.parent_id = cf.folder_id and cf.package_id = :package_id
    order by cr.title
    
      </querytext>
</fullquery>


<fullquery name="get_all_assessments_admin">
      <querytext>
    select ci.item_id as assessment_id, cr.title
    from cr_folders cf, cr_items ci, cr_revisions cr, as_assessments a
    where cr.revision_id = ci.latest_revision
    and a.assessment_id = cr.revision_id
    and ci.parent_id = cf.folder_id
    and  ci.item_id in (select object_id from acs_permissions where 
    grantee_id=:user_id and privilege='admin') and cf.package_id = :package_id
    order by cr.title
    
      </querytext>
</fullquery>

 
</queryset>
