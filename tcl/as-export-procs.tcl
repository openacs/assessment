ad_library {
    Export procs
    @author nperper@it.uc3m.es
    @creation-date 2005-02-01
}

namespace eval as::export {}

ad_proc -public as::export::new_element {
    {-value ""}
    {-father ""}
    {-label ""} 
    {-root ""}   
    {-material_p "f"}
    {-attribute_label ""}
    {-attribute_value ""}
} {
    @author Natalia Pérez (nperper@it.uc3m.es)
    @creation-date 2004-02-01

    New element 
} {
    #create a new element named "label" and child of "father", with attribute_label=attribute_value
    if {$value ne ""} {
        set label [$root createElement $label]
        $father appendChild $label
	if {$attribute_label ne ""} {
	    $label setAttribute $attribute_label $attribute_value
	}
	if {$material_p == "t"} {
	    set material [$root createElement material]
            $label appendChild $material
            set mattext [$root createElement mattext]    
	    $mattext setAttribute texttype text/html
            $material appendChild $mattext    
            set text [$root createCDATASection $value]
            $mattext appendChild $text
	} else {
            set text [$root createCDATASection $value]
            $label appendChild $text
	}
    }
}


ad_proc -public as::export::element_qtimetadatafield {
    {-root ""}   
    {-father ""}
    {-label ""} 
    {-value ""}    
} {
    @author Natalia Pérez (nperper@it.uc3m.es)
    @creation-date 2004-02-03

    New element qtimetadatafield
} {
   #create an element <qtimetadatafield><fieldlabel></fieldlabel><fieldentry></fieldentry></qtimetadatafield>
   if {$value ne ""} {
    #<qtimetadatafield>
    set qtimetadatafield [$root createElement qtimetadatafield]
    $father appendChild $qtimetadatafield
    #<fieldlabel>
    set fieldlabel [$root createElement fieldlabel]
    $qtimetadatafield appendChild $fieldlabel
    set text [$root createCDATASection $label]
    $fieldlabel appendChild $text
    #<fieldentry>
    set fieldentry [$root createElement fieldentry]
    $qtimetadatafield appendChild $fieldentry
    set text [$root createCDATASection $value]
    $fieldentry appendChild $text
  }  
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
