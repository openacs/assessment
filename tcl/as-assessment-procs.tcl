ad_library {
    Assessment procs
    @author eperez@it.uc3m.es, nperper@it.uc3m.es
    @creation-date 2004-07-26
}

namespace eval as::assessment {}

ad_proc -public as::assessment::new {
    {-name ""}
    {-title:required}
    {-creator_id ""}
    {-description ""}
    {-instructions ""}
    {-run_mode ""}
    {-anonymous_p ""}
    {-secure_access_p ""}
    {-reuse_responses_p ""}
    {-show_item_name_p ""}
    {-random_p ""}
    {-entry_page ""}
    {-exit_page ""}
    {-consent_page ""}
    {-return_url ""}
    {-start_time ""}
    {-end_time ""}
    {-number_tries ""}
    {-wait_between_tries ""}
    {-time_for_response ""}
    {-ip_mask ""}
    {-password ""}
    {-show_feedback ""}
    {-section_navigation ""}
    {-survey_p ""}
    {-package_id ""}
    {-type ""}
} {
    @author Eduardo Perez (eperez@it.uc3m.es)
    @creation-date 2004-07-26

    New assessment to the database
} {
    if { $package_id eq "" } { set package_id [ad_conn package_id] }
    set folder_id [as::assessment::folder_id -package_id $package_id]

    if { $creator_id eq "" } { set creator_id [ad_conn user_id]}

    # Insert as_assessment in the CR (and as_assessments table) getting the revision_id (as_assessment_id)
    db_transaction {
        set assessment_item_id [db_nextval acs_object_id_seq]
        if {$name eq ""} {
            set name "ASS_$assessment_item_id"
        }
        set assessment_item_id [content::item::new \
                                    -item_id $assessment_item_id \
                                    -parent_id $folder_id \
                                    -creation_user $creator_id \
                                    -content_type {as_assessments} \
                                    -name $name \
                                    -package_id $package_id \
                                    -context_id $folder_id]

        set as_assessment_id [content::revision::new \
                                -item_id $assessment_item_id \
                                -content_type {as_assessments} \
                                -title $title \
                                -description $description \
                                -attributes [list [list creator_id $creator_id] \
                                                  [list run_mode $run_mode] \
                                                  [list anonymous_p $anonymous_p] \
                                                  [list secure_access_p $secure_access_p] \
                                                  [list reuse_responses_p $reuse_responses_p] \
                                                  [list show_item_name_p $show_item_name_p] \
                                                  [list random_p $random_p] \
                                                  [list entry_page $entry_page] \
                                                  [list exit_page $exit_page] \
                                                  [list return_url $return_url] \
                                                  [list start_time $start_time] \
                                                  [list end_time $end_time] \
                                                  [list number_tries $number_tries] \
                                                  [list wait_between_tries $wait_between_tries] \
                                                  [list time_for_response $time_for_response] \
                                                  [list ip_mask $ip_mask] \
                                                  [list password $password] \
                                                  [list show_feedback $show_feedback] \
                                                  [list section_navigation $section_navigation] \
                                                  [list survey_p $survey_p] \
                                                  [list package_id $package_id] \
                                                  [list type $type]]]

    }
    db_dml update_clobs {} -clobs [list $instructions $consent_page]

    return $as_assessment_id
}

