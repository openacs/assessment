ad_page_contract {

        Lists the identifier of sessions, the name of subjects that took
	this assessment, the name of assessment and the finish time 
	of assessment for an assessment.

	@author Eduardo Pérez Ureta (eperez@it.uc3m.es)
	@creation-date 2004-09-03
} {
  assessment_id:notnull
  subject_id:notnull
} -properties {
	context:onevalue
	assessment_info:multirow
}

set context [list "[_ assessment.Show_Sessions]"]

set package_id [ad_conn package_id]

#get the user that take an assessment
#set subject_id [ad_conn user_id]
set subject_id $subject_id

#Lists the identifier of sessions, the name of subjects that took this assessment, the name of assessment and the finished time 
#of assessment for an assessment.
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
    } \
    -main_class {
        narrow
    }



set assessment_id_multi $assessment_id
#if the user is admin he will display all sessions from all subjects
db_multirow -extend { item_url assessment_id } sessions sessions_of_assessment {
} {
    set item_url [export_vars -base "session" {session_id}]
    set assessment_id $assessment_id_multi
}


ad_return_template
