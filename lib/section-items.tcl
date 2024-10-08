ad_include_contract {
    Section Items
} {
    assessment_id:object_type(content_item)
    section_id:object_type(as_sections)
}

set package_url [ad_conn package_url]
as::assessment::data -assessment_id $assessment_id

set item_add_new_url [export_vars -base "item-add" {section_id assessment_id {after 0}}]
set catalog_search_url [export_vars -base "catalog-search" {section_id assessment_id {after 0}}]

set item_add_top_url [export_vars -base item-add {as_item_id section_id assessment_id return_url {after 0}}]

ad_form -name admin_section_${section_id} -form {
    {section_id:text(hidden) {value $section_id}}
} -has_submit 1

db_multirow -extend {
    checks_related
    presentation_type
    html
    item_type
    choice_orientation
    allow_other_p
    item_edit_url
    item_copy_url
    item_delete_url
    item_add_url
    item_swap_up_url
    item_swap_down_url
    add_edit_check_url
    checks_admin_url
} items section_items {} {
    set presentation_type [as::item_form::add_item_to_form -name admin_section_${section_id} -section_id $section_id -item_id $as_item_id -random_p f]
    if {$presentation_type eq "fitb"} {
        regsub -all -line -nocase -- {<textbox as_item_choice_id=} $title "<input name=response_to_item.${as_item_id}_" html
    }
    set item [as::item::item_data -as_item_id $as_item_id]

    set item_edit_url [export_vars -base item-edit-general {as_item_id section_id assessment_id return_url}]
    set item_copy_url [export_vars -base item-copy {as_item_id section_id assessment_id return_url {after $sort_order}}]
    set item_delete_url [export_vars -base item-delete {as_item_id section_id assessment_id return_url}]
    set item_add_url [export_vars -base item-add {as_item_id section_id assessment_id return_url {after $sort_order}}]
    set item_swap_up_url [export_vars -base item-swap {as_item_id section_id assessment_id return_url sort_order {direction up}}]
    set item_swap_down_url [export_vars -base item-swap {as_item_id section_id assessment_id return_url sort_order {direction down}}]

    set add_edit_check_url [export_vars -base "../asm-admin/add-edit-check" {as_item_id section_id assessment_id {after $sort_order}}]
    set checks_admin_url [export_vars -base "../asm-admin/checks-admin" {section_id assessment_id {item_id $as_item_id}}]

    if {$presentation_type eq "rb" || $presentation_type eq "cb"} {
        set type [as::item_display_$presentation_type\::data -type_id [dict get $item display_type_id]]
        set choice_orientation [dict get $type choice_orientation]
    } else {
        set choice_orientation ""
    }

    set item_type [dict get $item item_type]

    if {$points eq ""} {
        set points 0
    }
    set max_time_to_complete [as::assessment::pretty_time -seconds $max_time_to_complete]

    set checks [as::section::checks_list -assessment_id $assessment_id -section_id $section_id]
    set checks_related 0
    #    ns_log notice "[llength $checks]"
    foreach  check_sql $checks {
        set cond_list  [split $check_sql "="]
        set item_id [lindex [split [lindex $cond_list 2] ")"] 0]
        if {$item_id == $as_item_id_i} {
            incr checks_related
        }

    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
