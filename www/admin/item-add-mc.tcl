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

ad_require_permission $assessment_id admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set page_title [_ assessment.add_new_question]
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]

set boolean_options [list [list "[_ assessment.yes]" t] [list "[_ assessment.no]" f]]
set correct_options [list [list "[_ assessment.yes]" t]]

set display_types [list]
foreach display_type [db_list display_types {}] {
    lappend display_types [list "[_ assessment.item_display_$display_type]" $display_type]
}


ad_form -name item_add_mc -action item-add-mc -export { assessment_id section_id after num_choices } -form {
    {as_item_id:key}
    {title:text {label "[_ assessment.Title]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.mc_Title_help]"}}
    {increasing_p:text(select) {label "[_ assessment.Increasing]"} {options $boolean_options}  {help_text "[_ assessment.Increasing_help]"}}
    {negative_p:text(select) {label "[_ assessment.Allow_Negative]"} {options $boolean_options} {help_text "[_ assessment.Allow_Negative_help]"}}
    {num_correct_answers:text {label "[_ assessment.num_Correct_Answer]"} {html {size 5 maxlength 5}} {help_text "[_ assessment.num_Correct_help]"}}
    {num_answers:text,optional {label "[_ assessment.num_Answers]"} {html {size 5 maxlength 5}} {help_text "[_ assessment.num_Answers_help]"}}
    {display_type:text(select) {label "[_ assessment.Display_Type]"} {options $display_types} {help_text "[_ assessment.Display_Type_help]"}}
}

# add form entries for each choice
set ad_form_code "-form \{\n"
for {set i 1} {$i <= $num_choices} {incr i} {
    if {[info exists choice($i)]} {
	append ad_form_code "\{choice.$i:text,optional \{label \"[_ assessment.Choice] $i\"\} \{html \{size 80 maxlength 1000\}\} \{value \"\$choice($i)\"\} \{help_text \"[_ assessment.Choice_help]\"\}\}\n"
    } else {
	append ad_form_code "\{choice.$i:text,optional \{label \"[_ assessment.Choice] $i\"\} \{html \{size 80 maxlength 1000\}\} \{help_text \"[_ assessment.Choice_help]\"\}\}\n"
    }
    if {[info exists correct($i)]} {
	append ad_form_code "\{correct.$i:text(checkbox),optional \{label \"[_ assessment.Correct_Answer_Choice] $i\"\} \{options \$correct_options\} \{values t\} \{help_text \"[_ assessment.Correct_Answer_help]\"\}\}\n"
    } else {
	append ad_form_code "\{correct.$i:text(checkbox),optional \{label \"[_ assessment.Correct_Answer_Choice] $i\"\} \{options \$correct_options\} \{help_text \"[_ assessment.Correct_Answer_help]\"\}\}\n"
    }
}
append ad_form_code "\}"
eval ad_form -extend -name item_add_mc $ad_form_code


ad_form -extend -name item_add_mc -edit_request {
    set title ""
    set increasing_p f
    set negative_p f
    set num_correct_answers "1"
    set num_answers ""
    set display_type "sa"
} -on_submit {
    if {[template::form get_action item_add_mc] == "more"} {
	# add 5 more choice entries and redirect to this form
	incr num_choices 5
	ad_returnredirect [export_vars -base "item-add-mc" {assessment_id section_id as_item_id after as_item_type_id title increasing_p negative_p num_correct_answers num_answers display_type num_choices choice:array correct:array}]
	ad_script_abort
    }
} -edit_data {
    db_transaction {
	set mc_id [as::item_type_mc::new \
		       -title $title \
		       -increasing_p $increasing_p \
		       -allow_negative_p $negative_p \
		       -num_correct_answers $num_correct_answers \
		       -num_answers $num_answers]
	
	content::item::relate -item_id [db_string cr_item_from_revision "select item_id from cr_revisions where revision_id=:as_item_id"] -object_id [db_string cr_item_from_revision "select item_id from cr_revisions where revision_id=:mc_id"] -relation_tag {as_item_type_rel} -relation_type {cr_item_rel}

	set count 0
	foreach i [array names choice] {
	    if {![empty_string_p $choice($i)]} {
	    incr count
	    set choice_id [as::item_choice::new -mc_id $mc_id \
			       -title "$choice($i)" \
			       -numeric_value "" \
			       -text_value "" \
			       -content_value "" \
			       -feedback_text "" \
			       -selected_p "" \
			       -correct_answer_p "[ad_decode [info exists correct($i)] 0 f t]" \
			       -sort_order "$count" \
			       -percent_score ""]
	    }
	}
    }
} -after_submit {
    # now go to form to enter choice-specific data
    ad_returnredirect [export_vars -base "item-add-mc-choices" {assessment_id section_id as_item_id after mc_id display_type choice:array correct:array}]
    ad_script_abort
}

ad_return_template
