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


select define_function_args('as_action__del','action_id');



--
-- procedure as_action__del/1
--
CREATE OR REPLACE FUNCTION as_action__del(
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
set admin_user_id [as::actions::get_admin_user_id]
set administration_name [db_string admin_name "select first_names || '' '' || last_name from 
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
acs_sendmail_lite::send -to_addr "$email" -from_addr "$admin_email" -subject "You have been added as a user to [ad_system_name] at [ad_url]" -body "$message"',
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
if { [exists_and_not_null subject_id] } {
	set user_id $subject_id
} 
dotlrn_privacy::set_user_guest_p -user_id $user_id -value "t"
dotlrn::user_add -can_browse  -user_id $user_id
dotlrn_community::add_user_to_community -community_id $community_id -user_id $user_id

set community_name [db_string get_community_name { select pretty_name from dotlrn_communities where community_id = :community_id}]

set subject "Your $community_name membership has been approved"
set message "Your $community_name membership has been approved. Please return to [ad_url] to log into [ad_system_name]."

set email_from [parameter::get -package_id [ad_acs_kernel_id] -parameter SystemOwner]

db_1row select_user_info { select email, first_names, last_name from registered_users where user_id = :user_id}

if [catch {acs_mail_lite::send -to_addr $email -from_addr $email_from -subject $subject -body $message} errmsg] {
         ad_return_error \
        "Error sending mail" \
        "There was an error sending email to $email."
}',
	new__package_id,
	new__creation_user,
	new__package_id
	);

--
-- The query below can be probably tuned if necessary. Note that also
-- the old query - accessing was acs_permissions_all - weird (get
-- permissions while ignoring privileges?). The old query was:
--
--      select pretty_name,community_id from dotlrn_communities
--      where community_id in (select object_id from acs_permissions_all where grantee_id=:user_id)
--
--
v_parameter_id:= nextval('as_action_params_parameter_id');
insert into as_action_params (parameter_id, action_id,type, varname, description,query) values (v_parameter_id,v_action_id,'q','community_id','Community to add the user', 'select pretty_name,community_id from dotlrn_communities from dotlrn_communities where acs_permission.permission_p(community_id, :user_id, ''read'')');

	return v_action_id;
END; $$ language 'plpgsql';

