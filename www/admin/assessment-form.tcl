ad_page_contract {
    Form to add/edit an assessment.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:integer,optional
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

if {[info exists assessment_id]} {
    set page_title [_ assessment.Edit_Assessment]
} else {
    set page_title [_ assessment.New_Assessment2]
}

set context_bar [ad_context_bar $page_title]
set format "YYYY-MM-DD HH24:MI"


ad_form -name assessment_form -action assessment-form -form {
    {assessment_id:key}
}

if {![exists_and_not_null assessment_id]} {
    ad_form -extend -name assessment_form -form {
	{name:text {label "[_ assessment.Name]"} {html {size 40 maxlength 400}}}
    }
}

set boolean_options [list [list "[_ assessment.yes]" t] [list "[_ assessment.no]" f]]
set feedback_options [list [list "[_ assessment.None]" none] [list "[_ assessment.All]" all] [list "[_ assessment.Only_incorrect]" incorrect] [list "[_ assessment.Only_correct]" correct]]
set navigation_options [list [list "[_ assessment.Default_Path]" "default path"] [list "[_ assessment.Randomized]" randomized] [list "[_ assessment.Rulebased_branching]" "rule-based branching"]]


ad_form -extend -name assessment_form -form {
    {title:text {label "[_ assessment.Title]"} {html {size 80 maxlength 1000}}}
    {description:text(textarea) {label "[_ assessment.Description]"} {html {rows 5 cols 80}}}
    {instructions:text(textarea),optional {label "[_ assessment.Instructions]"} {html {rows 5 cols 80}}}
    {mode:text,optional {label "[_ assessment.Mode]"} {html {size 25 maxlength 25}}}
    {editable_p:text(select) {label "[_ assessment.Editable]"} {options $boolean_options}}
    {anonymous_p:text(select) {label "[_ assessment.Anonymous_Responses]"} {options $boolean_options}}
    {secure_access_p:text(select) {label "[_ assessment.Secure_Access_1]"} {options $boolean_options}}
    {reuse_responses_p:text(select) {label "[_ assessment.Reuse_Responses_1]"} {options $boolean_options}}
    {show_item_name_p:text(select) {label "[_ assessment.Show_Item_Name_1]"} {options $boolean_options}}
    {entry_page:text,optional {label "[_ assessment.Entry_Page]"} {html {size 50 maxlength 50}}}
    {exit_page:text,optional {label "[_ assessment.Exit_Page]"} {html {size 50 maxlength 50}}}
    {consent_page:text(textarea),optional {label "[_ assessment.Consent_Page]"} {html {rows 5 cols 80}}}
    {return_url:text,optional {label "[_ assessment.Return_Url]"} {html {size 50 maxlength 50}}}
    {start_time:date,to_sql(sql_date),to_html(display_date),optional {label "[_ assessment.Start_Time]"} {format $format} {help}}
    {end_time:date,to_sql(sql_date),to_html(display_date),optional {label "[_ assessment.End_Time]"} {format $format} {help}}
    {number_tries:integer,optional {label "[_ assessment.Number_of_Tries]"} {html {size 10 maxlength 10}}}
    {wait_between_tries:integer,optional {label "[_ assessment.Minutes_for_Retry]"} {html {size 10 maxlength 10}}}
    {time_for_response:integer,optional {label "[_ assessment.time_for_completion]"} {html {size 10 maxlength 10}}}
    {show_feedback:text(select),optional {label "[_ assessment.Show_Feedback]"} {options $feedback_options}}
    {section_navigation:text(select),optional {label "[_ assessment.Section_Navigation]"} {options $navigation_options}}
} -new_request {
    set name ""
    set title ""
    set description ""
    set instructions ""
    set mode ""
    set editable_p f
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
	set start_time [util::date::acquire clock [clock scan $start_time]]
    }
    if {![empty_string_p $end_time]} {
	set end_time [util::date::acquire clock [clock scan $end_time]]
    }
} -on_submit {
    if {$start_time == "NULL"} {
	set start_time ""
    }
    if {$end_time == "NULL"} {
	set end_time ""
    }
} -new_data {
    set assessment_rev_id [as::assessment::new \
			       -name $name \
			       -title $title \
			       -description $description \
			       -instructions $instructions \
			       -mode $mode \
			       -editable_p $editable_p \
			       -anonymous_p $anonymous_p \
			       -secure_access_p $secure_access_p \
			       -reuse_responses_p $reuse_responses_p \
			       -show_item_name_p $show_item_name_p \
			       -entry_page $entry_page \
			       -exit_page $exit_page \
			       -consent_page $consent_page \
			       -return_url $return_url \
			       -start_time $start_time \
			       -end_time $end_time \
			       -number_tries $number_tries \
			       -wait_between_tries $wait_between_tries \
			       -time_for_response $time_for_response \
			       -show_feedback $show_feedback \
			       -section_navigation $section_navigation]

    set assessment_id [db_string assessment_id_from_revision {}]
} -edit_data {
    set assessment_rev_id [as::assessment::edit \
			       -assessment_id $assessment_id \
			       -title $title \
			       -description $description \
			       -instructions $instructions \
			       -mode $mode \
			       -editable_p $editable_p \
			       -anonymous_p $anonymous_p \
			       -secure_access_p $secure_access_p \
			       -reuse_responses_p $reuse_responses_p \
			       -show_item_name_p $show_item_name_p \
			       -entry_page $entry_page \
			       -exit_page $exit_page \
			       -consent_page $consent_page \
			       -return_url $return_url \
			       -start_time $start_time \
			       -end_time $end_time \
			       -number_tries $number_tries \
			       -wait_between_tries $wait_between_tries \
			       -time_for_response $time_for_response \
			       -show_feedback $show_feedback \
			       -section_navigation $section_navigation]
} -after_submit {
    ad_returnredirect [export_vars -base one-a {assessment_id}]
    ad_script_abort
}

ad_return_template
