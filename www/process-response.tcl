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

foreach response_to_item_id [array names response_to_item] {
  db_foreach session_responses_to_item {SELECT as_item_datax.item_id FROM as_item_datax WHERE as_item_datax.as_item_id=:response_to_item_id AND as_sessionsx.session_id=:as_session_id} {
    content::item::delete -item_id $item_id
  }
  foreach response $response_to_item($response_to_item_id) {
    as_item_data_new -session_id $as_session_id -as_item_id $response_to_item_id -choice_id_answer $response
  }
}

ad_return_template
