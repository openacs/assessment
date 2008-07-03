as::assessment::data -assessment_id $assessment_id
ad_form -name admin_section_${section_id} -form {
    {section_id:text(hidden) {value $section_id}}
}

set item_add_url [export_vars -base item-add {section_id assessment_id {after 0}}]
set catalog_search_url [export_vars -base catalog-search {section_id assessment_id {after 0}}]

db_multirow -extend { checks_related presentation_type html item_type choice_orientation item_edit_general_url item_copy_url catalog_search_url item_swap_url add_edit_check_url check_admin_url item_swap_down_url item_swap_up_url item_add_url item_delete_url} items section_items {} {

    # Build URLs
    set item_edit_general_url [export_vars -base item-edit-general {as_item_id section_id assessment_id}]
    set item_copy_url [export_vars -base item-copy {section_id assessment_id as_item_id {after $sort_order}}]
    set item_add_url [export_vars -base item-add {section_id assessment_id {after $sort_order}}]
    set catalog_search_url [export_vars -base catalog-search {section_id assessment_id {after $sort_order}}]
    set item_swap_down_url [export_vars -base item-swap {section_id assessment_id sort_order {direction down}}]
    set item_swap_up_url [export_vars -base item-swap {section_id assessment_id sort_order {direction up}}]
    set item_delete_url [export_vars -base item-swap {as_item_id section_id assessment_id}]
    set add_edit_check_url [export_vars -base ../asm-admin/add-edit-check {as_item_id section_id assessment_id {after $sort_order}}]
    set check_admin_url [export_vars -base ../asm-admin/checks-admin {section_id assessment_id {item_id $as_item_id}}]


    set presentation_type [as::item_form::add_item_to_form -name admin_section_${section_id} -section_id $section_id -item_id $as_item_id -random_p f]
    if {$presentation_type == "fitb"} {
        regsub -all -line -nocase -- {<textbox as_item_choice_id=} $title "<input name=response_to_item.${as_item_id}_" html
    }
    array set item [as::item::item_data -as_item_id $as_item_id]

    if {$presentation_type == "rb" || $presentation_type == "cb"} {
	array set type [as::item_display_$presentation_type\::data -type_id $item(display_type_id)]
	set choice_orientation $type(choice_orientation)
	array unset type
    } else {
	set choice_orientation ""
    }

    set item_type $item(item_type)
    array unset item

    if {[empty_string_p $points]} {
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
