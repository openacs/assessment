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
        session_id {
	    label {Session}
	    link_url_eval {[export_vars -base "session" {session_id}]}
	}
        subject_name {
	    label {Subject Name}
            link_url_eval {[acs_community_member_url -user_id $subject_id]}

        }
	assessment_name {
	    label {Assessment}
	    link_url_eval {[export_vars -base "assessment" {assessment_id}]}
	}
	completed_datetime {
	    label {Finnish Time}
	    html {nowrap}
	}
    } \
    -main_class {
        narrow
    }

set admin_p [ad_permission_p $package_id admin]

set assessment_id_multi $assessment_id
if { $admin_p } {
db_multirow -extend { item_url assessment_id } sessions sessions_of_assessment {
} {
    set item_url [export_vars -base "session" {session_id}]
    set assessment_id $assessment_id_multi
}
} else {
db_multirow -extend { item_url assessment_id } sessions sessions_of_assessment_of_subject {
} {
    set item_url [export_vars -base "session" {session_id}]
    set assessment_id $assessment_id_multi
}
}

set admin_p [ad_permission_p $package_id admin]

ad_return_template
