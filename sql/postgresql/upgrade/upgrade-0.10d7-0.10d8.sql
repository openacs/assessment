update acs_attributes
set datatype = 'text'
where object_type = 'as_items'
and attribute_name in ('feedback_right', 'feedback_wrong');

update acs_attributes
set datatype = 'text'
where object_type = 'as_sections'
and attribute_name in ('instructions', 'feedback_text');

update acs_attributes
set datatype = 'text'
where object_type = 'as_assessments'
and attribute_name in ('instructions', 'consent_page');

update acs_attributes
set datatype = 'text'
where object_type = 'as_section_display_types'
and attribute_name = 'adp_chunk';

update acs_attributes
set datatype = 'text'
where object_type = 'as_item_data'
and attribute_name = 'clob_answer';
