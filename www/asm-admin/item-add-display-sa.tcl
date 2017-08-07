ad_page_contract {
    Form to add an item with shortanswer display.

    @author Timo Hentschel (timo@timohentschel.de)
    @cvs-id $Id:
} {
    assessment_id:naturalnum,notnull
    section_id:naturalnum,notnull
    as_item_id:naturalnum,notnull
    after:integer
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

set page_title [_ assessment.add_item_display_sa]
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]


set orientation_types [list]
foreach orientation_type [list horizontal vertical] {
    lappend orientation_types [list "[_ assessment.$orientation_type]" $orientation_type]
}


ad_form -name item_add_display_sa -action item-add-display-sa -export { assessment_id section_id after } -form {
    {as_item_id:key}
    {html_options:text,optional,nospell {label "[_ assessment.Html_Options]"} {html {size 80 maxlength 1000}} {help_text "[_ assessment.Html_Options_help]"}}
    {abs_size:text,nospell {label "[_ assessment.Absolute_Size]"} {html {size 5 maxlength 5}} {help_text "[_ assessment.Absolute_Size_help]"}}
    {box_orientation:text(select) {label "[_ assessment.Box_Orientation]"} {options $orientation_types} {help_text "[_ assessment.Box_Orientation_help]"}}
} -edit_request {
    set html_options ""
    set abs_size 5
    set box_orientation "vertical"
} -validate {
    {html_options {[as::assessment::check_html_options -options $html_options]} "[_ assessment.error_html_options]"}
} -edit_data {
    db_transaction {
	set new_assessment_rev_id [as::assessment::new_revision -assessment_id $assessment_id]
	set section_id [as::section::latest -section_id $section_id -assessment_rev_id $new_assessment_rev_id]
	set new_section_id [as::section::new_revision -section_id $section_id -assessment_id $assessment_id]
	as::section::update_section_in_assessment\
                -old_section_id $section_id \
                -new_section_id $new_section_id \
                -new_assessment_rev_id $new_assessment_rev_id
	set old_item_id $as_item_id

	if {![db_0or1row item_display {}] || $object_type ne "as_item_display_sa"} {
	    set as_item_display_id [as::item_display_sa::new \
					-html_display_options $html_options \
					-abs_size $abs_size \
					-box_orientation $box_orientation]

	    if {![info exists object_type]} {
		# first item display mapped
		as::item_rels::new -item_rev_id $as_item_id -target_rev_id $as_item_display_id -type as_item_display_rel
	    } else {
		# old item display existing
		set as_item_id [as::item::new_revision -as_item_id $as_item_id]
	    }
	} else {
	    # old sa item display existing
	    set as_item_id [as::item::new_revision -as_item_id $as_item_id]
	    set as_item_display_id [as::item_display_sa::edit \
					-as_item_display_id $as_item_display_id \
					-html_display_options $html_options \
					-abs_size $abs_size \
					-box_orientation $box_orientation]
	}

	set old_item_id [as::item::latest -as_item_id $old_item_id -section_id $new_section_id -default 0]
	if {$old_item_id == 0} {
	    db_dml move_down_items {}
	    incr after
	    db_dml insert_new_item {}
	} else {
	    db_dml update_item_display {}
	    db_1row item_data {}
	    db_dml update_item {}
	}
    }
} -after_submit {
    # now go to assessment-page
    ad_returnredirect [export_vars -base one-a {assessment_id }]&\#$as_item_id
    ad_script_abort
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
