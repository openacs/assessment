ad_page_contract {

	Lists all the assessments that can be taken and their sessions.

	@author Eduardo Pérez Ureta (eperez@it.uc3m.es)
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

# create a list with all assessments and their sessions
template::list::create \
    -name assessments \
    -multirow assessments \
    -key assessment_id \
    -elements {
        title {
            label {Assessment}
            display_template {<if @assessments.assessment_url@ not nil><a href="@assessments.assessment_url@">@assessments.title@</a></if><else>@assessments.title@</else>}
        }
        session {
            label {[_ assessment.Sessions]}
            link_url_eval {[export_vars -base "sessions" {assessment_id}]}
        }
    } -main_class {
        narrow
    }

# get the information of all assessments store in the database
db_multirow -extend { session assessment_url } assessments asssessment_id_name_definition {} {
    set session {Sessions}
    if {([empty_string_p $start_time] || $start_time <= $cur_time) && ([empty_string_p $end_time] || $end_time >= $cur_time)} {
	if {[empty_string_p $password]} {
	    set assessment_url [export_vars -base "assessment" {assessment_id}]
	} else {
	    set assessment_url [export_vars -base "assessment-password" {assessment_id}]
	}
    } else {
	set assessment_url ""
    }
}

set admin_p [ad_permission_p $package_id create]

ad_return_template
