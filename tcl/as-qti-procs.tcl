ad_library {
	assessment -- QTI parser library routines
	@author eperez@it.uc3m.es
	@creation-date 2004-04-16
	@cvs-id $Id$
}

namespace eval as::qti {}

ad_proc -public as::qti::parse_qti_xml { xmlfile } { Parse a XML QTI file } {
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
	set questestinteropNodes [$root selectNodes {/questestinterop}]
	foreach questestinterop $questestinteropNodes {
		# Looks for assessments
		set assessmentNodes [$questestinterop selectNodes {assessment}]
		if { [llength $assessmentNodes] > 0 } {
			# There are assessments
			foreach assessment $assessmentNodes {
				set as_assessments__title [$assessment getAttribute {title} {Assessment}]
				set nodesList [$assessment childNodes]
				set as_assessments__definition ""
				set as_assessments__instructions ""
				foreach node $nodesList {
					set nodeName [$node nodeName]
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
					} elseif {$nodeName == "rubric"} {
						set instructionNodes [$assessment selectNodes {rubric/material/mattext/text()}]
						if {[llength $instructionNodes] != 0} {
							set instruction [lindex $instructionNodes 0]
							set as_assessments__instructions [$instruction nodeValue]
						}
					}
				}
				# Insert assessment in the CR (and as_assessments table) getting the revision_id (assessment_id)
				set as_assessments__assessment_id [as::assessment::new -title $as_assessments__title -description $as_assessments__definition -instructions $as_assessments__instructions]
				
				# Section
				set sectionNodes [$assessment selectNodes {section}]
				foreach section $sectionNodes {
					set as_assessment_section_map__sort_order 0
					set as_sections__title [$section getAttribute {title} {Section}]
					set nodesList [$section childNodes]
					set as_sections__definition ""
					foreach node $nodesList {
						set nodeName [$node nodeName]
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
					# Insert section in the CR (the and the as_sections table) getting the revision_id (section_id)
					set as_sections__section_id [as::section::new -title $as_sections__title -description $as_sections__definition]
					
					# Relation between as_sections and as_assessments
					db_dml as_assessment_section_map_insert {}
					incr as_assessment_section_map__sort_order
					# Process the items
					as::qti::parse_item $section $as_sections__section_id [file dirname $xmlfile]
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
	set itemNodes [$qtiNode selectNodes {item}]
	foreach item $itemNodes {
		# Order of the item_choices
		set sort_order 0
		set as_items__title [$item getAttribute {title} {Item}]
		array set as_item_choices__correct_answer_p {}
		array set as_item_choices__score {}
		set as_items__feedback_right {}
		set as_items__feedback_wrong {}
		set as_items__description {}
		set objectivesNodes [$item selectNodes {objectives}]
		foreach objectives $objectivesNodes {
			set mattextNodes [$objectives selectNodes {material/mattext/text()}]
			foreach mattext $mattextNodes {
				set as_items__description [$mattext nodeValue]
			}
		}
		set itemfeedbackNodes [$item selectNodes {itemfeedback}]
		foreach itemfeedback $itemfeedbackNodes {
			if {[regexp displayRight [$itemfeedback getAttribute {ident} {}]]} {
				set feedback_textNodes [$itemfeedback selectNodes {.//mattext/text()}]
				set as_items__feedback_right [[lindex $feedback_textNodes 0] nodeValue]
			}
			if {[regexp displayWrong [$itemfeedback getAttribute {ident} {}]]} {
				set feedback_textNodes [$itemfeedback selectNodes {.//mattext/text()}]
				set as_items__feedback_wrong [[lindex $feedback_textNodes 0] nodeValue]
			}
		}
		set resprocessingNodes [$item selectNodes {resprocessing}]
		foreach resprocessing $resprocessingNodes {
			set respconditionNodes [$resprocessing selectNodes {respcondition}]
			foreach respcondition $respconditionNodes {
				set title [$respcondition getAttribute {title} {Correct}]
				if {$title == {Correct}} {
					set correctNodes [$respcondition selectNodes {conditionvar/and/varequal/text()}]
					foreach correct $correctNodes {
						set as_item_choices__correct_answer_p([string trim [$correct nodeValue]]) {t}
					}
				}
				if {$title == {adjustscore}} {
					set choice {}
					set score {}
					set scoreNodes [$respcondition selectNodes {conditionvar/varequal/text()}]
					foreach correct $scoreNodes {
						set choice [string trim [$correct nodeValue]]
					}
					set scoreNodes [$respcondition selectNodes {setvar[@varname='SCORE']/text()}]
					foreach scorenode $scoreNodes {
						set score [string trim [$scorenode nodeValue]]
					}
					set as_item_choices__score($choice) $score
				}
			}
		}
		set presentationNodes [$item selectNodes {presentation}]
		foreach presentation $presentationNodes {
			set presentationChildNodes [$presentation selectNodes {.//material|.//response_str|.//response_num}]
			set materialNodes [$presentation selectNodes {.//material}]
			set material [lindex $materialNodes 0]
			# Initialize in case it doesn't exist
			set as_items__title {}
			if {[$material nodeName] == {material}} {
				set mattextNodes [$material selectNodes {mattext/text()}]
				set mattext [lindex $mattextNodes 0]
				set as_items__title [$mattext nodeValue]
			}
			set render_fibNodes [$presentation selectNodes {.//render_fib}]
			if {[llength $render_fibNodes] > 0} {
				set as_items__title {}
				# fillinblank or shortanswer
				set render_fib [lindex $render_fibNodes 0]
				# fillinblank (textbox)
				# this is the default
				set as_item_display_id {}
				if {[$render_fib hasAttribute {rows}]} {
					# shortanswer (textarea)
					set rows [$render_fib getAttribute {rows} {15}]
					set cols [$render_fib getAttribute {columns} {55}]
					set html "rows $rows cols $cols"					
					set as_item_display_id [as::item_display_ta::new -abs_size $html]
					foreach node $presentationChildNodes {
					if {[$node nodeName] == {material}} {
						set mattextNodes [$node selectNodes {mattext/text()}]
						foreach mattext $mattextNodes {
							append as_items__title [ad_quotehtml [$mattext nodeValue]]
							append as_items__title " "
						}
					}
					}
					set as_item_type_id [as::item_type_oq::new]
				} else {
					set as_item_display_id [as::item_display_tb::new]
				
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
						foreach respident $as_item_choices__choice_text_nodes {
							lappend as_item_choices__choice_text [string trim [$respident nodeValue]]
						}
						# Insert as_item_choice in the CR (and as_item_choices table) getting the revision_id (choice_id)
						set as_item_choice_id [as::item_choice::new -mc_id $as_item_type_id -title $as_item_choices__choice_text -sort_order $sort_order]
						# order of the item_choices
						incr sort_order
						append as_items__title " <textbox as_item_choice_id=$as_item_choice_id> "
					}
				    }	
				}
				# Insert as_item in the CR (and as_items table) getting the revision_id (as_item_id)
				set as_item_id [as::item::new -title $as_items__title -feedback_right $as_items__feedback_right -feedback_wrong $as_items__feedback_wrong]
				content::item::relate -item_id [db_string cr_item_from_revision "select item_id from cr_revisions where revision_id=:as_item_id"] -object_id [db_string cr_item_from_revision "select item_id from cr_revisions where revision_id=:as_item_type_id"] -relation_tag {as_item_type_rel} -relation_type {cr_item_rel}
				content::item::relate -item_id [db_string cr_item_from_revision "select item_id from cr_revisions where revision_id=:as_item_id"] -object_id [db_string cr_item_from_revision "select item_id from cr_revisions where revision_id=:as_item_display_id"] -relation_tag {as_item_display_rel} -relation_type {cr_item_rel}
			} else {
				set response_lidNodes [$presentation selectNodes {.//response_lid}]
				# The first node of the list. It may not be a good idea if it doesn't exist
				set response_lid [lindex $response_lidNodes 0]
				set as_items__rcardinality [$response_lid getAttribute {rcardinality} {Single}]
				
				# multiple choice either text (remember it can be internationalized or changed), images, sounds, videos
				# this is the default
				set as_item_display_id {}
				if {$as_items__rcardinality == {Multiple}} {
					# multiple response either text (remember it can be internationalized or changed), images, sounds, videos
					set as_item_display_id [as::item_display_cb::new]
				} else {
					set as_item_display_id [as::item_display_rb::new]
				}
				set as_item_type_id [as::item_type_mc::new]
				# Insert as_item in the CR (and as_items table) getting the revision_id (as_item_id)
				set as_item_id [as::item::new -title $as_items__title -feedback_right $as_items__feedback_right -feedback_wrong $as_items__feedback_wrong]
				content::item::relate -item_id [db_string cr_item_from_revision "select item_id from cr_revisions where revision_id=:as_item_id"] -object_id [db_string cr_item_from_revision "select item_id from cr_revisions where revision_id=:as_item_type_id"] -relation_tag {as_item_type_rel} -relation_type {cr_item_rel}
				content::item::relate -item_id [db_string cr_item_from_revision "select item_id from cr_revisions where revision_id=:as_item_id"] -object_id [db_string cr_item_from_revision "select item_id from cr_revisions where revision_id=:as_item_display_id"] -relation_tag {as_item_display_rel} -relation_type {cr_item_rel}
				set response_labelNodes [$presentation selectNodes {.//response_label}]
				foreach response_label $response_labelNodes {
					set as_item_choices__ident [$response_label getAttribute {ident}]
					set mattextNodes [$response_label selectNodes {material/mattext/text()}]
					set as_item_choices__choice_text [db_null]
					foreach mattext $mattextNodes {
						set as_item_choices__choice_text [$mattext nodeValue]
					}
					set matmediaNodes [$response_label selectNodes {material/matimage[@uri]}]
					set as_item_choices__content_value [db_null]
					foreach matmedia $matmediaNodes {
						set mediabasepath $basepath
						append mediabasepath {/}
						append mediabasepath [$matmedia getAttribute {uri}]
						set as_item_choices__content_value [as::file::new -file_pathname $mediabasepath]
					}
					# Insert as_item_choice in the CR (and as_item_choices table) getting the revision_id (choice_id)
					set as_item_choices__correct_answer_p($as_item_choices__ident) [expr [info exists as_item_choices__correct_answer_p($as_item_choices__ident)]?{t}:{f}]
					if {![info exists as_item_choices__score($as_item_choices__ident)]} {
						set as_item_choices__score($as_item_choices__ident) 0
					}
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
