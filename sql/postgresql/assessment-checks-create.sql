
-- Assessment Package
-- @author annyflores@viaro.net
-- @creation-date 2005-01-06

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
	item_id			integer,
	assessment_id		integer
);




create or replace function as_inter_item_check__new (integer,boolean,integer,integer,varchar,varchar,varchar,boolean,integer,integer,integer,integer)
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
	new__assessment_id	     alias for $12; 
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
	(inter_item_check_id,action_p,section_id_from,section_id_to,check_sql,name,description,postcheck_p,item_id,assessment_id)
        values (v_inter_item_check_id,new__action_p,new__section_id_from,new__section_id_to,new__check_sql,new__name,new__description,new__postcheck_p,new__item_id,new__assessment_id);

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
	
	