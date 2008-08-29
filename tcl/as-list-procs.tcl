# packages/assessment/tcl/as-list-procs.tcl

ad_library {
    
    
    
    @author Roel Canicula (roel@solutiongrove.com)
    @creation-date 2006-05-11
    @arch-tag: 90a004d7-68d3-44e7-b987-34cc4fcfc66c
    @cvs-id $Id$
}

namespace eval as::list {
    
    ad_proc -public params {
    } {
	Check form vars for assessment item submits
	
	@author Roel Canicula (roel@solutiongrove.com)
	@creation-date 2006-05-12
	
	@return 
	
	@error 
    } {
	# Process search items
	set paramlist [list]
	if { [set form [rp_getform]] ne "" } {
	    array set formarr [util_ns_set_to_list -set $form]
	    set paramlist [list]
	    
	    foreach param [array names formarr] {
		if { [regexp -nocase {^as_item_id_(\d+)$} $param match one_item_id] } {
		    lappend paramlist ${param}:multiple
		}
	    }
	}
	return $paramlist
    }

    ad_proc -public as_items {
    } {
	Check form vars for assessment item submits
	
	@author Roel Canicula (roel@solutiongrove.com)
	@creation-date 2006-05-12
	
	@return 
	
	@error 
    } {
	# Process search items
	set as_item_ids [list]
	if { [set form [rp_getform]] ne "" } {
	    array set formarr [util_ns_set_to_list -set $form]
	    set paramlist [list]
	    
	    foreach param [array names formarr] {
		if { [regexp -nocase {^as_item_id_(\d+)$} $param match one_item_id] } {
		    lappend as_item_ids $one_item_id
		}
	    }
	}
	return $as_item_ids
    }
}


ad_proc as::list::set_elements_property {
    {-list_name:required}
    {-element_names:required}
    {-property:required}
    {-value:required}
} {
    Sets a property on multiple list elements
    
    @param list_name Name of the list
    @param element_names List of element names
    @param property Which property to set
    @param value Value to set, all elements in element_names get this value

} {
    foreach name $element_names {
	template::element::set_property \
	    -list_name $list_name \
	    -element_name $name \
	    -property $property \
	    -value $value
    }
}

ad_proc as::list::add_columns {
    {-assessment_ids:required}
    {-list_name:required}
    {-show_columns {}}
    {-element_select 1}
    {-element_from 1}
} {
    Add columns to the list for assessment questions
    All columns will be hidden

    @param assessment_ids List of IDs of the assessments to get the items from

} {
    set elements [list]

    set multirow __as_list_$list_name
    as::list::get_items_multirow \
	-assessment_ids $assessment_ids \
	-multirow $multirow
    
    # don't query the same item more than one
    array set visited_items [list]
    template::multirow foreach $multirow {
	if {![info exists visited_items($item_id)] && $as_item_id == $latest_revision} {
	    set visited_items($item_id) $item_id
	    set title "[regsub -all {<.*?>} $title {}]"
	    lappend elements \
		as_item_id_$item_id [as::list::column_element_spec \
					 -as_item_id $as_item_id \
					 -cr_item_id $item_id \
					 -item_title $title \
					 -hide_p [expr {[lsearch $show_columns as_item_id_$item_id] < 0}] \
					 -element_select $element_select \
					 -element_from $element_from]
	}
    }
    return $elements
}

