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
    context:onevalue
    assessment_info:multirow
}

set context [list "[_ assessment.Show_Sessions]"]

set package_id [ad_conn package_id]

if {$subject_id eq ""} {
    set subject_id [ad_conn user_id]
}

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set assessment_rev_id $assessment_data(assessment_rev_id)

if {$assessment_data(survey_p) == "t"} {
    # Lists the identifier of sessions, the name of subjects that took this assessment,
    # the name of assessment and the finished time
    # of assessment for an assessment.

    template::list::create \
	-name sessions \
	-multirow sessions \
	-pass_properties { package_id } \
	-key sessions_id \
	-elements {
	    session_id {
		label {[_ assessment.Session]}
		link_url_eval {[export_vars -base "session" {session_id}]}
	    }
	    subject_name {
		label {[_ assessment.Subject_Name]}
		link_url_eval {[acs_community_member_url -user_id $subject_id]}
	    }
	    assessment_name {
		label {Assessment}
		link_url_eval {[export_vars -base "assessment" {assessment_id}]}
	    }
	    completed_datetime {
		label {[_ assessment.Finish_Time]}
		html {nowrap}
	    }
	    other_sessions {
		label {[_ assessment.Other_Sessions]}
		link_url_eval {[site_node::get_url_from_object_id -object_id $package_id][export_vars -base sessions {assessment_id subject_id}]}
	    }
	} -main_class {
	    narrow
	}
} else {
    template::list::create \
	-name sessions \
	-multirow sessions \
	-pass_properties { package_id } \
	-key sessions_id \
	-elements {
	    session_id {
		label {[_ assessment.Session]}
		link_url_eval {[export_vars -base "session" {session_id}]}
	    }
	    subject_name {
		label {[_ assessment.Subject_Name]}
		link_url_eval {[acs_community_member_url -user_id $subject_id]}
	    }
	    assessment_name {
		label {Assessment}
		link_url_eval {[export_vars -base "assessment" {assessment_id}]}
	    }
	    completed_datetime {
		label {[_ assessment.Finish_Time]}
		html {nowrap}
	    }
	    percent_score {
		label {[_ assessment.Percent_Score]}
		html {nowrap}
	    }
	    other_sessions {
		label {[_ assessment.Other_Sessions]}
		link_url_eval {[site_node::get_url_from_object_id -object_id $package_id][export_vars -base sessions {assessment_id subject_id}]}
	    }
	} \
	-main_class {
	    narrow
	}
}



#if the user is admin he will display all sessions from all subjects
if {[permission::permission_p -object_id [acs_magic_object "security_context_root"] -privilege "admin"]} {
    set query "sessions_of_assessment_of_subject"
} else {
    set query "sessions_of_assessment"
}

db_multirow -extend { item_url assessment_id } sessions $query {
} {
    set item_url [export_vars -base "session" {session_id}]
}


ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
