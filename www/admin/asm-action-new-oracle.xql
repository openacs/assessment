<?xml version="1.0"?>
<queryset>

<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="insert_action">
<querytext>
	declare begin
	:1 := as_action.new( 
	   action_id	      =>	:action_id,	
	   name		      =>	:name,
	   description	      =>	:description,
	   tcl_code	      =>	:tcl_code,
	   context_id	      =>	:package_id,
	   creation_user      =>	:user_id
	   );
	end;

</querytext>
</fullquery>

</queryset>