-- Assessment Package
-- @author annyflores@viaro.net
-- @creation-date 2005-01-19

select acs_object_type__create_type (
	'as_inter_item_check',
	'As_Inter_item_check',
	'As_Inter_item_checks',
	'acs_object',
	'as_inter_items_checks',
	'as_inter_item_check_id',
	null,
	'f',
	null,
	'as_inter_item_check__name'
);



----------------------------------------------------------
--	table as_inter_item_checks
----------------------------------------------------------

create table as_inter_item_checks (
	inter_item_check_id	integer
				constraint as_inter_item_checks_id_fk
				references acs_objects(object_id)
				on delete cascade
				constraint as_inter_item_checks_pk
				primary key,
	action_p		boolean not null,
	section_id_from		integer not null,
	section_id_to		integer,
	check_sql		varchar(4000)
				constraint as_inter_item_checks_nn not null,
	name			varchar(200),
	description		varchar(200),
	postcheck_p		boolean not null,
	item_id			integer
);

------------------------------------------------
-- 	table as_actions
------------------------------------------------


create table as_actions(
	action_id	integer
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
	inter_item_check_id	integer
				constraint as_action_map_check_id_fk
				references as_inter_item_checks(inter_item_check_id),
	action_id		integer
				constraint as_action_map_action_id_fk 
				references as_actions(action_id),
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

create or replace function as_inter_item_check__new (integer,boolean,integer,integer,varchar,varchar,varchar,boolean,integer,integer,integer)
returns integer as '
declare 
	new__inter_item_check_id     alias for $1;
        new__action_p                alias for $2;
        new__section_id_from         alias for $3;
        new__section_id_to           alias for $4;
        new__check_sql               alias for $5;
        new__name	  	     alias for $6;
        new__description	     alias for $7;
        new__postcheck_p	     alias for $8;
        new__item_id                 alias for $9;
	new__creation_user           alias for $10; 
	new__context_id              alias for $11; 
	v_inter_item_check_id	     integer;
begin
	v_inter_item_check_id := acs_object__new (
		new__inter_item_check_id,
		''as_inter_item_check'',
		now(),
		new__creation_user,
		null,
		new__context_id
	);
	insert into as_inter_item_checks 
	(inter_item_check_id,action_p,section_id_from,section_id_to,check_sql,name,description,postcheck_p,item_id)
        values (v_inter_item_check_id,new__action_p,new__section_id_from,new__section_id_to,new__check_sql,new__name,new__description,new__postcheck_p,new__item_id);

         return v_inter_item_check_id;
end;' language 'plpgsql';

create or replace function as_inter_item_check__delete (integer)
returns integer as '
declare 
	del__inter_item_check_id     alias for $1;
begin
	delete from as_actions_log where 
	inter_item_check_id = del__inter_item_check_id;
	
        delete from as_param_map where inter_item_check_id= del__inter_item_check_id;

	delete from as_action_map where inter_item_check_id = del__inter_item_check_id;

	delete from as_inter_item_checks where inter_item_check_id = del__inter_item_check_id;
        PERFORM acs_object__delete (del__inter_item_check_id);	
	return del__inter_item_check_id;	

end;' language 'plpgsql';	
	
	