ad_proc as::list::column_element_spec {
    -as_item_id
    -item_title
    -cr_item_id
    {-hide_p 0}
    {-element_select 1}
    {-element_from 1}
} {
    set item_type [db_string get_item_type {}]
    if {$item_type eq "as_item_type_mc"} {
	# MC
	set select_clause "as_item_id_${cr_item_id}.choice_value as as_item_id_${cr_item_id}"
    } else {
	# Default
	set select_clause "as_item_id_${cr_item_id}.text_answer as as_item_id_${cr_item_id}"			
    }
    set from_clause "left join (select dd.* from as_item_data dd where dd.as_item_cr_item_id = $cr_item_id) as_item_id_$cr_item_id on as_item_id_$cr_item_id.session_id = m.session_id"

    set where_clause " as_item_id_$cr_item_id.session_id = m.session_id"
    set spec [list \
		hide_p $hide_p \
		label $item_title \
		  where_clause ""]
    if {$element_select} {
	lappend spec select_clause $select_clause
    }
    if {$element_from} {
	lappend spec from_clause $from_clause
    }
    if {$element_select || $element_from} {
	lappend spec aggregate none
    }
    return $spec
}


ad_proc as::list::get_filters {
    {-assessment_ids:required}
    {-list_name:required}
} {
    Add assessment items as filters

    @param assessment_ids list of assessment_ids to get the items from
    We only get a question once, if its used in more than one of the assessments
    @param list_name Name of the list

} {

    foreach param [params] {
	upvar $param $param
    }
    
    #get all the items

    set filters [list]

	# we just want the questions that are in all the assessments we received
    set multirow __as_list_$list_name
    as::list::get_items_multirow \
	-assessment_ids $assessment_ids \
	-multirow $multirow

    # don't query the same item more than one
    array set visited_items [list]
    template::multirow foreach $multirow {
	if {![info exists visited_items($item_id)]} {
	    set visited_items($item_id) $item_id
	    set title "[regsub -all {<.*?>} $title {}]"
	    lappend filters as_item_id_$item_id \
		[as::list::filter_spec \
		     -as_item_id $as_item_id \
		     -cr_item_id $item_id \
		     -item_title $title]
	}
    }
    return $filters
}

ad_proc as::list::filter_spec {
    {-as_item_id:required}
    {-cr_item_id:required}
    {-item_title:required}
} {
    Generate list builder filter spec from one assessment question

    @param as_item_id Revision_id of hte question
    @param item_type Type of question
    @param item_title What we display for the filter label for the question
} {

    set item_type [db_string get_item_type {}]
    set type "singleval"

    set spec \
	[list \
	     label "'$item_title'"]
    if { $item_type eq "as_item_type_mc" } {
	lappend spec type "multival"
	set values [concat [list [list "--" ""]] [db_list_of_lists item_choices {}]]
	set i 0 
	foreach l $values {
	    if {[string length [lindex $l 0]] > 21} {
		set values [lreplace $values $i $i [list "[string range [lindex $l 0] 0 21]..." [lindex $l 1]]]		
	    }
	    incr i
	}
	lappend spec values $values
	lappend spec null_where_clause " 1=1 "
	lappend spec where_clause_eval "subst \"( ( :as_item_id_$cr_item_id is null and coalesce(trim( from as_item_id_${cr_item_id}.choice_value),'') = '' ) or (:as_item_id_${cr_item_id} is not null and btrim(as_item_id_${cr_item_id}.choice_value) in (\[template::util::tcl_to_sql_list \$as_item_id_${cr_item_id}\]) ) ) and as_item_id_$cr_item_id.session_id = m.session_id\""
	# FIXME Check elements list for this
	
	lappend spec form_element_properties [list widget ajax_list_select options $values]
	lappend spec select_clause "as_item_id_${cr_item_id}.choice_value as as_item_id_${cr_item_id}"				
    } else {
	lappend spec values ""; #[set as_item_id_$cr_item_id]
	lappend spec where_clause "lower(as_item_id_${cr_item_id}.text_answer) like '%'||lower(:as_item_id_$cr_item_id)||'%' 		 and as_item_id_$cr_item_id.session_id = m.session_id"
	# FIXME Check elements list for this
	lappend spec select_clause "as_item_id_${cr_item_id}.text_answer as as_item_id_${cr_item_id}"			
    }
    
    lappend from_clause "left join (select dd.* from as_item_data dd where dd.as_item_cr_item_id = $cr_item_id) as_item_id_$cr_item_id on as_item_id_$cr_item_id.session_id = m.session_id "
    return $spec
}

