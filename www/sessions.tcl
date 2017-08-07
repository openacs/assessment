ad_page_contract {

        Lists the identifier of sessions, the name of subjects that took
	this assessment, the name of assessment and the finish time 
	of assessment for an assessment.

	@author Eduardo Pérez Ureta (eperez@it.uc3m.es)
	@creation-date 2004-09-03
} {
    assessment_id:naturalnum,notnull
    {subject_id:naturalnum,optional ""}
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

set page_title "[_ assessment.Show_Sessions]"
set context_bar [ad_context_bar $page_title]
set format "[lc_get formbuilder_date_format], [lc_get formbuilder_time_format]"
set user_id [ad_conn user_id]
permission::require_permission -object_id $assessment_id -privilege read

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set assessment_rev_id $assessment_data(assessment_rev_id)
set admin_p [permission::permission_p -object_id $assessment_id -privilege admin]

#if the user is admin he will display all sessions from all subjects
if {$admin_p && $subject_id eq ""} {
    set query "sessions_of_assessment_of_subject"
} else {
    set query "sessions_of_assessment"
}

if {$subject_id eq "" || !$admin_p} {
    set subject_id $user_id
}

if {$assessment_data(survey_p) == "t"} {
    # Lists the identifier of sessions, the name of subjects that took this assessment,
    # the name of assessment and the finished time 
    # of assessment for an assessment.

    template::list::create \
	-name sessions \
	-multirow sessions \
	-key sessions_id \
	-elements {
	    session_id {
		label {[_ assessment.Session]}
		link_url_eval {[export_vars -base "session" {session_id}]}
	    }
	    subject_name {
		label {[_ assessment.Subject_Name]}
		display_template {<if @sessions.subject_url@ not nil><a href="@sessions.subject_url@">@sessions.subject_name@</a></if><else>@sessions.subject_name@</else>}
	    }
	    assessment_name {
		label {Assessment}
		display_template {<if @sessions.assessment_url@ not nil><a href="@sessions.assessment_url@">@sessions.assessment_name;noquote@</a></if><else>@sessions.assessment_name;noquote@</else>}
	    }
	    completed_datetime {
		label {[_ assessment.Finish_Time]}
	    }
	} -main_class {
	    narrow
	}
} else {
    template::list::create \
	-name sessions \
	-multirow sessions \
	-key sessions_id \
	-elements {
	    session_id {
		label {[_ assessment.Session]}
		link_url_eval {[export_vars -base "session" {session_id}]}
	    }
	    subject_name {
		label {[_ assessment.Subject_Name]}
		display_template {<if @sessions.subject_url@ not nil><a href="@sessions.subject_url@">@sessions.subject_name@</a></if><else>@sessions.subject_name@</else>}
	    }
	    assessment_name {
		label {Assessment}
		display_template {<if @sessions.assessment_url@ not nil><a href="@sessions.assessment_url@">@sessions.assessment_name;noquote@</a></if><else>@sessions.assessment_name;noquote@</else>}
	    }
	    completed_datetime {
		label {[_ assessment.Finish_Time]}
	    }
	    percent_score {
		label {[_ assessment.Percent_Score]}
		html {align right}
	    }
	} -main_class {
	    narrow
	} 
}


db_multirow -extend { subject_url assessment_url } sessions $query {
} {
    if {($start_time eq "" || $start_time <= $cur_time) && ($end_time eq "" || $end_time >= $cur_time)} {
	set assessment_url [export_vars -base "assessment" {assessment_id}]
    } else {
	set assessment_url ""
    }
    if {$assessment_data(anonymous_p) == "t" && $subject_id != $user_id} {
	set subject_name "[_ assessment.anonymous_name]"
	set subject_url ""
    } else {
	set subject_url [acs_community_member_url -user_id $subject_id]
    }
}


ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
