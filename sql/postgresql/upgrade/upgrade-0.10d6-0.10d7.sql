-- Assessment Package
-- @author annyflores@viaro.net
-- @creation-date 2005-01-06

create sequence as_action_params_parameter_id;

select acs_object_type__create_type (
	'as_action',
	'as_action',
	'as_actions',
	'acs_object',
	'as_actions',
	'action_id',
	null,
	'f',
	null,
	'as_action__name'
);





-- added
select define_function_args('as_action__new','action_id,name,description,tcl_code,context_id,creation_user,package_id');

--
-- procedure as_action__new/7
--
CREATE OR REPLACE FUNCTION as_action__new(
   new__action_id integer,
   new__name varchar,
   new__description varchar,
   new__tcl_code text,
   new__context_id integer,
   new__creation_user integer,
   new__package_id integer
) RETURNS integer AS $$
DECLARE 
	v_action_id	     integer;
BEGIN
	v_action_id := acs_object__new (
		new__action_id,
		'as_action',
		now(),
		new__creation_user,
		null,
		new__package_id,
		't'
	);
	insert into as_actions 
	(action_id,name,description,tcl_code)
        values (v_action_id,new__name,new__description,new__tcl_code);

        return v_action_id;
END;
$$ LANGUAGE plpgsql;





-- added
select define_function_args('as_action__delete','action_id');

--
-- procedure as_action__delete/1
--
CREATE OR REPLACE FUNCTION as_action__delete(
   del__action_id integer
) RETURNS integer AS $$
DECLARE 
BEGIN
	
		
	delete from as_action_params where action_id=del__action_id;
	
	delete from as_actions where action_id = del__action_id;
        PERFORM acs_object__delete (del__action_id);	
	return del__action_id;	

END;
$$ LANGUAGE plpgsql;	
	
	



-- added
select define_function_args('as_action__default_actions','context_id,creation_user,package_id');

--
-- procedure as_action__default_actions/3
--
CREATE OR REPLACE FUNCTION as_action__default_actions(
   new__context_id integer,
   new__creation_user integer,
   new__package_id integer
) RETURNS integer AS $$
DECLARE 
	v_action_id		integer;
	v_parameter_id		integer;
