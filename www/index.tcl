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

db_multirow assessment_info asssessment_id_name_definition {} {}

set admin_p [ad_permission_p $package_id admin]

ad_return_template
