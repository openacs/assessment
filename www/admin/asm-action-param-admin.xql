<?xml version="1.0"?>
<queryset>

<fullquery name="get_param_info">
<querytext>

	select type,varname,description,query 
	from as_action_params 
	where parameter_id = :parameter_id

</querytext>
</fullquery>

<fullquery name="insert_param">
<querytext>
	insert into as_action_params (parameter_id,action_id,type,varname,description,query) 
			 values(:parameter_id,:action_id, :type,:varname,:description,:query)


</querytext>
</fullquery>

<fullquery name="edit_param">
<querytext>
	update as_action_params set
	varname=:varname,description=:description,query=:query,type=:type
	where parameter_id = :parameter_id
	
</querytext>
</fullquery>


</queryset>
