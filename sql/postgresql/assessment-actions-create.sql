-- Assessment Package
-- @author annyflores@viaro.net
-- @creation-date 2005-01-06


------------------------------------------------
-- 	table as_actions
------------------------------------------------


create table as_actions(
	action_id	integer
			constraint as_action_action_id_fk
			references acs_objects(object_id)
			on delete cascade
			constraint as_actions_pk
			primary key,
	name		varchar(200),
	description	varchar(200),
	tcl_code	text
			constraint as_actions_tcl_code_nn not null
);

------------------------------------------------
-- 	table as_action_map
------------------------------------------------

create table as_action_map (
	inter_item_check_id	integer,
	action_id		integer,
	order_by		integer,
	user_message		varchar(200),
	action_perform		varchar(2)
);


------------------------------------------------
-- 	table as_action_params
------------------------------------------------

create table as_action_params (
	parameter_id	integer 
			constraint as_action_params_pk
			primary key,
	action_id	integer,
	type		varchar(1) not null,
	varname		varchar(50) not null,
	description	varchar(200),
	query		text
);



------------------------------------------------
-- 	table as_param_map
------------------------------------------------

create table as_param_map (
	parameter_id	integer,
	value		integer,

	item_id		integer,
	inter_item_check_id 	integer
	
);



-----------------------------------------------
-- 	table as_actions_log
------------------------------------------------

create table as_actions_log (
	action_log_id		integer
				constraint as_actions_log_pk 
				primary key,
	inter_item_check_id	integer not null,
	action_id		integer not null,
	finally_executed_by	integer,
	date_requested		date,
	date_processed		date,
	approved_p		boolean not null,
	failed_p		boolean not null,
	error_txt		varchar,
	session_id		integer
	

);

create sequence as_actions_log_action_log_id;	
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



create or replace function as_action__new (integer,varchar,varchar,text,integer,integer,integer)
returns integer as '
declare 
	new__action_id     	alias for $1;
        new__name        	alias for $2;
        new__description        alias for $3;
        new__tcl_code           alias for $4;
	new__context_id		alias for $5;
	new__creation_user	alias for $6;
	new__package_id         alias for $7;
	v_action_id	     integer;
begin
	v_action_id := acs_object__new (
		new__action_id,
		''as_action'',
		now(),
		new__creation_user,
		null,
		new__package_id,
		''t''
	);
	insert into as_actions 
	(action_id,name,description,tcl_code)
        values (v_action_id,new__name,new__description,new__tcl_code);

        return v_action_id;
end;' language 'plpgsql';



create or replace function as_action__delete (integer)
returns integer as '
declare 
	del__action_id     alias for $1;
begin
	
		
	delete from as_action_params where action_id=del__action_id;
	
	delete from as_actions where action_id = del__action_id;

        PERFORM acs_object__delete (del__action_id);	
	return del__action_id;	

end;' language 'plpgsql';	
	
	

create or replace function as_action__default_actions (integer,integer,integer)
returns integer as '
declare 
	new__context_id		alias for $1;
	new__creation_user	alias for $2;
	new__package_id		alias for $3;
	v_action_id		integer;
	v_parameter_id		integer;
begin
	
	
	v_action_id := as_action__new (
		null,
		''Register User'',
		''Register new users'',
		''set password [ad_generate_random_string] 
db_transaction {
array set user_new_info [auth::create_user -username $user_name -email $email -first_names $first_names -last_name $last_name -password $password]
}
set admin_user_id [auth::test::get_admin_user_id]
set administration_name [db_string admin_name "select first_names || \'\' \'\' || last_name from 
persons where person_id = :admin_user_id"]
set system_name [ad_system_name]
set system_url [ad_parameter -package_id [ad_acs_kernel_id] SystemURL ""].
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
ns_sendmail "$email" "$admin_email" "You have been added as a user to [ad_system_name] at [ad_url]" "$message"'',
	new__package_id,
	new__creation_user,
	new__package_id
	);

v_parameter_id:= nextval(''as_action_params_parameter_id'');
insert into as_action_params (parameter_id, action_id,type, varname, description) values (v_parameter_id,v_action_id,''n'',''first_names'',''First Names of the User'');
v_parameter_id:= nextval(''as_action_params_parameter_id'');
insert into as_action_params (parameter_id, action_id,type, varname, description) values (v_parameter_id,v_action_id,''n'',''last_name'',''Last Name of the User'');
v_parameter_id:= nextval(''as_action_params_parameter_id'');
insert into as_action_params (parameter_id, action_id,type, varname, description) values (v_parameter_id,v_action_id,''n'',''email'',''Email of the User'');
v_parameter_id:= nextval(''as_action_params_parameter_id'');
insert into as_action_params (parameter_id, action_id,type, varname, description) values (v_parameter_id,v_action_id,''n'',''user_name'',''User name of the User'');

v_action_id:= as_action__new (
	null,
	''Event Registration'',
	''Register user to event'',
	''set user_id [ad_conn user_id]
events::registration::new -event_id $event_id -user_id $user_id'',
	new__package_id,
	new__creation_user,
	new__package_id
	);

v_parameter_id:= nextval(''as_action_params_parameter_id'');
insert into as_action_params (parameter_id, action_id,type, varname, description,query) values (v_parameter_id,v_action_id,''q'',''event_id'',''Event to add the user'', ''select event_id,event_id from acs_events'');

v_action_id:= as_action__new (
	null,
	''Add to Community'',
	''Add user to a community'',
	''set user_id [ad_conn user_id]
dotlrn_privacy::set_user_guest_p -user_id $user_id -value "t"
dotlrn::user_add -can_browse  -user_id $user_id
dotlrn_community::add_user_to_community -community_id $community_id -user_id $user_id'',
	new__package_id,
	new__creation_user,
	new__package_id
	);

v_parameter_id:= nextval(''as_action_params_parameter_id'');
insert into as_action_params (parameter_id, action_id,type, varname, description,query) values (v_parameter_id,v_action_id,''q'',''community_id'',''Community to add the user'', ''select pretty_name,community_id from dotlrn_communities'');

	return v_action_id;
end;' language 'plpgsql';
