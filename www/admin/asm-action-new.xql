<?xml version="1.0"?>
<queryset>

<fullquery name="get_action_info">
<querytext>
	select name,description,tcl_code 
	from as_actions
	where action_id = :action_id

</querytext>
</fullquery>

<fullquery name="edit_action">
<querytext>
	update as_actions set
	name=:name,description=:description,tcl_code=:tcl_code
	where action_id = :action_id
	

</querytext>
</fullquery>


</queryset>