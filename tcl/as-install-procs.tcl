# /packages/assessment/tcl/as-install-procs.tcl

ad_library {
    Assessment Package callbacks library
    
    Procedures that deal with installing.
    
    @creation-date 2004-09-20
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
}

namespace eval as::install {}


ad_proc -public as::install::after_install {  
} { 
    Create content types and implementations
} { 

    # Create implementation for notifications of type "inter_item"
    inter_item_checks::apm_callback::package_install

    # Create content types and attributes
    as::install::assessment_create_install

    # Create implementation for notifications of type "assessment_response"
    as::install::notifications
}

ad_proc -public as::install::assessment_create_install {  
} { 
    Creates the content type and adds in attributes.
} { 

set value [parameter::get -parameter "AsmForRegisterId" -package_id [subsite::main_site_id]]

if {$value eq ""} {
    apm_parameter_register "AsmForRegisterId" "Assessment used on the registration process." "acs-subsite" "0" "number" "user-login"
}
    
content::type::new -content_type {as_item_choices} -supertype {content_revision} -pretty_name {Assessment Item Choice} -pretty_plural {Assessment Item Choices} -table_name {as_item_choices} -id_column {choice_id}
content::type::new -content_type {as_item_sa_answers} -supertype {content_revision} -pretty_name {Assessment Item Answer} -pretty_plural {Assessment Item Answer} -table_name {as_item_sa_answers} -id_column {choice_id}
content::type::new -content_type {as_item_type_mc} -supertype {content_revision} -pretty_name {Assessment Item Type Multiple Choice} -pretty_plural {Assessment Item Type Multiple Choice} -table_name {as_item_type_mc} -id_column {as_item_type_id}
content::type::new -content_type {as_item_type_oq} -supertype {content_revision} -pretty_name {Assessment Item Type Open Question} -pretty_plural {Assessment Item Type Open Question} -table_name {as_item_type_oq} -id_column {as_item_type_id}
content::type::new -content_type {as_item_type_sa} -supertype {content_revision} -pretty_name {Assessment Item Type Short Answer} -pretty_plural {Assessment Item Type Short Answer} -table_name {as_item_type_sa} -id_column {as_item_type_id}
content::type::new -content_type {as_item_display_rb} -supertype {content_revision} -pretty_name {Assessment Item Display Radio Button} -pretty_plural {Assessment Item Display Radio Button} -table_name {as_item_display_rb} -id_column {as_item_display_id}
content::type::new -content_type {as_item_display_cb} -supertype {content_revision} -pretty_name {Assessment Item Display CheckBox} -pretty_plural {Assessment Item Display CheckBox} -table_name {as_item_display_cb} -id_column {as_item_display_id}
content::type::new -content_type {as_item_display_sb} -supertype {content_revision} -pretty_name {Assessment Item Display SelectBox} -pretty_plural {Assessment Item Display SelectBox} -table_name {as_item_display_sb} -id_column {as_item_display_id}
content::type::new -content_type {as_item_display_tb} -supertype {content_revision} -pretty_name {Assessment Item Display TextBox} -pretty_plural {Assessment Item Display TextBox} -table_name {as_item_display_tb} -id_column {as_item_display_id}
content::type::new -content_type {as_item_display_sa} -supertype {content_revision} -pretty_name {Assessment Item Display Short Answer} -pretty_plural {Assessment Item Display Short Answer} -table_name {as_item_display_sa} -id_column {as_item_display_id}
content::type::new -content_type {as_item_display_ta} -supertype {content_revision} -pretty_name {Assessment Item Display TextArea} -pretty_plural {Assessment Item Display TextArea} -table_name {as_item_display_ta} -id_column {as_item_display_id}
content::type::new -content_type {as_items} -supertype {content_revision} -pretty_name {Assessment Item} -pretty_plural {Assessment Items} -table_name {as_items} -id_column {as_item_id}
content::type::new -content_type {as_section_display_types} -supertype {content_revision} -pretty_name {Assessment Section Display Type} -pretty_plural {Assessment Section Display Types} -table_name {as_section_display_types} -id_column {display_type_id}
content::type::new -content_type {as_sections} -supertype {content_revision} -pretty_name {Assessment Section} -pretty_plural {Assessment Sections} -table_name {as_sections} -id_column {section_id}
content::type::new -content_type {as_assessments}  -supertype {content_revision} -pretty_name {Assessment Assessment} -pretty_plural {Assessment Assessments} -table_name {as_assessments} -id_column {assessment_id}
content::type::new -content_type {as_sessions} -supertype {content_revision} -pretty_name {Assessment Session} -pretty_plural {Assessment Sessions} -table_name {as_sessions} -id_column {session_id}
content::type::new -content_type {as_section_data} -supertype {content_revision} -pretty_name {Assessment Section Data} -pretty_plural {Assessment Sections Data} -table_name {as_section_data} -id_column {section_data_id}
content::type::new -content_type {as_item_data} -supertype {content_revision} -pretty_name {Assessment Item Data} -pretty_plural {Assessment Items Data} -table_name {as_item_data} -id_column {item_data_id}
content::type::new -content_type {as_session_results} -supertype {content_revision} -pretty_name {Assessment Session Result} -pretty_plural {Assessment Session Results} -table_name {as_session_results} -id_column {result_id}

# Radiobutton display type
content::type::attribute::new -content_type {as_item_display_rb} -attribute_name {html_display_options} -datatype {string}    -pretty_name {HTML display Options} -column_spec {varchar(50)}
content::type::attribute::new -content_type {as_item_display_rb} -attribute_name {choice_orientation} -datatype {string}    -pretty_name {Choice Orientation} -column_spec {varchar(20)}
content::type::attribute::new -content_type {as_item_display_rb} -attribute_name {choice_label_orientation} -datatype {string}    -pretty_name {Choice Label Orientation} -column_spec {varchar(20)}
content::type::attribute::new -content_type {as_item_display_rb} -attribute_name {sort_order_type} -datatype {string}    -pretty_name {Sort Order Type} -column_spec {varchar(20)}
content::type::attribute::new -content_type {as_item_display_rb} -attribute_name {item_answer_alignment} -datatype {string}    -pretty_name {Item Answer Alignment} -column_spec {varchar(20)}
content::type::attribute::new -content_type {as_item_display_rb} -attribute_name {allow_other_p} -datatype {boolean}    -pretty_name {Allow Other?} -column_spec {char(1) default 'f'}
# Checkbox display type
content::type::attribute::new -content_type {as_item_display_cb} -attribute_name {html_display_options} -datatype {string}    -pretty_name {HTML display Options} -column_spec {varchar(50)}
content::type::attribute::new -content_type {as_item_display_cb} -attribute_name {choice_orientation} -datatype {string}    -pretty_name {Choice Orientation} -column_spec {varchar(20)}
content::type::attribute::new -content_type {as_item_display_cb} -attribute_name {choice_label_orientation} -datatype {string}    -pretty_name {Choice Label Orientation} -column_spec {varchar(20)}
content::type::attribute::new -content_type {as_item_display_cb} -attribute_name {sort_order_type} -datatype {string}    -pretty_name {Sort Order Type} -column_spec {varchar(20)}
content::type::attribute::new -content_type {as_item_display_cb} -attribute_name {item_answer_alignment} -datatype {string}    -pretty_name {Item Answer Alignment} -column_spec {varchar(20)}
content::type::attribute::new -content_type {as_item_display_cb} -attribute_name {allow_other_p} -datatype {boolean}    -pretty_name {Allow Other?} -column_spec {char(1) default 'f'}

# Selectbox display type
content::type::attribute::new -content_type {as_item_display_sb} -attribute_name {html_display_options} -datatype {string}    -pretty_name {HTML display Options} -column_spec {varchar(50)}
content::type::attribute::new -content_type {as_item_display_sb} -attribute_name {choice_label_orientation} -datatype {string}    -pretty_name {Choice Label Orientation} -column_spec {varchar(20)}
content::type::attribute::new -content_type {as_item_display_sb} -attribute_name {multiple_p} -datatype {string}    -pretty_name {Allow Multiple} -column_spec {char(1)}
content::type::attribute::new -content_type {as_item_display_sb} -attribute_name {sort_order_type} -datatype {string}    -pretty_name {Sort Order Type} -column_spec {varchar(20)}
content::type::attribute::new -content_type {as_item_display_sb} -attribute_name {item_answer_alignment} -datatype {string}    -pretty_name {Item Answer Alignment} -column_spec {varchar(20)}
content::type::attribute::new -content_type {as_item_display_sb} -attribute_name {prepend_empty_p} -datatype {string}    -pretty_name {Prepend Empty Item} -column_spec {char(1)}
content::type::attribute::new -content_type {as_item_display_sb} -attribute_name {allow_other_p} -datatype {boolean}    -pretty_name {Allow Other?} -column_spec {char(1) default 'f'}
# Textbox display type
content::type::attribute::new -content_type {as_item_display_tb} -attribute_name {html_display_options} -datatype {string}    -pretty_name {HTML display Options} -column_spec {varchar(50)}
content::type::attribute::new -content_type {as_item_display_tb} -attribute_name {abs_size} -datatype {string}    -pretty_name {Abstraction Real Size} -column_spec {varchar(20)}
content::type::attribute::new -content_type {as_item_display_tb} -attribute_name {item_answer_alignment} -datatype {string}    -pretty_name {Item Answer Alignment} -column_spec {varchar(20)}

# ShortAnswer display type
content::type::attribute::new -content_type {as_item_display_sa} -attribute_name {html_display_options} -datatype {string}    -pretty_name {HTML display Options} -column_spec {varchar(50)}
content::type::attribute::new -content_type {as_item_display_sa} -attribute_name {abs_size} -datatype {string}    -pretty_name {Abstraction Real Size} -column_spec {varchar(20)}
content::type::attribute::new -content_type {as_item_display_sa} -attribute_name {box_orientation} -datatype {string}    -pretty_name {Box Orientation} -column_spec {varchar(20)}

# Textarea display type
content::type::attribute::new -content_type {as_item_display_ta} -attribute_name {html_display_options} -datatype {string}    -pretty_name {HTML display Options} -column_spec {varchar(50)}
content::type::attribute::new -content_type {as_item_display_ta} -attribute_name {abs_size} -datatype {string}    -pretty_name {Abstraction Real Size} -column_spec {varchar(20)}
content::type::attribute::new -content_type {as_item_display_ta} -attribute_name {acs_widget} -datatype {string}    -pretty_name {ACS Templating Widget} -column_spec {varchar(20)}
content::type::attribute::new -content_type {as_item_display_ta} -attribute_name {item_answer_alignment} -datatype {string}    -pretty_name {Item Answer Alignment} -column_spec {varchar(20)}

# Item type multiple choice 
content::type::attribute::new -content_type {as_item_type_mc} -attribute_name {increasing_p}  -datatype {boolean}  -pretty_name {Increasing} -column_spec {char(1)}
content::type::attribute::new -content_type {as_item_type_mc} -attribute_name {allow_negative_p} -datatype {boolean}  -pretty_name {Allow Negative} -column_spec {char(1)}
content::type::attribute::new -content_type {as_item_type_mc} -attribute_name {num_correct_answers} -datatype {number}  -pretty_name {Number of Correct Answers} -column_spec {integer}
content::type::attribute::new -content_type {as_item_type_mc} -attribute_name {num_answers} -datatype {number}    -pretty_name {Number of Answers} -column_spec {integer}
content::type::attribute::new -content_type {as_item_type_mc} -attribute_name {allow_other_p} -datatype {boolean}    -pretty_name {Allow Other?} -column_spec {char(1) default 'f'}

# Item choices
content::type::attribute::new -content_type {as_item_choices} -attribute_name {mc_id}     -datatype {number}  -pretty_name {Parent ID}     -column_spec {integer}
content::type::attribute::new -content_type {as_item_choices} -attribute_name {data_type}     -datatype {string}  -pretty_name {Data Type}     -column_spec {varchar(20)}
content::type::attribute::new -content_type {as_item_choices} -attribute_name {numeric_value} -datatype {number}  -pretty_name {Numeric Value} -column_spec {numeric}
content::type::attribute::new -content_type {as_item_choices} -attribute_name {text_value}    -datatype {string}  -pretty_name {Text Value}    -column_spec {varchar(500)}
content::type::attribute::new -content_type {as_item_choices} -attribute_name {boolean_value} -datatype {boolean} -pretty_name {Boolean Value} -column_spec {boolean}
content::type::attribute::new -content_type {as_item_choices} -attribute_name {content_value} -datatype {number}  -pretty_name {Content Value} -column_spec {integer}
content::type::attribute::new -content_type {as_item_choices} -attribute_name {feedback_text} -datatype {string}  -pretty_name {Feedback Text} -column_spec {varchar(500)}
content::type::attribute::new -content_type {as_item_choices} -attribute_name {correct_answer_p} -datatype {boolean} -pretty_name {Correct Answer} -column_spec {char(1)}
content::type::attribute::new -content_type {as_item_choices} -attribute_name {selected_p}    -datatype {boolean} -pretty_name {Selected} -column_spec {char(1)}
content::type::attribute::new -content_type {as_item_choices} -attribute_name {fixed_position}         -datatype {number}  -pretty_name {Fixed Position} -column_spec {integer}
content::type::attribute::new -content_type {as_item_choices} -attribute_name {percent_score}         -datatype {number}  -pretty_name {Percent Score} -column_spec {integer}
content::type::attribute::new -content_type {as_item_choices} -attribute_name {sort_order}    -datatype {number}  -pretty_name {Sort Order} -column_spec {integer}

# Item type short answer
content::type::attribute::new -content_type {as_item_type_sa} -attribute_name {increasing_p}  -datatype {boolean}  -pretty_name {Increasing} -column_spec {char(1)}
content::type::attribute::new -content_type {as_item_type_sa} -attribute_name {allow_negative_p} -datatype {boolean}  -pretty_name {Allow Negative} -column_spec {char(1)}

# Item answers
content::type::attribute::new -content_type {as_item_sa_answers} -attribute_name {answer_id}     -datatype {number}  -pretty_name {Parent ID}     -column_spec {integer}
content::type::attribute::new -content_type {as_item_sa_answers} -attribute_name {data_type}     -datatype {string}  -pretty_name {Data Type}     -column_spec {varchar(20)}
content::type::attribute::new -content_type {as_item_sa_answers} -attribute_name {case_sensitive_p} -datatype {boolean}  -pretty_name {Case Sensitive} -column_spec {char(1)}
content::type::attribute::new -content_type {as_item_sa_answers} -attribute_name {percent_score} -datatype {number}  -pretty_name {Percent Score} -column_spec {integer}
content::type::attribute::new -content_type {as_item_sa_answers} -attribute_name {compare_by}    -datatype {string}  -pretty_name {Comparasion}    -column_spec {varchar(20)}
content::type::attribute::new -content_type {as_item_sa_answers} -attribute_name {regexp_text}    -datatype {string}  -pretty_name {Regexp}    -column_spec {varchar(20)}
content::type::attribute::new -content_type {as_item_sa_answers} -attribute_name {allowed_answerbox_list}    -datatype {string}  -pretty_name {Allowed Answerbox List}    -column_spec {varchar(20)}

# Item type open question
content::type::attribute::new -content_type {as_item_type_oq} -attribute_name {default_value}    -datatype {string}  -pretty_name {Default Value}    -column_spec {varchar(500)}
content::type::attribute::new -content_type {as_item_type_oq} -attribute_name {feedback_text}    -datatype {string} -pretty_name {Feedback Text} -column_spec {varchar(500)}
content::type::attribute::new -content_type {as_item_type_oq} -attribute_name {reference_answer} -datatype {text} -pretty_name {Reference Answer} -column_spec {text}
content::type::attribute::new -content_type {as_item_type_oq} -attribute_name {keywords} -datatype {string} -pretty_name {Keywords} -column_spec {varchar(4000)}

# Items
content::type::attribute::new -content_type {as_items} -attribute_name {subtext}              -datatype {string}  -pretty_name {Item Subtext}    -column_spec {varchar(500)}
content::type::attribute::new -content_type {as_items} -attribute_name {field_name}           -datatype {string}  -pretty_name {Item Field Name} -column_spec {varchar(500)}
content::type::attribute::new -content_type {as_items} -attribute_name {field_code}           -datatype {string}  -pretty_name {Item Field Code} -column_spec {varchar(500)}
content::type::attribute::new -content_type {as_items} -attribute_name {required_p}           -datatype {boolean} -pretty_name {Item Required}   -column_spec {char(1)}
content::type::attribute::new -content_type {as_items} -attribute_name {data_type}            -datatype {string}  -pretty_name {Item Data Type}  -column_spec {varchar(50)}
content::type::attribute::new -content_type {as_items} -attribute_name {max_time_to_complete} -datatype {number}  -pretty_name {Item Max Time to Complete} -column_spec {integer}
content::type::attribute::new -content_type {as_items} -attribute_name {feedback_wrong}    -datatype {text} -pretty_name {Item Right Feedback} -column_spec {text}
content::type::attribute::new -content_type {as_items} -attribute_name {feedback_right}    -datatype {text} -pretty_name {Item Wrong Feedback} -column_spec {text}
content::type::attribute::new -content_type {as_items} -attribute_name {points} -datatype {number}  -pretty_name {Points awarded for this item} -column_spec {float}
content::type::attribute::new -content_type {as_items} -attribute_name {validate_block} -datatype {text} -pretty_name {Validation Block} -column_spec {text}

# Sections
content::type::attribute::new -content_type {as_sections} -attribute_name {display_type_id}      -datatype {number}  -pretty_name {Section Display Type}  -column_spec {integer}
content::type::attribute::new -content_type {as_sections} -attribute_name {instructions}      -datatype {text}  -pretty_name {Section Instructions}  -column_spec {text}
content::type::attribute::new -content_type {as_sections} -attribute_name {num_items}      -datatype {number}  -pretty_name {Number of items displayed in this section}  -column_spec {integer}
content::type::attribute::new -content_type {as_sections} -attribute_name {feedback_text}      -datatype {text}  -pretty_name {Section Feedback}  -column_spec {text}
content::type::attribute::new -content_type {as_sections} -attribute_name {max_time_to_complete}      -datatype {number}  -pretty_name {Section Max Time to Complete}  -column_spec {integer}
content::type::attribute::new -content_type {as_sections} -attribute_name {points} -datatype {number}  -pretty_name {Points awarded for this section} -column_spec {float}

# Section Display Types
content::type::attribute::new -content_type {as_section_display_types} -attribute_name {num_items}      -datatype {number}  -pretty_name {Number of items displayed per page}  -column_spec {integer}
content::type::attribute::new -content_type {as_section_display_types} -attribute_name {adp_chunk}      -datatype {text}  -pretty_name {Section Display Template}  -column_spec {text}
content::type::attribute::new -content_type {as_section_display_types} -attribute_name {branched_p}      -datatype {boolean}  -pretty_name {Section Branched}  -column_spec {char(1)}
content::type::attribute::new -content_type {as_section_display_types} -attribute_name {back_button_p}      -datatype {boolean}  -pretty_name {Back button allowed}  -column_spec {char(1)}
content::type::attribute::new -content_type {as_section_display_types} -attribute_name {submit_answer_p}      -datatype {boolean}  -pretty_name {Seperate submit for each answer}  -column_spec {char(1)}
content::type::attribute::new -content_type {as_section_display_types} -attribute_name {sort_order_type}      -datatype {string}  -pretty_name {Item sort order type}  -column_spec {varchar(20)}

# Assessments
content::type::attribute::new -content_type {as_assessments} -attribute_name {creator_id}            -datatype {number}  -pretty_name {Assessment Creator Identifier}  -column_spec {integer}
content::type::attribute::new -content_type {as_assessments} -attribute_name {instructions}            -datatype {text}  -pretty_name {Assessment Creator Instructions}  -column_spec {text}
content::type::attribute::new -content_type {as_assessments} -attribute_name {run_mode}            -datatype {string}  -pretty_name {Assessment Mode}  -column_spec {varchar(25)}
content::type::attribute::new -content_type {as_assessments} -attribute_name {anonymous_p}         -datatype {boolean} -pretty_name {Assessment Anonymous} -column_spec {char(1)}
content::type::attribute::new -content_type {as_assessments} -attribute_name {secure_access_p}         -datatype {boolean} -pretty_name {Assessment Secure Access} -column_spec {char(1)}
content::type::attribute::new -content_type {as_assessments} -attribute_name {reuse_responses_p}         -datatype {boolean} -pretty_name {Assessment Reuse Responses} -column_spec {char(1)}
content::type::attribute::new -content_type {as_assessments} -attribute_name {show_item_name_p}         -datatype {boolean} -pretty_name {Assessment Show question titles} -column_spec {char(1)}
content::type::attribute::new -content_type {as_assessments} -attribute_name {random_p}         -datatype {boolean} -pretty_name {Assessment Allow Random} -column_spec {char(1)}
content::type::attribute::new -content_type {as_assessments} -attribute_name {entry_page}            -datatype {string}  -pretty_name {Assessment Customizable Entry page}  -column_spec {varchar(50)}
content::type::attribute::new -content_type {as_assessments} -attribute_name {exit_page}            -datatype {string}  -pretty_name {Assessment Customizable Thank/Exit page}  -column_spec {varchar(50)}
content::type::attribute::new -content_type {as_assessments} -attribute_name {consent_page}            -datatype {text}  -pretty_name {Assessment Consent Pages}  -column_spec {text}
content::type::attribute::new -content_type {as_assessments} -attribute_name {return_url}            -datatype {string}  -pretty_name {Assessment Return URL}  -column_spec {varchar(50)}
content::type::attribute::new -content_type {as_assessments} -attribute_name {start_time}            -datatype {number}  -pretty_name {Assessment Start Time}  -column_spec {timestamptz}
content::type::attribute::new -content_type {as_assessments} -attribute_name {end_time}            -datatype {number}  -pretty_name {Assessment End Time}  -column_spec {timestamptz}
content::type::attribute::new -content_type {as_assessments} -attribute_name {number_tries}            -datatype {number}  -pretty_name {Assessment Number Tries}  -column_spec {integer}
content::type::attribute::new -content_type {as_assessments} -attribute_name {wait_between_tries}            -datatype {number}  -pretty_name {Assessment Wait Between Tries}  -column_spec {integer}
content::type::attribute::new -content_type {as_assessments} -attribute_name {time_for_response}            -datatype {number}  -pretty_name {Assessment Time for Response}  -column_spec {integer}
content::type::attribute::new -content_type {as_assessments} -attribute_name {ip_mask}            -datatype {string}  -pretty_name {IP Mask}  -column_spec {varchar(100)}
content::type::attribute::new -content_type {as_assessments} -attribute_name {password} -datatype {string} -pretty_name {Password} -column_spec {varchar(100)}
content::type::attribute::new -content_type {as_assessments} -attribute_name {show_feedback}            -datatype {string}  -pretty_name {Assessment Show comments to the user}  -column_spec {varchar(50)}
content::type::attribute::new -content_type {as_assessments} -attribute_name {section_navigation}            -datatype {string}  -pretty_name {Assessment Navigation of sections}  -column_spec {varchar(50)}
# survey_p is replaced by type
content::type::attribute::new -content_type {as_assessments} -attribute_name {type}            -datatype {string}  -pretty_name {Type}  -column_spec {varchar(1000)}

# Sessions
content::type::attribute::new -content_type {as_sessions} -attribute_name {assessment_id}            -datatype {number}  -pretty_name {Assessment ID}  -column_spec {integer}
content::type::attribute::new -content_type {as_sessions} -attribute_name {subject_id}     -datatype {number}  -pretty_name {Subject ID}     -column_spec {integer}
content::type::attribute::new -content_type {as_sessions} -attribute_name {staff_id}     -datatype {number}  -pretty_name {Staff ID}     -column_spec {integer}
content::type::attribute::new -content_type {as_sessions} -attribute_name {target_datetime}     -datatype {number}  -pretty_name {Target Date Time}     -column_spec {timestamptz}
content::type::attribute::new -content_type {as_sessions} -attribute_name {creation_datetime}     -datatype {number}  -pretty_name {Creation Date Time}     -column_spec {timestamptz}
content::type::attribute::new -content_type {as_sessions} -attribute_name {first_mod_datetime}     -datatype {number}  -pretty_name {First Submission}     -column_spec {timestamptz}
content::type::attribute::new -content_type {as_sessions} -attribute_name {last_mod_datetime}     -datatype {number}  -pretty_name {Most Recent Submission}     -column_spec {timestamptz}
content::type::attribute::new -content_type {as_sessions} -attribute_name {completed_datetime}     -datatype {number}  -pretty_name {Final Submission}     -column_spec {timestamptz}
content::type::attribute::new -content_type {as_sessions} -attribute_name {session_status}            -datatype {string}  -pretty_name {Session Status}  -column_spec {varchar(20)}
content::type::attribute::new -content_type {as_sessions} -attribute_name {assessment_status}            -datatype {string}  -pretty_name {Assessment Status}  -column_spec {varchar(20)}
content::type::attribute::new -content_type {as_sessions} -attribute_name {percent_score}            -datatype {number}  -pretty_name {Percent Score}  -column_spec {integer}
content::type::attribute::new -content_type {as_sessions} -attribute_name {elapsed_seconds}            -datatype {number}  -pretty_name {Elapsed Seconds}  -column_spec {integer}

# Section data
content::type::attribute::new -content_type {as_section_data} -attribute_name {session_id}            -datatype {number}  -pretty_name {Session ID}  -column_spec {integer}
content::type::attribute::new -content_type {as_section_data} -attribute_name {section_id}            -datatype {number}  -pretty_name {Section ID}  -column_spec {integer}
content::type::attribute::new -content_type {as_section_data} -attribute_name {subject_id}            -datatype {number}  -pretty_name {Subject ID}  -column_spec {integer}
content::type::attribute::new -content_type {as_section_data} -attribute_name {staff_id}            -datatype {number}  -pretty_name {Staff ID}  -column_spec {integer}
content::type::attribute::new -content_type {as_section_data} -attribute_name {points}            -datatype {number}  -pretty_name {Points Awarded}  -column_spec {float}
content::type::attribute::new -content_type {as_section_data} -attribute_name {creation_datetime}     -datatype {number}  -pretty_name {Creation Date Time}     -column_spec {timestamptz}
content::type::attribute::new -content_type {as_section_data} -attribute_name {completed_datetime}     -datatype {number}  -pretty_name {Final Submission}     -column_spec {timestamptz}

# Item data
content::type::attribute::new -content_type {as_item_data} -attribute_name {session_id}     -datatype {number}  -pretty_name {Session ID}     -column_spec {integer}
content::type::attribute::new -content_type {as_item_data} -attribute_name {subject_id}     -datatype {number}  -pretty_name {Subject ID}     -column_spec {integer}
content::type::attribute::new -content_type {as_item_data} -attribute_name {staff_id}     -datatype {number}  -pretty_name {Staff ID}     -column_spec {integer}
content::type::attribute::new -content_type {as_item_data} -attribute_name {as_item_id}     -datatype {number}  -pretty_name {Item ID}     -column_spec {integer}
content::type::attribute::new -content_type {as_item_data} -attribute_name {section_id}     -datatype {number}  -pretty_name {Section ID}     -column_spec {integer}
content::type::attribute::new -content_type {as_item_data} -attribute_name {is_unknown_p} -datatype {boolean}  -pretty_name {Is Unknown} -column_spec {char(1)}
content::type::attribute::new -content_type {as_item_data} -attribute_name {boolean_answer} -datatype {boolean} -pretty_name {Boolean Answer} -column_spec {boolean}
content::type::attribute::new -content_type {as_item_data} -attribute_name {clob_answer} -datatype {text} -pretty_name {Clob Answer} -column_spec {text}
content::type::attribute::new -content_type {as_item_data} -attribute_name {numeric_answer} -datatype {number}  -pretty_name {Numeric Answer} -column_spec {numeric}
content::type::attribute::new -content_type {as_item_data} -attribute_name {integer_answer} -datatype {number}  -pretty_name {Integer Answer} -column_spec {integer}
content::type::attribute::new -content_type {as_item_data} -attribute_name {text_answer}    -datatype {string}  -pretty_name {Text Answer}    -column_spec {varchar(500)}
content::type::attribute::new -content_type {as_item_data} -attribute_name {timestamp_answer}    -datatype {number}  -pretty_name {TimeStamp Answer}    -column_spec {timestamptz}
content::type::attribute::new -content_type {as_item_data} -attribute_name {content_answer} -datatype {number}  -pretty_name {Content Answer} -column_spec {integer}
content::type::attribute::new -content_type {as_item_data} -attribute_name {signed_data}    -datatype {string}  -pretty_name {Signed Data}    -column_spec {varchar(500)}
content::type::attribute::new -content_type {as_item_data} -attribute_name {points} -datatype {number}  -pretty_name {Points awarded} -column_spec {float}

content::type::attribute::new -content_type {as_item_data} -attribute_name {as_item_cr_item_id} -datatype {number} -pretty_name {as_item cr_item_id} -column_spec {integer}
content::type::attribute::new -content_type {as_item_data} -attribute_name {choice_value} -datatype {text} -pretty_name {Choice Value}

# Session results
content::type::attribute::new -content_type {as_session_results} -attribute_name {target_id} -datatype {number} -pretty_name {Target Answer} -column_spec {integer}
content::type::attribute::new -content_type {as_session_results} -attribute_name {points} -datatype {number} -pretty_name {Points} -column_spec {float}

#File Upload Ansers
content::type::new -content_type {as_item_type_fu} -supertype {content_revision} -pretty_name {Assessment Item Type File Upload} -pretty_plural {Assessment Item Type File Upload} -table_name {as_item_type_fu} -id_column {as_item_type_id}

content::type::new -content_type {as_item_display_f} -supertype {content_revision} -pretty_name {Assessment Item Display File} -pretty_plural {Assessment Item Display File} -table_name {as_item_display_f} -id_column {as_item_display_id}

# File Upload display type
content::type::attribute::new -content_type {as_item_display_f} -attribute_name {html_display_options} -datatype {string}    -pretty_name {HTML display Options} -column_spec {varchar(50)}
content::type::attribute::new -content_type {as_item_display_f} -attribute_name {abs_size} -datatype {string}    -pretty_name {Abstraction Real Size} -column_spec {varchar(20)}
content::type::attribute::new -content_type {as_item_display_f} -attribute_name {box_orientation} -datatype {string}    -pretty_name {Box Orientation} -column_spec {varchar(20)}

}

