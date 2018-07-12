
DO $$
BEGIN
   update acs_object_types set
      table_name = 'as_inter_item_checks'
    where object_type = 'as_inter_item_check';

   update acs_object_types set
      name_method = null
    where object_type = 'as_action';
END$$;
