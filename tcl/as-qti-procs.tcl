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
					}
				}
				set show_feedback "all"
				set resprocessNodes [$root selectNodes {/questestinterop/assessment/section/item/resprocessing}]
				set as_assessments__survey_p {f}				
				if { [llength $resprocessNodes] == 0 } {				     
				     set as_assessments__survey_p {t}
				     #if it's a survey don't show feedback
				     set show_feedback "none"				     
				}				
				# Insert assessment in the CR (and as_assessments table) getting the revision_id (assessment_id)
				set as_assessments__assessment_id [as::assessment::new -title $as_assessments__title -description $as_assessments__definition -instructions $as_assessments__instructions -survey_p $as_assessments__survey_p -show_feedback $show_feedback]
				
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
					        }
					}
					# Insert section in the CR (and in the as_sections table) getting the revision_id (section_id)
					set as_sections__section_id [as::section::new -title $as_sections__title -description $as_sections__definition]
					
					set as_sections__points ""
					
					# Relation between as_sections and as_assessments
					db_dml as_assessment_section_map_insert {}
					incr as_assessment_section_map__sort_order
					# Process the items
					as::qti::parse_item $section $as_sections__section_id [file dirname $xmlfile]
					
					#get points from a section
					db_0or1row get_section_points {}
					#update as_assessment_section_map with section points
					db_dml update_as_assessment_section_map {}
				}
			}
		} else {
			# Just items (no assessments)
			as::qti::parse_item $questestinterop 0
		}
	}
	return $as_assessments__assessment_id
}

ad_proc -private as::qti::parse_item {qtiNode section_id basepath} { Parse items from a XML QTI file } {
    set as_item_section_map__sort_order 0
    #get all <item> elements
    set itemNodes [$qtiNode selectNodes {item}]
    foreach item $itemNodes {
	# Order of the item_choices
	set sort_order 0
	set as_items__title [$item getAttribute {title} {Item}]
	array set as_item_choices__correct_answer_p {}
	array set as_item_choices__score {}
	set as_items__points 0
	set as_items__feedback_right {}
	set as_items__feedback_wrong {}
	set as_items__description {}
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
		    set as_item_display_id [as::item_display_ta::new -html_display_options $html]
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
		    set as_item_type_id [as::item_type_oq::new]
		    # if render_fib element has not the attribute rows then it's a fill in blank item
		} else {
		    # textbox
		    set as_item_display_id [as::item_display_tb::new]

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
		set as_item_id [as::item::new -title $as_items__title -feedback_right $as_items__feedback_right -feedback_wrong $as_items__feedback_wrong -points $as_items__points]
		# set the relation between as_items and as_item_type tables
		as::item_rels::new -item_rev_id $as_item_id -target_rev_id $as_item_type_id -type as_item_type_rel
		# set the relation between as_items and as_item_display tables
		as::item_rels::new -item_rev_id $as_item_id -target_rev_id $as_item_display_id -type as_item_display_rel
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
		    set as_item_display_id [as::item_display_cb::new]
		} else {
		    # multiple choice (radiobutton)
		    # insert as_item_display_rb
		    set as_item_display_id [as::item_display_rb::new]
		}

		# insert as_item_type_mc
		set as_item_type_id [as::item_type_mc::new]

		# Insert as_item
		set as_item_id [as::item::new -title $as_items__title -feedback_right $as_items__feedback_right -feedback_wrong $as_items__feedback_wrong -points $as_items__points]

		# set the relation between as_items and as_item_type tables
		as::item_rels::new -item_rev_id $as_item_id -target_rev_id $as_item_type_id -type as_item_type_rel
		# set the relation between as_items and as_item_display tables
		as::item_rels::new -item_rev_id $as_item_id -target_rev_id $as_item_display_id -type as_item_display_rel
		# <response_label> (each choice)
		set response_labelNodes [$presentation selectNodes {.//response_label}]
		foreach response_label $response_labelNodes {
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
			set mediabasepath $basepath
			append mediabasepath {/}
			append mediabasepath [$matmedia getAttribute {uri}]
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
		    as::item_choice::new -mc_id $as_item_type_id -title $as_item_choices__choice_text -sort_order $sort_order -correct_answer_p $as_item_choices__correct_answer_p($as_item_choices__ident) -percent_score $as_item_choices__score($as_item_choices__ident) -content_value $as_item_choices__content_value
		    # order of the item_choices
		    incr sort_order
		}
	    }
	}
	# Relation between as_items and as_sections
	if {$section_id != 0} {
	    db_dml as_item_section_map_insert {}
	    incr as_item_section_map__sort_order
	}
    }
    return 1
}
