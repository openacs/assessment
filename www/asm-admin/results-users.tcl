ad_page_contract {

    Lists the result of each subject who completed the assessment

    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-24
} {
    assessment_id:naturalnum,notnull
    {start_time:optional ""}
    {end_time:optional ""}
    {status:optional,notnull ""}
} -properties {
    context:onevalue
    page_title:onevalue
}

permission::require_permission \
    -object_id $assessment_id \
    -party_id [ad_conn user_id] \
    -privilege "admin"

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

set package_id [ad_conn package_id]
set node_id [ad_conn node_id]
set group_id [application_group::closest_ancestor_element  -include_self  -node_id $node_id  -element "application_group_id"]

set folder_id [as::assessment::folder_id -package_id $package_id]
if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set user_id [ad_conn user_id]

set page_title "[_ assessment.Results_by_user]"
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]
set format "[lc_get formbuilder_date_format], [lc_get formbuilder_time_format]"
set form_format [lc_get formbuilder_date_format]

set start_date_sql ""
set end_date_sql ""

ad_form -name assessment_results -action results-users -form {
    {assessment_id:key}
    {start_time:date,to_sql(sql_date),to_html(display_date),optional 
        {label "[_ assessment.csv_Start_Time]"} 
        {format $form_format} 
        {help} 
        {help_text "[_ assessment.csv_Start_Time_help]"}
    }
    {end_time:date,to_sql(sql_date),to_html(display_date),optional 
        {label "[_ assessment.csv_End_Time]"} 
        {format $form_format} 
        {help} 
        {help_text "[_ assessment.csv_End_Time_help]"}
    }
} -edit_request {
} -on_submit {
    if {$start_time eq "NULL"} {
        set start_time ""
    }
    if {$end_time eq "NULL"} {
        set end_time ""
    }
    if {[db_type] eq "postgresql"} {
        regsub -all -- {to_date} $start_time {to_timestamp} start_time
        regsub -all -- {to_date} $end_time {to_timestamp} end_time
    }

    
    if {$start_time ne ""} {
        set start_date_sql [db_map restrict_start_date]
    }
    if {$end_time ne ""} {
        set end_date_sql [db_map restrict_end_date]
    }
}

set status_p [expr {$status ne ""}]
if { $status_p } {
    if { $status eq "complete" } {
        set whereclause "cs.completed_datetime is not null"
    } elseif { $status eq "incomplete" } {
        set whereclause "cs.completed_datetime is null and ns.session_id is not null"
    } else {
        set whereclause "cs.completed_datetime is null and ns.session_id is null"
    }
} else {
    set whereclause "cs.completed_datetime is null and ns.session_id is null"
}

template::list::create \
    -name results \
    -multirow results \
    -key session_id \
    -elements {
        session_id {
            label {[_ assessment.View_Results]}
            display_template {
                <if @results.session_id@ not nil>
                  <a href="@results.result_url@">View</a>
                </if>
            }
        }
        subject_name {
            label {[_ assessment.Name]}
        }
        status {
            label {[_ assessment.Status]}
        }
        completed_datetime {
            label {[_ assessment.Finish_Time]}
            html {style white-space:nowrap}
        }
        percent_score {
            label {[_ assessment.Percent_Score]}
            html {align right style "white-space:nowrap;"}
            display_template {
                <if @results.result_url@ not nil>
                  <a href="@results.result_url@">
                    @results.percent@
                    <if @results.percent@ not nil>%</if>
                  </a>
                </if>
            }
        }
    } -filters {
        assessment_id {
            where_clause {
                a.item_id = :assessment_id
            }
        }
        subject_id {
            where_clause {
                cs.subject_id = :subject_id
            }
        }
        status {
            values {{"[_ assessment.Complete]" complete} {"[_ assessment.Incomplete]" incomplete} {"[_ assessment.Not_Taken]" nottaken}}
            where_clause {
                $whereclause
            }
        }
    } -bulk_actions {"#assessment.Send_Email#" send-mail "#assessment.Send_an_email_to_the_selected users#"} \
    -bulk_action_export_vars {assessment_id}


template::multirow create subjects subject_id subject_url subject_name

set count_complete 0
db_multirow -extend { result_url subject_url status delete_url session_score assessment_score percent } results assessment_results {} {

    # to display list of users who answered the assessment if anonymous
    template::multirow append subjects $subject_id [acs_community_member_url -user_id $subject_id] $subject_name

    if {$assessment_data(anonymous_p) == "t" && $subject_id != $user_id} {
        set subject_name "[_ assessment.anonymous_name]"
        set subject_url "" 
    } else {
        set subject_url [acs_community_member_url -user_id $subject_id]
    }

    set result_url [export_vars -base "results-session" {session_id}]

    if { $completed_datetime eq "" && $session_id eq "" } {
        set status [_ assessment.Not_Taken]
    } elseif { $completed_datetime eq "" && $session_id ne "" } {
        set status [_ assessment.Incomplete]
        set session_score ""
        set assessment_score ""
    } else {
        incr count_complete
        set status [_ assessment.Complete]
        set session_score [db_string get_session_score {} -default ""]
        set assessment_score [db_string get_max_points {}]
        if { $assessment_score > 0 } {
            set percent [format "%3.2f" [expr double([expr {double($session_score)*100}] / [expr {double($assessment_score)}])]]
        } else {
            set percent ""
        }

    }

    set delete_url [export_vars -base session-delete {assessment_id subject_id session_id}]
}

template::multirow sort subjects subject_name

if { $assessment_data(anonymous_p) == "t" } {
    template::list::create \
        -name subjects \
        -multirow subjects \
        -key subject_id \
        -elements {
            subject_name {
                label {[_ assessment.Subject_Name]}
                display_template {
                    <a href="@subjects.subject_url@">@subjects.subject_name@</a>
                }
            }
        } -main_class {
            narrow
        } 
}

set count_all_users [template::multirow size results]
set count_incomplete [expr {$count_all_users - $count_complete}]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
