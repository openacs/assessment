ad_page_contract {
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @creation_date 2005-01-17
    
} {
    {assessment:optional}
    {interval:optional}
    {date:optional}
    {state:optional}
    
} -properties {
    context
}

# shows not approved requests as default


# set options
set approved_options [as::assessment::check::state_options]
set assessment_list [as::assessment::check::get_assessments]
set intervals [as::assessment::check::intervals]


# set default values

set d_state "f"
set d_assessment [lindex [lindex $assessment_list 0] 1]
set d_interval [lindex [lindex $intervals 0] 1]
set d_date ""
set date_query ""
set interval_query ""
set assessment_query ""
set state_query ""

if {[exists_and_not_null assessment] && $assessment!="all"} {
    set d_assessment $assessment
    set new_assessment_revision [db_string get_assessment_id {}]
    
    set assessment_query "and c.section_id_from in (select s.section_id from as_sections s, cr_revisions cr, cr_items ci, as_assessment_section_map asm  where ci.item_id = cr.item_id  and cr.revision_id = s.section_id and s.section_id = asm.section_id and asm.assessment_id = :new_assessment_revision)"
} 

if {[exists_and_not_null state]} {
    set d_state $state 
    ns_log notice "----------------->state $state"
} 
if {[exists_and_not_null interval] && $interval!="all"} {
    set d_interval $interval
    set interval_query "and to_date(al.date_requested,'YYYY-MM-DD') >= to_date('$interval','YYYY-MM-DD') and to_date(al.date_requested,'YYYY-MM-DD') <=to_date(now(),'YYYY-MM-DD') "
    set date_query ""
}

if {[exists_and_not_null date]} {
    set d_date $date
    set date_query "and to_date(al.date_requested,'YYYY-MM-DD') = to_date('$date','YYYY-MM-DD')"
    set interval_query ""
}

if { $d_state == "ae"} {
    set state_query "and al.failed_p='f' and al.approved_p='t'"
} elseif {$d_state =="f"} {
    set state_query "and al.approved_p='f'"
} elseif {$d_state == "t"} {
    set state_query "and al.failed_p='t' and al.approved_p='t'"
}

ad_form -name assessments -form {
    {assessment:text(select)
	{label "Assessment"}
	{options $assessment_list}
	{html { onChange "get_assessment()"}}
	{value $d_assessment}
    }
    
    {state:text(select)
	{label ""}
	{options $approved_options}
	{html { onChange "get_state()"}}
	{value $d_state}
    }
    
} -has_submit 1


ad_form -name interval  -form {
    {date:text(select)
	{label "Date request since ..."}
	{options $intervals}
	{value $d_interval}
	{html { onChange "get_interval()"}}
    }
} -has_submit 1


ad_form -name  specific_date  -form {
    {assessment:text(hidden)
	{value $d_assessment}
    }
    
    {state:text(hidden)
    	{value $d_state}
    }
    
    {specific_date:text(text)
	{label "" }
	{html {id sel2}}
	{after_html {<input type='reset' value=' ... ' onclick="return showCalendar('sel2', 'y-m-d');"><b>YYYY-MM-DD</b>}}
	{value $d_date}
    }
    
    {submit:text(submit)
	{label "Specific Date"}
    }
} -on_submit {
    ad_returnredirect "admin-request?state=$state&assessment=$assessment&date=$specific_date"
}


set query "select al.failed_p,c.inter_item_check_id,c.name,al.action_log_id,a.name as action_name,a.action_id,(select p.first_names || ' ' || p.last_name as name from persons p where p.person_id = (select subject_id from as_sessions where session_id=al.session_id))as user_name,al.session_id,c.description,al.date_requested from as_actions a, as_actions_log al, as_inter_item_checks c where al.inter_item_check_id=c.inter_item_check_id $assessment_query and c.action_p='t' $state_query  and a.action_id=al.action_id $interval_query $date_query"

db_multirow actions_log actions_log $query
template::list::create \
    -name actions_log \
    -multirow actions_log \
    -key action_log_id\
    -bulk_actions {
	"Approve" "approve-check" "Approve Actions"
    }\
    -bulk_action_method post \
    -bulk_action_export_vars {
	action_log_id
    }\
    -row_pretty_plural "actions log" \
    -elements {
	inter_item_check_id {
	    label "Trigger"
	    display_col name
	    
	}
	action_id {
	    label "Action"
	    display_col action_name
	}
	description {
	    label "Description"
	}
	
	user_name {
	    label "User"
	}
	date_requested {
	    label "Date"
	}
	failed_p {
	    label "Performed"
	}

	
    }

