-- Disclaimer: this has not really been tested

begin;

create or replace package body  as_action
as
	function new (
	action_id     	in acs_objects.object_id%TYPE default null,
        name  		in as_actions.name%TYPE,
        description     in as_actions.description%TYPE,
        tcl_code        in as_actions.tcl_code%TYPE,
	context_id	in acs_objects.context_id%TYPE,
	creation_user	in acs_objects.creation_user%TYPE
     ) return as_actions.action_id%TYPE
	is
		v_action_id as_actions.action_id%TYPE;

	begin

	v_action_id := acs_object.new (
			object_id	=> 	action_id,
			object_type	=>	'as_action',
			creation_user	=>	creation_user,
			creation_ip	=>	null,
			context_id	=>	context_id
			);

	insert into as_actions 	(action_id,name,description,tcl_code)
        values (v_action_id,name,description,tcl_code);

        return v_action_id;
	end new;



        procedure del (
		action_id  as_actions.action_id%TYPE
		) is
	begin

		delete from as_action_params where action_id=as_action.del.action_id;
		delete from as_actions where action_id = as_action.del.action_id;
        	acs_object.del(as_action.del.action_id);

	end del;


	procedure default_actions (
		context_id	in acs_objects.context_id%TYPE,
		creation_user	in acs_objects.creation_user%TYPE

	) is
		v_action_id		as_actions.action_id%TYPE;

	begin

	v_action_id := new (
		action_id	=>	null,
		name		=>	'Register User',
		description	=>	'Register new users',
		tcl_code	=>	'set password [ad_generate_random_string]
db_transaction {
array set user_new_info [auth::create_user -username $user_name -email $email -first_names $first_names -last_name $last_name -password $password]
}

set admin_user_id [as::actions::get_admin_user_id]
set administration_name [db_string admin_name "select first_names || '' '' || last_name from persons where
person_id = :admin_user_id"]

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
acs_mail_lite::send -to_addr "$email" -from_addr "$admin_email" -subject "You have been added as a user to [ad_system_name] at [ad_url]" -body "$message"',
	context_id	=>	context_id,
	creation_user	=>	creation_user
	);


insert into as_action_params (parameter_id, action_id,type, varname, description)
values (parameter_id_seq.nextval,v_action_id,'n','first_names','First Names of the User');

insert into as_action_params (parameter_id, action_id,type, varname, description)
values (parameter_id_seq.nextval,v_action_id,'n','last_name','Last Name of the User');

insert into as_action_params (parameter_id, action_id,type, varname, description)
values (parameter_id_seq.nextval,v_action_id,'n','email','Email of the User');

insert into as_action_params (parameter_id, action_id,type, varname, description)
values (parameter_id_seq.nextval,v_action_id,'n','user_name','User name of the User');

v_action_id:=  new (
	action_id	=>	null,
	name		=>	'Event Registration',
	description	=>	'Register user to event',
	tcl_code	=>	'set user_id [ad_conn user_id]
events::registration::new -event_id $event_id -user_id $user_id',
	context_id	=>	context_id,
	creation_user	=>	creation_user
	);


insert into as_action_params (parameter_id, action_id,type, varname, description,query)
values (parameter_id_seq.nextval,v_action_id,'q','event_id','Event to add the user', 'select event_id,event_id from acs_events');

v_action_id:= new (
	action_id	=>	null,
	name		=>	'Add to Community',
	description	=>	'Add user to a community',
	tcl_code	=>	'set user_id [ad_conn user_id]
if { [info exists subject_id] && $subject_id ne "" } {
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
	context_id	=>	context_id,
	creation_user	=>	creation_user
	);


insert into as_action_params (parameter_id, action_id,type, varname, description,query)
values (parameter_id_seq.nextval,v_action_id,'q','community_id','Community to add the user',
'select pretty_name,community_id from dotlrn_communities');


	end default_actions;

end as_action;
/
show errors;

-- update entries containing deprecated code
update as_actions set
 tcl_code = replace(tcl_code, '[exists_and_not_null subject_id]', '[info exists subject_id] && $subject_id ne ""');

update as_actions set
 tcl_code = replace(tcl_code, '[ad_parameter -package_id [ad_acs_kernel_id] SystemURL ""]', '[parameter::get -package_id [ad_acs_kernel_id] -parameter SystemURL -default ""]');

end;