ad_proc as::list::get_items_multirow {
    -assessment_ids:required
    -multirow
} {
    Creates a multirow of all the items from assessments
    This will only query once per request.

    @param assessment_ids List of assessment ids
    @param multirow name of multirow to create
} {
    if {[template::multirow exists $multirow]} {
	return
    }
    if {[llength $assessment_ids] > 1} {
#	set multiple_assessment_where "where exists (select null from (select m.assessment_id, m.section_id from as_assessment_section_map m where  m.assessment_id in ([template::util::tcl_to_sql_list $assessment_ids])) s2 where s1.section_id=s2.section_id and s1.assessment_id <> s2.assessment_id)"
	set multiple_assessment_where ""
    } else {
	set multiple_assessment_where ""
    }
    array set visited_sections [list]
    foreach section [db_list_of_lists sections {}] {
	set option_section_title [lindex $section 0]
	set option_section_id [lindex $section 1]
	if {![info exists visited_sections($option_section_id)]} {
	    db_multirow -append $multirow items {}
	    set visited_sections($option_section_id) $option_section_id
	}
    }
}

ad_proc as::list::get_groupbys {
    -assessment_ids:required
    -list_name:required
} {
    Create values spec for grouping on assessment question columns
} {

    foreach param [params] {
	upvar $param $param
    }
    
    #get all the items

    set groupbys [list]

    # we just want the questions that are in all the assessments we received
    set multirow __as_list_$list_name
    as::list::get_items_multirow \
	-assessment_ids $assessment_ids \
	-multirow $multirow

    # don't query the same item more than one
    array set visited_items [list]
    template::multirow foreach $multirow {
	if {![info exists visited_items($item_id)]} {
	    set visited_items($item_id) $item_id
	    lappend groupbys \
		[as::list::groupby_spec \
		     -as_item_id $as_item_id \
		     -cr_item_id $item_id \
		     -item_title $title]
	}
    }
    return $groupbys
}

ad_proc as::list::get_orderbys {
    -assessment_ids:required
    -list_name:required
} {
    Create values spec for ordering on assessment question columns
} {

    foreach param [params] {
	upvar $param $param
    }
    
    #get all the items

    set orderbys [list]

    # we just want the questions that are in all the assessments we received
    set multirow __as_list_$list_name
    as::list::get_items_multirow \
	-assessment_ids $assessment_ids \
	-multirow $multirow

    # don't query the same item more than one
    array set visited_items [list]
    template::multirow foreach $multirow {
	if {![info exists visited_items($item_id)]} {
	    set visited_items($item_id) $item_id
	    lappend orderbys as_item_id_$item_id \
		[as::list::orderby_spec \
		     -as_item_id $as_item_id \
		     -cr_item_id $item_id \
		     -item_title $title]
	}
    }

    return $orderbys
}


ad_proc as::list::groupby_spec {
    {-as_item_id:required}
    {-cr_item_id:required}
    {-item_title:required}
} {
    Generate list builder groupby filter spec from one assessment question

    @param as_item_id Revision_id of hte question
    @param item_type Type of question
    @param item_title What we display for the filter label for the question
} {

    set item_ref as_item_id_$cr_item_id
    return [list $item_title [list [list groupby $item_ref] [list orderby $item_ref]]]
}

ad_proc as::list::orderby_spec {
    {-as_item_id:required}
    {-cr_item_id:required}
    {-item_title:required}
} {
    Generate list builder orderby filter spec from one assessment question

    @param as_item_id Revision_id of hte question
    @param item_type Type of question
    @param item_title What we display for the filter label for the question
} {
    set item_ref as_item_id_$cr_item_id
    return [list orderby ${item_ref}.choice_value]    
}