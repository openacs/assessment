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

# update the last_mod_datetime col of as_sessions table to set the time when the most recent submission of assessment was done
db_dml session_finished {}

foreach response_to_item_name [array names response_to_item] {
    #reset variables
    set rb__display_id {}
    unset rb__display_id
    set tb__display_id {}
    unset tb__display_id
    set ta__display_id {}
    unset ta__display_id
    #get the choice identifier from response_to_item array
    regsub -all -line -nocase -- {.*_} $response_to_item_name {} response_to_item_choice_id
    #get the item identifier from response_to_item array
    regsub -all -line -nocase -- {_.*} $response_to_item_name {} response_to_item_id
    set item_display_id [as::item_rels::get_target -item_rev_id $response_to_item_id -type as_item_display_rel]
    db_0or1row as_item_display_rbx "SELECT as_item_display_id AS rb__display_id FROM as_item_display_rb WHERE as_item_display_id=:item_display_id"
    db_0or1row as_item_display_tbx "SELECT as_item_display_id AS tb__display_id FROM as_item_display_tb WHERE as_item_display_id=:item_display_id"
    db_0or1row as_item_display_tax "SELECT as_item_display_id AS ta__display_id FROM as_item_display_ta WHERE as_item_display_id=:item_display_id"
    set presentation_type "checkbox" ;# DEFAULT
    #set the presentation type
    if {[info exists rb__display_id]} {set presentation_type "radio"}
    if {[info exists tb__display_id]} {set presentation_type "fitb"}
    if {[info exists ta__display_id]} {set presentation_type "textarea"}

    # the presentation type is textbox (fill in the blank item)
    if {[info exists tb__display_id]} {
        db_foreach session_responses_to_item {SELECT as_item_datax.item_id FROM as_item_datax WHERE as_item_datax.as_item_id=:response_to_item_id AND as_item_datax.choice_id_answer=:response_to_item_choice_id AND as_item_datax.session_id=:as_session_id} {
            content::item::delete -item_id $item_id
        }
	#insert the answered responses by user in the CR (and as_item_data table) 
        foreach response $response_to_item($response_to_item_name) {
            as::item_data::new -session_id $as_session_id -as_item_id $response_to_item_id -choice_id_answer $response_to_item_choice_id -text_answer $response
        }
    } else {
        #the presentation type is textarea (short answer item)
        if {[info exists ta__display_id]} {
            db_foreach session_responses_to_item {SELECT as_item_datax.item_id FROM as_item_datax WHERE as_item_datax.as_item_id=:response_to_item_id AND as_item_datax.session_id=:as_session_id} {
        content::item::delete -item_id $item_id
        }
	#insert the response in the CR (and as_item_data table)
        foreach response $response_to_item($response_to_item_name) {
            as::item_data::new -session_id $as_session_id -as_item_id $response_to_item_id -text_answer $response
        } 
	#other types of items (presentation type is checkbox or radio)
       } else {
        db_foreach session_responses_to_item {SELECT as_item_datax.item_id FROM as_item_datax WHERE as_item_datax.as_item_id=:response_to_item_id AND as_item_datax.session_id=:as_session_id} {
        content::item::delete -item_id $item_id
        }
	#insert the answered responses by user in the CR (and as_item_data table)
        foreach response $response_to_item($response_to_item_name) {
            as::item_data::new -session_id $as_session_id -as_item_id $response_to_item_id -choice_id_answer $response
        }
        }
    }
}

ad_return_template
