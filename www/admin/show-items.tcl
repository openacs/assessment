ad_page_contract {
    @author eperez@it.uc3m.es
    @creation-date 2004-09-21
} {
} -properties {
    context:onevalue
}

set context [list "[_ assessment.Show_Items]"]

ad_form -name show_item_form  -html {enctype multipart/form-data} -form {
    { assessment_id:text {value 1} }
}

#For each item:
db_multirow items query_all_items {} {
    #If there is an item 
    if {![empty_string_p $as_item_id]} {
	add_item_to_form show_item_form $as_item_id
    }
}

ad_return_template
