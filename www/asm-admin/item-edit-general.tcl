ad_page_contract {
    Form to edit an item.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:integer
    section_id:integer
    as_item_id:integer
    choice:optional,array
    correct:optional,array
    move_up:optional,array
    move_down:optional,array
    delete:optional,array
} -properties {
    context:onevalue
    page_title:onevalue
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set page_title [_ assessment.edit_item_general]
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] [list [export_vars -base item-edit {assessment_id section_id as_item_id}] [_ assessment.edit_item]] $page_title]
set package_id [ad_conn package_id]

set boolean_options [list [list "[_ assessment.yes]" t] [list "[_ assessment.no]" f]]
set type $assessment_data(type)

set item_type [string range [db_string get_item_type {}] end-1 end]
set display_types [list]
foreach display_type [db_list display_types {}] {
    lappend display_types [list "[_ assessment.item_display_$display_type]" $display_type]
}


ad_form -name item_edit_general -action item-edit-general -export { assessment_id section_id } -html {enctype multipart/form-data} -form {
    {as_item_id:key}
    {question_text:richtext,nospell {label "[_ assessment.Question]"} {html {rows 9 cols 80 style {width: 95%}}} {help_text "[_ assessment.item_Question_help]"}}
    {required_p:text(select) {label "[_ assessment.Required]"} {options $boolean_options} {help_text "[_ assessment.item_Required_help]"}}
}

if { $type ne "survey"} { 
    ad_form -extend -name item_edit_general -form {
        {points:integer,optional,nospell {label "[_ assessment.points_item]"} {html {size 10 maxlength 10}} {help_text "[_ assessment.points_item_help]"}}
        {feedback_right:richtext,optional,nospell {label "[_ assessment.Feedback_right]"} {html {rows 5 cols 80 style {width:95%}}} {help_text "[_ assessment.Feedback_right_help]"}}
        {feedback_wrong:richtext,optional,nospell {label "[_ assessment.Feedback_wrong]"} {html {rows 5 cols 80 style {width:95%}}} {help_text "[_ assessment.Feedback_wrong_help]"}}
    }
} else {
    ad_form -extend -name item_edit_general -form {
        {points:text(hidden) ""}
        {feedback_right:text(hidden),optional}
        {feedback_wrong:text(hidden),optional}
    }
}

ad_form -extend -name item_edit_general -form {
    {description:text(hidden),optional}
    {content:text(hidden),optional}
    {subtext:text(hidden),optional}
    {field_name:text(hidden),optional}
    {field_code:text(hidden),optional}
    {validate_block:text(hidden),optional}
    {data_type:text(hidden),optional}
    {display_type:text(hidden),optional}
    {max_time_to_complete:text(hidden),optional}
    {formbutton_ok:text(submit) {label "[_ assessment.Save_and_finish]"}}
}


