ad_page_contract {
    
    Form for creating a specific type of item
    
    @author nperper@it.uc3m.es
    @date July 20, 2004
} {     
    {as_item_id1:integer ""}        
    {item_type:html}
    {as_item_type_mc__num_answers "0"}       
} -properties {
    context:onevalue
    item_type:onevalue
    as_item_type_mc__num_answers:onevalue
}
  
set context [list "Create a new Item"]

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
permission::require_permission -object_id $package_id -privilege admin


set item_title [db_string item_title {SELECT as_itemsx.title FROM as_itemsx WHERE as_itemsx.as_item_id=:as_item_id1}]
set item_definition [db_string item_definition {SELECT as_itemsx.definition FROM as_itemsx WHERE as_itemsx.as_item_id=:as_item_id1}]

set as_item_type_id1 [db_nextval acs_object_id_seq]

#Form for creating a specific type of item
form create item-add-2 -elements {
     
    as_item_id1 -datatype integer -widget hidden
    as_item_type_id1 -datatype integer -widget hidden 
    as_items__title -label "Item Text" -datatype text -widget inform   
    item_type -datatype text -widget hidden    
         
}


element set_properties item-add-2 as_item_id1 -value $as_item_id1
element set_properties item-add-2 as_item_type_id1 -value $as_item_type_id1
element set_properties item-add-2 as_items__title -value $item_title
element set_properties item-add-2 item_type -value $item_type



#as_items.definition isn't mandatory, then this field can't be filled. If this field is filled we show its value.
set null ""
if {$item_definition ne $null } {
    element create item-add-2 as_items__definition -label "Description" -datatype text -widget inform        
    element set_properties item-add-2 as_items__definition -value $item_definition
}     


#for each type of item we create some elements
switch -- $item_type {
    "textarea" {
        element create item-add-2  as_item_type_oq__as_item_default -label "Default value" -datatype text -html {size 15} 
        element create item-add-2 as_item_type_oq__feedback_text -label "Feedback" -datatype text -html {rows 5 cols 50} -widget textarea -optional
	
	form set_properties item-add-2 -action "index"
    }
    "checkbox" -
	"radiobutton" {
      element create item-add-2 as_item_type_mc__increasing_p -label "Increasing" -datatype text -widget select -options {{{All or Nothing} f } {Increasing t} } -optional 

      element create item-add-2 as_item_type_mc__allow_negative_p -label "Allow negative?" -datatype text -widget radio -options {{Yes t} {No f}} -value f  -optional 
      element create item-add-2  as_item_type_mc__num_correct_answers -label "Number of Correct Answers" -datatype integer -html {size 7} -optional
      element create item-add-2 as_item_type_mc__num_answers -label "Number of Answers" -datatype integer -html {size 7}  
      
      element set_properties item-add-2 as_item_type_mc__num_answers -value $as_item_type_mc__num_answers 
      
      
      
            
if { [template::form is_valid item-add-2] } {
       #valid new item submission so create new item type
    set as_item_type_mc__increasing_p [template::element::get_value item-add-2 as_item_type_mc__increasing_p]
    set as_item_type_mc__allow_negative_p [template::element::get_value item-add-2 as_item_type_mc__allow_negative_p]
    set as_item_type_mc__num_correct_answers [template::element::get_value item-add-2 as_item_type_mc__num_correct_answers]
    set as_item_type_mc__num_answers [template::element::get_value item-add-2 as_item_type_mc__num_answers]
    
    db_transaction {   
        #Insert as_item_type_mc in the CR (and as_item_type_mc table) getting the revision_id (as_item_type_id)
	set as_item_type_id [as::item_type_mc::new -increasing_p $as_item_type_mc__increasing_p -allow_negative_p $as_item_type_mc__allow_negative_p -num_correct_answers $as_item_type_mc__num_correct_answers -num_answers $as_item_type_mc__num_answers]
	#set the relation between as_items table and as_item_type_mc table
	content::item::relate -item_id [db_string cr_item_from_revision "select item_id from cr_revisions where revision_id=:as_item_id1"] -object_id [db_string cr_item_from_revision "select item_id from cr_revisions where revision_id=:as_item_type_id"] -relation_tag {as_item_type_rel} -relation_type {cr_item_rel}
    }
    
    #redirect back to choice-add
    ad_returnredirect "choice-add?as_item_type_id=$as_item_type_id&as_item_type_mc__num_answers=$as_item_type_mc__num_answers&item_type=$item_type"
     
    } 
   
      
    }
    
    "open_question" {
         element create item-add-2 as_item_type_oq__as_item_default -label "Item default" -datatype text -html {size 15} -optional
	 element create item-add-2 as_item_type_oq__feedback_text -label "Feedback" -datatype text -widget textarea -html {rows 5 cols 50} -optional 
	 
	 form set_properties item-add-2 -action "index"
    }
    
    "shortanswer" {
        element create item-add-2 as_item_type_sa__increasing_p -label "Increasing" -datatype text -widget select -options {{{All or Nothing} f } {Increasing t} } -optional
       element create item-add-2 as_item_type_sa__allow_negative_p -label "Allow negative?" -datatype text -widget radio -options {{Yes t} {No f}} -value f  -optional 
       element create item-add-2 as_item_type_mc__num_answers -label "Number of Answers" -datatype integer -html {size 7} 
       
      
    }
    
    
    "imagemap" {
        element create item-add-2 as_item_type_im__increasing_p -label "Increasing" -datatype text -widget select -options {{{All or Nothing} f } {Increasing t} } -optional
        element create item-add-2 as_item_type_im__allow_negative_p -label "Allow negative?" -datatype text -widget radio -options {{Yes t} {No f}} -value f  -optional 
	element create item-add-2 as_item_type_mc__num_answers -label "Number of Answers" -datatype integer -html {size 7} 
	
	
    }   
    
   
} 


ad_return_template
  
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