ad_proc -public as::install::package_instantiate {
    -package_id:required
} {
    Define folders
    
} {
    # create a content folder
    set folder_id [content::folder::new -name "assessment_$package_id" -package_id $package_id -context_id $package_id]
    # register the allowed content types for a folder
    content::folder::register_content_type -folder_id $folder_id -content_type {image} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {content_revision} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_choices} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_type_mc} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_sa_answers} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_type_sa} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_type_oq} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_display_rb} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_display_cb} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_display_sb} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_display_tb} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_display_sa} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_display_ta} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_items} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_section_display_types} -include_subtypes t

    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_type_fu} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_display_f} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_sections} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_assessments} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_sessions} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_section_data} -include_subtypes t
    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_data} -include_subtypes t
}


ad_proc -public as::install::after_upgrade {
    {-from_version_name:required}
    {-to_version_name:required}
} {
    apm_upgrade_logic \
        -from_version_name $from_version_name \
        -to_version_name $to_version_name \
        -spec {
            0.08d 0.09d1 {
                db_transaction {
                    content::type::attribute::new -content_type {as_sections} -attribute_name {num_items}      -datatype {number}  -pretty_name {Number of items displayed in this section}  -column_spec {integer}
                    content::type::attribute::new -content_type {as_item_choices} -attribute_name {fixed_position}         -datatype {number}  -pretty_name {Fixed Position} -column_spec {integer}
                    set packages [db_list packages {select package_id from apm_packages where package_key = 'assessment'}]
                    foreach package_id $packages {
                        set folder_id [as::assessment::folder_id -package_id $package_id]
                        content::folder::register_content_type -folder_id $folder_id -content_type {image} -include_subtypes t
                        content::folder::register_content_type -folder_id $folder_id -content_type {content_revision} -include_subtypes t
                    }
                }
            }
            0.09d1 0.10d1 {
                content::type::attribute::new -content_type {as_section_data} -attribute_name {points} -datatype {number} -pretty_name {Points Awarded} -column_spec {integer}
            }
            0.10d1 0.10d2 {
                content::type::attribute::new -content_type {as_item_data} -attribute_name {section_id} -datatype {number} -pretty_name {Section ID} -column_spec {integer}
            }
            0.10d2 0.10d3 {
                db_transaction {
                    content::type::attribute::new -content_type {as_section_data} -attribute_name {creation_datetime} -datatype {number} -pretty_name {Creation Date Time} -column_spec {timestamptz}
                    content::type::attribute::new -content_type {as_section_data} -attribute_name {completed_datetime} -datatype {number} -pretty_name {Final Submission} -column_spec {timestamptz}
                    content::type::attribute::new -content_type {as_assessments} -attribute_name {ip_mask} -datatype {string} -pretty_name {IP Mask} -column_spec {varchar(100)}
                }
            }
            0.10d3 0.10d4 {
                as::install::notifications
            }
            0.10d6 0.10d7 {
                as::actions::insert_actions_after_upgrade
            }
            0.10d8 0.10d9 {
                db_transaction {
                    content::type::new -content_type {as_session_results} -supertype {content_revision} -pretty_name {Assessment Session Result} -pretty_plural {Assessment Session Results} -table_name {as_session_results} -id_column {result_id}
                    content::type::attribute::new -content_type {as_session_results} -attribute_name {target_id} -datatype {number} -pretty_name {Target Answer} -column_spec {integer}
                    content::type::attribute::new -content_type {as_session_results} -attribute_name {points} -datatype {number} -pretty_name {Points} -column_spec {integer}

                    set packages [db_list packages {select package_id from apm_packages where package_key = 'assessment'}]
                    foreach package_id $packages {
                        set folder_id [as::assessment::folder_id -package_id $package_id]
                        content::folder::register_content_type -folder_id $folder_id -content_type {as_session_results} -include_subtypes t
                    }

                    set item_data_list [db_list_of_lists get_all_item_data_ids {
                        select item_data_id, points
                        from as_item_data
                        where points is not null
                    }]
                    foreach item_data $item_data_list {
                        as::session_results::new -target_id [lindex $item_data 0] -points [lindex $item_data 1]
                    }

                    set section_data_list [db_list_of_lists get_all_section_data_ids {
                        select section_data_id, points
                        from as_section_data
                        where points is not null
                    }]
                    foreach section_data $section_data_list {
                        as::session_results::new -target_id [lindex $section_data 0] -points [lindex $section_data 1]
                    }

                    set session_list [db_list_of_lists get_all_session_ids {
                        select session_id, percent_score
                        from as_sessions
                        where percent_score is not null
                    }]
                    foreach session $session_list {
                        as::session_results::new -target_id [lindex $session 0] -points [lindex $session 1]
                    }

                    content::type::attribute::new -content_type {as_assessments} -attribute_name {password} -datatype {string} -pretty_name {Password} -column_spec {varchar(100)}

                    content::type::attribute::new -content_type {as_item_type_oq} -attribute_name {reference_answer} -datatype {text} -pretty_name {Reference Answer} -column_spec {text}
                    content::type::attribute::new -content_type {as_item_type_oq} -attribute_name {keywords} -datatype {string} -pretty_name {Keywords} -column_spec {varchar(4000)}
                }
            }
            0.10d9 0.10d10 {
                as::actions::update_checks_after_upgrade
            }
            0.10d10 0.10d11 {
                content::type::attribute::new -content_type {as_assessments} -attribute_name {random_p} -datatype {boolean} -pretty_name {Assessment Allow Random} -column_spec {char(1)}
            }
            0.10d11 0.10d12 {
                content::type::attribute::new -content_type {as_items} -attribute_name {field_name} -datatype {string} -pretty_name {Item Field Name} -column_spec {varchar(500)}
            }
            
            0.11 0.12 {
                #File Upload new type
                content::type::new -content_type {as_item_type_fu} -supertype {content_revision} -pretty_name {Assessment Item Type File Upload} -pretty_plural {Assessment Item Type File Upload} -table_name {as_item_type_fu} -id_column {as_item_type_id}
                content::type::new -content_type {as_item_display_f} -supertype {content_revision} -pretty_name {Assessment Item Display File} -pretty_plural {Assessment Item Display File} -table_name {as_item_display_f} -id_column {as_item_display_id}
                # File Upload display type
                content::type::attribute::new -content_type {as_item_display_f} -attribute_name {html_display_options} -datatype {string} -pretty_name {HTML display Options} -column_spec {varchar(50)}
                content::type::attribute::new -content_type {as_item_display_f} -attribute_name {abs_size} -datatype {string} -pretty_name {Abstraction Real Size} -column_spec {varchar(20)}
                content::type::attribute::new -content_type {as_item_display_f} -attribute_name {box_orientation} -datatype {string} -pretty_name {Box Orientation} -column_spec {varchar(20)}
                
                db_foreach packages { select package_id from apm_packages where package_key = 'assessment'} { 
                    set folder_id [as::assessment::folder_id -package_id $package_id]
                    
                    # File Upload registration
                    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_type_fu} -include_subtypes t
                    content::folder::register_content_type -folder_id $folder_id -content_type {as_item_display_f} -include_subtypes t
                }
                
            }
            0.12 0.13 {
                content::type::attribute::new -content_type {as_assessments} -attribute_name {type}            -datatype {number}  -pretty_name {Type}  -column_spec {integer}
                
            }
            0.13 0.14 {
                # update as_param_map table to set the item_id  as a cr_item and not a cr_revision id
                
                db_foreach as_parameter { select cr.item_id, pm.parameter_id from as_param_map pm, cr_revisions cr where cr.revision_id = pm.item_id} {
                    db_dml update_parameters { update as_param_map set item_id=:item_id where parameter_id=:parameter_id}
                }
                
            }
            0.14 0.15 {
                # update as_inter_item_check_id table to set the check_sql condition using the item_id of a choice instead of using the revision_id
                
                db_foreach check { select inter_item_check_id, check_sql from as_inter_item_checks } {
                    set cond_list  [split $check_sql "="]
                    set item_id [lindex [split [lindex $cond_list 2] " "] 0]
                    set choice_id [lindex [split [lindex $cond_list 1] " "] 0]
                    set condition [db_string get_item_id {select item_id from cr_revisions where revision_id=:choice_id} -default -1]
                    set check_sql_updated [as::assessment::check::get_sql -item_id $item_id -condition $condition]
                    if { $condition != -1 } {
                        db_dml update_check_sql { update as_inter_item_checks set check_sql = :check_sql_updated where inter_item_check_id=:inter_item_check_id}
                    }
                }
                
            }
            0.15 0.16 {
                content::type::attribute::new -content_type {as_item_display_sb} -attribute_name {prepend_empty_p} -datatype {string}    -pretty_name {Prepend Empty Item} -column_spec {char(1)}
            } 
            0.16 0.17 {
                content::type::attribute::new -content_type {as_items} -attribute_name {validate_block} -datatype {text} -pretty_name {Validation Block} -column_spec {text}
            }
            0.22d6 0.22d7 {
                if { ![acs_sc_binding_exists_p NotificationType assessment_response_notif_type] } {
                    as::install::notifications
                }
            }
    	    0.22d7 0.22d8 {
		# upgrade already done in SQL just add the attributes for
		# completeness
		content::type::attribute::new -content_type {as_item_data} -attribute_name {as_item_cr_item_id} -datatype {number} -pretty_name {as_item cr_item_id} -column_spec {integer}
		content::type::attribute::new -content_type {as_item_data} -attribute_name {choice_value} -datatype {text} -pretty_name {Choice Value}
                
                content::type::attribute::new -content_type {as_sessions} -attribute_name {elapsed_seconds}            -datatype {number}  -pretty_name {Elapsed Seconds}  -column_spec {integer}
		content::type::attribute::new -content_type {as_item_type_mc} -attribute_name {allow_other_p} -datatype {boolean}    -pretty_name {Allow Other?} -column_spec {char(1) default 'f'}
	    }
	}    
}

