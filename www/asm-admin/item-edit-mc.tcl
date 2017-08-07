ad_page_contract {
    Form to edit a multiple choice item.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:naturalnum,notnull
    section_id:naturalnum,notnull
    as_item_id:naturalnum,notnull
    choice:optional,array
    correct:optional,array
    {num_choices:integer,optional 5}
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

if {[template::form get_action item_show_mc] eq "existing"} {
    ad_returnredirect [export_vars -base item-edit-mc-existing {assessment_id section_id as_item_id}]
    ad_script_abort
}

set page_title [_ assessment.edit_item_type_mc]
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] [list [export_vars -base item-edit {assessment_id section_id as_item_id}] [_ assessment.edit_item]] $page_title]

set boolean_options [list [list "[_ assessment.yes]" t] [list "[_ assessment.no]" f]]
set correct_options [list [list "[_ assessment.yes]" t]]
set type $assessment_data(type)


ad_form -name item_edit_mc -action item-edit-mc -export { assessment_id section_id num_choices } -form {
    {as_item_id:key}
    {title:text,optional {label "[_ assessment.Title]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.mc_Title_help]"}}
}

if {$type > 1} {
    ad_form -extend -name item_edit_mc -form {
    {increasing_p:text(select) {label "[_ assessment.Increasing]"} {options $boolean_options}  {help_text "[_ assessment.Increasing_help]"}}
    {negative_p:text(select) {label "[_ assessment.Allow_Negative]"} {options $boolean_options} {help_text "[_ assessment.Allow_Negative_help]"}}
    {num_correct_answers:text,optional,nospell {label "[_ assessment.num_Correct_Answer]"} {html {size 5 maxlength 5}} {help_text "[_ assessment.num_Correct_help]"}}
    }
} else {
    ad_form -extend -name item_edit_mc -form {
	{increasing_p:text(hidden) {value ""}}
	{negative_p:text(hidden) {value ""}}
	{num_correct_answers:text(hidden) {value ""}}
    }
}
ad_form -extend -name item_edit_mc -form {
    {num_answers:text,optional,nospell {label "[_ assessment.num_Answers]"} {html {size 5 maxlength 5}} {help_text "[_ assessment.num_Answers_help]"}}
}

# add form entries for existing choices
array set choice {}
set ad_form_code "-form \{\n"
set choices [db_list_of_lists existing_choices {}]
set count 0
set validate_list [list]
set count_correct [array exists correct]
foreach one_choice $choices {
    lassign $one_choice choice_title choice_id choice_correct_p
    incr count
    if {![info exists choice($choice_id)]} {
	set choice($choice_id) $choice_title
	if {$choice_correct_p == "t"} {
	    set correct($choice_id) t
	}
    }
    append ad_form_code "\{choice.$choice_id:text,optional,nospell \{label \"[_ assessment.Choice] $count\"\} \{html \{size 80 maxlength 1000\}\} \{value \"\$choice($choice_id)\"\} \}\n"

    if { $type > 1} {
    if {[info exists correct($choice_id)]} {
	append ad_form_code "\{correct.$choice_id:text(checkbox),optional \{label \"[_ assessment.Correct_Answer_Choice] $count\"\} \{options \$correct_options\} \{values t\} \}\n"
    } else {
	append ad_form_code "\{correct.$choice_id:text(checkbox),optional \{label \"[_ assessment.Correct_Answer_Choice] $count\"\} \{options \$correct_options\} \}\n"
    }
    # lappend validate_list "correct.$choice_id {\$count_correct > 0} \"\[_ assessment.one_correct_choice_req\]\""
    }
}

# add new empty form entries for new choices
for {set i 1} {$i <= $num_choices} {incr i} {
    incr count
    if {[info exists choice(_$i)]} {
	append ad_form_code "\{choice._$i:text,optional,nospell \{label \"[_ assessment.Choice] $count\"\} \{html \{size 80 maxlength 1000\}\} \{value \"\$choice(_$i)\"\} \}\n"
    } else {
	append ad_form_code "\{choice._$i:text,optional,nospell \{label \"[_ assessment.Choice] $count\"\} \{html \{size 80 maxlength 1000\}\}\}\n"
    }
    if { $type > 1} {
    if {[info exists correct(_$i)]} {
	append ad_form_code "\{correct._$i:text(checkbox),optional \{label \"[_ assessment.Correct_Answer_Choice] $count\"\} \{options \$correct_options\} \{values t\}\}\n"
    } else {
	append ad_form_code "\{correct._$i:text(checkbox),optional \{label \"[_ assessment.Correct_Answer_Choice] $count\"\} \{options \$correct_options\} \}\n"
    }
    }
}
append ad_form_code "\}"
eval ad_form -extend -name item_edit_mc $ad_form_code


