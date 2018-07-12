
-- Assessment Package
-- @author annyflores@viaro.net
-- @creation-date 2005-01-06

select acs_object_type__create_type (
	'as_inter_item_check',
	'As_Inter_item_check',
	'As_Inter_item_checks',
	'acs_object',
	'as_inter_item_checks',
	'inter_item_check_id',
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






-- added
select define_function_args('as_inter_item_check__new','inter_item_check_id,action_p,section_id_from,section_id_to,check_sql,name,description,postcheck_p,item_id,creation_user,context_id,assessment_id');

--
-- procedure as_inter_item_check__new/12
--
CREATE OR REPLACE FUNCTION as_inter_item_check__new(
   new__inter_item_check_id integer,
   new__action_p boolean,
   new__section_id_from integer,
   new__section_id_to integer,
   new__check_sql varchar,
   new__name varchar,
   new__description varchar,
   new__postcheck_p boolean,
   new__item_id integer,
   new__creation_user integer,
   new__context_id integer,
   new__assessment_id integer
) RETURNS integer AS $$
DECLARE 
	v_inter_item_check_id	     integer;
BEGIN
	v_inter_item_check_id := acs_object__new (
		new__inter_item_check_id,
		'as_inter_item_check',
		now(),
		new__creation_user,
		null,
		new__context_id
	);
	insert into as_inter_item_checks 
	(inter_item_check_id,action_p,section_id_from,section_id_to,check_sql,name,description,postcheck_p,item_id,assessment_id)
        values (v_inter_item_check_id,new__action_p,new__section_id_from,new__section_id_to,new__check_sql,new__name,new__description,new__postcheck_p,new__item_id,new__assessment_id);

         return v_inter_item_check_id;
END;
$$ LANGUAGE plpgsql;



-- added
select define_function_args('as_inter_item_check__delete','inter_item_check_id');

--
-- procedure as_inter_item_check__delete/1
--
CREATE OR REPLACE FUNCTION as_inter_item_check__delete(
   del__inter_item_check_id integer
) RETURNS integer AS $$
DECLARE 
BEGIN
	delete from as_actions_log where 
	inter_item_check_id = del__inter_item_check_id;
	
        delete from as_param_map where inter_item_check_id= del__inter_item_check_id;

	delete from as_action_map where inter_item_check_id = del__inter_item_check_id;

	delete from as_inter_item_checks where inter_item_check_id = del__inter_item_check_id;
        PERFORM acs_object__delete (del__inter_item_check_id);	
	return del__inter_item_check_id;	

END;
$$ LANGUAGE plpgsql;	
	
	
