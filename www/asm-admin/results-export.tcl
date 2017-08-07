ad_page_contract {
    Export assessment responses as csv file.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:naturalnum,notnull
} -properties {
    context:onevalue
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
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]

set export_options [list [list "[_ assessment.csv_export_name]" name] [list "[_ assessment.csv_export_title]" title]]
set form_format [lc_get formbuilder_date_format]

ad_form -name assessment_export -action results-export -form {
    {assessment_id:key}
    {column_format:text(radio) {label "[_ assessment.csv_export_format]"} {value "name" } {options $export_options} {help_text "[_ assessment.csv_export_format_help]"}}
    {start_time:date,to_sql(sql_date),to_html(display_date),optional {label "[_ assessment.csv_Start_Time]"} {format $form_format} {help} {help_text "[_ assessment.csv_Start_Time_help]"}}
    {end_time:date,to_sql(sql_date),to_html(display_date),optional {label "[_ assessment.csv_End_Time]"} {format $form_format} {help} {help_text "[_ assessment.csv_End_Time_help]"}}
} -edit_request {
} -on_submit {
    if {$start_time eq "NULL"} {
	set start_time ""
    }
    if {$end_time eq "NULL"} {
	set end_time ""
    }
    if {[db_type] eq "postgresql"} {
	regsub -all -- {to_date} $start_time {to_timestamp} start_time
	regsub -all -- {to_date} $end_time {to_timestamp} end_time
    }

    if {$assessment_data(anonymous_p) == "t"} {
	set csv_first_row_list [list score submission_date]
    } else {
	set csv_first_row_list  [list score submission_date user_id email name]
    }
    
    set start_date_sql ""
    set end_date_sql ""
    if {$start_time ne ""} {
	set start_date_sql [db_map restrict_start_date]
    }
    if {$end_time ne ""} {
	set end_date_sql [db_map restrict_end_date]
    }

    set session_list ""
    db_foreach all_sessions {} {
	lappend session_list $session_id
	
	if {$assessment_data(anonymous_p) == "t"} {
	    set csv_result_list($session_id) [list \"[as::assessment::quote_export -text $percent_score]\" \"[as::assessment::quote_export -text $submission_date]\"]
	} else {
	    set subject_mail [db_string get-email "select email from parties where party_id = :subject_id"]
	    set csv_result_list($session_id) [list \"$percent_score\" \"$submission_date\" \"$subject_id \" \"[as::assessment::quote_export -text $subject_mail]\" \"[as::assessment::quote_export -text [person::name -person_id $subject_id]]\"]
	}
    }
	
    set item_list [list]
    if {$session_list ne ""} {

	set section_list [db_list_of_lists all_sections {}]

	foreach one_section $section_list {
	    lassign $one_section section_id section_item_id
	    set mc_item_list [list]
	    db_foreach all_section_items {} {
		lappend item_list $section_id $as_item_id
		if {$column_format eq "name"} {
		    set csv_first_row($as_item_id) [as::assessment::quote_export -text "$as_item_id __ $field_name"]
		} else {
		    if {$description eq ""} {
			set csv_first_row($as_item_id) [as::assessment::quote_export -text $title]
		    } else {
			set csv_first_row($as_item_id) [as::assessment::quote_export -text "$title / $description"]
		    }
		}
		set item_type [string range $object_type end-1 end]
		if {$item_type eq "mc"} {
		    lappend mc_item_list $as_item_id		    
		} else {
		    array set results [as::item_type_$item_type\::results -as_item_item_id $as_item_item_id -section_item_id $section_item_id -data_type $data_type -sessions $session_list]
		    foreach session_id $session_list {
			if {[info exists results($session_id)]} {
			    set csv_${section_id}_${as_item_id}($session_id) [as::assessment::quote_export -text $results($session_id)]
			} else {
			    set csv_${section_id}_${as_item_id}($session_id) ""
			}
		    }
		    array unset results
		}
	    }

	    # Now get all MC items in one go
	    if {$mc_item_list ne ""} {
		db_foreach mc_items {} {
		    if {$text_value eq ""} {
			if {[exists_and_not_null csv_${section_id}_${as_item_id}($session_id)]} {
			    # append list of choices separated with comma
			    append csv_${section_id}_${as_item_id}($session_id) ",[as::assessment::quote_export -text $title]"
			} else {
			    # just set the choice value
			    set csv_${section_id}_${as_item_id}($session_id) [as::assessment::quote_export -text $title]
			}
		    } else {
			if {[exists_and_not_null csv_${section_id}_${as_item_id}($session_id)]} {
			    append csv_${section_id}_${as_item_id}($session_id) ",[as::assessment::quote_export -text $text_value]"
			} else {
			    set csv_${section_id}_${as_item_id}($session_id) [as::assessment::quote_export -text $text_value]
			}
		    }
		}
		array unset results
	    }
	}
    }

    foreach {section_id item_id} $item_list {
	lappend csv_first_row_list "\"$csv_first_row($item_id)\""
    }
    set csv_text "[join $csv_first_row_list ","]\r\n"

    foreach session_id $session_list {
	foreach {section_id item_id} $item_list {
	    if {[exists_and_not_null csv_${section_id}_${item_id}($session_id)]} {
		lappend csv_result_list($session_id) "\"[set csv_${section_id}_${item_id}($session_id)]\""
	    } else {
		lappend csv_result_list($session_id) ""
	    }
	}
	append csv_text "[join $csv_result_list($session_id) ","]\r\n"
    }
    set csv_text [string map {\xe4 ä \xfc ü \xf6 ö \xdf ß \xc4 Ä \xdc Ü \xd6 Ö} $csv_text]
} -after_submit {
    ns_set put [ad_conn outputheaders] Content-Disposition "attachment;filename=results.csv"
    ns_return 200 "text/csv" [encoding convertfrom iso8859-1 "$csv_text"]
#    ns_returnfile 200 text/csv $tmp_csv_filename
     # iso-8859-1
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
