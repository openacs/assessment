ad_page_contract {
    Form to add/edit an assessment.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:integer,optional
    {__new_p 0}
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

if {![info exists assessment_id] || $__new_p} {
    set page_title [_ assessment.New_Assessment2]
    set _assessment_id 0
} else {
    set page_title [_ assessment.Edit_Assessment]
    set _assessment_id 0
    db_0or1row rev_id_from_item_id {}
}

set context_bar [ad_context_bar $page_title]
set package_id [ad_conn package_id]
set sql_format "YYYY-MM-DD HH24:MI:SS"
set form_format "[lc_get formbuilder_date_format] [lc_get formbuilder_time_format]"


set boolean_options [list [list "[_ assessment.yes]" t] [list "[_ assessment.no]" f]]
set feedback_options [list [list "[_ assessment.None]" none] [list "[_ assessment.All]" all] [list "[_ assessment.Only_incorrect]" incorrect] [list "[_ assessment.Only_correct]" correct]]
set navigation_options [list [list "[_ assessment.Default_Path]" "default path"] [list "[_ assessment.Randomized]" randomized] [list "[_ assessment.Rulebased_branching]" "rule-based branching"]]


ad_form -name assessment_form -action assessment-form -form {
    {assessment_id:key}
}

if {[info exists assessment_id]} {
    ad_form -extend -name assessment_form -form {
	{name:text(inform) {label "[_ assessment.Name]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.assessment_Name_help]"}}
    }
} else {
    ad_form -extend -name assessment_form -form {
	{name:text,optional,nospell {label "[_ assessment.Name]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.assessment_Name_help]"}}
    }
}

ad_form -extend -name assessment_form -form {
    {title:text,nospell {label "[_ assessment.Title]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.as_Title_help]"}}
    {description:text(textarea),optional {label "[_ assessment.Description]"} {html {rows 5 cols 80}} {help_text "[_ assessment.as_Description_help]"}}
}

if {![empty_string_p [category_tree::get_mapped_trees $package_id]]} {
    category::ad_form::add_widgets -container_object_id $package_id -categorized_object_id $_assessment_id -form_name assessment_form
}

ad_form -extend -name assessment_form -form {
    {instructions:text(textarea),optional {label "[_ assessment.Instructions]"} {html {rows 5 cols 80}} {help_text "[_ assessment.as_Instructions_help]"}}
    {run_mode:text,optional,nospell {label "[_ assessment.Mode]"} {html {size 25 maxlength 25}} {help_text "[_ assessment.as_Mode_help]"}}
    {anonymous_p:text(select) {label "[_ assessment.Anonymous_Responses]"} {options $boolean_options} {help_text "[_ assessment.as_Anonymous_help]"}}
    {secure_access_p:text(select) {label "[_ assessment.Secure_Access_1]"} {options $boolean_options} {help_text "[_ assessment.as_Secure_Access_help]"}}
    {reuse_responses_p:text(select) {label "[_ assessment.Reuse_Responses_1]"} {options $boolean_options} {help_text "[_ assessment.as_Reuse_Responses_help]"}}
    {show_item_name_p:text(select) {label "[_ assessment.Show_Item_Name_1]"} {options $boolean_options} {help_text "[_ assessment.as_Show_Item_Name_help]"}}
    {entry_page:text,optional,nospell {label "[_ assessment.Entry_Page]"} {html {size 50 maxlength 50}} {help_text "[_ assessment.as_Entry_Page_help]"}}
    {exit_page:text,optional,nospell {label "[_ assessment.Exit_Page]"} {html {size 50 maxlength 50}} {help_text "[_ assessment.as_Exit_Page_help]"}}
    {consent_page:text(textarea),optional,nospell {label "[_ assessment.Consent_Page]"} {html {rows 5 cols 80}} {help_text "[_ assessment.as_Consent_Page_help]"}}
    {return_url:text,optional,nospell {label "[_ assessment.Return_Url]"} {html {size 50 maxlength 50}} {help_text "[_ assessment.as_Return_Url_help]"}}
    {start_time:date,to_sql(sql_date),to_html(display_date),optional {label "[_ assessment.Start_Time]"} {format $form_format} {help} {help_text "[_ assessment.as_Start_Time_help]"}}
    {end_time:date,to_sql(sql_date),to_html(display_date),optional {label "[_ assessment.End_Time]"} {format $form_format} {help} {help_text "[_ assessment.as_End_Time_help]"}}
    {number_tries:integer,optional,nospell {label "[_ assessment.Number_of_Tries]"} {html {size 10 maxlength 10}} {help_text "[_ assessment.as_Number_Tries_help]"}}
    {wait_between_tries:integer,optional,nospell {label "[_ assessment.Minutes_for_Retry]"} {html {size 10 maxlength 10}} {help_text "[_ assessment.as_Minutes_Retry_help]"}}
    {time_for_response:integer,optional,nospell {label "[_ assessment.time_for_completion]"} {html {size 10 maxlength 10}} {help_text "[_ assessment.as_time_help]"}}
    {show_feedback:text(select),optional {label "[_ assessment.Show_Feedback]"} {options $feedback_options} {help_text "[_ assessment.as_Feedback_help]"}}
    {section_navigation:text(select),optional {label "[_ assessment.Section_Navigation]"} {options $navigation_options} {help_text "[_ assessment.as_Navigation_help]"}}
} -new_request {
    set name ""
    set title ""
    set description ""
    set instructions ""
    set run_mode ""
    set anonymous_p f
    set secure_access_p f
    set reuse_responses_p f
    set show_item_name_p f
    set entry_page ""
    set exit_page ""
    set consent_page ""
    set return_url ""
    set start_time ""
    set end_time ""
    set number_tries ""
    set wait_between_tries ""
    set time_for_response ""
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
    {name {[as::assessment::unique_name -name $name -new_p $__new_p]} "[_ assessment.name_used]"}
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
				   -description $description \
				   -instructions $instructions \
				   -run_mode $run_mode \
				   -anonymous_p $anonymous_p \
				   -secure_access_p $secure_access_p \
				   -reuse_responses_p $reuse_responses_p \
				   -show_item_name_p $show_item_name_p \
				   -entry_page $entry_page \
				   -exit_page $exit_page \
				   -consent_page $consent_page \
				   -return_url $return_url \
				   -start_time "" \
				   -end_time "" \
				   -number_tries $number_tries \
				   -wait_between_tries $wait_between_tries \
				   -time_for_response $time_for_response \
				   -show_feedback $show_feedback \
				   -section_navigation $section_navigation]

	set assessment_id [db_string assessment_id_from_revision {}]

	if {[exists_and_not_null category_ids]} {
	    category::map_object -object_id $assessment_rev_id $category_ids
	}

	db_dml update_time {}
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
				   -entry_page $entry_page \
				   -exit_page $exit_page \
				   -consent_page $consent_page \
				   -return_url $return_url \
				   -start_time "" \
				   -end_time "" \
				   -number_tries $number_tries \
				   -wait_between_tries $wait_between_tries \
				   -time_for_response $time_for_response \
				   -show_feedback $show_feedback \
				   -section_navigation $section_navigation]

	if {[exists_and_not_null category_ids]} {
	    category::map_object -object_id $assessment_rev_id $category_ids
	}

	db_dml update_time {}
    }
} -after_submit {
    ad_returnredirect [export_vars -base one-a {assessment_id}]
    ad_script_abort
}

ad_return_template
