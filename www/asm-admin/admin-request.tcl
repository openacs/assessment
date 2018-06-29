ad_page_contract {
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @creation-date 2005-01-17

} {
    {assessment:optional ""}
    {interval:optional ""}
    {date:optional ""}
    {state:optional ""}
} -properties {
    context
}
set party_id [ad_conn user_id]
set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
set permission ""



# shows not approved requests as default


# set options
set approved_options [as::assessment::check::state_options]
set assessment_list [as::assessment::check::get_assessments]
set intervals [as::assessment::check::intervals]

set context [list "[_ assessment.Request] [_ assessment.Administration]"]

# set default values

set d_state "f"
set d_assessment [lindex $assessment_list 0 1]
set d_interval [lindex $intervals 0 1]
set d_date ""
set date_query ""
set interval_query ""
set assessment_query ""
set state_query ""

if {![acs_user::site_wide_admin_p -user_id [ad_conn user_id]]} {
    set permission {
        and c.assessment_id in (
                                select object_id from acs_permissions
                                 where grantee_id=:party_id
                                and privilege='admin'
                                )
    }
}
if {$assessment ne "" && $assessment ne "all"} {
    permission::require_permission -object_id $assessment -privilege admin
    
    as::assessment::data -assessment_id $assessment
    set d_assessment $assessment
    set new_assessment_revision $assessment_data(assessment_rev_id)
    
    set assessment_query {
        and c.section_id_from in (
                                  select s.section_id
                                    from as_sections s,
                                         cr_revisions cr,
                                         cr_items ci,
                                         as_assessment_section_map asm
                                   where ci.item_id = cr.item_id
                                     and cr.revision_id = s.section_id
                                     and s.section_id = asm.section_id
                                     and asm.assessment_id = :new_assessment_revision)
    }
} else {
    
    set assessment_query {
        and assessment_id in (
                              select ci.item_id as assessment_i
                                from cr_folders cf,
                                     cr_items ci,
                                     cr_revisions cr,
                                     as_assessments a 
                               where cr.revision_id = ci.latest_revision
                                 and a.assessment_id = cr.revision_id
                                 and ci.parent_id = cf.folder_id
                                 and cf.package_id = :package_id)
    }
}

if {$state ne ""} {
    set d_state $state 
    
} 

if {$interval ne "" && $interval ne "all"} {
    set d_interval $interval
    set interval_query "and date_trunc('day', al.date_requested) >= to_date('$interval','YYYY-MM-DD')"
    set date_query ""
}

if {$date ne ""} {
    set d_date $date
    set date_query "and date_trunc('day', al.date_requested) = to_date('$date','YYYY-MM-DD')"
    set interval_query ""
}

if { $d_state eq "ae"} {
    set state_query "and al.failed_p= 'f' and al.approved_p='t'"
} elseif {$d_state =="f"} {
    set state_query "and al.approved_p='f'"
} elseif {$d_state == "t"} {
    set state_query "and al.failed_p='t' and al.approved_p='t'"
}
# ad_return_complaint 1 "$approved_options"
# ad_script_abort
ad_form -name assessments -form {
    {assessment:text(select)
	{label "[_ assessment.Assessment]"}
	{options $assessment_list}
	{value $d_assessment}
    }
    
    {state:text(select)
	{label ""}
	{options "$approved_options"}
	{value $d_state}
    }
    
} -has_submit 1

template::add_event_listener -id assessment -event change -script {get_assessment();}
template::add_event_listener -id state -event change -script {get_state();}


ad_form -name interval -form {
    {date:text(select)
	{label "[_ assessment.date_request]"}
	{options $intervals}
	{value $d_interval}
    }
} -has_submit 1
template::add_event_listener -id date -event change -script {get_interval();}


ad_form -name  specific_date_form  -form {
    {assessment:text(hidden)
	{value $d_assessment}
    }
    
    {state:text(hidden)
    	{value $d_state}
    }
    
    {specific_date:text(text)
	{label "" }
	{html {id sel2}}
	{after_html {<input type='reset' value=' ... ' id='sel2-control'><b>YYYY-MM-DD</b>}}
	{value $d_date}
    }
    
    {submit:text(submit)
	{label "[_ assessment.specific_date]"}
    }
} -on_submit {
    ad_returnredirect "admin-request?state=$state&assessment=$assessment&date=$specific_date"
    ad_script_abort

} -on_request {
    template::add_event_listener -id sel2-control -script {showCalendar('sel2', 'y-m-d');}
}


set query [subst {
    select c.section_id_from,
           al.failed_p,
           al.inter_item_check_id,
           c.name,
           al.action_log_id,
           c.assessment_id,
           a.name as action_name,
           a.action_id,
           (select subject_id from as_sessions where session_id=al.session_id) as subject_id,
           al.session_id,
           c.description,
           al.date_requested
      from as_actions a,
           as_actions_log al,
           as_inter_item_checks c
     where al.inter_item_check_id = c.inter_item_check_id
           $assessment_query
       and c.action_p = 't'
           $state_query
       and a.action_id = al.action_id
           $interval_query
           $date_query
           $permission
       and (select latest_revision
              from cr_items where item_id = c.assessment_id) in (select assessment_id from as_assessments)
}]

db_multirow -extend {user_name request_url} actions_log actions_log $query {
    set user_name [person::name -person_id $user_id]
    set request_url [export_vars -base "request-notification" {assessment_id {section_id $section_id_from} inter_item_check_id}]
}

template::list::create \
    -name actions_log \
    -multirow actions_log \
    -key action_log_id\
    -bulk_actions {
	"\#assessment.approve\#" "approve-check" "\#assessment.approve_actions\#"
	"\#assessment.bulk_mail_send\#" "bulk-mail" "\#assessment.bulk_mail_send\#"
    }\
    -bulk_action_method post \
    -bulk_action_export_vars {
        d_assessment
	d_state
	d_interval
	d_date
    }\
    -row_pretty_plural "[_ assessment.action_log]"\
    -elements {
	inter_item_check_id {
	    label "[_ assessment.trigger]"
	    display_col name
	    
	}
	action_id {
	    label "[_ assessment.action]"
	    display_col action_name
	}
	description {
	    label "[_ assessment.Description]"
	}
	
	user_name {
	    label "[_ assessment.User_ID]"
	}
	date_requested {
	    label "[_ assessment.data_type_date]"
	}
	failed_p {
	    label "[_ assessment.performed]"
	}
	notified_users {
	    label "[_ assessment.notified_users]"
	    display_template {
                <a href="@actions_log.request_url@">#assessment.notified_users#</a>
            }
	}
    }



# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
