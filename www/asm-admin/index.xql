<?xml version="1.0"?>
<queryset>

<fullquery name="get_all_assessments">
      <querytext>
    select ci.item_id as assessment_id, cr.title, ci.publish_status
    from cr_items ci, cr_revisions cr
    where cr.revision_id = ci.latest_revision
    and ci.content_type = 'as_assessments'
    and ci.parent_id = :folder_id
    and exists (select 1 from acs_object_party_privilege_map ppm 
                    where ppm.object_id = ci.item_id
                    and ppm.privilege = 'admin'
                    and ppm.party_id = :user_id)
    order by cr.title
    
      </querytext>
</fullquery>

 
</queryset>
