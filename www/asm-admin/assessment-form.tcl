ad_page_contract {
    Form to add/edit an assessment.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:integer,optional
    {__new_p 0}
    {permission_p 0}
    {edit_p:optional "0"}
    {type ""}
} -properties {
    context:onevalue
    page_title:onevalue
}
		
if {![info exists assessment_id] || $__new_p} {
    set page_title [_ assessment.New_Assessment2]
    set s_assessment_id 0

} else {
    set page_title [_ assessment.Edit_Assessment]
    permission::require_permission -object_id $assessment_id -privilege admin
    set s_assessment_id 0
    db_0or1row rev_id_from_item_id {}
    if {![info exist type]} {
	# Get the assessment data
	as::assessment::data -assessment_id $assessment_id
	set type $assessment_data(type)
    }
}
set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create

set context [list [list index [_ assessment.admin]] $page_title]
set package_id [ad_conn package_id]
set sql_format "YYYY-MM-DD HH24:MI:SS"
set form_format "[lc_get formbuilder_date_format] [lc_get formbuilder_time_format]"
set user_id [ad_conn user_id]

set boolean_options [list [list "[_ assessment.yes]" t] [list "[_ assessment.no]" f]]
set feedback_options [list [list "[_ assessment.None]" none] [list "[_ assessment.All]" all] [list "[_ assessment.Only_incorrect]" incorrect] [list "[_ assessment.Only_correct]" correct]]
set navigation_options [list [list "[_ assessment.Default_Path]" "default path"] [list "[_ assessment.Randomized]" randomized] [list "[_ assessment.Rulebased_branching]" "rule-based branching"]]


##    {entry_page:text,optional,nospell {label "[_ assessment.Entry_Page]"} {html {size 50 maxlength 50}} {help_text "[_ assessment.as_Entry_Page_help]"}}
##    {exit_page:text,optional,nospell {label "[_ assessment.Exit_Page]"} {html {size 50 maxlength 50}} {help_text "[_ assessment.as_Exit_Page_help]"}}


ad_form -name assessment_form -export permission_p -action assessment-form -form {
    {assessment_id:key}
}

