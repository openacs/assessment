<?xml version="1.0"?>
<queryset>

<fullquery name="insert_action">
<querytext>
	declare begin
	:1 := as_actions.new( 
	   action_id	      =>	:action_id,
	   name		      =>	:name,
	   description	      =>	:description,
	   tcl_code	      =>	:tcl_code,
	   context_id	      =>	:package_id,
	   user_id	      =>	:user_id,
	   package_id	      =>	:package_id
	   );
	end;

</querytext>
</fullquery>

</queryset>