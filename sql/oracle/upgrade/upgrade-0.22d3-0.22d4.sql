alter table as_item_rels drop constraint as_item_rels_item_fk;
alter table as_item_rels drop constraint as_item_rels_target_fk;
alter table as_item_rels add constraint as_item_rels_item_fk foreign key (item_rev_id) references acs_objects(object_id) on delete cascade;
alter table as_item_rels add constraint as_item_rels_target_fk foreign key (target_rev_id) references acs_objects(object_id) on delete cascade;

alter table as_item_section_map drop constraint as_item_smap_i_id_fk;
alter table as_item_section_map drop constraint as_item_smap_s_id_fk;
alter table as_item_section_map add constraint as_item_smap_i_id_fk foreign key (as_item_id) references as_items(as_item_id) on delete cascade;
alter table as_item_section_map add constraint as_item_smap_s_id_fk foreign key (section_id) references as_sections(section_id) on delete cascade;

alter table as_item_choices drop constraint as_item_choices_content_fk;
alter table as_item_choices drop constraint as_item_choices_id_fk;
alter table as_item_choices drop constraint as_item_choices_parent_id_fk;
alter table as_item_choices add constraint as_item_choices_content_fk foreign key (content_value) references cr_revisions(revision_id) on delete cascade;
alter table as_item_choices add constraint as_item_choices_id_fk foreign key (choice_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_choices add constraint as_item_choices_parent_id_fk foreign key (mc_id) references as_item_type_mc(as_item_type_id) on delete cascade;

alter table as_item_sa_answers drop constraint as_item_sa_answ_id_fk;
alter table as_item_sa_answers drop constraint as_item_sa_answ_parent_id_fk;
alter table as_item_sa_answers add constraint as_item_sa_answ_id_fk foreign key (choice_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_sa_answers add constraint as_item_sa_answ_parent_id_fk foreign key (answer_id) references as_item_type_sa(as_item_type_id) on delete cascade;

alter table as_item_help_map drop constraint as_item_help_map_as_item_id_fk;
alter table as_item_help_map drop constraint as_item_help_map_message_id_fk;
alter table as_item_help_map add constraint as_item_help_map_as_item_id_fk foreign key (as_item_id) references as_items(as_item_id) on delete cascade;
alter table as_item_help_map add constraint as_item_help_map_message_id_fk foreign key (message_id) references as_messages(message_id) on delete cascade;

alter table as_sections drop constraint as_sections_display_type_id_fk;
alter table as_sections drop constraint as_sections_section_id_fk;
alter table as_sections add constraint  as_sections_display_type_id_fk foreign key (display_type_id) references as_section_display_types(display_type_id) on delete cascade;
alter table as_sections add constraint as_sections_section_id_fk foreign key (section_id) references cr_revisions(revision_id) on delete cascade;

alter table as_sessions drop constraint as_sessions_assessment_id_fk;
alter table as_sessions drop constraint as_sessions_session_id_fk;
alter table as_sessions drop constraint as_sessions_staff_id_fk;
alter table as_sessions drop constraint as_sessions_subject_id_fk;
alter table as_sessions add constraint as_sessions_assessment_id_fk foreign key (assessment_id) references as_assessments(assessment_id) on delete cascade;
alter table as_sessions add constraint as_sessions_session_id_fk foreign key (session_id) references cr_revisions(revision_id) on delete cascade;
alter table as_sessions add constraint as_sessions_staff_id_fk foreign key (staff_id) references users(user_id) on delete cascade;
alter table as_sessions add constraint as_sessions_subject_id_fk foreign key (subject_id) references persons(person_id) on delete cascade;

alter table as_section_data drop constraint as_section_data_id_fk;
alter table as_section_data add constraint as_section_data_id_fk foreign key (section_data_id) references cr_revisions(revision_id) on delete cascade;
alter table as_section_data drop constraint as_section_data_sect_id_fk;
alter table as_section_data add constraint as_section_data_sect_id_fk foreign key (section_id) references as_sections(section_id) on delete cascade;
alter table as_section_data drop constraint as_section_data_sess_id_fk;
alter table as_section_data add constraint as_section_data_sess_id_fk foreign key (session_id) references as_sessions(session_id) on delete cascade;
alter table as_section_data drop constraint as_section_data_staff_id_fk;
alter table as_section_data add constraint as_section_data_staff_id_fk foreign key (staff_id) references users(user_id) on delete cascade;
alter table as_section_data drop constraint as_section_data_subj_id_fk;
alter table as_section_data add constraint as_section_data_subj_id_fk foreign key (subject_id) references persons(person_id) on delete cascade;

alter table as_item_type_mc drop constraint as_item_type_mc_type_id_fk;
alter table as_item_type_mc add constraint as_item_type_mc_type_id_fk foreign key (as_item_type_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_type_oq drop constraint as_item_type_oq_type_id_fk;
alter table as_item_type_oq add constraint as_item_type_oq_type_id_fk foreign key (as_item_type_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_display_rb drop constraint as_item_display_rb_displ_id_fk;
alter table as_item_display_rb add constraint as_item_display_rb_displ_id_fk foreign key (as_item_display_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_display_cb drop constraint as_item_display_cb_displ_id_fk;
alter table as_item_display_cb add constraint as_item_display_cb_displ_id_fk foreign key (as_item_display_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_display_sb drop constraint as_item_display_sb_displ_id_fk;
alter table as_item_display_sb add constraint as_item_display_sb_displ_id_fk foreign key (as_item_display_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_display_tb drop constraint as_item_display_tb_displ_id_fk;
alter table as_item_display_tb add constraint as_item_display_tb_displ_id_fk foreign key (as_item_display_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_display_sa drop constraint as_item_display_sa_displ_id_fk;
alter table as_item_display_sa add constraint as_item_display_sa_displ_id_fk foreign key (as_item_display_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_type_sa drop constraint as_item_type_sa_type_id_fk;
alter table as_item_type_sa add constraint as_item_type_sa_type_id_fk foreign key (as_item_type_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_display_ta drop constraint as_item_display_ta_displ_id_fk;
alter table as_item_display_ta add constraint as_item_display_ta_displ_id_fk foreign key (as_item_display_id) references cr_revisions(revision_id) on delete cascade;
alter table as_items drop constraint as_items_item_id_fk;
alter table as_items add constraint as_items_item_id_fk foreign key (as_item_id) references cr_revisions(revision_id) on delete cascade;
alter table as_section_display_types drop constraint as_section_display_types_id_fk;
alter table as_section_display_types add constraint as_section_display_types_id_fk foreign key (display_type_id) references cr_revisions(revision_id) on delete cascade;
alter table as_assessments drop constraint as_assessments_id_fk;
alter table as_assessments add constraint as_assessments_id_fk foreign key (assessment_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_data drop constraint as_item_data_content_fk;
alter table as_item_data add constraint as_item_data_content_fk foreign key (content_answer) references cr_revisions(revision_id) on delete cascade;
alter table as_item_data drop constraint as_item_data_file_id_fk;
alter table as_item_data add constraint as_item_data_file_id_fk foreign key (file_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_data drop constraint as_item_data_id_fk;
alter table as_item_data add constraint as_item_data_id_fk foreign key (item_data_id) references cr_revisions(revision_id) on delete cascade;
alter table as_item_data drop constraint as_item_data_item_id;
alter table as_item_data add constraint as_item_data_item_id foreign key (as_item_id) references as_items(as_item_id) on delete cascade;
alter table as_item_data drop constraint as_item_data_section_id;
alter table as_item_data add constraint as_item_data_section_id foreign key (section_id) references as_sections(section_id) on delete cascade;
alter table as_item_data drop constraint as_item_data_sess_id_fk;
alter table as_item_data add constraint as_item_data_sess_id_fk foreign key (session_id) references as_sessions(session_id) on delete cascade;
alter table as_item_data drop constraint as_item_data_staff_id_fk;
alter table as_item_data add constraint as_item_data_staff_id_fk foreign key (staff_id) references users(user_id) on delete cascade;
alter table as_item_data drop constraint as_item_data_subj_id_fk;
alter table as_item_data add constraint as_item_data_subj_id_fk foreign key (subject_id) references persons(person_id) on delete cascade;

-- -- File Upload Item
-- create table as_item_type_fu (
-- 	as_item_type_id		integer
-- 				constraint as_item_type_fu_type_id_pk
-- 				primary key
-- 				constraint as_item_type_fu_type_id_fk
-- 				references cr_revisions(revision_id)
--                 on delete cascade
-- );

-- -- File Upload Display Type
-- create table as_item_display_f (
-- 	as_item_display_id	integer
-- 				constraint as_item_display_f_displ_id_pk
-- 				primary key
-- 				constraint as_item_display_f_displ_id_fk
-- 				references cr_revisions(revision_id)
--                 on delete cascade,
-- 	-- field to specify other stuff like textarea dimensions
-- 	html_display_options	varchar(50),
-- 	-- an abstraction of the real size value in "small","medium","large" 
-- 	abs_size		varchar(10),
-- 	-- the orientation between the "question part" of the Item (the title/subtext) and the "answer part" (beside-left, beside-right, below, above)
-- 	item_answer_alignment	varchar(20)
-- );

-- alter table as_item_data add file_id integer
-- 		constraint as_item_data_file_id_fk
-- 		references cr_revisions(revision_id)
--                 on delete cascade;

-- insert into as_item_types_map (item_type, display_type)
-- values ('fu', 'f');


create or replace package as_action
as
	function new (
	action_id     	in acs_objects.object_id%TYPE default null,
        name  		in as_actions.name%TYPE,
        description     in as_actions.description%TYPE,
        tcl_code        in as_actions.tcl_code%TYPE,
	context_id	in acs_objects.context_id%TYPE,
	creation_user	in acs_objects.creation_user%TYPE
		     ) return as_actions.action_id%TYPE;
	procedure del (
	 	action_id 	in as_actions.action_id%TYPE
	);
	procedure default_actions (
		context_id	in acs_objects.context_id%TYPE,
		creation_user	in acs_objects.creation_user%TYPE
	);
end as_action;
/
show errors;

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
ns_sendmail "$email" "$admin_email" "You have been added as a user to [ad_system_name] at [ad_url]" "$message"',
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

if [catch {ns_sendmail $email $email_from $subject $message} errmsg] {
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
	
alter table as_session_items drop constraint as_sess_items_item_fk;
alter table as_session_items drop constraint as_sess_items_section_fk;
alter table as_session_items drop constraint as_sess_items_session_fk;
alter table as_session_items add constraint "as_sess_items_item_fk" FOREIGN KEY (as_item_id) REFERENCES as_items(as_item_id) on delete cascade;
alter table as_session_items add constraint "as_sess_items_section_fk" FOREIGN KEY (section_id) REFERENCES as_sections(section_id) on delete cascade;
alter table as_session_items add constraint "as_sess_items_session_fk" FOREIGN KEY (session_id) REFERENCES as_sessions(session_id) on delete cascade;
