ad_library {
	assessment -- QTI parser library routines
	@author eperez@it.uc3m.es
	@creation-date 2004-04-16
	@cvs-id $Id$
}

ad_proc -public parse_qti_xml { xmlfile } { Parse a XML QTI file } {
	# Open, read and close the XML file
	set file_id [open $xmlfile r]
	set file_string [read $file_id]
	close $file_id
	
	# Parser
	# XML => DOM document
	dom parse $file_string document
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
				set as_assessments__name [$assessment getAttribute {title}]
				set nodesList [$assessment childNodes]
				set as_assessments__definition "NULL"
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
					}
				}
				# assessment_id
				set as_assessments__assessment_id [expr [db_exec_plsql as_assessments_assessment_id {}] + 1]
				# Insert assessment in the as_assessments table
				db_dml as_assessments_insert {}
				# Section
				set sectionNodes [$assessment selectNodes {section}]
				foreach section $sectionNodes {
					set as_sections__name [$section getAttribute {title}]
					set nodesList [$section childNodes]
					set as_sections__definition "NULL"
					foreach node $nodesList {
						set nodeName [$node nodeName]
						if {$nodeName == "qticomment"} {
							set definitionNodes [$section selectNodes {qticomment/text()}]
							if {[llength $definitionNodes] != 0} {
								set definition [lindex $definitionNodes 0]
								set as_sections__definition [$definition nodeValue]
							}
						}
					}
					set as_sections__section_id [expr [db_exec_plsql as_sections_section_id {}] + 1]
					# Insert section in the as_sections table
					db_dml as_sections_insert {}
					# Relation between as_sections and as_assessments
					db_dml as_assessment_section_map_insert {}
					# Process the items
					parse_item $section $as_sections__section_id
				}
			}
		} else {
			# Just items (no assessments)
			parse_item $questestinterop 0
		}
	}
}

ad_proc -private parse_item { qtiNode section_id} { Parse items from a XML QTI file } {
	set itemNodes [$qtiNode selectNodes {item}]
	foreach item $itemNodes {
		# items are OACS objects
		set item_id [db_nextval acs_object_id_seq]
		# Order of the item_choices (as_item_choice_map)
		set sort_order 0
		set as_items__name [$item getAttribute {title}]
		set objectivesNodes [$item selectNodes {objectives}]
		foreach objectives $objectivesNodes {
			set mattextNodes [$objectives selectNodes {material/mattext/text()}]
			foreach mattext $mattextNodes {
				set as_items__name [$mattext nodeValue]
			}
		}
		set presentationNodes [$item selectNodes {presentation}]
		foreach presentation $presentationNodes {
			set nodeNodes [$presentation selectNodes {.//material}]
			set node [lindex $nodeNodes 0]
			# Initialize in case it doen't exist
			set as_items__item_text {}
			if {[$node nodeName] == {material}} {
				set mattextNodes [$node selectNodes {mattext/text()}]
				set mattext [lindex $mattextNodes 0]
				set as_items__item_text [$mattext nodeValue]
			}
			set render_fibNodes [$presentation selectNodes {.//render_fib}]
			if {[llength $render_fibNodes] > 0} {
				# fillinblank or shortanswer
				set render_fib [lindex $render_fibNodes 0]
				# fillinblank (textbox)
				# this is the default
				set as_item__display_type_id 4
				if {[$render_fib hasAttribute {rows}]} {
					# shortanswer (textarea)
					set as_item__display_type_id 1
				}
				db_dml as_item_insert {}
				foreach node $nodeNodes {
					if {[$node nodeName] == {material}} {
						set mattextNodes [$node selectNodes {mattext/text()}]
						set mattext [lindex $mattextNodes 0]
						set as_item_choices__choice_text [$mattext nodeValue]
						set choice_id [db_nextval acs_object_id_seq]
						db_dml as_item_choice_insert {}
						db_dml as_item_choice_map_insert {}
						# order of the item_choices
						incr sort_order
					}
				}
			} else {
				set response_lidNodes [$presentation selectNodes {.//response_lid}]
				# The first node of the list. It may not be a good idea if it doesn't exist
				set response_lid [lindex $response_lidNodes 0]
				set as_items__rcardinality [$response_lid getAttribute {rcardinality} {}]
				# multiple choice either text (remember it can be internationalized or changed), images, sounds, videos
				# this is the default
				set as_item__display_type_id 2
				if {$as_items__rcardinality == {Multiple}} {
					# multiple response either text (remember it can be internationalized or changed), images, sounds, videos
					set as_item__display_type_id 3
				}
				db_dml as_item_insert {}
				set response_labelNodes [$presentation selectNodes {.//response_label}]
				foreach response_label $response_labelNodes {
					set mattextNodes [$response_label selectNodes {material/mattext/text()}]
					set as_item_choices__choice_text [db_null]
					foreach mattext $mattextNodes {
						set as_item_choices__choice_text [$mattext nodeValue]
					}
					set choice_id [db_nextval acs_object_id_seq]
					db_dml as_item_choice_insert {}
					db_dml as_item_choice_map_insert {}
					# order of the item_choices
					incr sort_order
				}
			}
		}
		# Relation between as_items and as_sections
		if {$section_id != 0} {
			db_dml as_item_section_map_insert {}
		}
	}
}