BEGIN
	
	
	v_action_id := as_action__new (
		null,
		'Register User',
		'Register new users',
		'set password [ad_generate_random_string] 
db_transaction {
array set user_new_info [auth::create_user -username $user_name -email $email -first_names $first_names -last_name $last_name -password $password]
}
set admin_user_id [auth::test::get_admin_user_id]
set administration_name [db_string admin_name "select first_names || \'\' \'\' || last_name from 
persons where person_id = :admin_user_id"]
set system_name [ad_system_name]
set system_url [parameter::get -package_id [ad_acs_kernel_id] -parameter SystemURL -default ""].
set admin_email [db_string unused "select email from parties where party_id = :admin_user_id"]
set message "$first_names $last_name,
You have been added as a user to $system_name
at $system_url
Login information:
Email: $email
Password: $password
(you may change your password after you log in)
Thank you,
$administration_name"
ns_sendmail "$email" "$admin_email" "You have been added as a user to [ad_system_name] at [ad_url]" "$message"',
	new__package_id,
	new__creation_user,
	new__package_id
	);

v_parameter_id:= nextval('as_action_params_parameter_id');
insert into as_action_params (parameter_id, action_id,type, varname, description) values (v_parameter_id,v_action_id,'n','first_names','First Names of the User');
v_parameter_id:= nextval('as_action_params_parameter_id');
insert into as_action_params (parameter_id, action_id,type, varname, description) values (v_parameter_id,v_action_id,'n','last_name','Last Name of the User');
v_parameter_id:= nextval('as_action_params_parameter_id');
insert into as_action_params (parameter_id, action_id,type, varname, description) values (v_parameter_id,v_action_id,'n','email','Email of the User');
v_parameter_id:= nextval('as_action_params_parameter_id');
insert into as_action_params (parameter_id, action_id,type, varname, description) values (v_parameter_id,v_action_id,'n','user_name','User name of the User');

v_action_id:= as_action__new (
	null,
	'Event Registration',
	'Register user to event',
	'set user_id [ad_conn user_id]
events::registration::new -event_id $event_id -user_id $user_id',
	new__package_id,
	new__creation_user,
	new__package_id
	);

v_parameter_id:= nextval('as_action_params_parameter_id');
insert into as_action_params (parameter_id, action_id,type, varname, description,query) values (v_parameter_id,v_action_id,'q','event_id','Event to add the user', 'select event_id,event_id from acs_events');

v_action_id:= as_action__new (
	null,
	'Add to Community',
	'Add user to a community',
	'set user_id [ad_conn user_id]
dotlrn_privacy::set_user_guest_p -user_id $user_id -value "t"
dotlrn::user_add -can_browse  -user_id $user_id
dotlrn_community::add_user_to_community -community_id $community_id -user_id $user_id',
	new__package_id,
	new__creation_user,
	new__package_id
	);

v_parameter_id:= nextval('as_action_params_parameter_id');
insert into as_action_params (parameter_id, action_id,type, varname, description,query) values (v_parameter_id,v_action_id,'q','community_id','Community to add the user', 'select pretty_name,community_id from dotlrn_communities');

	return v_action_id;
END;
$$ LANGUAGE plpgsql;


create table del_actions (
	action_id integer,
	tcl_code  text,
	name	  varchar(200),
	description varchar(200)
);

create table del_params (
	parameter_id	integer, 
	action_id	integer,
	type		varchar(1),
	varname		varchar(50),
	description	varchar(200),
	query		text
);






--
-- procedure as_action__create_action_object/0
--
CREATE OR REPLACE FUNCTION as_action__create_action_object(

) RETURNS integer AS $$
DECLARE 
	v_action_id	integer;
	v_parameter_id	integer;
	package		RECORD;
	action		RECORD;
	param		RECORD;
	check		RECORD;
	del_actions 	RECORD;
BEGIN
	
	FOR action IN SELECT * from as_actions LOOP
		insert into del_actions (action_id,tcl_code,name,description) values (action.action_id,action.tcl_code,action.name,action.description);
	end LOOP;

	FOR param IN SELECT * from as_action_params LOOP
		insert into del_params (parameter_id,type,query,description,varname,action_id) values (param.parameter_id,param.type,param.query,param.description,param.varname,param.action_id);
	end LOOP;


	delete from as_actions;
	delete from as_action_params;

	alter table as_actions add constraint as_actions_action_id_fk foreign key (action_id) references acs_objects(object_id);  

	FOR package IN SELECT apm.package_id,o.context_id,o.creation_user from apm_packages apm, acs_objects o where o.object_id=apm.package_id and apm.package_key = 'assessment' LOOP

		FOR action IN SELECT * from del_actions LOOP
	
			v_action_id:= as_action__new (null,action.name,action.description,action.tcl_code,package.package_id,package.creation_user,package.package_id);

			FOR param IN SELECT * from del_params where action_id=action.action_id LOOP
			
				v_parameter_id:=nextval('as_action_params_parameter_id');		
				insert into as_action_params (parameter_id,type,query,description,varname,action_id) values (v_parameter_id,param.type,param.query,param.description,param.varname,v_action_id);


	
				FOR check IN SELECT * from as_inter_item_checks c, as_action_map am where c.assessment_id in (select object_id from acs_objects where package_id=package.package_id) and am.action_id=action.action_id and c.inter_item_check_id=c.inter_item_check_id LOOP
				update as_action_map set action_id=v_action_id where inter_item_check_id=check.inter_item_check_id;
				update as_param_map set parameter_id=v_parameter_id where parameter_id=param.parameter_id and inter_item_check_id=check.inter_item_check_id;

				end LOOP;		

					
			end LOOP;

		end LOOP;
	
	end LOOP;
	

	drop table del_actions;
	drop table del_params;
	return v_action_id;


END;
$$ LANGUAGE plpgsql;

