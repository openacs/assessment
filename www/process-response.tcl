ad_page_contract {

    Insert user response into database.
    This page receives an input for each item named
    response_to_item.$item_id

    @author  eperez@it.uc3m.es
    @date    2004-09-12
} {
    session_id:integer,notnull
    response_to_item:array,optional,multiple,html
    assessment_id:integer,notnull
    section_id:integer,notnull
    section_order
    item_order
}

set context_bar [list]
set user_id [ad_conn user_id]

# FIXME Check staff_id or subject_id against user_id

db_transaction {
    db_dml session_updated {}

    foreach response_to_item_name [array names response_to_item] {
	#get the choice identifier from response_to_item array
	regsub -all -line -nocase -- {.*_} $response_to_item_name {} response_to_item_choice_id
	#get the item identifier from response_to_item array
	regsub -all -line -nocase -- {_.*} $response_to_item_name {} response_to_item_id

	db_1row item_type {}
	set item_type [string range $item_type end-1 end]

	as::item_type_$item_type\::process -type_id $item_type_id -session_id $session_id -as_item_id $response_to_item_id -subject_id $user_id -response $response_to_item($response_to_item_name) -max_points $points
    }
}

if {![empty_string_p $section_order]} {
    ad_returnredirect [export_vars -base assessment {assessment_id session_id section_order item_order}]
    ad_script_abort
}

db_dml session_finished {}

ad_return_template
