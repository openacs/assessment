ad_library {
    assessment -- QTI parser library routines
    @author eperez@it.uc3m.es
    @creation-date 2004-04-16
    @cvs-id $Id$
}

namespace eval as::qti {}

ad_proc -public as::qti::register {
    {-tmp_dir:required}
    {-community_id:required}
} {
    Relation with assessment    

} {
    
    if {[regexp -nocase -- {\.zip$} $tmp_dir]} {
	# Generate a random directory name
	set tmpdirectory [ns_tmpnam]
	# Create a temporary directory
	file mkdir $tmpdirectory
	# UNZIP the zip file in the temporary directory
	catch { exec unzip ${tmp_dir} -d $tmpdirectory } outMsg

	set url_assessment {}
	# Read the content of the temporary directory
	foreach file_i [ glob -directory $tmpdirectory *{.xml}  ] {
	    set url_assessment [as::qti::register_xml -xml_file $file_i -community_id $community_id]
	}

	# Delete the temporary directory
	file delete -force $tmpdirectory
    } else {
        set url_assessment [as::qti::register_xml -xml_file $tmp_dir -community_id $community_id]
    }

    return $url_assessment
}

ad_proc -public as::qti::register_xml {
    {-xml_file:required}
    {-community_id:required}
} {
    Relation with assessment of QTI XML files returning the relative url to it

} {
    set assessment_id [as::qti::register_xml_object_id -xml_file $xml_file -community_id $community_id]

    set url_assessment "../../assessment/assessment?assessment_id=$assessment_id"
    
    return $url_assessment
}

ad_proc -public as::qti::register_xml_object_id {
    {-xml_file:required}
    {-community_id:required}
} {
    Relation with assessment of QTI XML files returning the object_id

} {
    # Save the current package_id to restore when the assessment is
    # imported
    set current_package_id [ad_conn package_id]
    # Get the assessment package_id associated with the current
    # community
    # FIXME this is a hack until I figure out how to get the
    # package_id of the assessment of the current community
    ad_conn -set package_id [db_string get_assessment_package_id {select dotlrn_community_applets.package_id from dotlrn_community_applets join apm_packages on (dotlrn_community_applets.package_id=apm_packages.package_id) where community_id = :community_id and package_key='assessment'}]
    
    set assessment_revision_id [as::qti::parse_qti_xml $xml_file]
    content::item::set_live_revision -revision_id $assessment_revision_id
    set assessment_id [db_string items_items_as_item_id "SELECT item_id FROM cr_revisions WHERE revision_id = :assessment_revision_id"]

    # Restore the package_id
    ad_conn -set package_id $current_package_id
    
    return $assessment_id
}

ad_proc -private as::qti::mattext_gethtml { mattextNode } { Get the HTML of a mattext } {
    set texttype [$mattextNode getAttribute {texttype} {text/plain}]
    if { $texttype == "text/html" } {
	return [$mattextNode text]
    } else {
	return [ad_html_text_convert -from text/plain -to text/html -- [$mattextNode text]]
    }
}