switch -- $item_type {
    "mc" {
    ad_form -extend -name item_edit_general -form {
        {num_choices:text(hidden)}
        {ms_label:text,optional}
        {add_another_choice:text(submit) {label "[_ assessment.Add_another_choice]"}}
    }
ns_log notice "Add Another = '[template::element::get_value item_edit_general add_another_choice]'"
    if {[template::form::is_submission item_edit_general] \
            && [template::element::get_value item_edit_general add_another_choice] \
            eq [_ assessment.Add_another_choice]} {
        set num_choices [element::get_value item_edit_general num_choices]
        incr num_choices
        element::set_value item_edit_general num_choices $num_choices
    } 

#####
#####
    set as_item_type_id [as::item::get_item_type_id -as_item_id $as_item_id]
    if {[array exists move_up]} {
        foreach n [array names move_up] {
            array set new_array [as::item_type_mc::choices_swap \
                -assessment_id $assessment_id \
                -section_id $section_id \
                -as_item_id $as_item_id \
                -mc_id  $as_item_type_id \
                -sort_order [db_string get_sort_order {}] \
                                     -direction up]
            foreach var {as_item_id section_id} {
                set $var $new_array($var)
                template::element::set_value item_edit_general $var [set $var]
            }
        }
    }
    if {[array exists move_down]} {
        foreach n [array names move_down] {
            array set new_array [as::item_type_mc::choices_swap \
                -assessment_id $assessment_id \
                -section_id $section_id \
                -as_item_id $as_item_id \
                -mc_id $as_item_type_id \
                -sort_order [db_string get_sort_order {}] \
                                     -direction down]
        }
            foreach var {as_item_id section_id} {
                set $var $new_array($var)
                template::element::set_value item_edit_general $var [set $var]
            }
    }
    if {[array exists delete]} {
        foreach n [array names delete] {
            array set new_array [as::item_type_mc::choice_delete \
                -assessment_id $assessment_id \
                -section_id $section_id \
                -as_item_id $as_item_id \
                                     -choice_id $n]
        }
            foreach var {as_item_id section_id} {
                set $var $new_array($var)
            }
    }

#######
#######


    set existing_choices [as::item_type_mc::existing_choices $as_item_id]

    if {![template::form::is_submission item_edit_general] \
            && ![info exists num_choices]} {
        set num_choices 5
    } elseif {![info exists num_choices]} {
            set num_choices [expr {[set num_choices [template::element::get_value item_edit_general num_choices]] eq "" ? $num_choices : 5}]
    }

    template::multirow create choice_elements id new_p
    foreach c $existing_choices {
        set id [lindex $c 1]
        template::multirow append choice_elements $id f
        if {[lindex $c 2] eq "t"} {
            set correct($id) t
        }
    }

    if {$num_choices > [llength $existing_choices]} {
        set new_choices [expr {$num_choices - [llength $existing_choices] }]
        for {set i 1} {$i <= $new_choices} {incr i} {
            set id __new_${i}
            set correct_p f
            if {[info exists correct($id)]} {
                set correct_p t
            }
            lappend existing_choices [list "" $id $correct_p]
            template::multirow append choice_elements $id t
        }
    }
    as::item_type_mc::add_existing_choices_to_edit_form \
        -form_id item_edit_general \
        -existing_choices $existing_choices \
        -choice_array_name choice \
        -correct_choice_array_name correct

    }
    "oq" {
        ad_form -extend -name item_edit_general -form {
            {reference_answer:text(textarea),optional {label "[_ assessment.oq_Reference_Answer]"} {html {rows 5 cols 80}} {help_text "[_ assessment.oq_Reference_Answer_help]"}}
        }
    }
    "sa" {
    }
}
    
