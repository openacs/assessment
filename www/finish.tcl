ad_page_contract {

    Insert user response into database.
    This page receives an input for each item named
    response_to_item.$item_id

    @author  eperez@it.uc3m.es
    @date    2004-09-12
} {
    session_id:integer,notnull
    assessment_id:integer,notnull
}

set context_bar [list]
set user_id [ad_conn user_id]

ad_return_template
