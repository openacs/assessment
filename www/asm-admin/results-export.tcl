ad_page_contract {
    Export assessment responses as csv file.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:integer
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set assessment_rev_id $assessment_data(assessment_rev_id)
set page_title "[_ assessment.csv_export]"
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]

set export_options [list [list "[_ assessment.csv_export_name]" name] [list "[_ assessment.csv_export_title]" title]]


ad_form -name assessment_export -action results-export -form {
    {assessment_id:key}
    {column_format:text(radio) {label "[_ assessment.csv_export_format]"} {options $export_options} {help_text "[_ assessment.csv_export_format_help]"}}
} -edit_request {
} -on_submit {
    if {$assessment_data(anonymous_p) == "t"} {
	set csv_first_row [list score submission_date]
    } else {
	set csv_first_row [list score submission_date user_id email first_names last_name]
    }
    
    set column_list ""
    db_foreach all_items {} {
	lappend item_list [list $as_item_item_id $section_item_id [string range $object_type end-1 end] $data_type]
	if {$column_format == "name"} {
	    lappend csv_first_row [as::assessment::quote_export -text $name]
	} else {
	    lappend csv_first_row [as::assessment::quote_export -text $title]
	}
    }
    
    set session_list ""
    db_foreach all_sessions {} {
	lappend session_list $session_id
	
	if {$assessment_data(anonymous_p) == "t"} {
	    set csv($session_id) [list $percent_score $submission_date]
	} else {
	    set csv($session_id) [list $percent_score $submission_date $subject_id [as::assessment::quote_export -text $email] [as::assessment::quote_export -text $first_names] [as::assessment::quote_export -text $last_name]]
	}
    }
    
    foreach one_item $item_list {
	util_unlist $one_item as_item_item_id section_item_id item_type data_type
	array set results [as::item_type_$item_type\::results -as_item_item_id $as_item_item_id -section_item_id $section_item_id -data_type $data_type -sessions $session_list]
	
	foreach session_id $session_list {
	    if {[info exists results($session_id)]} {
		lappend csv($session_id) [as::assessment::quote_export -text $results($session_id)]
	    } else {
		lappend csv($session_id) ""
	    }
	}
	
	array unset results
    }
    
    set csv_text "[join $csv_first_row ";"]\r\n"
    foreach session_id $session_list {
	append csv_text "[join $csv($session_id) ";"]\r\n"
    }
} -after_submit {
    ReturnHeaders "text/comma-separated-values"
    ns_write $csv_text
    ns_conn close
    ad_script_abort
}

ad_return_template