ad_proc -public as::assessment::edit {
    {-assessment_id:required}
    {-title:required}
    {-creator_id ""}
    {-description ""}
    {-instructions ""}
    {-run_mode ""}
    {-anonymous_p ""}
    {-secure_access_p ""}
    {-reuse_responses_p ""}
    {-show_item_name_p ""}
    {-random_p ""}
    {-entry_page ""}
    {-exit_page ""}
    {-consent_page ""}
    {-return_url ""}
    {-start_time ""}
    {-end_time ""}
    {-number_tries ""}
    {-wait_between_tries ""}
    {-time_for_response ""}
    {-ip_mask ""}
    {-password ""}
    {-show_feedback ""}
    {-section_navigation ""}
    {-type ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-10-26

    Edit assessment in the database
} {
    set assessment_rev_id [db_string assessment_revision {}]

    # edit as_assessment in the CR
    db_transaction {
        set new_rev_id [content::revision::new \
                            -item_id $assessment_id \
                            -content_type {as_assessments} \
                            -title $title \
                            -description $description \
                            -attributes [list [list creator_id $creator_id] \
                                              [list run_mode $run_mode] \
                                              [list anonymous_p $anonymous_p] \
                                              [list secure_access_p $secure_access_p] \
                                              [list reuse_responses_p $reuse_responses_p] \
                                              [list show_item_name_p $show_item_name_p] \
                                              [list random_p $random_p] \
                                              [list entry_page $entry_page] \
                                              [list exit_page $exit_page] \
                                              [list return_url $return_url] \
                                              [list start_time $start_time] \
                                              [list end_time $end_time] \
                                              [list number_tries $number_tries] \
                                              [list wait_between_tries $wait_between_tries] \
                                              [list time_for_response $time_for_response] \
                                              [list ip_mask $ip_mask] \
                                              [list password $password] \
                                              [list show_feedback $show_feedback] \
                                              [list section_navigation $section_navigation] \
                                              [list type $type]] ]
        db_dml update_clobs {} -clobs [list $instructions $consent_page]
        copy_sections -assessment_id $assessment_rev_id -new_assessment_id $new_rev_id
    }

    return $new_rev_id
}

ad_proc -public as::assessment::data {
    {-assessment_id:required}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-10-25

    Get all assessment info

    creates a Tcl array variable named "assessment_data" in the caller's environment,
    which contains key/value pairs for all properties of the requested assessment.
} {
    upvar assessment_data assessment_data

    if {$assessment_id eq ""} {
        db_1row lookup_assessment_id ""
    }

    db_1row get_data_by_assessment_id {} -column_array assessment_data

    if {![info exists assessment_data(assessment_id)]} {
        # assessment doesn't exist, caller has to handle this in their
        # own way
        return
    }

    set assessment_data(creator_name) [person::name -person_id $assessment_data(creation_user)]
    set assessment_data(title) [as::assessment::title -title $assessment_data(title)]
}

ad_proc -public as::assessment::new_revision {
    {-assessment_id:required}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-11-02

    Creates new revision of an assessment with all sections
} {
    data -assessment_id $assessment_id
    array set a [array get assessment_data]

    db_transaction {
        set new_rev_id [content::revision::new \
                            -item_id $assessment_id \
                            -content_type {as_assessments} \
                            -title $a(title) \
                            -description $a(description) \
                            -attributes [list [list creator_id $a(creator_id)] \
                                              [list run_mode $a(run_mode)] \
                                              [list anonymous_p $a(anonymous_p)] \
                                              [list secure_access_p $a(secure_access_p)] \
                                              [list reuse_responses_p $a(reuse_responses_p)] \
                                              [list show_item_name_p $a(show_item_name_p)] \
                                              [list random_p $a(random_p)] \
                                              [list entry_page $a(entry_page)] \
                                              [list exit_page $a(exit_page)] \
                                              [list return_url $a(return_url)] \
                                              [list start_time $a(start_time)] \
                                              [list end_time $a(end_time)] \
                                              [list number_tries $a(number_tries)] \
                                              [list wait_between_tries $a(wait_between_tries)] \
                                              [list time_for_response $a(time_for_response)] \
                                              [list ip_mask $a(ip_mask)] \
                                              [list password $a(password)] \
                                              [list show_feedback $a(show_feedback)] \
                                              [list section_navigation $a(section_navigation)]  \
                                              [list type $a(type)]]]

        set instructions $a(instructions)
        set consent_page $a(consent_page)
        db_dml update_clobs {} -clobs [list $a(instructions) $a(consent_page)]

        copy_sections -assessment_id $a(assessment_rev_id) -new_assessment_id $new_rev_id
        copy_categories -from_id $a(assessment_rev_id) -to_id $new_rev_id
    }

    return $new_rev_id
}

ad_proc -public as::assessment::copy {
    {-assessment_id:required}
    {-name ""}
    {-folder_id ""}
    {-new_title ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-23

    Copies an assessment with all sections and items
} {
    if {$folder_id eq ""} {
        set package_id [ad_conn package_id]
        set folder_id [as::assessment::folder_id -package_id $package_id]
    }

    data -assessment_id $assessment_id
    array set a [array get assessment_data]
    if {$new_title eq ""} {
        append a(title) "[_ assessment.copy_appendix]"
    } else {
        set a(title) $new_title
    }

    db_transaction {
        set new_assessment_id [db_nextval acs_object_id_seq]
        if {$name eq ""} {
            set name "ASS_$new_assessment_id"
        }
        set new_assessment_id [content::item::new -item_id $new_assessment_id -parent_id $folder_id -content_type {as_assessments} -name $name]

        set new_rev_id [content::revision::new \
                            -item_id $new_assessment_id \
                            -content_type {as_assessments} \
                            -title $a(title) \
                            -description $a(description) \
                            -attributes [list [list creator_id $a(creator_id)] \
                                              [list instructions $a(instructions)] \
                                              [list run_mode $a(run_mode)] \
                                              [list anonymous_p $a(anonymous_p)] \
                                              [list secure_access_p $a(secure_access_p)] \
                                              [list reuse_responses_p $a(reuse_responses_p)] \
                                              [list show_item_name_p $a(show_item_name_p)] \
                                              [list random_p $a(random_p)] \
                                              [list entry_page $a(entry_page)] \
                                              [list exit_page $a(exit_page)] \
                                              [list consent_page $a(consent_page)] \
                                              [list return_url $a(return_url)] \
                                              [list start_time $a(start_time)] \
                                              [list end_time $a(end_time)] \
                                              [list number_tries $a(number_tries)] \
                                              [list wait_between_tries $a(wait_between_tries)] \
                                              [list time_for_response $a(time_for_response)] \
                                              [list ip_mask $a(ip_mask)] \
                                              [list password $a(password)] \
                                              [list show_feedback $a(show_feedback)] \
                                              [list section_navigation $a(section_navigation)] \
                                              [list type $a(type)]] ]

        copy_sections -assessment_id $a(assessment_rev_id) -new_assessment_id $new_rev_id
        copy_categories -from_id $a(assessment_rev_id) -to_id $new_rev_id
    }

    return $new_assessment_id
}

ad_proc as::assessment::copy_sections {
    {-assessment_id:required}
    {-new_assessment_id:required}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-11-07

    Copies all sections from assessment_id to new_assessment_id
} {
    db_dml copy_sections {}
}

ad_proc as::assessment::copy_categories {
    {-from_id:required}
    {-to_id:required}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-07

    Copies all categories from one object to new object
} {
    db_dml copy_categories {}
}

ad_proc as::assessment::sections {
    {-assessment_id:required}
    {-session_id:required}
    {-sort_order_type ""}
    {-random_p ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-14

    Returns all sections of an assessment in the correct order.
    may vary from session to session
} {
    set section_list [db_list get_sorted_sections {}]

    if {[llength $section_list] > 0} {
        return $section_list
    }

    # get all sections of assessment
    set all_sections [db_list_of_lists assessment_sections {}]

    if {$random_p == "f"} {
        set sort_order_type "default path"
    }

    # sort section positions
    switch -exact $sort_order_type {
        randomized {
            set all_sections [util::randomize_list $all_sections]
        }
    }

    # save section order
    set section_list ""
    set count 0
    foreach one_section $all_sections {
        incr count
        lassign $one_section section_id title
        lappend section_list $section_id
        db_dml save_order {}
    }

    return $section_list
}

ad_proc -public as::assessment::calculate {
    -assessment_id:required
    -session_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-14

    Award points to this assessment if all sections are filled out
} {
    if {[db_string check_sections_calculated {}] > 0} {
        return
    }

    db_1row sum_of_section_points {}

    if {(![info exists section_max_points] || $section_max_points eq "") || $section_max_points==0} {
        set section_max_points 100
    }

    set percent_score [expr {round(100 * $section_points / $section_max_points)}]
    as::session_results::new -target_id $session_id -points $percent_score
    db_dml update_assessment_percent {}
}

ad_proc -public as::assessment::check_session_conditions {
    -assessment_id:required
    -subject_id:required
    -password:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-22

    Checks if subject is allowed to take the assessment
} {
    db_1row assessment_data {}
    db_1row total_tries {}
    if {$wait_between_tries ne ""} {
        set wait_between_tries [expr {60 * $wait_between_tries}]
    }
    if {$total_tries > 0} {
        db_1row cur_wait_time {}
    } else {
        set cur_wait_time $wait_between_tries
    }

    set error_list ""
    if {($start_time ne "" && $start_time > $cur_time) || ($end_time ne "" && $end_time < $cur_time)} {
        append error_list "<li>[_ assessment.assessment_not_public]</li>"
    }

    if {$number_tries ne "" && $number_tries > 0 && $number_tries <= $total_tries} {
        append error_list "<li>[_ assessment.assessment_too_many_tries]</li>"
    }
    if {$wait_between_tries ne "" && $wait_between_tries > $cur_wait_time} {
        set pretty_wait_time [pretty_time -seconds [expr {$wait_between_tries - $cur_wait_time}]]
        append error_list "<li>[_ assessment.assessment_wait_retry]</li>"
    }
    if {$as_password ne "" && $password ne $as_password } {
        append error_list "<li>[_ assessment.assessment_wrong_password]</li>"
    }
    if {$ip_mask ne ""} {
        regsub -all {\.} "^$ip_mask" {\\.} ip_mask
        regsub -all {\*} $ip_mask {.*} ip_mask
        if {![regexp $ip_mask [ad_conn peeraddr]]} {
            append error_list "<li>[_ assessment.assessment_restricted_ips]</li>"
        }
    }

    return $error_list
}

ad_proc as::assessment::pretty_time {
    {-seconds}
    {-hours:boolean}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-14

    Returns a pretty string of min:sec
} {
    if {$seconds eq "0" || $seconds eq ""} {
        return $seconds
    }
    set time ""
    if {$seconds ne ""} {
        if {$hours_p} {
            set time_hour [expr {$seconds / 3600}]
            set seconds [expr {$seconds - ($time_hour * 3600)}]
        }
        set time_min [expr {$seconds / 60}]
        set time_sec [expr {$seconds - ($time_min * 60)}]
        set pad "00"
        if {$hours_p} {
            append time "[string range $pad [string length $time_hour] end]$time_hour\:"
        }
        append time "[string range $pad [string length $time_min] end]$time_min\:[string range $pad [string length $time_sec] end]$time_sec min"
    }
    return $time
}

ad_proc as::assessment::pretty_time_hours_minutes {
    {-seconds}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-12-14

    Returns a pretty string of min:sec
} {
    if {$seconds eq "0" || $seconds eq ""} {
        return $seconds
    }
    set time ""
    if {$seconds ne ""} {
        set time_hour [expr {$seconds / 3600}]
        set seconds [expr {$seconds - ($time_hour * 3600)}]

        set time_min [expr {$seconds / 60}]
        set time_sec [expr {$seconds - ($time_min * 60)}]
        if {$time_hour > 0} {
            append time "$time_hour \#acs-templating.hours\#"
        }
        append time " $time_min \#acs-templating.minutes\#"
    }
    return $time
}

ad_proc as::assessment::folder_id {
    -package_id:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-06

    Returns the folder_id of the package instance. Cached
} {
    ns_log notice "assessment folder id  package_id = '${package_id}'"
    return [content::folder::get_folder_from_package -package_id $package_id]
}

ad_proc as::assessment::unique_name {
    {-name ""}
    {-new_p 1}
    {-item_id ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-05

    Checks if a name string is unique or empty, excluding a given item
} {
    if {$new_p && $name ne ""} {
        if {$item_id eq ""} {
            set count [db_string check_unique {}]
        } else {
            set count [db_string check_unique_excluding_item {}]
        }
        if {$count > 0} {
            return 0
        }
    }
    return 1
}

ad_proc as::assessment::check_html_options {
    -options:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-11

    Checks if list contains only key value pairs
} {
    if {[llength $options] % 2 == 0} {
        return 1
    } else {
        return 0
    }
}

ad_proc as::assessment::display_content {
    -content_id:required
    -content_type:required
    -filename:required
    {-title ""}
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-06

    Returns a html snippet to display a content item (i.e. image)
} {
    if {$content_id eq ""} {
        return $title
    }
    if {$content_type eq "image"} {
        return "<img src=\"view/$filename?revision_id=$content_id\" alt=\"$title\">"
    } else {
        return "<a href=\"view/$filename?revision_id=$content_id\">$title</a>"
    }
}

ad_proc -private as::assessment::quote_export {
    -text:required
} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-26

    Quotes a string for csv export
} {
    regsub -all {;} $text {,,} text
    regsub -all "\n" $text {} text
    regsub -all "\r" $text {} text
    return $text
}

ad_proc -private as::assessment::compare_numbers {a b} {
    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-18

    Compares the first part of a pair of strings as numbers
} {
    set a0 [expr double([lindex $a 0 0])]
    set b0 [expr double([lindex $b 0 0])]
    if {$a0 > $b0} {
        return 1
    } elseif {$a0 == $b0} {
        return 0
    } else {
        return -1
    }
}

ad_proc -private as::assessment::title {
    -title
} {
    Remove html tags from assessment title

    @author Anny Flores (annyflores@viaro.net)
} {

    regsub -all {\<[a-zA-Z]*\>} $title "" title
    regsub -all {</[a-z]*>} $title "" title
    regsub -all {<a [^<]*>} $title "" title

    return $title
}

ad_proc -private as::assessment::delete {
    -assessment_id:required
} {
    Remove an assessment and all associated data

    @author Dave Bauer (dave@solutiongrove.com)

    @param assessment_id
} {
    foreach session_id [db_list get_subject_ids "select session_id from as_sessions,cr_revisions where assessment_id=revision_id and item_id=:assessment_id"] {
        as::session::delete -session_id $session_id
    }

    content::item::delete -item_id $assessment_id
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
