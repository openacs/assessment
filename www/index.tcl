ad_page_contract {
	@author Eduardo Pérez Ureta (eperez@it.uc3m.es)
	@creation-date 2004-09-03
} {
} -properties {
	context:onevalue
	assessment_info:multirow
}

set context [list "Show Assessments"]

set package_id [ad_conn package_id]

template::list::create \
    -name assessments \
    -multirow assessments \
    -key assessment_id \
    -elements {
        title {
            label {Assessment}
            link_url_eval {[export_vars -base "assessment" {assessment_id}]}
            link_html { title {@assessments.description@} }

        }
        session {
            label {Sessions}
            link_url_eval {[export_vars -base "sessions" {assessment_id}]}
        }
    } \
    -main_class {
        narrow
    }

db_multirow -extend { session } assessments asssessment_id_name_definition {} {
    set session {Sessions}
}

set admin_p [ad_permission_p $package_id admin]

ad_return_template
