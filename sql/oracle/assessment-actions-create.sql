-- Assessment Package
-- @author annyflores@viaro.net
-- @creation-date 2005-01-06


------------------------------------------------
-- 	table as_actions
------------------------------------------------


create table as_actions(
	action_id	integer
			constraint as_actions_pk
			primary key,
	name		varchar(200),
	description	varchar(200),
	tcl_code	varchar(4000)
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
	query		varchar(400)
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
	approved_p		varchar(1) not null,
	failed_p		varchar(1) not null,
	error_txt		varchar(100),
	session_id		integer
);

--------------------------------------------------------
--   SEQUENCE FOR PRIMARY KEY
--------------------------------------------------------

        create sequence action_log_id_seq
        minvalue 1
        maxvalue 999999999
        start with 1
        increment by 1
        cache 20;


--------------------------------------------------------
--   SEQUENCE FOR PRIMARY KEY
--------------------------------------------------------

        create sequence parameter_id_seq
        minvalue 1
        maxvalue 999999999
        start with 1
        increment by 1
        cache 20;