ad_proc -public as::qti::parse_qti_xml { xmlfile } { Parse a XML QTI file } {
    set as_assessments__assessment_id {}

    # Parser
    # XML => DOM document
    dom parse [::tDOM::xmlReadFile $xmlfile] document
    # DOM document => DOM root
    $document documentElement root
    # XPath v1.0
    # get all <questestinterop> elements of a XML instance file
    set questestinteropNodes [$root selectNodes {/questestinterop}]
    foreach questestinterop $questestinteropNodes {
	# Looks for assessments
	set assessmentNodes [$questestinterop selectNodes {assessment}]
	if { [llength $assessmentNodes] > 0 } {
	    # There are assessments
	    foreach assessment $assessmentNodes {
		set as_assessments__title [$assessment getAttribute {title} {Assessment}]
		#get assessment's children: section, (qticomment, duration, qtimetadata, objectives, assessmentcontrol, 
		#rubric, presentation_material, outcomes_processing, assessproc_extension, assessfeedback,
		#selection_ordering, reference, sectionref)
		set nodesList [$assessment childNodes]
		set as_assessments__definition ""
		set as_assessments__instructions ""
		set as_assessments__duration ""
		#for each assessment's child
		foreach node $nodesList {
		    set nodeName [$node nodeName]
		    #as_assessmentsx.description = <qticomment> or <objectives>
		    if {$nodeName == "qticomment"} {
			set definitionNodes [$assessment selectNodes {qticomment}]
			if {[llength $definitionNodes] != 0} {
			    set definition [lindex $definitionNodes 0]
			    set as_assessments__definition [as::qti::mattext_gethtml $definition]
			}
		    } elseif {$nodeName == "objectives"} {
			set definitionNodes [$assessment selectNodes {objectives/material/mattext}]
			if {[llength $definitionNodes] != 0} {
			    set definition [lindex $definitionNodes 0]
			    set as_assessments__definition [as::qti::mattext_gethtml $definition]
			}
			#as_assessments.instructions = <rubric>
		    } elseif {$nodeName == "rubric"} {
			set instructionNodes [$assessment selectNodes {rubric/material/mattext}]
			if {[llength $instructionNodes] != 0} {
			    set instruction [lindex $instructionNodes 0]
			    set as_assessments__instructions [as::qti::mattext_gethtml $instruction]
			}
			#as_assessments.time_for_response = <duration>	
		    } elseif {$nodeName == "duration"} {
			set durationNodes [$assessment selectNodes {duration/text()}]
			if {[llength $durationNodes] != 0} {
			    set duration [lindex $durationNodes 0]
			    set as_assessments__duration [as::qti::duration [$duration nodeValue]]
			}
		    } 
		}
		set qtimetadataNodes [$assessment selectNodes {qtimetadata}]
		set as_assessments__run_mode ""
		set as_assessments__anonymous_p f
		set as_assessments__secure_access_p f
		set as_assessments__reuse_responses_p f
		set as_assessments__show_item_name_p f
		set as_assessments__consent_page ""
		set as_assessments__return_url ""
		set as_assessments__start_time ""
		set as_assessments__end_time ""
		set as_assessments__number_tries ""
		set as_assessments__wait_between_tries ""
		set as_assessments__ip_mask ""
		set as_assessments__show_feedback "none"
		set as_assessments__section_navigation "default path"
		
		set itemfeedbacknodes [$root selectNodes {/questestinterop/assessment/section/item/itemfeedback}]
		if { [llength $itemfeedbacknodes] >0} {
		    set as_assessments__show_feedback "all"
		}
		set resprocessNodes [$root selectNodes {/questestinterop/assessment/section/item/resprocessing}]
		set as_assessments__type test			
		if { [llength $resprocessNodes] == 0 } {				     
		    set as_assessments__type survey
		    #if it's a survey don't show feedback
		    set as_assessments__show_feedback "none"				     
		}			
		
		if {[llength $qtimetadataNodes] > 0} {
		    #nodes qtimetadatafield
		    set qtimetadatafieldNodes [$qtimetadataNodes selectNodes {qtimetadatafield}]
		    foreach qtimetadatafieldnode $qtimetadatafieldNodes {
			set label [$qtimetadatafieldnode selectNodes {fieldlabel/text()}]
			set label [$label nodeValue]
			set value [$qtimetadatafieldnode selectNodes {fieldentry/text()}]
			if { $value ne ""} { set value [$value nodeValue] }
			
			switch -exact -- $label {
			    run_mode {
				set as_assessments__run_mode $value					 
			    }
			    anonymous_p {
				set as_assessments__anonymous_p $value					 
			    }
			    secure_access_p {
				set as_assessments__secure_access_p $value				 
			    }
			    reuse_responses_p {
				set as_assessments__reuse_responses_p $value				 
			    }
			    show_item_name_p {
				set as_assessments__show_item_name_p $value				 
			    }
			    consent_page {
				set as_assessments__consent_page $value				 
			    }
			    start_time {
				set as_assessments__start_time $value					 
			    }
			    end_time {
				set as_assessments__end_time $value					 
			    }
			    number_tries {
				set as_assessments__number_tries $value				 
			    }
			    wait_between_tries {
				set as_assessments__wait_between_tries $value				 
			    }
			    ip_mask {
				set as_assessments__ip_mask $value
			    }
			    show_feedback {
				set as_assessments__show_feedback $value
			    }
			    section_navigation {
				set as_assessments__section_navigation $value
			    }
			}
			
		    }				    
		}				
		
		# Insert assessment in the CR (and as_assessments table) getting the revision_id (assessment_id)
		set as_assessments__assessment_id [as::assessment::new \
						       -title $as_assessments__title \
						       -description $as_assessments__definition \
						       -instructions $as_assessments__instructions \
						       -run_mode $as_assessments__run_mode \
						       -anonymous_p $as_assessments__anonymous_p \
						       -secure_access_p $as_assessments__secure_access_p \
						       -reuse_responses_p $as_assessments__reuse_responses_p \
						       -show_item_name_p $as_assessments__show_item_name_p \
						       -consent_page $as_assessments__consent_page \
						       -return_url $as_assessments__return_url \
						       -start_time $as_assessments__start_time \
						       -end_time $as_assessments__end_time \
						       -number_tries $as_assessments__number_tries \
						       -wait_between_tries $as_assessments__wait_between_tries \
						       -time_for_response $as_assessments__duration \
						       -ip_mask $as_assessments__ip_mask \
						       -show_feedback $as_assessments__show_feedback \
						       -section_navigation $as_assessments__section_navigation \
						       -type $as_assessments__type \
						       -package_id [ad_conn package_id]]			
		
		set assessment_item_id [content::revision::item_id -revision_id $as_assessments__assessment_id]
		permission::grant -party_id [ad_conn user_id] -object_id $assessment_item_id -privilege "admin"
		# Section
		set sectionNodes [$assessment selectNodes {section}]
		set as_asmt_sect_map__sort_order 0
		foreach section $sectionNodes {					
		    set as_sections__title [$section getAttribute {title} {Section}]
		    set as_sections__ident [$section getAttribute {ident} {Section}]
		    #get section's children (qticomment, duration, qtimetadata, objectives, sectioncontrol, 
		    #sectionprecondition, sectionpostcondition, rubric, presentation_material, outcomes_processing,
		    #sectionproc_extension, sectionfeedback, selection_ordering, reference, itemref, item, sectionref,
		    #section)
		    set nodesList [$section childNodes]
		    set as_sections__definition ""
		    set as_sections__instructions ""
		    set as_sections__duration ""
		    set as_sections__sectionfeedback ""
		    #for each section's child
		    foreach node $nodesList {
			set nodeName [$node nodeName]
			#as_sectionsx.description = <qticomment> or <objectives>
			if {$nodeName == "qticomment"} {
			    set definitionNodes [$section selectNodes {qticomment}]
			    if {[llength $definitionNodes] != 0} {
				set definition [lindex $definitionNodes 0]
				set as_sections__definition [as::qti::mattext_gethtml $definition]
			    }
			} elseif {$nodeName == "objectives"} {
			    set definitionNodes [$section selectNodes {objectives/material/mattext}]
			    if {[llength $definitionNodes] != 0} {
				set definition [lindex $definitionNodes 0]
				set as_sections__definition [as::qti::mattext_gethtml $definition]
			    }		
			    #as_sections.max_time_to_complete = <duration>    				    
			} elseif {$nodeName == "duration"} {
			    set section_durationNodes [$section selectNodes {duration/text()}]
			    if {[llength $section_durationNodes] != 0} {
				set section_duration [lindex $section_durationNodes 0]
				set as_sections__duration [as::qti::duration [$section_duration nodeValue]]
			    }				
			    #as_sections.instructions = <rubric>    		    
			} elseif {$nodeName == "rubric"} {
			    set section_instructionNodes [$section selectNodes {rubric/material/mattext}]
			    if {[llength $section_instructionNodes] != 0} {
				set section_instruction [lindex $section_instructionNodes 0]
				set as_sections__instructions [as::qti::mattext_gethtml $section_instruction]
			    }				
			    #as_sections.feedback_text = <sectionfeedback>    		        
			} elseif {$nodeName == "sectionfeedback"} {
			    set sectionfeedbackNodes [$section selectNodes {sectionfeedback/material/mattext}]
			    if {[llength $sectionfeedbackNodes] != 0} {
				set sectionfeedback [lindex $sectionfeedbackNodes 0]
				set as_sections__sectionfeedback [as::qti::mattext_gethtml $sectionfeedback]
			    }				
			} 							
		    }
		    
		    set qtimetadataNodes [$section selectNodes {qtimetadata}]
		    set as_sections__num_items ""
		    set as_sections__points ""
		    set asdt__display_type none
		    set asdt__s_num_items ""
		    set asdt__adp_chunk ""
		    set asdt__branched_p f
		    set asdt__back_button_p t
		    set asdt__submit_answer_p f
		    set asdt__sort_order_type order_of_entry
		    
		    if {[llength $qtimetadataNodes] > 0} {
			#nodes qtimetadatafield
			set qtimetadatafieldNodes [$qtimetadataNodes selectNodes {qtimetadatafield}]
			foreach qtimetadatafieldnode $qtimetadatafieldNodes {
			    set label [$qtimetadatafieldnode selectNodes {fieldlabel/text()}]
			    set label [$label nodeValue]
			    set value [$qtimetadatafieldnode selectNodes {fieldentry/text()}]
			    if { $value ne ""} { set value [$value nodeValue] }
			    
			    switch -exact -- $label {
				num_items {
				    set as_sections__num_items $value			
				}
				points {
				    set as_sections__points $value
				}
				display_type {
				    set asdt__display_type $value
				}
				s_num_items {
				    set asdt__s_num_items $value 
				}
				adp_chunk {
				    set asdt__adp_chunk $value 
				}	
				branched_p {
				    set asdt__branched_p $value				
				}
				back_button_p {
				    set asdt__back_button_p $value
				}
				submit_answer_p {
				    set asdt__submit_answer_p $value
				}
				sort_order_type {
				    set asdt__sort_order_type $value
				}				     
			    }   
			}					 
		    }	
		    
		    #section display type
		    set display_type_id [as::section_display::new \
					     -title $asdt__display_type \
					     -num_items $asdt__s_num_items \
					     -adp_chunk $asdt__adp_chunk \
					     -branched_p $asdt__branched_p \
					     -back_button_p $asdt__back_button_p \
					     -submit_answer_p $asdt__submit_answer_p \
					     -sort_order_type $asdt__sort_order_type]
		    # Insert section in the CR (and in the as_sections table) getting the revision_id (section_id)
		    set section_id [as::section::new \
					-name $as_sections__ident \
					-title $as_sections__title \
					-description $as_sections__definition \
					-instructions $as_sections__instructions \
					-feedback_text $as_sections__sectionfeedback \
					-max_time_to_complete $as_sections__duration \
					-num_items $as_sections__num_items \
					-points $as_sections__points \
					-display_type_id $display_type_id]
		    
		    # Relation between as_sections and as_assessments
ns_log debug "
DB --------------------------------------------------------------------------------
DB DAVE debugging procedure as::qti::parse_qti_xml
DB --------------------------------------------------------------------------------

DB --------------------------------------------------------------------------------"
		    db_dml as_assessment_section_map_insert {}
		    incr as_asmt_sect_map__sort_order
		    set as_item_sect_map__sort_order 0
		    # Process the items
		    set as_items [as::qti::parse_item $section [file dirname $xmlfile]]
		    # Relation between as_items and as_sections
		    foreach as_item_list $as_items {
			array set as_item $as_item_list
			set as_item_id $as_item(as_item_id)
			set as_item__duration $as_item(duration)
			set as_item__points [expr int($as_item(points))]
			set as_item__required_p $as_item(required_p)
			db_dml as_item_section_map_insert {}
			incr as_item_sect_map__sort_order
		    }
		    
		    #get points from a section
		    db_0or1row get_section_points {}
		    #update as_assessment_section_map with section points
		    db_dml update_as_assessment_section_map {}
		}
	    }
	} else {
	    # Just items (no assessments)
	    as::qti::parse_item $questestinterop [file dirname $xmlfile]]
    }
}
return $as_assessments__assessment_id
}

