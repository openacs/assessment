ad_page_contract {

    Insert user response into database.
    This page receives an input for each item named
    response_to_item.$item_id

    @author  eperez@it.uc3m.es
    @date    2004-09-12
} {
    as_session_id:integer,notnull
    response_to_item:array,optional,multiple,html
}

set context_bar [list]

# FIXME Check staff_id or subject_id against user_id

db_dml session_finished {UPDATE as_sessions SET last_mod_datetime = NOW(), completed_datetime = NOW() WHERE session_id = :as_session_id}

foreach response_to_item_name [array names response_to_item] {
    set as_item_display_rbx__item_id {}
    unset as_item_display_rbx__item_id
    set as_item_display_tbx__item_id {}
    unset as_item_display_tbx__item_id
    set as_item_display_tax__item_id {}
    unset as_item_display_tax__item_id
    regsub -all -line -nocase -- {.*_} $response_to_item_name {} response_to_item_choice_id
    regsub -all -line -nocase -- {_.*} $response_to_item_name {} response_to_item_id 
    set item_item_id [db_string cr_item_from_revision "select item_id from cr_revisions where revision_id=:response_to_item_id"]
    set item_display_id [db_string item_item_type "SELECT related_object_id FROM cr_item_rels WHERE relation_tag = 'as_item_display_rel' AND item_id=:item_item_id"]
    db_0or1row as_item_display_rbx "SELECT item_id AS as_item_display_rbx__item_id FROM as_item_display_rbx WHERE item_id=:item_display_id"
    db_0or1row as_item_display_tbx "SELECT item_id AS as_item_display_tbx__item_id FROM as_item_display_tbx WHERE item_id=:item_display_id"
    db_0or1row as_item_display_tax "SELECT item_id AS as_item_display_tax__item_id FROM as_item_display_tax WHERE item_id=:item_display_id"
    set presentation_type "checkbox" ;# DEFAULT
    if {[info exists as_item_display_rbx__item_id]} {set presentation_type "radio"}
    if {[info exists as_item_display_tbx__item_id]} {set presentation_type "fitb"}
    if {[info exists as_item_display_tax__item_id]} {set presentation_type "textarea"}

    if {[info exists as_item_display_tbx__item_id]} {
        db_foreach session_responses_to_item {SELECT as_item_datax.item_id FROM as_item_datax WHERE as_item_datax.as_item_id=:response_to_item_id AND as_item_datax.choice_id_answer=:response_to_item_choice_id AND as_item_datax.session_id=:as_session_id} {
            content::item::delete -item_id $item_id
        }
        foreach response $response_to_item($response_to_item_name) {
            as::item_data::new -session_id $as_session_id -as_item_id $response_to_item_id -choice_id_answer $response_to_item_choice_id -text_answer $response
        }
    } else {
        if {[info exists as_item_display_tax__item_id]} {
            db_foreach session_responses_to_item {SELECT as_item_datax.item_id FROM as_item_datax WHERE as_item_datax.as_item_id=:response_to_item_id AND as_item_datax.session_id=:as_session_id} {
        content::item::delete -item_id $item_id
        }
        foreach response $response_to_item($response_to_item_name) {
            as::item_data::new -session_id $as_session_id -as_item_id $response_to_item_id -text_answer $response
        } 
       } else {
        db_foreach session_responses_to_item {SELECT as_item_datax.item_id FROM as_item_datax WHERE as_item_datax.as_item_id=:response_to_item_id AND as_item_datax.session_id=:as_session_id} {
        content::item::delete -item_id $item_id
        }
        foreach response $response_to_item($response_to_item_name) {
            as::item_data::new -session_id $as_session_id -as_item_id $response_to_item_id -choice_id_answer $response
        }
        }
    }
}

ad_return_template
