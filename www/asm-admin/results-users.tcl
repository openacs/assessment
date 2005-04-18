ad_page_contract {

    Lists the result of each subject who completed the assessment

    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-01-24
} {
    assessment_id
} -properties {
    context:onevalue
    page_title:onevalue
}

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set user_id [ad_conn user_id]
set assessment_rev_id $assessment_data(assessment_rev_id)
set page_title "[_ assessment.Results_by_user]"
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]
set format "[lc_get formbuilder_date_format], [lc_get formbuilder_time_format]"

template::list::create \
    -name results \
    -multirow results \
    -key sessions_id \
    -elements {
	session_id {
	    label {[_ assessment.Session]}
	    display_template {<if @results.result_url@ not nil><a href="@results.result_url@">@results.session_id@</a></if><else></else>}
	}
	subject_name {
	    label {[_ assessment.Subject_Name]}
	    display_template {<if @results.subject_url@ not nil><a href="@results.subject_url@">@results.subject_name@</a></if><else>@results.subject_name@</else>}
	}
	completed_datetime {
	    label {[_ assessment.Finish_Time]}
	    html {nowrap}
	}
	percent_score {
	    label {[_ assessment.Percent_Score]}
	    html {align right nowrap}
	    display_template {<if @results.result_url@ not nil><a href="@results.result_url@">@results.percent_score@</a></if><else></else>}
	}
    } -main_class {
	narrow
    } 


template::multirow create subjects subject_id subject_url subject_name

db_multirow -extend { result_url subject_url } results assessment_results {
} {
    # to display list of users who answered the assessment if anonymous
    template::multirow append subjects $subject_id [acs_community_member_url -user_id $subject_id] $subject_name

    if {$assessment_data(anonymous_p) == "t" && $subject_id != $user_id} {
	set subject_name "[_ assessment.anonymous_name]"
	set subject_url "" 
    } else {
	set subject_url [acs_community_member_url -user_id $subject_id]
    }
    set result_url [export_vars -base "results-session" {session_id}]
}

template::multirow sort subjects subject_name
if {$assessment_data(anonymous_p) == "t"} {
    template::list::create \
	-name subjects \
	-multirow subjects \
	-key subject_id \
	-elements {
	    subject_name {
		label {[_ assessment.Subject_Name]}
		display_template {<a href="@subjects.subject_url@">@subjects.subject_name@</a>}
	    }
	} -main_class {
	    narrow
	} 
}

ad_return_template
