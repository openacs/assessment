<?xml version="1.0"?>
<queryset>

<fullquery name="get_param_info">
<querytext>

	select type,varname,description,query 
	from as_action_params 
	where parameter_id = :parameter_id

</querytext>
</fullquery>

</queryset>