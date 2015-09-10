ad_page_contract {

    Preview a section

    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-03-29
} -query {
    assessment_id:integer
    section_id:integer
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
set page_title "[_ assessment.section_preview]"
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]
db_1row section_data {} -column_array section

# get all items of section in correct order
set item_list [db_list_of_lists section_items {}]


# form for display an assessment with sections and items
ad_form -name section_preview_form -action section-preview -html {enctype multipart/form-data} -export {assessment_id} -form {
    {section_id:text(hidden) {value $section_id}}
}

multirow create items as_item_id name title description subtext required_p max_time_to_complete presentation_type html content as_item_type_id choice_orientation next_title

foreach one_item $item_list {
    lassign $one_item as_item_id name title description subtext required_p max_time_to_complete content_rev_id content_filename content_type as_item_type_id

    set presentation_type [as::item_form::add_item_to_form -name section_preview_form -session_id "" -section_id $section_id -item_id $as_item_id -default_value "" -required_p $required_p]

    # Fill in the blank item. Replace all <textbox> that appear in the title by an <input> of type="text"
    if {$presentation_type == {tb}} {
	regsub -all -line -nocase -- {<textbox as_item_choice_id=} $title "<input name=response_to_item.${as_item_id}_" html
    }
    set max_time_to_complete [as::assessment::pretty_time -seconds $max_time_to_complete]

    if {$presentation_type eq "rb" || $presentation_type eq "cb"} {
	db_1row choice_orientation {}
    } else {
	set choice_orientation ""
    }

    multirow append items $as_item_id $name $title $description $subtext $required_p $max_time_to_complete $presentation_type "" [as::assessment::display_content -content_id $content_rev_id -filename $content_filename -content_type $content_type] $as_item_type_id $choice_orientation ""
}

for {set i 1; set j 2} {$i <= ${items:rowcount}} {incr i; incr j} {
    upvar 0 items:$i this
    if {$i < ${items:rowcount}} {
	upvar 0 items:$j next
	set this(next_title) $next(title)
    } else {
	set this(next_title) ""
    }
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
