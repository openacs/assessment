ad_page_contract {
    @author Eduardo P�rez Ureta (eperez@it.uc3m.es)
    @creation-date 2004-09-13
} -query {
  assessment_id:notnull
} -properties {
    as_session_id
    context:onevalue
}

set context [list "Show Items"]

set as_session_id [as_session_new -assessment_id $assessment_id -subject_id [ad_conn user_id]]
db_dml session_start {UPDATE as_sessions SET creation_datetime = NOW() WHERE session_id=:as_session_id}

ad_form -name show_item_form -action process-response -html {enctype multipart/form-data} -form {
    { as_session_id:text {value $as_session_id} }
}

#For each item:
db_multirow items query_all_items {} {
    #If there is an item 
    if {![empty_string_p $as_item_id]} {
	add_item_to_form show_item_form $as_item_id
    }
}

ad_return_template