<?xml version="1.0"?>
<queryset>

<fullquery name="get_action_info">
<querytext>
	select name,description,tcl_code 
	from as_actions
	where action_id = :action_id

</querytext>
</fullquery>

<fullquery name="insert_action">
<querytext>
	insert into as_actions (action_id,name,description,tcl_code) 
			 values(:action_id,:name,:description,:tcl_code)

</querytext>
</fullquery>

<fullquery name="action_select">
<querytext>
    select action_id, name,description from as_actions

</querytext>
</fullquery>


</queryset>
