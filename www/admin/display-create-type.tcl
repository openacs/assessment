ad_page_contract {

    Form for selecting display options
    
    @author nperper@it.uc3m.es
    @date July 21, 2004
} { 
    item_type:html,notnull
    {as_item_id1}    
    
} -properties {
    context:onevalue
    item_type:onevalue
    as_item_id1:onevalue 
}
  

set context [list "Presentation Type"]

set package_id [ad_conn package_id]
set user_id [ad_get_user_id]
ad_require_permission $package_id admin


set as_item_display_id1 [db_nextval acs_object_id_seq]




#Form for selecting display options 
form create display-type -elements {
    as_item_id1 -datatype integer -widget hidden    
    item_type -datatype text -widget hidden 
    as_item_display_type__name -datatype text -widget hidden       
    as_item_display_type__html_display_options -label "Html Display Options" -datatype text -html {rows 5 cols 50} -widget textarea -optional    
}
      
     
     #set a value for as_item_id	
     element set_properties display-type as_item_id1 -value $as_item_id1
     element set_properties display-type item_type -value $item_type
     element set_properties display-type as_item_display_type__name -value $as_item_display_id1

#for each item_type (textbox, shortanswer, textarea, radiobutton, checkbox, select, imagemap, multiplechoice, pop-up_date, typed_date, file_upload)      
switch -- $item_type {
    "textbox" {
          element set_properties display-type as_item_display_type__name -value "textbox"
          element create display-type as_item_display_tb__abs_size -label "Abs Size" -datatype text -widget select -options {{small small} {medium medium} {large large}} -optional
	  
	  element create display-type as_item_display_tb__item_answer_alignment -label "Answer Alignment" -datatype text -widget select -options {{{beside left} beside_left} {{beside right} beside_right} {bellow bellow} {above above}} -optional
    }
    
    "shortanswer" {
          element set_properties display-type as_item_display_type__name -value "short answer"
          element create display-type as_item_display_sa__abs_size -label "Abs Size" -datatype text -widget select -options {{small small} {medium medium} {large large}} -optional
	  element create display-type as_item_display_sa__box_orientation -label "Box Orientation" -datatype text -widget select -options {{horizontal horizontal} {vertical vertical}} -optional
    }
    
    "textarea" {
          element set_properties display-type as_item_display_type__name -value "textarea"
          element create display-type as_item_display_ta__abs_size -label "Abs Size" -datatype text -widget select -options {{small small} {medium medium} {large large}} -optional
	  element create display-type as_item_display_ta__acs_widget -datatype text -widget hidden -value "text"
	  element create display-type as_item_display_ta__item_answer_alignment -label "Answer Alignment" -datatype text -widget select -options {{{beside left} beside_left} {{beside right} beside_right} {bellow bellow} {above above}} -optional
    }
    
    "radiobutton" {
          element create display-type as_item_display_rb__acs_widget -datatype text -widget hidden -value "radio"  
          element create display-type as_item_display_rb__choice_orientation -label "Choice Orientation" -datatype text -widget select -options {{horizontal horizontal} {vertical vertical}} -optional    
          element create display-type as_item_display_rb__choice_label_orientation -label "Choice Label Orientation" -datatype text -widget select -options {{top top} {left left} {right right} {buttom buttom}} -optional          
	  element create display-type as_item_display_rb__sort_order -label "Sort Order" -datatype text -widget select -options {{numerical numerical} {alphabetic alphabetic} {randomized randomized} {{by order of entry} {by order of entry}}} -optional
	  element create display-type as_item_display_rb__item_answer_alignment -label "Answer Alignment" -datatype text -widget select -options {{{beside left} beside_left} {{beside right} beside_right} {bellow bellow} {above above}} -optional 	  
	  
	  if { [template::form is_valid display-type] } {
              #valid new display-type submission so create the display type
              set as_item_display_type__name [template::element::get_value display-type as_item_display_type__name]
              set as_item_display_type__html_display_options [template::element::get_value display-type as_item_display_type__html_display_options]
              set as_item_display_rb__choice_orientation [template::element::get_value display-type as_item_display_rb__choice_orientation]
              set as_item_display_rb__choice_label_orientation [template::element::get_value display-type as_item_display_rb__choice_label_orientation]
              set item_type [template::element::get_value display-type item_type]
              set as_item_display_rb__sort_order [template::element::get_value display-type as_item_display_rb__sort_order]
              set as_item_display_rb__item_answer_alignment [template::element::get_value display-type as_item_display_rb__item_answer_alignment]
	      
	      set as_item_id1 [template::element::get_value display-type as_item_id1]
             
      db_transaction {
       #add the item
        #Insert as_item_display_rb in the CR (and as_item_display_rb table) getting the revision_id (as_item_display_id)
        set as_item_display_rb_id [as_item_display_rb_new -name $as_item_display_type__name -html_display_options $as_item_display_type__html_display_options -choice_orientation $as_item_display_rb__choice_orientation -choice_label_orientation $as_item_display_rb__choice_label_orientation -sort_order_type $as_item_display_rb__sort_order -item_answer_alignment $as_item_display_rb__item_answer_alignment]
       
        #set the relation between as_items table and as_item_display_rb table
        content::item::relate -item_id [db_string cr_item_from_revision "select item_id from cr_revisions where revision_id=:as_item_id1"] -object_id [db_string cr_item_from_revision "select item_id from cr_revisions where revision_id=:as_item_display_rb_id"] -relation_tag {as_item_display_rel} -relation_type {cr_item_rel}
	
    }
    
    #redirect back to item-create-2
    ad_returnredirect "item-create-2?item_type=$item_type&as_item_id1=$as_item_id1"
}
	  
     }
     
     "checkbox" {
          element set_properties display-type as_item_display_type__name -value "CheckBox"
	  element create display-type as_item_display_cb__choice_orientation -label "Choice Orientation" -datatype text -widget select -options {{horizontal horizontal} {vertical vertical}} -optional    
	  element create display-type as_item_display_cb__choice_label_orientation -label "Choice Label Orientation" -datatype text -widget select -options {{top top} {left left} {right right} {buttom buttom}} -optional
	  element create display-type as_item_display_cb__allow_multiple_p -label "Allow Multiple?" -datatype text -widget radio -options {{Yes t} {No f}} -value t -optional
	  element create display-type as_item_display_cb__sort_order -label "Sort Order" -datatype text -widget select -options {{numerical numerical} {alphabetic alphabetic} {randomized randomized} {{by order of entry} {by order of entry}}} -optional
	  element create display-type as_item_display_cb__item_answer_alignment -label "Answer Alignment" -datatype text -widget select -options {{{beside left} beside_left} {{beside right} beside_right} {bellow bellow} {above above}} -optional	  
     }
    
    "select" {
        element set_properties display-type as_item_display_type__name -value "Select Box"
	element create display-type as_item_display_sb__acs_widget -datatype text -widget hidden -value "select"  
        element create display-type as_item_display_sb__sort_order -label "Sort Order" -datatype text -widget select -options {{numerical numerical} {alphabetic alphabetic} {randomized randomized} {{by order of entry} {by order of entry}}} -optional
        element create display-type as_item_display_sb__allow_multiple_p -label "Allow Multiple?" -datatype text -widget radio -options {{Yes t} {No f}} -value f -optional
	element create display-type as_item_display_sb__item_answer_alignment -label "Answer Alignment" -datatype text -widget select -options {{{beside left} beside_left} {{beside right} beside_right} {bellow bellow} {above above}} -optional	  
    }
    
    "imagemap" {
        element set_properties display-type as_item_display_type__name -value "Image map"
        element create display-type as_item_display_im__allow_multiple_p -label "Allow Multiple?" -datatype text -widget radio -options {{Yes t} {No f}} -value f -optional
	element create display-type as_item_display_im__item_answer_alignment -label "Answer Alignment" -datatype text -widget select -options {{{beside left} beside_left} {{beside right} beside_right} {bellow bellow} {above above}} -optional	 
    }
    
    "multiplechoice" {
        element set_properties display-type as_item_display_type__name -value "MultipleChoice" 
	element create display-type widget_choice -label "Widget Choice" -datatype text -widget select -options {{select select} {radio radio} {checkbox checkbox}} -optional
	element create display-type sort_order -label "Sort Order" -datatype text -widget select -options {{numerical numerical} {alphabetic alphabetic} {randomized randomized} {{by order of entry} {by order of entry}}} -optional
	element create display-type other_size -label "Other Size" -datatype text -html {size 15}
	element create display-type other_label -label "Other Label" -datatype text -html {size 59}
	element create display-type item_answer_alignment -label "Answer Alignment" -datatype text -widget select -options {{{beside left} beside_left} {{beside right} beside_right} {bellow bellow} {above above}} -optional 
    }
    
    "pop-up_date" {
        element set_properties display-type as_item_display_type__name -value "Pop Up Date" 
        element create display-type pop-up_date -label "Date"  -datatype date -widget date -format "MONTH DD YYYY" -today -help         
    }
    
    "typed_date" {
        element set_properties display-type as_item_display_type__name -value "Typed Date" 
        element create display-type typed_date -label "Date" -datatype date -widget date -format "MMt/DDt/YYYYt" -today -help         
    }
    
    "file_upload" {
        element set_properties display-type as_item_display_type__name -value "File Upload" 
	element create display-type file_upload -label "File" -datatype text -widget file
    }
    
}






ad_return_template
  