set edit_request "{
    db_1row item_type_data {}
}"

set on_submit "{
    if {\[template::form get_action item_add_mc\] == \"more\"} {
	# add 5 more choice entries and redirect to this form
	incr num_choices 5
	ad_returnredirect \[export_vars -base \"item-edit-mc\" {assessment_id section_id as_item_id title increasing_p negative_p num_correct_answers num_answers display_type num_choices choice:array correct:array}\]
	ad_script_abort
    }
}"

set edit_data "{
    db_transaction {
	set new_item_id \[as::item::new_revision -as_item_id \$as_item_id\]
	set as_item_type_id \[db_string item_type_id {}\]
	set new_item_type_id \[as::item_type_mc::edit \\
				  -as_item_type_id \$as_item_type_id \\
				  -title \$title \\
				  -increasing_p \$increasing_p \\
				  -allow_negative_p \$negative_p \\
				  -num_correct_answers \$num_correct_answers \\
				  -num_answers \$num_answers\]

	set new_assessment_rev_id \[as::assessment::new_revision -assessment_id \$assessment_id\]
	set section_id \[as::section::latest -section_id \$section_id -assessment_rev_id \$new_assessment_rev_id\]
	set new_section_id \[as::section::new_revision -section_id \$section_id -assessment_id \$assessment_id\]
	set as_item_id \[as::item::latest -as_item_id \$as_item_id -section_id \$new_section_id\]
	as::assessment::check::copy_item_checks -assessment_id \$assessment_id -section_id \$new_section_id -as_item_id \$as_item_id -new_item_id \$new_item_id

	as::section::update_section_in_assessment\
                -old_section_id \$section_id \
                -new_section_id \$new_section_id \
                -new_assessment_rev_id \$new_assessment_rev_id
	db_dml update_item_in_section {}
	db_dml update_item_type {}

	# edit existing choices
	set count 0
	foreach i \[lsort \[array names choice\]\] {
            if {\[string index  \$i 0\] != \"_\" && !\[empty_string_p \$choice(\$i)\]} {
          	incr count
		set new_choice_id \[as::item_choice::new_revision -choice_id \$i -mc_id \$new_item_type_id\]
		set title \$choice(\$i)
		set correct_answer_p \[ad_decode \[info exists correct(\$i)\] 0 f t\]
		db_dml update_title {}
		db_dml update_correct_and_sort_order {}
	    }
	}

	# add new choices
	foreach i \[lsort \[array names choice\]\] {

	    if {\[string index \$i 0\] == \"_\" && !\[empty_string_p \$choice(\$i)\]} {
		incr count
		set new_choice_id \[as::item_choice::new -mc_id \$new_item_type_id \\
				       -title \$choice(\$i) \\
				       -numeric_value \"\" \\
				       -text_value \"\" \\
				       -content_value \"\" \\
				       -feedback_text \"\" \\
				       -selected_p \"\" \\
				       -correct_answer_p \[ad_decode \[info exists correct(\$i)\] 0 f t\] \\
				       -sort_order \$count \\
				       -percent_score \"\"\]
	    }
	}
    }
    set mc_id \$new_item_type_id
    set as_item_id \$new_item_id
    set section_id \$new_section_id
}"

set after_submit "{
    # now go to form to edit choice-specific data
    ad_returnredirect \[export_vars -base \"item-edit-mc-choices\" {assessment_id section_id as_item_id mc_id}\]
    ad_script_abort
}"

eval ad_form -extend -name item_edit_mc -validate "{$validate_list}" -edit_request $edit_request -on_submit $on_submit -edit_data $edit_data -after_submit $after_submit

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
