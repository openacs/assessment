
DO $$
BEGIN
   update acs_attributes set
      datatype = 'timestamp'
    where object_type = 'as_assessments'
      and attribute_name in ('start_time', 'end_time');

   update acs_attributes set
      datatype = 'timestamp'
    where object_type = 'as_item_data'
      and attribute_name in ('timestamp_answer');

   update acs_attributes set
      datatype = 'boolean'
    where object_type = 'as_item_display_sb'
      and attribute_name in ('multiple_p', 'prepend_empty_p');
      
   update acs_attributes set
      datatype = 'timestamp'
    where object_type = 'as_section_data'
      and attribute_name in ('creation_datetime', 'completed_datetime');      

   update acs_attributes set
      datatype = 'timestamp'
    where object_type = 'as_sessions'
      and attribute_name in (
          'target_datetime',
          'creation_datetime',
          'first_mod_datetime',
          'last_mod_datetime',
          'completed_datetime'
          );
END$$;
