<?xml version="1.0"?>
<queryset>

<fullquery name="get_action_info">
<querytext>
	select name,description,tcl_code 
	from as_actions
	where action_id = :action_id 

</querytext>
</fullquery>


<fullquery name="action_select">
<querytext>
    select a.action_id, a.name,a.description from as_actions a where (select context_id from acs_objects
    where object_id=a.action_id)=:package_id


</querytext>
</fullquery>


</queryset>
