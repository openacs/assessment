ad_library {
	assessment -- QTI parser library routines
	@author eperez@it.uc3m.es
	@creation-date 2004-04-16
	@cvs-id $Id$
}

ad_proc -public parse_qti_xml { xmlfile } { Parse a XML QTI file } {
	set package_id [ad_conn package_id]
	set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

	# Open, read and close the XML file
	set file_id [open $xmlfile r]
	set file_string [read $file_id]
	close $file_id
	set numItems 0
	
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
				# Insert assessment in the CR (and as_assessments table) getting the revision_id (assessment_id)
				set assessment_item_id [content::item::new -parent_id $folder_id -content_type {as_assessments} -name $as_assessments__name -title $as_assessments__definition ]
				set as_assessments__assessment_id [content::revision::new -item_id $assessment_item_id -content_type {as_assessments} -title $as_assessments__definition ]
				
				
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
					# Insert section in the CR (the and the as_sections table) getting the revision_id (section_id)
					set section_item_id [content::item::new -parent_id $folder_id -content_type {as_sections} -name $as_sections__name -title $as_sections__definition ]
					set as_sections__section_id [content::revision::new -item_id $section_item_id -content_type {as_sections} -title $as_sections__definition ]
					# Relation between as_sections and as_assessments
					db_dml as_assessment_section_map_insert {}
					# Process the items
					set numItems [parse_item $section $as_sections__section_id]
				}
			}
		} else {
			# Just items (no assessments)
			set numItems [parse_item $questestinterop 0]
		}
	}
	return $numItems
}

ad_proc -private parse_item { qtiNode section_id} { Parse items from a XML QTI file } {
	set package_id [ad_conn package_id]
	set folder_id [db_string get_folder_id "select folder_id from cr_folders where package_id=:package_id"]

	set itemNodes [$qtiNode selectNodes {item}]
	foreach item $itemNodes {
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
			set as_items__title {}
			if {[$node nodeName] == {material}} {
				set mattextNodes [$node selectNodes {mattext/text()}]
				set mattext [lindex $mattextNodes 0]
				set as_items__title [$mattext nodeValue]
			}
			set render_fibNodes [$presentation selectNodes {.//render_fib}]
			if {[llength $render_fibNodes] > 0} {
				# currently dead code
				if {0 == 1} {
				# fillinblank or shortanswer
				set render_fib [lindex $render_fibNodes 0]
				# fillinblank (textbox)
				# this is the default
				set as_item__display_type_id 4
				if {[$render_fib hasAttribute {rows}]} {
					# shortanswer (textarea)
					set as_item__display_type_id 1
				}
				# Insert as_item in the CR (and as_assessments table) getting the revision_id (as_item_id)
				set item_item_id [content::item::new -parent_id $folder_id -content_type {as_items} -name $as_items__name -title $as_items__title ]
				set as_item_id [content::revision::new -item_id $item_item_id -content_type {as_items} -title $as_items__title ]
				foreach node $nodeNodes {
					if {[$node nodeName] == {material}} {
						set mattextNodes [$node selectNodes {mattext/text()}]
						set mattext [lindex $mattextNodes 0]
						set as_item_choices__choice_text [$mattext nodeValue]
						# Insert as_item_choice in the CR (and as_item_choices table) getting the revision_id (choice_id)
						set as_items_choices__choice_id [content::item::new -parent_id $folder_id -content_type {as_item_choices} -name $as_item_choices__ident -title $as_item_choices__choice_text ]
						set choice_id [content::revision::new -item_id $as_items_choices__choice_id -content_type {as_item_choices} -title $as_item_choices__choice_text ]
						db_dml as_item_choice_map_insert {}
						# order of the item_choices
						incr sort_order
					}
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
				# Insert as_item in the CR (and as_assessments table) getting the revision_id (as_item_id)
				set item_item_id [content::item::new -parent_id $folder_id -content_type {as_items} -name $as_items__name -title $as_items__title ]
				set as_item_id [content::revision::new -item_id $item_item_id -content_type {as_items} -title $as_items__title ]
				set response_labelNodes [$presentation selectNodes {.//response_label}]
				foreach response_label $response_labelNodes {
					set as_item_choices__ident [$response_label getAttribute {ident}]
					set mattextNodes [$response_label selectNodes {material/mattext/text()}]
					set as_item_choices__choice_text [db_null]
					foreach mattext $mattextNodes {
						set as_item_choices__choice_text [$mattext nodeValue]
					}
					# Insert as_item_choice in the CR (and as_item_choices table) getting the revision_id (choice_id)
					set as_items_choices__choice_id [content::item::new -parent_id $folder_id -content_type {as_item_choices} -name $as_item_choices__ident -title $as_item_choices__choice_text ]
					set choice_id [content::revision::new -item_id $as_items_choices__choice_id -content_type {as_item_choices} -title $as_item_choices__choice_text ]
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
	return [llength $itemNodes]
}