ad_form -extend -name item_edit_general -edit_request {
    db_1row general_item_data {}
    if {[empty_string_p $data_type]} {
	set data_type varchar
    }
    set data_type_disp "[_ assessment.data_type_$data_type]" 
    set display_type [string range [db_string get_display_type {}] end-1 end]
    set question_text [template::util::richtext::create $question_text $mime_type]

    set feedback_right [template::util::richtext::create $feedback_right $mime_type]
    set feedback_wrong [template::util::richtext::create $feedback_wrong $mime_type]
    # FIXME fill in reference answer 

} -on_submit {
    set category_ids [category::ad_form::get_categories -container_object_id $package_id]
    if {[empty_string_p $points]} {
	set points 0
    }
} -edit_data {
    if {[exists_and_not_null formbutton_ok] || [exists_and_not_null formbutton_add_another_question]} {
        set question_text [template::util::richtext::get_property contents $question_text]
        set feedback_right [template::util::richtext::get_property content $feedback_right]
        set feedback_wrong [template::util::richtext::get_property content $feedback_wrong]
        db_transaction {
            set old_display_type [string range [db_string get_display_type {}] end-1 end]
            set new_item_id [as::item::edit \
                                 -as_item_id $as_item_id \
                                 -title $question_text \
                                 -description $description \
                                 -subtext $subtext \
                                 -field_name $field_name \
                                 -field_code $field_code \
                                 -required_p $required_p \
                                 -data_type $data_type \
                                 -feedback_right $feedback_right \
                                 -feedback_wrong $feedback_wrong \
                                 -max_time_to_complete $max_time_to_complete \
                                 -points $points \
                                 -validate_block $validate_block]

            if {[exists_and_not_null category_ids]} {
                category::map_object -object_id $new_item_id $category_ids
            }
            if {![empty_string_p $content]} {
                set filename [lindex $content 0]
                set tmp_filename [lindex $content 1]
                set file_mimetype [lindex $content 2]
                set n_bytes [file size $tmp_filename]
                set max_file_size 10000000
                # [ad_parameter MaxAttachmentSize]
                set pretty_max_size [util_commify_number $max_file_size]

                if { $n_bytes > $max_file_size && $max_file_size > 0 } {
                    ad_return_complaint 1 "[_ assessment.file_too_large]"
                    return
                }
                if { $n_bytes == 0 } {
                    ad_return_complaint 1 "[_ assessment.file_zero_size]"
                    return
                }
                set folder_id [as::assessment::folder_id -package_id $package_id]
                set content_rev_id [cr_import_content -title $filename $folder_id $tmp_filename $n_bytes $file_mimetype [as::item::generate_unique_name]]
                # delete content association if it exists then insert a new one
                # otherwise we can't add a file on edit that did not exist
                # when the question was originally created
                db_dml delete_item_content {}
                db_dml insert_item_content {}
            } elseif {[info exists delete_content] && $delete_content == "t" } {
                db_dml delete_item_content {}
            }
            set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
            set section_id [as::section::latest -section_id $section_id -assessment_rev_id $new_assessment_rev_id]
            set new_section_id [as::section::new_revision -section_id $section_id -assessment_id $assessment_id]
            set as_item_id [as::item::latest -as_item_id $as_item_id -section_id $new_section_id]
            as::assessment::check::copy_item_checks -assessment_id $assessment_id -section_id $new_section_id -as_item_id $as_item_id -new_item_id $new_item_id
            set as_item_type_id [as::item::get_item_type_id -as_item_id $new_item_id]
            as::section::update_section_in_assessment \
                -old_section_id $section_id \
                -new_section_id $new_section_id \
                -new_assessment_rev_id $new_assessment_rev_id

            db_dml update_item_in_section {}

            switch -- $item_type {
                mc {
                    set num_answers 0
                    set num_correct_answers 0
                    foreach c [array names choice] {
                        if {$choice($c) ne ""} {
                            incr num_answers
                        }
                    }
                    foreach c [array names correct] {
                        if {$correct($c) eq "t"} {
                            incr num_correct_answers 
                        }
                    }
                    set new_item_type_id [as::item_type_mc::edit \
                                              -as_item_type_id $as_item_type_id \
                                              -title $question_text \
                                              -increasing_p f \
                                              -allow_negative_p f \
                                              -num_correct_answers $num_correct_answers \
                                              -num_answers $num_answers]
                    db_dml update_item_type {}
                    # edit existing choices
                    set count 0
                    foreach i [lsort [array names choice]] {
                        if {[string range  $i 0 0] != "_" && ![empty_string_p $choice($i)]} {
                            incr count
                            set new_choice_id [as::item_choice::new_revision -choice_id $i -mc_id $new_item_type_id]
                            set title $choice($i)
                            set correct_answer_p [ad_decode [info exists correct($i)] 0 f t]
                            db_dml update_title {}
                            db_dml update_correct_and_sort_order {}
                        }
                    }

                    # add new choices
                    foreach i [lsort [array names choice]] {
                        
                        if {[string range  $i 0 0] == "_" && ![empty_string_p $choice($i)]} {
                            incr count
                            set new_choice_id [as::item_choice::new -mc_id $new_item_type_id \
                                                   -title $choice($i) \
                                                   -numeric_value "" \
                                                   -text_value "" \
                                                   -content_value "" \
                                                   -feedback_text "" \
                                                   -selected_p "" \
                                                   -correct_answer_p [ad_decode [info exists correct($i)] 0 f t] \
                                                   -sort_order $count \
                                                   -percent_score ""]
                        }
                    }
                } 
                "oq" {
                    set new_item_type_id [as::item_type_oq::edit \
                                              -as_item_type_id $as_item_type_id \
                                              -title $question_text \
                                              -default_value "" \
                                              -feedback_text "" \
                                              -reference_answer $reference_answer \
                                              -keywords ""]
                    db_dml update_item_type {}

                }
                "fu" {
                    set new_item_type_id [as::item_type_fu::edit \
				  -as_item_type_id $as_item_type_id \
				  -title $question_text]
                    db_dml update_item_type {}
                }
                "sa" {
                    set new_item_type_id [as::item_type_sa::edit \
                                              -as_item_type_id $as_item_type_id \
                                              -title $question_text \
                                              -increasing_p f\
                                              -allow_negative_p f]
                    db_dml update_item_type {}
                }
            }
            
        }
        
        set as_item_id $new_item_id
        set section_id $new_section_id

        application_data_link::update_links_from \
            -object_id $as_item_id \
            -text $question_text
    }
} -after_submit {
    if {[exists_and_not_null formbutton_ok]} {
	ad_returnredirect [export_vars -base "questions" {assessment_id section_id }]&\#${as_item_id}
	ad_script_abort
    }
}

ad_return_template