if {[info exists assessment_id] &&   $edit_p } {# 
    ad_form -extend -name assessment_form -form {
	{name:text(inform) {label "#assessment.Name#"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.assessment_Name_help]"}}
    }
} else {
    ad_form -extend -name assessment_form -form {
	{name:text,optional,nospell {label "[_ assessment.Name]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.assessment_Name_help]"}}
    }
}

ad_form -extend -name assessment_form -form {
    {title:text,nospell {label "[_ assessment.Title]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.as_Title_help]"}}
}
if { $type > 1} {
    ad_form -extend -name assessment_form -form {    {description:text(textarea),optional {label "[_ assessment.Description]"} {html {rows 5 cols 80}} {help_text "[_ assessment.as_Description_help]"}}
    }
}

if {![empty_string_p [category_tree::get_mapped_trees $package_id]]} {
    category::ad_form::add_widgets -container_object_id $package_id -categorized_object_id $s_assessment_id -form_name assessment_form
}


 
ad_form -extend -name assessment_form -form {{instructions:text(textarea),optional {label "[_ assessment.Instructions]"} {html {rows 5 cols 80}} {help_text "[_ assessment.as_Instructions_help]"}}
}
if { $type > 1} {
    ad_form -extend -name assessment_form -form {
	{run_mode:text,optional,nospell {label "[_ assessment.Mode]"} {html {size 25 maxlength 25}} {help_text "[_ assessment.as_Mode_help]"}}
    }
}

if { !$permission_p } { 
    ad_form -extend -name assessment_form  -form {
	{anonymous_p:text(select) {label "[_ assessment.Anonymous_Responses]"} {options $boolean_options} {help_text "[_ assessment.as_Anonymous_help]"} {value f}}
    } 
} else {
    ad_form -extend -name assessment_form  -form {
	{anonymous_p:text(hidden) {value t}}
    }
    
}

if { $type > 1} {
    ad_form -extend -name assessment_form -form {{secure_access_p:text(select) {label "[_ assessment.Secure_Access_1]"} {options $boolean_options} {help_text "[_ assessment.as_Secure_Access_help]"}}
	{reuse_responses_p:text(select) {label "[_ assessment.Reuse_Responses_1]"} {options $boolean_options} {help_text "[_ assessment.as_Reuse_Responses_help]"}}
	{show_item_name_p:text(select) {label "[_ assessment.Show_Item_Name_1]"} {options $boolean_options} {help_text "[_ assessment.as_Show_Item_Name_help]"}}
	{random_p:text(select) {label "[_ assessment.Allow_Random]"} {options $boolean_options} {help_text "[_ assessment.as_Allow_Random_help]"}}
	{consent_page:text(textarea),optional,nospell {label "[_ assessment.Consent_Page]"} {html {rows 5 cols 80}} {help_text "[_ assessment.as_Consent_Page_help]"}}
    }
}

ad_form -extend -name assessment_form -form {{return_url:text,optional,nospell {label "[_ assessment.Return_Url]"} {html {size 50 maxlength 50}} {help_text "[_ assessment.as_Return_Url_help]"}}}

if { $type > 1} {
    ad_form -extend -name assessment_form -form {
	{start_time:date,to_sql(sql_date),to_html(display_date),optional {label "[_ assessment.Start_Time]"} {format $form_format} {help} {help_text "[_ assessment.as_Start_Time_help]"}}
	{end_time:date,to_sql(sql_date),to_html(display_date),optional {label "[_ assessment.End_Time]"} {format $form_format} {help} {help_text "[_ assessment.as_End_Time_help]"}}
	{number_tries:integer,optional,nospell {label "[_ assessment.Number_of_Tries]"} {html {size 10 maxlength 10}} {help_text "[_ assessment.as_Number_Tries_help]"}}
	{wait_between_tries:integer,optional,nospell {label "[_ assessment.Minutes_for_Retry]"} {html {size 10 maxlength 10}} {help_text "[_ assessment.as_Minutes_Retry_help]"}}
	{time_for_response:integer,optional,nospell {label "[_ assessment.time_for_response]"} {html {size 10 maxlength 10}} {help_text "[_ assessment.as_time_help]"}}
	{ip_mask:text,optional,nospell {label "[_ assessment.ip_mask]"} {html {size 20 maxlength 100}} {help_text "[_ assessment.as_ip_mask_help]"}}
	{password:text,optional,nospell {label "[_ assessment.password]"} {html {size 20 maxlength 100}} {help_text "[_ assessment.as_password_help]"}}
	{show_feedback:text(select),optional {label "[_ assessment.Show_Feedback]"} {options $feedback_options} {help_text "[_ assessment.as_Feedback_help]"}}
	{section_navigation:text(select),optional {label "[_ assessment.Section_Navigation]"} {options $navigation_options} {help_text "[_ assessment.as_Navigation_help]"}}
	{type:text(hidden) {value $type}}
    }
} else  {
    ad_form -extend -name assessment_form -form {
	{description:text(hidden) value ""}
	{run_mode:text(hidden) {value ""}}
	{secure_access_p:text(hidden) {value "f"}}
	{reuse_responses_p:text(hidden) {value "f"}}
	{show_item_name_p:text(hidden) {value "f"}}
	{random_p:text(hidden) {value "t"}}
	{consent_page:text(hidden) {value ""}}
	{start_time:date(hidden) {value ""}}
	{end_time:date(hidden) {value ""}}
	{number_tries:text(hidden) {value ""}}
	{wait_between_tries:text(hidden) {value ""}}
	{time_for_response:text(hidden) {value ""}}
	{ip_mask:text(hidden) {value ""}}
	{password:text(hidden) {value ""}}
	{show_feedback:text(hidden) {value ""}}
	{section_navigation:text(hidden) {value ""}}
	{type:text(hidden) {value $type}}
    } 
}

ad_form -extend -name assessment_form -new_request {
    set name ""
    set title ""
    set description ""
    set instructions ""
    set run_mode ""
    set secure_access_p f
    set reuse_responses_p f
    set show_item_name_p f
    set random_p t
    set entry_page ""
    set exit_page ""
    set consent_page ""
    set return_url ""
    set start_time ""
    set end_time ""
    set number_tries ""
    set wait_between_tries ""
    set time_for_response ""
    set ip_mask ""
    set password ""
    set show_feedback "none"
    set section_navigation "default path"
} -edit_request {
    db_1row assessment_data {}

    if {![empty_string_p $start_time]} {
	set start_time [util::date::acquire ansi $start_time]
    }
    if {![empty_string_p $end_time]} {
	set end_time [util::date::acquire ansi $end_time]
    }
} -validate {
    {name {[as::assessment::unique_name -name $name -new_p $__new_p]} "[_ assessment.name_used] $assessment_id"}
} -on_submit {
    if {$start_time == "NULL"} {
	set start_time ""
    }
    if {$end_time == "NULL"} {
	set end_time ""
    }
    if {[db_type] == "postgresql"} {
	regsub -all -- {to_date} $start_time {to_timestamp} start_time
	regsub -all -- {to_date} $end_time {to_timestamp} end_time
    }

    set category_ids [category::ad_form::get_categories -container_object_id $package_id]
} -new_data {
    db_transaction {
	set assessment_rev_id [as::assessment::new \
				   -name $name \
				   -title $title \
                                   -creator_id $user_id \
				   -description $description \
				   -instructions $instructions \
				   -run_mode $run_mode \
				   -anonymous_p $anonymous_p \
				   -secure_access_p $secure_access_p \
				   -reuse_responses_p $reuse_responses_p \
				   -show_item_name_p $show_item_name_p \
				   -random_p $random_p \
				   -entry_page "" \
				   -exit_page "" \
				   -consent_page $consent_page \
				   -return_url $return_url \
				   -start_time "" \
				   -end_time "" \
				   -number_tries $number_tries \
				   -wait_between_tries $wait_between_tries \
				   -time_for_response $time_for_response \
				   -ip_mask $ip_mask \
				   -password $password \
				   -show_feedback $show_feedback \
				   -section_navigation $section_navigation \
				   -type $type]

	set assessment_id [db_string assessment_id_from_revision {}]

	# grant permission for this assessment to the user

	permission::grant -party_id $user_id -object_id $assessment_id -privilege "admin"

	if {[exists_and_not_null category_ids]} {
	    category::map_object -object_id $assessment_rev_id $category_ids
	}

	if {![empty_string_p $start_time]} {
	    db_dml update_start_time {}
	}
	if {![empty_string_p $end_time]} {
	    db_dml update_end_time {}
	}
    }
} -edit_data {
    db_transaction {
	set assessment_rev_id [as::assessment::edit \
				   -assessment_id $assessment_id \
				   -title $title \
				   -description $description \
				   -instructions $instructions \
				   -run_mode $run_mode \
				   -anonymous_p $anonymous_p \
				   -secure_access_p $secure_access_p \
				   -reuse_responses_p $reuse_responses_p \
				   -show_item_name_p $show_item_name_p \
				   -random_p $random_p \
				   -entry_page "" \
				   -exit_page "" \
				   -consent_page $consent_page \
				   -return_url $return_url \
				   -start_time "" \
				   -end_time "" \
				   -number_tries $number_tries \
				   -wait_between_tries $wait_between_tries \
				   -time_for_response $time_for_response \
				   -ip_mask $ip_mask \
				   -password $password \
				   -show_feedback $show_feedback \
				   -section_navigation $section_navigation \
				   -type $type]

	if {[exists_and_not_null category_ids]} {
	    category::map_object -object_id $assessment_rev_id $category_ids
	}

	if {![empty_string_p $start_time]} {
	    db_dml update_start_time {}
	}
	if {![empty_string_p $end_time]} {
	    db_dml update_end_time {}
	}
    }
} -after_submit {
    if {$permission_p} {
	permission::grant -party_id "-1" -object_id $assessment_id -privilege read
    }
    ad_returnredirect [export_vars -base one-a {assessment_id}]
    ad_script_abort
}

ad_return_template
