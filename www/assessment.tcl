ad_page_contract {

    This page allows to display an assessment with sections and items

    @author Eduardo Pérez Ureta (eperez@it.uc3m.es)
    @creation-date 2004-09-13
} -query {
  assessment_id:notnull
} -properties {
    as_session_id
    context:onevalue
}

set context [list "[_ assessment.Show_Items]"]

set as_session_id [as::session::new -assessment_id $assessment_id -subject_id [ad_conn user_id]]

set assessment_name [db_string assessment_name {
    SELECT title
    FROM as_assessmentsx
    WHERE assessment_id = :assessment_id
}]

set assessment_instruction [db_string assessment_instruction {
    SELECT instructions
    FROM as_assessmentsx
    WHERE assessment_id = :assessment_id
}]

# update the creation_datetime col of as_sessions table to set the time when the subject initiated the Assessment
db_dml session_start {
    UPDATE as_sessions
    SET creation_datetime = NOW()
    WHERE session_id = :as_session_id
}

# form for display an assessment with sections and items
ad_form -name show_item_form -action process-response -html {enctype multipart/form-data} -form {
    { as_session_id:text {value $as_session_id} }
}

# get all items from an assessment
db_multirow -extend {presentation_type html} items query_all_items {} {
    set presentation_type [as::item_form::add_item_to_form show_item_form $as_item_id]
    # Fill in the blank item. Replace all <textbox> that appear in the title by an <input> of type="text"
    if {$presentation_type == {fitb}} {
        regsub -all -line -nocase -- {<textbox as_item_choice_id=} $title "<input name=response_to_item.${as_item_id}_" html
    }
}

ad_return_template
