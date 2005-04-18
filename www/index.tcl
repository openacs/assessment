ad_page_contract {

	Lists all the assessments that can be taken and their sessions.

	@author Eduardo P�rez Ureta (eperez@it.uc3m.es)
	@creation-date 2004-09-03
} {
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

set page_title "[_ assessment.Show_Assessments]"
set context_bar [ad_context_bar]
set package_id [ad_conn package_id]
set folder_id [as::assessment::folder_id -package_id $package_id]
set user_id [ad_conn user_id]

# create a list with all open assessments
template::list::create \
    -name assessments \
    -multirow assessments \
    -key assessment_id \
    -elements {
        title {
            label "[_ assessment.open_assessments]"
            display_template {<a href="@assessments.assessment_url@">@assessments.title@</a>}
        }
    } -main_class {
        narrow
    }

# get the information of all open assessments
template::multirow create assessments assessment_id title description assessment_url
db_foreach open_asssessments {} {
    if {([empty_string_p $start_time] || $start_time <= $cur_time) && ([empty_string_p $end_time] || $end_time >= $cur_time)} {
	if {[empty_string_p $password]} {
	    set assessment_url [export_vars -base "assessment" {assessment_id}]
	} else {
	    set assessment_url [export_vars -base "assessment-password" {assessment_id}]
	}
	template::multirow append assessments $assessment_id $title $description $assessment_url
    }
}

# create a list with all answered assessments and their sessions
template::list::create \
    -name sessions \
    -multirow sessions \
    -key assessment_id \
    -elements {
        title {
            label "[_ assessment.Assessments]"
            display_template {@sessions.title@}
        }
        session {
            label {[_ assessment.Sessions]}
            link_url_eval {[export_vars -base "sessions" {assessment_id}]}
        }
    } -main_class {
        narrow
    }

# get the information of all assessments store in the database
db_multirow -extend { session } sessions answered_asssessments {} {
    set session {Sessions}
}

set admin_p [ad_permission_p $package_id create]

ad_return_template
