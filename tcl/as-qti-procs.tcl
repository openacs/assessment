ad_library {
	assessment -- QTI parser library routines
	@author eperez@it.uc3m.es
	@creation-date 2004-04-16
	@cvs-id $Id$
}

namespace eval as::qti {}

ad_proc -public as::qti::parse_qti_xml { xmlfile } { Parse a XML QTI file } {
	set as_assessments__assessment_id {}

	# set utf-8 system encoding
	encoding system utf-8
	
	# Parser
	# XML => DOM document
	set file_id [open $xmlfile r]
	dom parse -channel $file_id document
	close $file_id
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
						set definitionNodes [$assessment selectNodes {qticomment/text()}]
						if {[llength $definitionNodes] != 0} {
							set definition [lindex $definitionNodes 0]
							set as_assessments__definition [$definition nodeValue]
						}
					} elseif {$nodeName == "objectives"} {
						set definitionNodes [$assessment selectNodes {objectives/material/mattext/text()}]
						if {[llength $definitionNodes] != 0} {
							set definition [lindex $definitionNodes 0]
							set as_assessments__definition [$definition nodeValue]
						}
					#as_assessments.instructions = <rubric>
					} elseif {$nodeName == "rubric"} {
						set instructionNodes [$assessment selectNodes {rubric/material/mattext/text()}]
						if {[llength $instructionNodes] != 0} {
							set instruction [lindex $instructionNodes 0]
							set as_assessments__instructions [$instruction nodeValue]
						}
					#as_assessments.time_for_response = <duration>	
					} elseif {$nodeName == "duration"} {
					        set durationNodes [$assessment selectNodes {duration/text()}]
						if {[llength $durationNodes] != 0} {
							set duration [lindex $durationNodes 0]
							set as_assessments__duration [$duration nodeValue]
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
				set as_assessments__survey_p {f}				
				if { [llength $resprocessNodes] == 0 } {				     
				     set as_assessments__survey_p {t}
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
					 set value [$value nodeValue]
					 					 
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
								   -survey_p $as_assessments__survey_p ]			
				
				# Section
				set sectionNodes [$assessment selectNodes {section}]
				foreach section $sectionNodes {
					set as_assessment_section_map__sort_order 0
					set as_sections__title [$section getAttribute {title} {Section}]
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
							set definitionNodes [$section selectNodes {qticomment/text()}]
							if {[llength $definitionNodes] != 0} {
								set definition [lindex $definitionNodes 0]
								set as_sections__definition [$definition nodeValue]
							}
						} elseif {$nodeName == "objectives"} {
						    set definitionNodes [$section selectNodes {objectives/material/mattext/text()}]
						    if {[llength $definitionNodes] != 0} {
							set definition [lindex $definitionNodes 0]
							set as_sections__definition [$definition nodeValue]
						    }		
						#as_sections.max_time_to_complete = <duration>    				    
					        } elseif {$nodeName == "duration"} {
						    set section_durationNodes [$section selectNodes {duration/text()}]
						    if {[llength $section_durationNodes] != 0} {
							set section_duration [lindex $section_durationNodes 0]
							set as_sections__duration [$section_duration nodeValue]
						    }				
						#as_sections.instructions = <rubric>    		    
					        } elseif {$nodeName == "rubric"} {
						    set section_instructionNodes [$section selectNodes {rubric/material/mattext/text()}]
						    if {[llength $section_instructionNodes] != 0} {
							set section_instruction [lindex $section_instructionNodes 0]
							set as_sections__instructions [$section_instruction nodeValue]
						    }				
						#as_sections.feedback_text = <sectionfeedback>    		        
					        } elseif {$nodeName == "sectionfeedback"} {
						    set sectionfeedbackNodes [$section selectNodes {sectionfeedback/material/mattext/text()}]
						    if {[llength $sectionfeedbackNodes] != 0} {
							set sectionfeedback [lindex $sectionfeedbackNodes 0]
							set as_sections__sectionfeedback [$sectionfeedback nodeValue]
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
					 	set value [$value nodeValue]
					 						 
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
					                             -title $as_sections__title \
								     -description $as_sections__definition \
								     -instructions $as_sections__instructions \
								     -feedback_text $as_sections__sectionfeedback \
								     -max_time_to_complete $as_sections__duration \
								     -num_items $as_sections__num_items \
								     -points $as_sections__points \
								     -display_type_id $display_type_id]
									
					# Relation between as_sections and as_assessments
					db_dml as_assessment_section_map_insert {}
					incr as_assessment_section_map__sort_order
					set as_item_section_map__sort_order 0
					# Process the items
					set as_items [as::qti::parse_item $section [file dirname $xmlfile]]
					# Relation between as_items and as_sections
					foreach as_item_id $as_items {
					    db_dml as_item_section_map_insert {}
					    incr as_item_section_map__sort_order
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
    
    #get all <item> elements
    set itemNodes [$qtiNode selectNodes {item}]
    foreach item $itemNodes {
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
		    set as_items__duration [$duration nodeValue]
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
		set instructionNodes [$item selectNodes {rubric/material/mattext/text()}]
		if {[llength $instructionNodes] != 0} {
		    set instruction [lindex $instructionNodes 0]
		    set as_items__subtext [$instruction nodeValue]
		}
	    }		 	    
	}   
	
	set qtimetadataNodes [$item selectNodes {qtimetadata}]
	if {[llength $qtimetadataNodes] > 0} {
	    #nodes qtimetadatafield
	    set qtimetadatafieldNodes [$qtimetadataNodes selectNodes {qtimetadatafield}]
	    foreach qtimetadatafieldnode $qtimetadatafieldNodes {
                set label [$qtimetadatafieldnode selectNodes {fieldlabel/text()}]
	  	set label [$label nodeValue]
         	set value [$qtimetadatafieldnode selectNodes {fieldentry/text()}]
	 	set value [$value nodeValue]		
					 
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
	 	
	# Order of the item_choices
	set sort_order 0
	set as_items__title [$item getAttribute {title} {Item}]
	array set as_item_choices__correct_answer_p {}
	array set as_item_choices__score {}
	set as_items__points 0
	set as_items__feedback_right {}
	set as_items__feedback_wrong {}	
	# <objectives> 
	set objectivesNodes [$item selectNodes {objectives}]
	foreach objectives $objectivesNodes {
	    set mattextNodes [$objectives selectNodes {material/mattext/text()}]
	    foreach mattext $mattextNodes {
		set as_items__description [$mattext nodeValue]
	    }
	}
	
	# <resprocessing>
	set resprocessingNodes [$item selectNodes {resprocessing}]
	foreach resprocessing $resprocessingNodes {
	    # <respcondition>
	    set respconditionNodes [$resprocessing selectNodes {respcondition}]
	    foreach respcondition $respconditionNodes {
		set scoreNodes [$respcondition selectNodes {conditionvar/varequal/text()}]
		foreach choice $scoreNodes {
		    set choice_id [string trim [$choice nodeValue]]
		}
		if {[info exists choice_id]} {
		    set score 0
		    # get score
		    set scoreNodes [$respcondition selectNodes {setvar/text()}]
		    foreach scorenode $scoreNodes {
			set score [string trim [$scorenode nodeValue]]
			if {$score>0} {
			    set as_item_choices__correct_answer_p($choice_id) {t}
			}
		    }
		    set as_item_choices__score($choice_id) $score
		    incr as_items__points $score
		}
		#<displayfeedback>
		set displayfeedbackNodes [$respcondition selectNodes {displayfeedback}]
		if {[llength $displayfeedbackNodes]>0} {
		    set displayfeedbackelement [lindex $displayfeedbackNodes 0]
		    set displayfeedback__ident [$displayfeedbackelement getAttribute {linkrefid}]
		    # <itemfeedback>
		    set itemfeedbackNodes [$item selectNodes {itemfeedback}]
		    foreach itemfeedback $itemfeedbackNodes {
			# wrong feedback
			if {[string compare [$itemfeedback getAttribute {ident}] $displayfeedback__ident] == 0} {
			    set feedback_textNodes [$itemfeedback selectNodes {.//mattext/text()}]
			    set as_items__feedback_wrong [[lindex $feedback_textNodes 0] nodeValue]
			    # right feedback
			} else {
			    set feedback_textNodes [$itemfeedback selectNodes {.//mattext/text()}]
			    set as_items__feedback_right [[lindex $feedback_textNodes 0] nodeValue]
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
	    if {[$material nodeName] == {material}} {
		set mattextNodes [$material selectNodes {mattext/text()}]
		set mattext [lindex $mattextNodes 0]
		set as_items__title [$mattext nodeValue]		
	    }
	    # <render_fib>
	    set render_fibNodes [$presentation selectNodes {.//render_fib}]
	    if {[llength $render_fibNodes] > 0} {
		set as_items__title {}
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
			    set mattextNodes [$node selectNodes {mattext/text()}]
			    foreach mattext $mattextNodes {
				append as_items__title [ad_quotehtml [$mattext nodeValue]]
				append as_items__title " "
			    }
			}
		    }
		    # insert as_item_type_oq (shortanswer)
		    set as_item_type_id [as::item_type_oq::new \
		                        -default_value $aitoq__default_value \
				        -feedback_text $aitoq__feedback_text]					 
		    # if render_fib element has not the attribute rows then it's a fill in blank item
		} else {
		    # textbox
		    set as_item_display_id [as::item_display_tb::new \
		                           -abs_size $aidtb__abs_size \
					   -item_answer_alignment $aidrb__answer_alignment]

		    # multiple choice
		    set as_item_type_id [as::item_type_mc::new]

		    foreach node $presentationChildNodes {
			if {[$node nodeName] == {material}} {
			    set mattextNodes [$node selectNodes {mattext/text()}]
			    foreach mattext $mattextNodes {
				append as_items__title [ad_quotehtml [$mattext nodeValue]]
				append as_items__title " "
			    }
			} elseif {[$node nodeName] == {response_str} || [$node nodeName] == {response_num} } {
			    set as_item_choices__ident [$node getAttribute {ident}]
			    # get the correct response
			    set as_item_choices__choice_text_nodes [$node selectNodes "//conditionvar/or/varequal\[@respident='$as_item_choices__ident'\]/text()"]
			    set as_item_choices__choice_text {}
			    # get the title of each choice
			    foreach respident $as_item_choices__choice_text_nodes {
				lappend as_item_choices__choice_text [string trim [$respident nodeValue]]
			    }
			    # Insert as_item_choice
			    set as_item_choice_id [as::item_choice::new -mc_id $as_item_type_id -title $as_item_choices__choice_text -sort_order $sort_order]
			    # order of the item_choices
			    incr sort_order
			    append as_items__title " <textbox as_item_choice_id=$as_item_choice_id> "
			}
		    }	
		}
		# Insert as_item
		set as_item_id [as::item::new \
		               -title $as_items__title \
			       -description $as_items__description \
			       -subtext $as_items__subtext \
			       -field_code $as_items__field_code \
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
		lappend as_items $as_item_id
	    } else {
		set response_lidNodes [$presentation selectNodes {.//response_lid}]
		# The first node of the list. It may not be a good idea if it doesn't exist
		set response_lid [lindex $response_lidNodes 0]
		set as_items__rcardinality [$response_lid getAttribute {rcardinality} {Single}]
		
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
		lappend as_items $as_item_id
		# <response_label> (each choice)
		set response_labelNodes [$presentation selectNodes {.//response_label}]
		foreach response_label $response_labelNodes {
		    set selected_p f
		    set as_item_choices__ident [$response_label getAttribute {ident}]
		    set mattextNodes [$response_label selectNodes {material/mattext/text()}]
		    set as_item_choices__choice_text [db_null]
		    # get the title of each choice
		    foreach mattext $mattextNodes {
			set as_item_choices__choice_text [$mattext nodeValue]
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
			set as_item_choices__score($as_item_choices__ident) [expr round(100 * $as_item_choices__score($as_item_choices__ident) / $as_items__points)]
		    } else {
			set as_item_choices__score($as_item_choices__ident) 0
		    }
		    # insert as_item_choice
		    as::item_choice::new \
		                    -mc_id $as_item_type_id \
				    -title $as_item_choices__choice_text \
				    -sort_order $sort_order \
				    -selected_p $selected_p \
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
