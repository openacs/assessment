<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_category_url">
      <querytext>
      
	    select site_node__url(n.node_id)
	    from site_nodes n, site_nodes top, apm_packages p
	    where top.parent_id is null
	    and n.parent_id = top.node_id
	    and p.package_id = n.object_id
	    and p.package_key = 'categories'
	
      </querytext>
</fullquery>

<fullquery name="get_all_assessments">
  <querytext>
    
    select ci.item_id as assessment_id, cr.title, ci.publish_status
     from cr_items ci, cr_revisions cr
    where cr.revision_id = ci.latest_revision
      and ci.content_type = 'as_assessments'
      and ci.parent_id = :folder_id
      and acs_permission__permission_p(ci.item_id, :user_id, 'admin')
    order by cr.title
    
  </querytext>
</fullquery>
 
</queryset>
