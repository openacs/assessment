ad_page_contract {
    @author nperper@it.uc3m.es
    @date September 16, 2004
} 



ad_form -name show_item_form  -html {enctype multipart/form-data} -form {
    { assessment_id:text {value 1} }
}


#For each item:
db_multirow items query_all_items {} 
#{
    #If there is an item 
#    if {![empty_string_p $as_item_id]} {
#	add_item_to_form show_item_form $as_item_id
 #   }
#}



ad_return_template