ad_page_contract {
	@author eperez@it.uc3m.es
	@creation-date 2004-07-20
} {
} -properties {
    context:onevalue
}

if {0} {
#set package_id [ad_conn package_id]
#set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]
#content::folder::delete -folder_id $folder_id -cascade_p {t}

if {0} {
content::type::create_type -content_type {as_item_choices} -supertype {content_revision} -pretty_name {Assessment Item Choice} -pretty_plural {Assessment Item Choices} -table_name {as_item_choices} -id_column {choice_id}
content::type::create_type -content_type {as_items} -supertype {content_revision} -pretty_name {Assessment Item} -pretty_plural {Assessment Items} -table_name {as_items} -id_column {as_item_id}
content::type::create_type -content_type {as_sections} -supertype {content_revision} -pretty_name {Assessment Section} -pretty_plural {Assessment Sections} -table_name {as_sections} -id_column {section_id}
content::type::create_type -content_type {as_assessments} -supertype {content_revision} -pretty_name {Assessment Assessment} -pretty_plural {Assessment Assessments} -table_name {as_assessments} -id_column {assessment_id}
}

content::type::create_attribute -content_type {as_item_choices} -attribute_name {parent_id}     -datatype {number}  -pretty_name {Parent ID}     -column_spec {integer}
content::type::create_attribute -content_type {as_item_choices} -attribute_name {data_type}     -datatype {string}  -pretty_name {Data Type}     -column_spec {varchar(20)}
content::type::create_attribute -content_type {as_item_choices} -attribute_name {numeric_value} -datatype {number}  -pretty_name {Numeric Value} -column_spec {numeric}
content::type::create_attribute -content_type {as_item_choices} -attribute_name {text_value}    -datatype {string}  -pretty_name {Text Value}    -column_spec {varchar(500)}
content::type::create_attribute -content_type {as_item_choices} -attribute_name {boolean_value} -datatype {boolean} -pretty_name {Boolean Value} -column_spec {boolean}
content::type::create_attribute -content_type {as_item_choices} -attribute_name {content_value} -datatype {number}  -pretty_name {Content Value} -column_spec {integer}
content::type::create_attribute -content_type {as_item_choices} -attribute_name {feedback_text} -datatype {string}  -pretty_name {Feedback Text} -column_spec {varchar(500)}
content::type::create_attribute -content_type {as_item_choices} -attribute_name {correct_answer_p} -datatype {boolean} -pretty_name {Correct Answer} -column_spec {char(1)}
content::type::create_attribute -content_type {as_item_choices} -attribute_name {selected_p}    -datatype {boolean} -pretty_name {Selected} -column_spec {char(1)}
content::type::create_attribute -content_type {as_item_choices} -attribute_name {score}         -datatype {number}  -pretty_name {Score} -column_spec {integer}
content::type::create_attribute -content_type {as_item_choices} -attribute_name {sort_order}    -datatype {number}  -pretty_name {Sort Order} -column_spec {integer}

content::type::create_attribute -content_type {as_items} -attribute_name {subtext}              -datatype {string}  -pretty_name {Item Subtext}    -column_spec {varchar(500)}
content::type::create_attribute -content_type {as_items} -attribute_name {field_code}           -datatype {string}  -pretty_name {Item Field Code} -column_spec {varchar(500)}
content::type::create_attribute -content_type {as_items} -attribute_name {enabled_p}            -datatype {boolean} -pretty_name {Item Enabled}    -column_spec {char(1)}
content::type::create_attribute -content_type {as_items} -attribute_name {required_p}           -datatype {boolean} -pretty_name {Item Required}   -column_spec {char(1)}
content::type::create_attribute -content_type {as_items} -attribute_name {item_default}         -datatype {string}  -pretty_name {Item Default}    -column_spec {varchar(500)}
content::type::create_attribute -content_type {as_items} -attribute_name {max_time_to_complete} -datatype {number}  -pretty_name {Item Max Time to Complate} -column_spec {integer}
content::type::create_attribute -content_type {as_items} -attribute_name {adp_chunk}            -datatype {string}  -pretty_name {Item Adp Chunk}  -column_spec {varchar(500)}

content::type::create_attribute -content_type {as_sections} -attribute_name {instructions}      -datatype {string}  -pretty_name {Section Instructions}  -column_spec {text}
content::type::create_attribute -content_type {as_sections} -attribute_name {enabled_p}         -datatype {boolean} -pretty_name {Section Enabled} -column_spec {char(1)}
}

set folder_id [content::folder::new -name {as_items} -package_id [ad_conn package_id] ]
content::folder::register_content_type -folder_id $folder_id -content_type {as_item_choices} -include_subtypes t
content::folder::register_content_type -folder_id $folder_id -content_type {as_items} -include_subtypes t
content::folder::register_content_type -folder_id $folder_id -content_type {as_sections} -include_subtypes t
content::folder::register_content_type -folder_id $folder_id -content_type {as_assessments} -include_subtypes t

set context [list]

ad_return_template
