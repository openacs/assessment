ad_page_contract {
    @author Eduardo Pérez Ureta (eperez@it.uc3m.es)
    @creation-date 2004-09-13
} -query {
  assessment_id:notnull
} -properties {
    as_session_id
    context:onevalue
}

set context [list "[_ assessment.Show_Items]"]

set as_session_id [as_session_new -assessment_id $assessment_id -subject_id [ad_conn user_id]]

set assessment_name [db_string assessment_name {
    SELECT title
    FROM as_assessmentsx
    WHERE assessment_id = :assessment_id
}]

db_dml session_start {
    UPDATE as_sessions
    SET creation_datetime = NOW()
    WHERE session_id = :as_session_id
}

ad_form -name show_item_form -action process-response -html {enctype multipart/form-data} -form {
    { as_session_id:text {value $as_session_id} }
}

db_multirow -extend {presentation_type html} items query_all_items {} {
    set presentation_type [add_item_to_form show_item_form $as_item_id]
    if {$presentation_type == {fitb}} {
        regsub -all -line -nocase -- {<textbox as_item_choice_id=} $title "<input name=response_to_item.${as_item_id}_" html
    }
}

ad_return_template
