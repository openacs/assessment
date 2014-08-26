-- Assessment Package
-- @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
-- @creation-date 2005-02-03


------------------------------------------------
--	Default Actions
------------------------------------------------

--- REGISTER USER

insert into as_actions (action_id,name,description,tcl_code) values (1,'Register User','Register new users','
set password [ad_generate_random_string]
db_transaction {
array set user_new_info [auth::create_user -username $user_name -email $email -first_names $first_names\\
 -last_name $last_name -password $password]
}
set admin_user_id [as::actions::get_admin_user_id]
set administration_name [db_string admin_name "select first_names || \' \' || last_name from persons where person_id
 = :admin_user_id"]
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
acs_mail_lite::send -to_addr "$email" -from_addr "$admin_email" -subject "You have been added as a user to [ad_system_name] at [ad_url]" -body "$message"');

insert into as_action_params (parameter_id, action_id,type, varname, description) values (1,1,'n','first_names',
'First Names of the User');
insert into as_action_params (parameter_id, action_id,type, varname, description) values (2,1,'n','last_name',
'Last Name of the User');
insert into as_action_params (parameter_id, action_id,type, varname, description) values (3,1,'n','email'
,'Email of the User');
insert into as_action_params (parameter_id, action_id,type, varname, description) values (4,1,'n','user_name',
'User name of the User');

--- REGISTER USER TO EVENT

insert into as_actions (action_id,name,description,tcl_code) values (2,'Event Registration','Register user to event','
set user_id [ad_conn user_id]
events::registration::new -event_id $event_id -user_id $user_id');

insert into as_action_params (parameter_id, action_id,type, varname, description,query) values (5,2,'q','event_id',
'Event to add the user', 'select event_id,event_id from acs_events');

--- REGISTER USER TO DOTLRN AND ADD USER TO COMMUNITY

insert into as_actions (action_id,name,description,tcl_code) values (3,'Add to Community','Add user to a community','
set user_id [ad_conn user_id]
dotlrn_privacy::set_user_guest_p -user_id $user_id -value "t"
dotlrn::user_add -can_browse  -user_id $user_id
dotlrn_community::add_user_to_community -community_id $community_id -user_id $user_id');


insert into as_action_params (parameter_id, action_id,type, varname, description,query) values (6,3,'q','community_id',
'Community to add the user', 'select pretty_name,community_id from dotlrn_communities');
