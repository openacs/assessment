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

template::list::create \
    -name sessions \
    -multirow sessions \
    -key sessions_id \
    -elements {
        subject_name {
	    label {Subject Name}
            link_url_eval {[acs_community_member_url -user_id $subject_id]}

        }
	assessment_name {
	    label {Assessment}
	    link_url_eval {[export_vars -base "assessment" {session_id}]}
	}
	completed_datetime {
	    label {Finnish Time}
	    link_url_eval {[export_vars -base "session" {session_id}]}
	}
    } \
    -main_class {
        narrow
    }

db_multirow -extend { item_url } sessions sessions_of_assessment {
} {
    set item_url [export_vars -base "session" {session_id}]
}

set admin_p [ad_permission_p $package_id admin]

ad_return_template
