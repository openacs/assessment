ad_page_contract {
    Form to add a multiple choice item.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:integer
    section_id:integer
    as_item_id:integer
    after:integer
    choice:optional,array
    correct:optional,array
    {num_choices:integer,optional 10}
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

set page_title [_ assessment.add_item_type_mc]
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]
set folder_id [as::assessment::folder_id -package_id $package_id]

set boolean_options [list [list "[_ assessment.yes]" t] [list "[_ assessment.no]" f]]
set correct_options [list [list "[_ assessment.yes]" t]]

set choice_sets [db_list_of_lists existing_choice_sets {}]
set choice_sets [concat [list [list "" ""]] $choice_sets]
set display_types [list]
foreach display_type [db_list display_types {}] {
    lappend display_types [list "[_ assessment.item_display_$display_type]" $display_type]
}


ad_form -name item_add_mc -action item-add-mc -export { assessment_id section_id after num_choices } -form {
    {as_item_id:key}
    {title:text {label "[_ assessment.choice_set_title]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.mc_Title_help]"}}
    {increasing_p:text(select) {label "[_ assessment.Increasing]"} {options $boolean_options}  {help_text "[_ assessment.Increasing_help]"}}
    {negative_p:text(select) {label "[_ assessment.Allow_Negative]"} {options $boolean_options} {help_text "[_ assessment.Allow_Negative_help]"}}
    {num_correct_answers:text,optional,nospell {label "[_ assessment.num_Correct_Answer]"} {html {size 5 maxlength 5}} {help_text "[_ assessment.num_Correct_help]"}}
    {num_answers:text,optional,nospell {label "[_ assessment.num_Answers]"} {html {size 5 maxlength 5}} {help_text "[_ assessment.num_Answers_help]"}}
    {display_type:text(select) {label "[_ assessment.Display_Type]"} {options $display_types} {help_text "[_ assessment.Display_Type_help]"}}
    {mc_id:text(select),optional {label "[_ assessment.Choice_Sets]"} {options $choice_sets} {help_text "[_ assessment.Choice_Sets_help]"}}
}

# add form entries for each choice
set validate_list [list]
set count_correct [array exists correct]
set ad_form_code "-form \{\n"
for {set i 1} {$i <= $num_choices} {incr i} {
    if {[info exists choice($i)]} {
	append ad_form_code "\{choice.$i:text,optional,nospell \{label \"[_ assessment.Choice] $i\"\} \{html \{size 80 maxlength 1000\}\} \{value \"\$choice($i)\"\} \{help_text \"[_ assessment.Choice_help]\"\}\}\n"
    } else {
	append ad_form_code "\{choice.$i:text,optional,nospell \{label \"[_ assessment.Choice] $i\"\} \{html \{size 80 maxlength 1000\}\} \{help_text \"[_ assessment.Choice_help]\"\}\}\n"
    }
    if {[info exists correct($i)]} {
	append ad_form_code "\{correct.$i:text(checkbox),optional \{label \"[_ assessment.Correct_Answer_Choice] $i\"\} \{options \$correct_options\} \{values t\} \{help_text \"[_ assessment.Correct_Answer_help]\"\}\}\n"
    } else {
	append ad_form_code "\{correct.$i:text(checkbox),optional \{label \"[_ assessment.Correct_Answer_Choice] $i\"\} \{options \$correct_options\} \{help_text \"[_ assessment.Correct_Answer_help]\"\}\}\n"
    }
    lappend validate_list "correct.$i {\$count_correct > 0} \"\[_ assessment.one_correct_choice_req\]\""
}
append ad_form_code "\}"
if {[exists_and_not_null mc_id]} {
    set count_correct 1
}
eval ad_form -extend -name item_add_mc $ad_form_code


set edit_request "{
    set title \"\"
    set increasing_p f
    set negative_p f
    set num_correct_answers \"\"
    set num_answers \"\"
    set display_type \"sa\"
}"

set on_submit "{
    if {\[template::form get_action item_add_mc\] == \"more\"} {
	# add 5 more choice entries and redirect to this form
	incr num_choices 5
	ad_returnredirect \[export_vars -base \"item-add-mc\" {assessment_id section_id as_item_id after as_item_type_id title increasing_p negative_p num_correct_answers num_answers display_type num_choices choice:array correct:array}\]
	ad_script_abort
    }
}"

set edit_data "{
    db_transaction {
	if {!\[db_0or1row item_type {}\] || \$object_type != \"as_item_type_mc\"} {
	    if {\[empty_string_p \$mc_id\]} {
		set new_mc_id \[as::item_type_mc::new \\
			   -title \$title \\
			   -increasing_p \$increasing_p \\
			   -allow_negative_p \$negative_p \\
			   -num_correct_answers \$num_correct_answers \\
			   -num_answers \$num_answers\]
	    } else {
		set new_mc_id \$mc_id
	    }
	    
	    if {!\[info exists object_type\]} {
		# first item type mapped
		as::item_rels::new -item_rev_id \$as_item_id -target_rev_id \$new_mc_id -type as_item_type_rel
	    } else {
		# old item type existing
		set as_item_id \[as::item::new_revision -as_item_id \$as_item_id\]
		db_dml update_item_type {}
	    }
	} else {
	    # old mc item type existing
	    set as_item_id \[as::item::new_revision -as_item_id \$as_item_id\]
	    if {\[empty_string_p \$mc_id\]} {
		set new_mc_id \[as::item_type_mc::edit \\
			   -as_item_type_id \$as_item_type_id \\
			   -title \$title \\
			   -increasing_p \$increasing_p \\
			   -allow_negative_p \$negative_p \\
			   -num_correct_answers \$num_correct_answers \\
			   -num_answers \$num_answers\]
	    } else {
		set new_mc_id \$mc_id
	    }
	    
	    db_dml update_item_type {}
	}
	
	set count 0
	if {\[empty_string_p \$mc_id\]} {
	    foreach i \[lsort -integer \[array names choice\]\] {
		if {!\[empty_string_p \$choice(\$i)\]} {
		    incr count
		    set choice_id \[as::item_choice::new -mc_id \$new_mc_id \\
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
    }
}"

set after_submit "{
    # now go to form to enter choice-specific data
    if {\[empty_string_p \$mc_id\]} {
	ad_returnredirect \[export_vars -base \"item-add-mc-choices\" {assessment_id section_id as_item_id after mc_id display_type}\]
    } else {
	ad_returnredirect \[export_vars -base \"item-add-display-\$display_type\" {assessment_id section_id as_item_id after}\]
    }
    ad_script_abort
}"

eval ad_form -extend -name item_add_mc -validate "{$validate_list}" -edit_request $edit_request -on_submit $on_submit -edit_data $edit_data -after_submit $after_submit

ad_return_template