ad_proc -public as::install::before_uninstantiate {  
    {-package_id}
    {-node_id ""}
} { 
    before-uninstantiate callback.
} { 
    # reset the RegistrationId parameter
    as::parameter::reset_parameter -package_id $package_id -node_id $node_id
ns_log notice "delete assessment package $package_id"
    # delete actions
    db_foreach get_package_actions {} {
        ns_log debug "delete action $object_id"
        package_exec_plsql -var_list [list [list action_id $object_id]] \
            as_action del
    }
    foreach folder_id [db_list get_folders ""] {
        content::folder::delete -folder_id $folder_id -cascade_p t
    }
}

ad_proc -public as::install::before_unmount {  
    {-package_id}
    {-node_id ""}
} { 
    before-unmount callback.
} { 
    # reset the RegistrationId parameter
    as::parameter::reset_parameter -package_id $package_id -node_id $node_id
}

ad_proc -private as::install::notifications {  
} { 
    Create notif implementation for type assessment_response
} { 

    db_transaction {
        set impl_id [acs_sc::impl::new -contract_name NotificationType -name assessment_response_notif_type -owner assessment]
        acs_sc::impl::alias::new -contract_name NotificationType -impl_name assessment_response_notif_type -operation GetURL -alias as::notification::get_url -language TCL
        acs_sc::impl::alias::new -contract_name NotificationType -impl_name assessment_response_notif_type -operation ProcessReply -alias as::notification::process_reply -language TCL
        acs_sc::impl::binding::new -contract_name NotificationType -impl_name assessment_response_notif_type

        set type_id [notification::type::new -sc_impl_id $impl_id -short_name assessment_response_notif -pretty_name "Survey Response Notification" -description "Notifications for Assessment"]

        db_dml insert_intervals {
            insert into notification_types_intervals
            (type_id, interval_id)
            select :type_id as type_id, interval_id
            from notification_intervals
            where name in ('instant','hourly','daily')
        }
        db_dml insert_delivery_method {
            insert into notification_types_del_methods
            (type_id, delivery_method_id)
            select :type_id as type_id, delivery_method_id
            from notification_delivery_methods
            where short_name = 'email'
        }
    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
