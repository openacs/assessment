#www/show_items.tcl

ad_page_contract {
    @author alvaro@it.uc3m.es
    @creation-date 2004-04-16
} {
} -properties {
    context:onevalue
}

set context [list "Show Items"]

ad_form -name show_item_form  -html {enctype multipart/form-data} -form {
    { assessment_id:text {value 1} }
}

#For each item:
db_multirow items query_all_items {} {
    #If there is an item 
    if {![empty_string_p $item_id]} {
	add_item_to_form show_item_form $item_id
    }
}

ad_return_template