ad_proc -private as::qti::parse_item {qtiNode basepath} { Parse items from a XML QTI file } {

    #get all <item> elements
    set itemNodes [$qtiNode selectNodes {item}]
    foreach item $itemNodes {
	set as_items__ident ""
	set as_items__description ""
	set as_items__subtext ""
	set as_items__field_code ""
	set as_items__required_p t
	set as_items__data_type "varchar"   
	set as_items__duration ""
	set aitmc__increasing_p f
	set aitmc__allow_negative_p f
	set aitmc__num_correct_answers ""
	set aitmc__num_answers ""
	set aitoq__default_value ""
	set aitoq__feedback_text ""
	set aidrb__html_options ""
	set aidrb__choice_orientation "vertical"
	set aidrb__label_orientation "top"
	set aidrb__order_type "order_of_entry"
	set aidrb__answer_alignment "besideright"
	set aidta__abs_size 1000
	set aidtb__abs_size 20
    
        #item's child
        set nodesList [$item childNodes]        
        #for each item's child
        foreach node $nodesList {
            set nodeName [$node nodeName]
            #as_items.max_time_to_complete = <duration> 
            if {$nodeName == "duration"} {
                set durationNodes [$item selectNodes {duration/text()}]
                if {[llength $durationNodes] != 0} {
                    set duration [lindex $durationNodes 0]
                    set as_items__duration [as::qti::duration [$duration nodeValue]]
                }
                #as_items.description = <qticomment>    
            } elseif {$nodeName == "qticomment"} {
                set qticommentNodes [$item selectNodes {qticomment/text()}]
                if {[llength $qticommentNodes] != 0} {
                    set qticomment [lindex $qticommentNodes 0]
                    set as_items__description [$qticomment nodeValue]
                }
                #as_items.subtext = <rubric>
            } elseif {$nodeName == "rubric"} {
                set instructionNodes [$item selectNodes {rubric/material/mattext}]
                if {[llength $instructionNodes] != 0} {
                    set instruction [lindex $instructionNodes 0]
                    set as_items__subtext [as::qti::mattext_gethtml $instruction]
                }
            }                       
        }   
        
        set itemmetadataNodes [$item selectNodes {itemmetadata}]

        if { [llength $itemmetadataNodes] > 0 } {

            set qtimetadataNodes [$itemmetadataNodes selectNodes {qtimetadata}]
            if {[llength $qtimetadataNodes] > 0} {
                #nodes qtimetadatafield
                set qtimetadatafieldNodes [$qtimetadataNodes selectNodes {qtimetadatafield}]
                foreach qtimetadatafieldnode $qtimetadatafieldNodes {
                    set label [$qtimetadatafieldnode selectNodes {fieldlabel/text()}]
                    set label [$label nodeValue]
                    set value [$qtimetadatafieldnode selectNodes {fieldentry/text()}]
                    if { $value ne "" } { set value [$value nodeValue] }

                    switch -exact -- $label {
                        field_code {
                            set as_items__field_code $value                     
                        }
                        required_p {
                            set as_items__required_p $value
                        }
                        data_type {
                            set as_items__data_type $value 
                        }
                        increasing_p {
                            set aitmc__increasing_p $value
                        }
                        allow_negative_p {
                            set aitmc__allow_negative_p $value
                        }
                        num_correct_answers {
                            set aitmc__num_correct_answers $value
                        }               
                        num_answers {
                            set aitmc__num_answers $value
                        }       
                        default_value {
                            set aitoq__default_value $value
                        }
                        feedback_text {
                            set aitoq__feedback_text $value
                        }
                        html_display_options {
                            set aidrb__html_options $value
                        }
                        choice_orientation {
                            set aidrb__choice_orientation $value
                        }
                        choice_label_orientation {
                            set aidrb__label_orientation $value
                        }
                        sort_order_type {
                            set aidrb__order_type $value
                        }
                        item_answer_alignment {
                            set aidrb__answer_alignment $value
                        }       
                        abs_size {
                            set aidta__abs_size $value
                        }       
                        tb_abs_size {
                            set aidtb__abs_size $value
                        }                                    
                    }   
                }                                        
            }
        }
        
        # Order of the item_choices
        set sort_order 0
        set as_items__title [$item getAttribute {title} {Item}]
        set as_items__ident [$item getAttribute {ident} {Item}]

        array set as_item_choices__correct_answer_p {}
        array set as_item_choices__score {}
        array set as_item_choices__feedback_text {}
        set as_items__points 0
        set as_items__feedback_right {}
        set as_items__feedback_wrong {} 
        # <objectives> 
        set objectivesNodes [$item selectNodes {objectives}]
        foreach objectives $objectivesNodes {
            set mattextNodes [$objectives selectNodes {material/mattext}]
            foreach mattext $mattextNodes {
                set as_items__description [as::qti::mattext_gethtml $mattext]
            }
        }
        
        # <resprocessing>
        set resprocessingNodes [$item selectNodes {resprocessing}]
        foreach resprocessing $resprocessingNodes {
            # <respcondition>
            set respconditionNodes [$resprocessing selectNodes {respcondition}]
            foreach respcondition $respconditionNodes {
                set resp_cond_varNodes {}
                set scoreNodes [$respcondition selectNodes {conditionvar/varequal/text()}]
                foreach choice $scoreNodes {
                    set choice_id ""
                    set choice_id [string trim [$choice nodeValue]]
                    
                    if {[info exists choice_id]} {
                        set score 0
                        # get score
                        set scoreNodes [$respcondition selectNodes {setvar/text()}]
                        foreach scorenode $scoreNodes {
                            set score [expr int([string trim [$scorenode nodeValue]])]
                            if {$score>0} {
                                set as_item_choices__correct_answer_p($choice_id) {t}
                            }
                        }
                        set as_item_choices__score($choice_id) $score
                        incr as_items__points $score
                    }
                }
                
                set scoreNodes [$respcondition selectNodes {conditionvar/and/varequal/text()}]
                foreach choice $scoreNodes {
                    set choice_id ""
                    set choice_id [string trim [$choice nodeValue]]
                    
                    if {[info exists choice_id]} {
                        set score 0
                        # get score
                        set scoreNodes [$respcondition selectNodes {setvar/text()}]
                        foreach scorenode $scoreNodes {
                            set score [expr int([string trim [$scorenode nodeValue]])]
                            if {$score>0} {
                                set as_item_choices__correct_answer_p($choice_id) {t}
                            }
                        }
                        set scoreNodes1 [$respcondition selectNodes {conditionvar/and/varequal}]
                        if {[llength $scoreNodes1]>0} {
                            set score1 [expr ($score*1.0/[llength $scoreNodes1])]
                        }                   
                        set as_item_choices__score($choice_id) $score1
                        set as_items__points $score                 
                    }
                }
                
                set resp_cond_varNodes [$respcondition selectNodes {conditionvar/varequal/text()}]              
                if {[llength $resp_cond_varNodes]==1} { } else {        
                    set resp_cond_or_varNodes [$respcondition selectNodes {conditionvar/or/not/and/varequal/text() | conditionvar/not/or/varequal/text() | conditionvar/not/and/or/varequal/text()}]
                    if {[llength $resp_cond_or_varNodes]>0} {
                        set displayfeedbackNode [$respcondition selectNodes {displayfeedback}]
                        if {[llength $displayfeedbackNode]>0} {
                            set displayfeedback__ident [$displayfeedbackNode getAttribute {linkrefid}]                  
                            set as_items__feedback_wrong [$item selectNodes "//itemfeedback\[@ident='$displayfeedback__ident'\]/flow_mat/material/mattext"]
                            if {$as_items__feedback_wrong ne ""} {
                                set as_items__feedback_wrong [$as_items__feedback_wrong text]                      
                            }
                        }
                    } else {
                        set resp_cond_and_varNodes [$respcondition selectNodes {conditionvar/and/varequal/text()| conditionvar/or/varequal/text()}]
                        if {[llength $resp_cond_and_varNodes]>0} {                  
                            set displayfeedbackNode [$respcondition selectNodes {displayfeedback}]
                            if {[llength $displayfeedbackNode]>0} {
                                set displayfeedback__ident [$displayfeedbackNode getAttribute {linkrefid}]                          
                                set as_items__feedback_right [$item selectNodes "//itemfeedback\[@ident='$displayfeedback__ident'\]/flow_mat/material/mattext"]
                                if {$as_items__feedback_right ne ""} {
                                    set as_items__feedback_right [$as_items__feedback_right text]                  
                                }       
                            }
                        }
                    }
                }        
            }
        }
        
        # <presentation> element
        set presentationNodes [$item selectNodes {presentation}]
        foreach presentation $presentationNodes {
            # <material> or <response_str> or <response_num> (some presentation's children)
            set presentationChildNodes [$presentation selectNodes {.//material|.//response_str|.//response_num}]
            # <material>
            set materialNodes [$presentation selectNodes {.//material}]
            set material [lindex $materialNodes 0]
            # Initialize in case it doesn't exist
            set as_items__title {}
            if {$material ne "" && [$material nodeName] == {material}} {
                set mattextNodes [$material selectNodes {mattext}]
                set mattext [lindex $mattextNodes 0]
                set as_items__title [as::qti::mattext_gethtml $mattext]
            }
            # <render_fib>
            set render_fibNodes [$presentation selectNodes {.//render_fib}]
            if {[llength $render_fibNodes] > 0} {

                # fillinblank or shortanswer
                set render_fib [lindex $render_fibNodes 0]
                # fillinblank (textbox)
                # this is the default
                set as_item_display_id {}
                #if render_fib element has the attribute rows then we suppose it's a shortanswer item
                if {[$render_fib hasAttribute {rows}]} {
                    # shortanswer (textarea)
                    set rows [$render_fib getAttribute {rows} {15}]
                    set cols [$render_fib getAttribute {columns} {55}]
                    # we need the size of textarea (values of rows and cols)
                    set html "rows $rows cols $cols"
                    # insert as_item_display_ta in the CR (and in the as_item_display_ta table) getting the revision_id (item_display_id)                                       
                    set as_item_display_id [as::item_display_ta::new \
                                                -html_display_options $html \
                                                -abs_size $aidta__abs_size \
                                                -item_answer_alignment $aidrb__answer_alignment]
                    foreach node $presentationChildNodes {
                        # get the title of item
                        if {[$node nodeName] == {material}} {
                            set mattextNodes [$node selectNodes {mattext}]
                            foreach mattext $mattextNodes {
                                set as_items__title [as::qti::mattext_gethtml $mattext]
                                append as_items__title " "
                            }
                        }
                    }
                    # insert as_item_type_oq (textarea)
                    set as_item_type_id [as::item_type_oq::new \
                                             -default_value $aitoq__default_value \
                                             -feedback_text $aitoq__feedback_text]                                       
                    # if render_fib element has not the attribute rows then it's a fill in blank item
                } else {
                    # textbox (shortanswer)
                    set as_item_display_id [as::item_display_tb::new \
                                                -abs_size $aidtb__abs_size \
                                                -item_answer_alignment $aidrb__answer_alignment]
                    set as_item_type_id [as::item_type_sa::new]
                }
                
                # Insert as_item
                set as_item_id [as::item::new \
                                    -title $as_items__title \
                                    -description $as_items__description \
                                    -subtext $as_items__subtext \
                                    -field_code $as_items__field_code \
                                    -field_name $as_items__ident \
                                    -required_p $as_items__required_p \
                                    -data_type $as_items__data_type \
                                    -feedback_right $as_items__feedback_right \
                                    -feedback_wrong $as_items__feedback_wrong \
                                    -max_time_to_complete $as_items__duration \
                                    -points $as_items__points]
                # set the relation between as_items and as_item_type tables
                as::item_rels::new -item_rev_id $as_item_id -target_rev_id $as_item_type_id -type as_item_type_rel
                # set the relation between as_items and as_item_display tables
                as::item_rels::new -item_rev_id $as_item_id -target_rev_id $as_item_display_id -type as_item_display_rel
                set as_item(as_item_id) $as_item_id
                set as_item(points) $as_items__points
                set as_item(duration) $as_items__duration
                set as_item(required_p) $as_items__required_p
                lappend as_items [array get as_item]
            } else {
                set response_lidNodes [$presentation selectNodes {.//response_lid}]
                # The first node of the list. It may not be a good idea if it doesn't exist
                set response_lid [lindex $response_lidNodes 0]
                if { $response_lid ne "" } {
                    set as_items__rcardinality [$response_lid getAttribute {rcardinality} {Single}]
                } else {
                    set as_items__rcardinality ""
                }

                # multiple choice either text (remember it can be internationalized or changed), images, sounds, videos
                # this is the default
                set as_item_display_id {}
                if {$as_items__rcardinality == {Multiple}} {
                    # multiple response (checkbox) either text (remember it can be internationalized or changed), images, sounds, videos
                    # insert as_item_display_cb
                    set as_item_display_id [as::item_display_cb::new \
                                                -html_display_options $aidrb__html_options \
                                                -choice_orientation $aidrb__choice_orientation \
                                                -choice_label_orientation $aidrb__label_orientation \
                                                -sort_order_type $aidrb__order_type \
                                                -item_answer_alignment $aidrb__answer_alignment]
                } else {
                    # multiple choice (radiobutton)
                    # insert as_item_display_rb
                    set as_item_display_id [as::item_display_rb::new \
                                                -html_display_options $aidrb__html_options \
                                                -choice_orientation $aidrb__choice_orientation \
                                                -choice_label_orientation $aidrb__label_orientation \
                                                -sort_order_type $aidrb__order_type \
                                                -item_answer_alignment $aidrb__answer_alignment]
                }
                
                # insert as_item_type_mc
                set as_item_type_id [as::item_type_mc::new \
                                         -increasing_p $aitmc__increasing_p \
                                         -allow_negative_p $aitmc__allow_negative_p \
                                         -num_correct_answers $aitmc__num_correct_answers \
                                         -num_answers $aitmc__num_answers]                         
                
                # Insert as_item
                set as_item_id [as::item::new \
                                    -title $as_items__title \
                                    -description $as_items__description \
                                    -subtext $as_items__subtext \
                                    -field_code $as_items__field_code \
                                    -field_name $as_items__ident \
                                    -required_p $as_items__required_p \
                                    -data_type $as_items__data_type \
                                    -feedback_right $as_items__feedback_right \
                                    -feedback_wrong $as_items__feedback_wrong \
                                    -max_time_to_complete $as_items__duration \
                                    -points $as_items__points]          
                # set the relation between as_items and as_item_type tables
                as::item_rels::new -item_rev_id $as_item_id -target_rev_id $as_item_type_id -type as_item_type_rel
                # set the relation between as_items and as_item_display tables
                as::item_rels::new -item_rev_id $as_item_id -target_rev_id $as_item_display_id -type as_item_display_rel
                set as_item(as_item_id) $as_item_id
                set as_item(points) $as_items__points
                set as_item(duration) $as_items__duration
                set as_item(required_p) $as_items__required_p
                lappend as_items [array get as_item]
                # <response_label> (each choice)
                set response_labelNodes [$presentation selectNodes {.//response_label}]
                foreach response_label $response_labelNodes {
                    set selected_p f
                    set as_item_choices__ident [$response_label getAttribute {ident}]
                    set mattextNodes [$response_label selectNodes {material/mattext}]
                    set as_item_choices__choice_text [db_null]
                    # get the title of each choice
                    foreach mattext $mattextNodes {
                        set as_item_choices__choice_text [as::qti::mattext_gethtml $mattext]
                    }
                    # for multimedia items
                    set matmediaNodes [$response_label selectNodes {material/matimage[@uri]}]
                    set as_item_choices__content_value [db_null]
                    foreach matmedia $matmediaNodes {
                        set mediabasepath [file join $basepath [$matmedia getAttribute {uri}]]
                        # insert as_file in the CR (and in the as_file table) getting the content value
                        set as_item_choices__content_value [as::file::new -file_pathname $mediabasepath]
                    }
                    # Insert as_item_choice
                    set as_item_choices__correct_answer_p($as_item_choices__ident) [expr [info exists as_item_choices__correct_answer_p($as_item_choices__ident)]?{t}:{f}]
                    if {[info exists as_item_choices__score($as_item_choices__ident)]} {
                        if {$as_items__points== 0} {
                            #if <setvar> is missing
                            set as_items__points 1                      
                        }
                        set as_item_choices__score($as_item_choices__ident) [expr round(100 * $as_item_choices__score($as_item_choices__ident) / $as_items__points)]
                    } else {
                        set as_item_choices__score($as_item_choices__ident) 0
                    }
                    set as_item_choices__feedback_text($as_item_choices__ident) ""    
                    
                    set resprocessingNodes [$item selectNodes {resprocessing}]
                    foreach resprocessing $resprocessingNodes {
                        # <respcondition>
                        set respconditionNodes [$resprocessing selectNodes {respcondition}]                 
                        foreach respcondition $respconditionNodes {
                            set displayfeedbackNode ""
                            set resp_cond_varNodes [$respcondition selectNodes {conditionvar/varequal/text()}]
                            if {[llength $resp_cond_varNodes]==1} {                 
                                set displayfeedbackNode [$respcondition selectNodes {displayfeedback}]              
                                set choice_identifier [$resp_cond_varNodes nodeValue]
                                if {[llength $displayfeedbackNode]>0} {
                                    set displayfeedback__ident [$displayfeedbackNode getAttribute {linkrefid}]              
                                    set choice_identifier [$resp_cond_varNodes nodeValue]                       
                                    if {$as_item_choices__ident == $choice_identifier} {                        
                                        set choices__feedback_text [$item selectNodes "//itemfeedback\[@ident='$displayfeedback__ident'\]/flow_mat/material/mattext/text()"]
                                        if {[llength $choices__feedback_text]>0} {
                                            set as_item_choices__feedback_text($as_item_choices__ident) [$choices__feedback_text nodeValue]
                                        }                       
                                    }
                                }  
                            } 
                        }
                    }
                    # insert as_item_choice
                    as::item_choice::new \
                        -mc_id $as_item_type_id \
                        -title $as_item_choices__choice_text \
                        -sort_order $sort_order \
                        -selected_p $selected_p \
                        -feedback_text $as_item_choices__feedback_text($as_item_choices__ident) \
                        -correct_answer_p $as_item_choices__correct_answer_p($as_item_choices__ident) \
                        -percent_score $as_item_choices__score($as_item_choices__ident) \
                        -content_value $as_item_choices__content_value
                    # order of the item_choices
                    incr sort_order
                }
            }
            #import an image as title of item
            set matmediaNodes [$presentation selectNodes {material/matimage[@uri]}]
            if {[llength $matmediaNodes]>0} {                               
                set mediabasepath [file join $basepath [$matmediaNodes getAttribute {uri}]]
                # insert as_file in the CR (and in the as_file table) getting the content value
                set as_item_choices__content_value [as::file::new -file_pathname $mediabasepath]
                as::item_rels::new -item_rev_id $as_item_id -target_rev_id $as_item_choices__content_value -type as_item_content_rel
            }     
        }
    }
    return $as_items
}

ad_proc -public as::qti::duration {
    duration
} {
    Convert duration
    
    @author Roel Canicula (roel@solutiongrove.com)
    @creation-date 2006-05-04
    
    @param duration

    @return 
    
    @error 
} {
    if { [regexp {^\d+$} $duration] } {
	return $duration
    } elseif { [regexp {^p|P$} $duration] } {
	return ""
    } elseif { [regexp {^p|P} $duration] } {
	# check for format P0Y0M0DT0H1M0S
	regexp {t|T(\d+)h|H(\d+)m|M(\d+)s|S} $duration match h m s
	# ignore year, month and days for now
	return [expr $h*3600+$m*60+$s]
    }
}
