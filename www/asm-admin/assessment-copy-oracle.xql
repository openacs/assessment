<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="assessment_instances">
      <querytext>

    select pc.instance_name, na.node_id
    from apm_packages pa, site_nodes na, site_nodes nc,
	 apm_packages pc
    where pa.package_key = 'assessment'
    and na.object_id = pa.package_id
    and nc.node_id = na.parent_id
    and pc.package_id = nc.object_id
        and exists (select 1 from acs_object_party_privilege_map ppm
                    where ppm.object_id = pa.package_id
                    and ppm.privilege = 'admin'
                    and ppm.party_id = :user_id)
      </querytext>
</fullquery>

</queryset>
