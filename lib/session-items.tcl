ad_include_contract {
    Display session items

    @param assessment_id
    @param assessment_data
    @param edit_p
    @param feedback_only_p
    @param item_id_list
    @param next_url
    @param return_p
    @param session_id
    @param section_id
    @param show_item_name_p
    @param show_feedback
    @param subject_id
    @param survey_p
} {
    assessment_data:array,notnull
    {assessment_id:integer $assessment_data(assessment_id)}
    {edit_p:boolean,notnull 0}
    {feedback_only_p:boolean,notnull 0}
    {item_id_list ""}
    {next_url:localurl ""}
    return_p:optional,notnull
    session_id:integer,notnull
    section_id:integer,notnull
    show_item_name_p:boolean,notnull
    show_feedback:notnull
    subject_id:integer,notnull
    survey_p:boolean,notnull
}

set admin_p [permission::permission_p \
                     -party_id [ad_conn user_id] \
                     -privilege admin \
                     -object_id $assessment_id]


# if we can tell this is the last section, next button should go to feedback for the entire assessment.
set section_list [as::assessment::sections \
                      -assessment_id $assessment_id \
                      -session_id $session_id \
                      -sort_order_type $assessment_data(section_navigation) \
                      -random_p $assessment_data(random_p)]

if {$next_url eq "" && [lsearch $section_list $section_id] eq [llength $section_list]-1} {
    set next_url [export_vars -base session {session_id next_url}]
}

if {$item_id_list ne ""} {
    set items_clause "and i.as_item_id in ([ns_dbquotelist $item_id_list])"
} else {
    set items_clause ""
}

ad_form -name session_results_$section_id -mode display -form {
    {section_id:text(hidden) {value $section_id}}
} -has_edit 1
ad_form -name Xsession_results_$section_id -mode display -form {
    {section_id:text(hidden) {value $section_id}}
}

set feedback_count 0
set admin_package_url [ad_conn package_url]asm-admin/
db_multirow -extend { presentation_type html result_points feedback answered_p choice_orientation next_as_item_id next_pr_type num content has_feedback_p correct_p view item_edit_general_url results_edit_url} items session_items {} {
    # build URLs
    set item_edit_general_url [export_vars -base "${admin_package_url}item-edit-general" {as_item_id assessment_id section_id}]
    set results_edit_url [export_vars -base "${admin_package_url}results-edit" {session_id section_id as_item_id}]

    set default_value [as::item_data::get -subject_id $subject_id -as_item_id $as_item_id -session_id $session_id]
    set item [as::item::item_data -as_item_id $as_item_id]

    set presentation_type [as::item_form::add_item_to_form -name session_results_$section_id -section_id $section_id -item_id $as_item_id -session_id $session_id -default_value $default_value -show_feedback $show_feedback -random_p $assessment_data(random_p)]

    if {$presentation_type eq "fitb"} {
        regsub -all -line -nocase -- {<textbox as_item_choice_id=} $title "<input name=response_to_item.${as_item_id}_" html
    } elseif {$presentation_type == "f"} {
        set view [as::item_display_$presentation_type\::view -item_id $as_item_id -session_id $session_id -section_id $section_id]

        template::add_event_listener -id "p-type-f-$as_item_id" -script {
            var w=window.open(this.href, 'newWindow', 'width=650,height=400');
        }
    }

    if {$presentation_type eq "rb" || $presentation_type eq "cb"} {
        set type [as::item_display_$presentation_type\::data -type_id [dict get $item display_type_id]]
        set choice_orientation [dict get $type choice_orientation]
    } else {
        set choice_orientation ""
    }

    if {$points eq ""} {
        set points 0
    }
    set max_time_to_complete [as::assessment::pretty_time -seconds $max_time_to_complete]
    if {$default_value ne ""} {
        set result_points [dict get $default_value points]
        set item_data_id  [dict get $default_value item_data_id]
        set answered_p t
        #ns_log notice "points = $points result_points= $result_points"
        if { $points != 0 } {
            if {$result_points < $points} {
                set correct_p 0
                if {$show_feedback ne "correct"} {
                    if { $feedback_wrong ne "" } {
                        set feedback "<span style=\"color:red\">$feedback_wrong</span>"
                        set has_feedback_p 1
                    } else {
                    set feedback ""
                    }
                }
            } else {
                set correct_p 1
                if {$show_feedback ne "incorrect"} {
                    if { $feedback_right ne "" } {
                        set feedback "<span style=\"color:green\">$feedback_right</span>"
                        set has_feedback_p 1
                    } else {
                        set feedback ""
                    }
                }
            }
        } else {
            set correct_p 1
            if {$presentation_type eq "rb" || $presentation_type eq "cb"} {
                set user_answers [db_list get_user_choice_answers {}]

                set correct_answers [db_list get_correct_choice_answers {}]

                if { $presentation_type eq "rb" } {
                    set user_answers [lindex $user_answers 0]

                    if { [lsearch $correct_answers $user_answers] == -1 } {
                        set correct_p 0
                        if {$show_feedback ne "correct"} {
                            if { $feedback_wrong ne "" } {
                                set feedback "<span style=\"color:red\">$feedback_wrong</span>"
                                set has_feedback_p 1
                            } else {
                                set feedback ""
                            }
                        }
                    } else {
                        if {$show_feedback ne "incorrect"} {
                            if { $feedback_right ne "" } {
                                set feedback "<span style=\"color:green\">$feedback_right</span>"
                                set has_feedback_p 1
                            } else {
                                set feedback ""
                            }
                        }
                    }
                } else {
                    # Checkbox, all answers must be correct if no
                    # points are set

                    if { [llength $user_answers] != [llength $correct_answers] } {
                        set correct_p 0
                    } else {
                        set correct_p 1
                        foreach one_answer $user_answers {
                            if { [lsearch $correct_answers $one_answer] == -1 } {
                                set correct_p 0
                                break
                            }
                        }
                    }

                    if { !$correct_p } {
                        if {$show_feedback ne "correct"} {
                            if { $feedback_wrong ne "" } {
                                set feedback "<span style=\"color:red\">$feedback_wrong</span>"
                                set has_feedback_p 1
                            } else {
                                set feedback ""
                            }
                        }
                    } else {
                        if {$show_feedback ne "incorrect"} {
                            if { $feedback_right ne "" } {
                                set feedback "<span style=\"color:green\">$feedback_right</span>"
                                set has_feedback_p 1
                            } else {
                                set feedback ""
                            }
                        }
                    }
                }
            }
        }
        if {[string is double -strict]} {
            set result_points [format "%3.2f" $result_points]
        }
        # result points here
    } else {
        set result_points ""
        set feedback ""
        set answered_p f
    }

    set content $question_text

    if { $has_feedback_p == 1 } {
        incr feedback_count
    }
}

if { $feedback_only_p
     && $feedback_count == 0
     && $next_url ne ""
 } {
    ad_returnredirect $next_url
    ad_script_abort
}

set counter 1
for {set i 1; set j 2} {$i <= ${items:rowcount}} {incr i; incr j} {
    upvar 0 items:$i this
    set this(num) $counter
    if {$i < ${items:rowcount}} {
        upvar 0 items:$j next
        set this(next_as_item_id) $next(as_item_id)
        set this(next_pr_type) $next(presentation_type)
        if {$this(as_item_id) != $next(as_item_id)} {
            incr counter
        }
    } else {
        set this(next_as_item_id) ""
        set this(next_pr_type) ""
    }
}
set showpoints [parameter::get -parameter "ShowPoints" -default 1 ]

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
