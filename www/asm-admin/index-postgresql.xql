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

 
</queryset>
