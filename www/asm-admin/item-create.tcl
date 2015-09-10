ad_page_contract {

    Form for creating an item.
    
    @author nperper@it.uc3m.es
    @date September 14, 2004
} -properties {
    context:onevalue
    as_items__title:onevalue
    as_items__definition:onevalue
    item_type:onevalue   
}
  
set context [list "Create a new Item"]

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
permission::require_permission -object_id $package_id -privilege admin



#item_id
set item_id [db_nextval acs_object_id_seq]

#form for creating an item
form create item-add -elements {    
    as_items_name -datatype integer -widget hidden 
    as_items_title -label "Item Title" -datatype text -html {size 59} 
    as_items_subtext -label "Item Text" -datatype text -html {rows 5 cols 50} -widget textarea -optional
    as_items_definition -label "Description" -datatype text -html {rows 8 cols 50} -widget textarea -value "" -optional    
    item_type -label "Item Type" -datatype text -widget select -options {{{Open Question} textarea} {{Short Answer} shortanswer} {{Multiple Choice (radio buttons)}  radiobutton} {{Multiple Choice (checkboxes)} checkbox } {{Multiple Choices (Image Map)} imagemap} {{Multiple Choice with Fill-in-Blank} shortanswer} } 
    
    as_items_max_time_to_complete -label "Maximum time to complete (in seconds)" -datatype integer -html {size 15}  -optional
    as_items_required_p -label "Required?" -datatype text -widget radio -options {{Yes t} {No f}} -value t   
    as_items_data_type -label "Data Type of the answer" -datatype text -widget select -options {{integer integer} {numeric numeric} {exponential exponential} {varchar varchar} {text text} {date date} {boolean boolean} {timestamp timestamp} {{content type} {content type}} } -optional
}


element set_properties item-add as_items_name -value $item_id

if { [template::form is_valid item-add] } {
      #valid new item submission so create new item
      set as_items_name [template::element::get_value item-add as_items_name]
      set as_items_title [template::element::get_value item-add as_items_title]
      set as_items_subtext [template::element::get_value item-add as_items_subtext]
      set as_items_definition [template::element::get_value item-add as_items_definition]
      set item_type [template::element::get_value item-add item_type]
      set as_items_max_time_to_complete [template::element::get_value item-add as_items_max_time_to_complete]
      set as_items_required_p [template::element::get_value item-add as_items_required_p]
      set as_items_data_type [template::element::get_value item-add as_items_data_type]
      
      db_transaction {
       #add the item
        #Insert as_item in the CR (and as_items table) getting the revision_id (as_item_id)
	set as_item_id [as::item::new -title $as_items_title -definition $as_items_definition -required_p $as_items_required_p -data_type $as_items_data_type -max_time_to_complete $as_items_max_time_to_complete]
    }
    
    #redirect back to display-create-type
    ad_returnredirect "display-create-type?item_type=$item_type&as_item_id1=$as_item_id"
}

#item_type -label "Item Type" -datatype text -widget select -options {{{Open Question} textarea} {{Short Answer} shortanswer} {Matching matching} {{File Upload} {file_upload}} {{Multiple Choice (radio buttons)}  radiobutton} {{Multiple Choice (checkboxes)} checkbox } {{Multiple Choices (Image Map)} image_map_mc} {{Multiple Choice with Fill-in-Blank} textarea}  {Rank rank} {{Matrix table} {matrix table}} {{Composite matrix-based multiple response} radiobutton}   }



ad_return_template
  

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
