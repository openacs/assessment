<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="assessment_instances">
      <querytext>

    select pc.instance_name, na.node_id
    from apm_packages pa, site_nodes na, site_nodes nc,
	 apm_packages pc
    where pa.package_key = 'assessment'
    and na.object_id = pa.package_id
    and nc.node_id = na.parent_id
    and pc.package_id = nc.object_id
    and acs_permission__permission_p (pa.package_id, :user_id, 'admin') = 't'

      </querytext>
</fullquery>

</queryset>
