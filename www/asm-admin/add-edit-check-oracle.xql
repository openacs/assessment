<?xml version="1.0"?>
<queryset>

<fullquery name="new_check">
<querytext>
     declare begin
        :1 := as_inter_item_check.new (
		inter_item_check_id	=>     	:inter_item_check_id,
		name			=> 	:name,
		action_p		=>	:action_p,
		section_id_from 	=>	:section_id_from,
		section_id_to		=>	:section_id_to,
		check_sql		=>	:check_sql,
		description		=>	:description,
		postcheck_p		=>	:postcheck_p,
		item_id			=>	null,
		assessment_id		=>	:assessment_id,
		creation_user		=>	:user_id,
		context_id		=>	null,
		object_type		=>	'as_inter_item_checks',
		creation_date		=>	:date
		);
	end;

</querytext>
</fullquery>


</queryset>
