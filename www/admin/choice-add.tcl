ad_page_contract {
    
    Form for creating choices
    
    @author nperper@it.uc3m.es
    @date Sept 13, 2004
} {
    {as_item_type_id}
    {as_item_type_mc__num_answers}
    {item_type}
} -properties {
    context:onevalue    
}
  
set context [list "Create a new Choice"]

set package_id [ad_conn package_id]
set user_id [ad_get_user_id]
ad_require_permission $package_id admin

#set as_item_type_id [db_nextval acs_object_id_seq]



#Form for creating a specific type of item
form create choice-create -elements {
    item_type -datatype text -widget hidden
    as_item_type_mc__num_answers -datatype integer -widget hidden
    as_item_type_id -datatype integer -widget text
    
}


#element set_properties choice-create item_type -value "radiobutton"
element set_properties choice-create item_type -value $item_type
element set_properties choice-create as_item_type_mc__num_answers -value $as_item_type_mc__num_answers
element set_properties choice-create as_item_type_id -value $as_item_type_id


#set item_type "radiobutton"
#set as_item_type_mc__num_answers 2


#for each type of item we create some elements
switch -- $item_type {
    
    "checkbox" -
	"radiobutton" {
		
	array set as_item_choices__name {}
	array set as_item_choices__title {}
	array set as_item_choices__feedback_text {}
	
	for {set i 0 } { $i <$as_item_type_mc__num_answers} {incr i } {
      
        set choice_id [db_nextval acs_object_id_seq]
        template::form::section choice-create Choice_${i}

	
	
        element create choice-create as_item_choices__name_${i} -label "Choice Title" -datatype text -html {size 59}
        element create choice-create as_item_choices__title_${i} -label "Choice Text" -datatype text -html {rows 5 cols 50} -widget textarea -value ""
        element create choice-create as_item_choices__feedback_text_${i} -label "Feedback" -datatype text -html {rows 8 cols 50} -widget textarea -optional
        element create choice-create as_item_choices__selected_p_${i} -label "Selected?" -datatype text -widget select -options {{yes t} {no f}} -value f
        element create choice-create as_item_choices__correct_answer_p_${i} -label "Correct?" -datatype text -widget select -options {{yes t} {no f}} -value f
        element create choice-create as_item_choices__score_${i} -label "Score (in percent)" -datatype integer -html {size 7}    -value 0
	
	element set_properties choice-create as_item_choices__name_${i} -value $choice_id
	element set_properties choice-create as_item_choices__title_${i} 
	element set_properties choice-create as_item_choices__feedback_text_${i} 
	element set_properties choice-create as_item_choices__selected_p_${i} 
	element set_properties choice-create as_item_choices__correct_answer_p_${i} 
	element set_properties choice-create as_item_choices__score_${i} 
     }
      

		
	if { [template::form is_valid choice-create] } {
          	  
	  set item_type [template::element::get_value choice-create item_type]
	  set as_item_type_mc__num_answers [template::element::get_value choice-create as_item_type_mc__num_answers]
	  set as_item_type_id [template::element::get_value choice-create as_item_type_id]
	  
	  for {set i 0 } { $i <$as_item_type_mc__num_answers} {incr i } {
	  
	    set as_item_choices__name($i) [template::element::get_value choice-create as_item_choices__name_${i}]
	    set as_item_choices__title($i) [template::element::get_value choice-create as_item_choices__title_${i}]
	    set as_item_choices__feedback_text($i) [template::element::get_value choice-create as_item_choices__feedback_text_${i}]
	    set as_item_choices__selected_p($i) [template::element::get_value choice-create as_item_choices__selected_p_${i}]
	    set as_item_choices__correct_answer_p($i) [template::element::get_value choice-create as_item_choices__correct_answer_p_${i}]
	    set as_item_choices__score($i) [template::element::get_value choice-create as_item_choices__score_${i}]
          
	    
	  
          db_transaction {  
	     as::item_choice::new -mc_id $as_item_type_id -name $as_item_choices__name($i) -title $as_item_choices__title($i) -feedback_text $as_item_choices__feedback_text($i) -percent_score $as_item_choices__score($i)
	  
          }
    
    #redirect back to one
    ad_returnredirect "one" 
        
} 
}
    
}
} 


ad_return_template
  