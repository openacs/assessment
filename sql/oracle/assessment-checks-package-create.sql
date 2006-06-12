-- Assessment Package
-- @author annyflores@viaro.net
-- @creation-date 2005-01-06

create or replace package as_inter_item_check 
as 
		function new (
	 	inter_item_check_id     in acs_objects.object_id%TYPE	default null,
        	action_p                in as_inter_item_checks.action_p%TYPE,
        	section_id_from         in as_inter_item_checks.section_id_from%TYPE,
        	section_id_to           in as_inter_item_checks.section_id_to%TYPE,
        	check_sql               in as_inter_item_checks.check_sql%TYPE,
        	name	  	        in as_inter_item_checks.name%TYPE,
        	description	        in as_inter_item_checks.description%TYPE,
        	postcheck_p	        in as_inter_item_checks.postcheck_p%TYPE,
        	item_id                 in as_inter_item_checks.item_id%TYPE,
		assessment_id           in as_inter_item_checks.assessment_id%TYPE,		
		creation_user           in acs_objects.creation_user%TYPE,
		context_id              in acs_objects.context_id%TYPE,
		object_type             in acs_objects.object_type%TYPE,
		creation_date		in acs_objects.creation_date%TYPE
		    ) return as_inter_item_checks.inter_item_check_id%TYPE;
		
		procedure del (
		inter_item_check_id 	in as_inter_item_checks.inter_item_check_id%TYPE
		);
end as_inter_item_check;
/
show errors;

create or replace package body as_inter_item_check 
as 
	function new (
	 	inter_item_check_id     in acs_objects.object_id%TYPE	default null,
        	action_p                in as_inter_item_checks.action_p%TYPE,
        	section_id_from         in as_inter_item_checks.section_id_from%TYPE,
        	section_id_to           in as_inter_item_checks.section_id_to%TYPE,
        	check_sql               in as_inter_item_checks.check_sql%TYPE,
        	name	  	        in as_inter_item_checks.name%TYPE,
        	description	        in as_inter_item_checks.description%TYPE,
        	postcheck_p	        in as_inter_item_checks.postcheck_p%TYPE,
        	item_id                 in as_inter_item_checks.item_id%TYPE,
	       	assessment_id           in as_inter_item_checks.assessment_id%TYPE,
		creation_user           in acs_objects.creation_user%TYPE,
		context_id              in acs_objects.context_id%TYPE,
		object_type             in acs_objects.object_type%TYPE,
		creation_date		in acs_objects.creation_date%TYPE
		    ) return as_inter_item_checks.inter_item_check_id%TYPE
		is 
		v_inter_item_check_id	as_inter_item_checks.inter_item_check_id%TYPE;
	begin
		 
		v_inter_item_check_id := acs_object.new (
			object_id	=> 	inter_item_check_id,
			object_type	=>	object_type,
			creation_date	=>	creation_date,
			creation_user	=>	creation_user,
			creation_ip	=>	null,
			context_id	=>	context_id
		);
		
		insert into as_inter_item_checks 
		(inter_item_check_id,action_p,section_id_from,section_id_to,check_sql,name,description,postcheck_p,item_id,assessment_id)
        	values (v_inter_item_check_id,action_p,section_id_from,section_id_to,check_sql,name,description,postcheck_p,item_id,assessment_id);
	
	         return v_inter_item_check_id;

	end new; 

	-- body for procedure del
	procedure del (
		inter_item_check_id	in as_inter_item_checks.inter_item_check_id%TYPE
		) is
	begin
		delete from as_actions_log where 
		inter_item_check_id = as_inter_item_check.del.inter_item_check_id;
	
	        delete from as_param_map where inter_item_check_id= as_inter_item_check.del.inter_item_check_id;

		delete from as_action_map where inter_item_check_id = as_inter_item_check.del.inter_item_check_id;

		delete from as_inter_item_checks where inter_item_check_id = as_inter_item_check.del.inter_item_check_id;
         	 acs_object.del (as_inter_item_check.del.inter_item_check_id);	
	end del;
	
end as_inter_item_check;
/
show errors;
