ad_page_contract {

    Insert user response into database.
    This page receives an input for each item named
    response_to_item.$item_id

    @author  eperez@it.uc3m.es
    @date    2004-09-12
} {
    assessment_id:integer
    response_to_item:array,optional,multiple,html
}

set context_bar [list]

foreach response_to_item_id [array names response_to_item] {
  as_item_data_new -session_id [as_session__get_session_id_from_user_assessment -subject_id [ad_conn user_id] -assessment_id $assessment_id] -item_id $response_to_item_id -choice_id_answer $response_to_item($response_to_item_id)
}
