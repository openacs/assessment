
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
set administration_name [db_string admin_name "select first_names || '' '' || last_name from persons where person_id = :admin_user_id"]
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

v_parameter_id:= nextval('as_action_params_parameter_id');
insert into as_action_params (parameter_id, action_id,type, varname, description,query) values (v_parameter_id,v_action_id,'q','community_id','Community to add the user', 'select pretty_name,community_id from dotlrn_communities where community_id in (select object_id from acs_permissions_all where grantee_id=:user_id)');

	return v_action_id;
END; $$ language 'plpgsql';
