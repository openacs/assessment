ad_page_contract {
	@author Eduardo Pérez Ureta (eperez@it.uc3m.es)
	@creation-date 2004-09-03
} {
  assessment_id:notnull
} -properties {
	context:onevalue
	assessment_info:multirow
}

set context [list "Show Sessions"]

set package_id [ad_conn package_id]

db_multirow sessions sessions_of_assessment {} {}

set admin_p [ad_permission_p $package_id admin]

ad_return_template
