db_multirow -extend { value } items session_items {

    select i.as_item_id, i.subtext, cr.title, cr.description, ci.name,
           ism.required_p, ism.section_id, ism.sort_order, i.feedback_right,
           i.feedback_wrong, ism.max_time_to_complete, ism.points, o.creation_user
    from as_items i, cr_revisions cr, cr_items ci, as_item_section_map ism,
         as_session_items si, acs_objects o
    where ci.item_id = cr.item_id
    and cr.revision_id = i.as_item_id
    and i.as_item_id = ism.as_item_id
    and ism.section_id = si.section_id
    and ism.as_item_id = si.as_item_id
    and si.session_id = :session_id
    and si.session_id = o.object_id
    order by si.sort_order
} {

    # TODO - you can grab these values at the same time you grab the sections - el\
imination a query each time
    # OR, you can grab these all at once and set variables


    set default_value [as::item_data::get -subject_id $creation_user -as_item_id $as_item_id -session_id $session_id]
    array set values $default_value

    #TODO - see if we need this
    array set item_info [as::item::item_data -as_item_id $as_item_id]
    set presentation_type $item_info(display_type)
    set item_type $item_info(item_type)

    if {[array size values] == 0} {
        set value ""
    } else {
	if {$item_type eq "mc"} {
	    
            set choice_id $values(choice_answer)
            set value [db_string get_choice_value {
                select title from cr_revisions, as_item_choices
                where cr_revisions.revision_id = as_item_choices.choice_id
                and choice_id = :choice_id
            }
		      ]
        } else {

            set value "$values(text_answer) $values(integer_answer) $values(numeric_answer) $values(content_answer) $values(boolean_answer) $values(clob_answer) $values(timestamp_answer)"
        }
    }
}




# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
