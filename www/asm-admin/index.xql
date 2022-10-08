<?xml version="1.0"?>
<queryset>

<fullquery name="get_all_assessments">
      <querytext>
        select
            ci.item_id as assessment_id,
            cr.title,
            ci.content_type
        from cr_folders cf
             inner join cr_items ci
                on ci.parent_id = cf.folder_id
                    and cf.package_id = :package_id
             inner join cr_revisions cr
                on cr.revision_id = coalesce(ci.latest_revision, content_item__get_latest_revision(ci.item_id))
             inner join as_assessments a
                on  a.assessment_id = cr.revision_id
        where ci.latest_revision is not null
        order by cr.title    
      </querytext>
</fullquery>

 
</queryset>
