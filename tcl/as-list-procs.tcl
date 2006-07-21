# packages/assessment/tcl/as-list-procs.tcl

ad_library {
    
    
    
    @author Roel Canicula (roel@solutiongrove.com)
    @creation-date 2006-05-11
    @arch-tag: 90a004d7-68d3-44e7-b987-34cc4fcfc66c
    @cvs-id $Id$
}

namespace eval as::list {

    ad_proc -public filters {
	-assessments
    } {
	Generate filters per question
	
	@author Roel Canicula (roel@solutiongrove.com)
	@creation-date 2006-05-11
	
	@param assessment_ids List of lists of title, assessment_id pairs

	@return 

	@error 
    } {

	set assessment_search_options [list]
	set search_js_array ""
	set list_filters [list]

	foreach param [params] {
	    upvar $param $param
	}

	foreach assessment $assessments {
	    set option_assessment_title [lindex $assessment 0]
	    set option_assessment_id [lindex $assessment 1]
	    lappend assessment_ids $option_assessment_id
	}
	

	# we just want the questions that are in all the assessments we received
	if {[llength $assessments] > 1} {
	    set multiple_assessment_where "where exists (select null from (select m.assessment_id, m.section_id from as_assessment_section_map m where  m.assessment_id in ([template::util::tcl_to_sql_list $assessment_ids])) s2 where s1.section_id=s2.section_id and s1.assessment_id <> s2.assessment_id)"
	} else {
	    set multiple_assessment_where ""
	}
	set section_ids [db_list section_ids "select distinct section_id from (select m.assessment_id, m.section_id from as_assessment_section_map m where m.assessment_id in ([template::util::tcl_to_sql_list $assessment_ids])) s1 $multiple_assessment_where"]	
	if {![llength $section_ids]} {
	    # no sections are common to all assessments
	    return [list list_filters {} assessment_search_options {} search_js_array {}]
	}
	# don't query the same item more than one
	array set visited_items [list]
	foreach section [db_list_of_lists sections "
		select cr.title as option_section_title, s.section_id as option_section_id
		from as_sections s, cr_revisions cr, cr_items ci --, as_assessment_section_map asm
		where ci.item_id = cr.item_id
		and cr.revision_id = s.section_id
		and s.section_id in ([template::util::tcl_to_sql_list $section_ids])
	    "] {
	    set option_section_title [lindex $section 0]
	    set option_section_id [lindex $section 1]
	    db_foreach items {
		select ci.item_id as option_item_id, cr.title as option_item_title, cr.revision_id as option_revision_id
		
		from as_items i, cr_revisions cr, cr_items ci, as_item_section_map ism, cr_revisions asr
		
		where ci.item_id = cr.item_id
		and cr.revision_id = i.as_item_id
		and i.as_item_id = ism.as_item_id
		and ism.section_id = :option_section_id
		and asr.revision_id = i.as_item_id
		
		order by ism.sort_order
	    } {
		if {![info exists visited_items($option_item_id)]} {
		    set visited_items($option_item_id) $option_item_id
		    if { ! [exists_and_not_null assessment_id] } {
			lappend assessment_search_options [list "...... $option_item_title" $option_item_id]
		    } else {
			lappend assessment_search_options [list "... $option_item_title" $option_item_id]
		    }

		    set one_item_type [db_string get_item_type {
			select oi.object_type
			from cr_items i, as_item_rels it, as_item_rels dt, acs_objects oi
			where dt.item_rev_id = it.item_rev_id
			and it.rel_type = 'as_item_type_rel'
			and dt.rel_type = 'as_item_display_rel'
			and oi.object_id = it.target_rev_id
			and i.latest_revision = it.item_rev_id
			and i.item_id = :option_item_id
		    }]

		    set one_item_choices [db_list_of_lists item_choices {
			select r.title, c.choice_id
			
			from cr_revisions r, as_item_choices c
			left outer join cr_revisions r2 on (c.content_value = r2.revision_id)
			
			where r.revision_id = c.choice_id
			and c.mc_id = (select max(t.as_item_type_id)
				       from as_item_type_mc t, cr_revisions c, as_item_rels r
				       where t.as_item_type_id = r.target_rev_id
				       and r.item_rev_id = :option_revision_id
				       and r.rel_type = 'as_item_type_rel'
				       and c.revision_id = t.as_item_type_id
				       group by c.title, t.increasing_p, t.allow_negative_p,
				       t.num_correct_answers, t.num_answers)
			
			order by c.sort_order
		    }]

		    append search_js_array "searchItems\['$option_item_id'\] = '$one_item_type'\n"
		    #####

		    if { $one_item_type eq "as_item_type_mc" } {
			set values $one_item_choices
			set search_clause [subst { 
			    exists (select 1
				    from as_item_data_choices dc
				    where dd.item_data_id = dc.item_data_id
				    and dc.choice_id = :as_item_id_$option_item_id)
			}]
		    } else {
			set values ""; #[set as_item_id_$option_item_id]
			set search_clause "lower(dd.text_answer) like '%'||lower(:as_item_id_$option_item_id)||'%' "
		    }
		    
		    lappend list_filters "as_item_id_$option_item_id" \
			[list \
			     label $option_item_title \
			     values $values \
			     where_clause [subst {
				 (:as_item_id_$option_item_id is null
				  or
				  exists (select 1
					  from as_itemsi ii, as_item_data dd,
					  (select oi.object_type, it.item_rev_id as as_item_id
					   from as_item_rels it, as_item_rels dt, acs_objects oi
					   where dt.item_rev_id = it.item_rev_id
					   and it.rel_type = 'as_item_type_rel'
					   and dt.rel_type = 'as_item_display_rel'
					   and oi.object_id = it.target_rev_id) tt,
					  cr_items ci
					  
					  where ii.item_id = $option_item_id
					  and ii.as_item_id = dd.as_item_id
					  and ii.as_item_id = tt.as_item_id
					  and dd.session_id = m.session_id
					  and ii.as_item_id = ci.latest_revision
					  and $search_clause
					  ))
			     }]]
		}
	    }
	}
    
	ns_log notice  "as_list_filters returning '[list list_filters $list_filters assessment_search_options $assessment_search_options search_js_array $search_js_array]'"
	return [list list_filters $list_filters assessment_search_options $assessment_search_options search_js_array $search_js_array]
    }


    ad_proc -public filters_old {
	-assessment_id
    } {
	Generate filters per question
	
	@author Roel Canicula (roel@solutiongrove.com)
	@creation-date 2006-05-11
	
 	@param assessment_id

	@return 
	
	@error 
    } {
	set assessment_search_options [list]
	set search_js_array ""
	set list_filters [list]

	foreach param [params] {
	    upvar $param $param
	}

	if { [exists_and_not_null assessment_id] } {
	    set as_clause { and a.assessment_id = :assessment_id }
	} else {
	    set as_clause ""
	}
	
	set assessments [db_list_of_lists assessments [subst {
	    select distinct a.title, a.assessment_id
	    from dotlrn_ecommerce_section s, dotlrn_catalogi c, as_assessmentsi a, cr_items i
	    where s.course_id = c.item_id
	    and c.assessment_id = a.item_id
	    and a.assessment_id = i.latest_revision
	    $as_clause
	}]]

	foreach assessment $assessments {
	    set option_assessment_title [lindex $assessment 0]
	    set option_assessment_id [lindex $assessment 1]
	    if { ! [exists_and_not_null assessment_id] } {
		lappend assessment_search_options [list "ASSESSMENT: $option_assessment_title" "$option_assessment_id"]
	    }
	    append search_js_array "searchItems\['$option_assessment_id'\] = 'assessment'\n"

	    foreach section [db_list_of_lists sections {
		select cr.title as option_section_title, s.section_id as option_section_id
		from as_sections s, cr_revisions cr, cr_items ci, as_assessment_section_map asm
		where ci.item_id = cr.item_id
		and cr.revision_id = s.section_id
		and s.section_id = asm.section_id
		and asm.assessment_id = :option_assessment_id
		order by asm.sort_order
	    }] {
		set option_section_title [lindex $section 0]
		set option_section_id [lindex $section 1]
		if { ! [exists_and_not_null assessment_id] } {
		    lappend assessment_search_options [list "... SECTION: $option_section_title" "$option_section_id"]
		} else {
		    lappend assessment_search_options [list "SECTION: $option_section_title" "$option_section_id"]
		}
		append search_js_array "searchItems\['$option_section_id'\] = 'section'\n"

		db_foreach items {
		    select ci.item_id as option_item_id, cr.title as option_item_title, cr.revision_id as option_revision_id

		    from as_items i, cr_revisions cr, cr_items ci, as_item_section_map ism, cr_revisions asr

		    where ci.item_id = cr.item_id
		    and cr.revision_id = i.as_item_id
		    and i.as_item_id = ism.as_item_id
		    and ism.section_id = :option_section_id
		    and asr.revision_id = i.as_item_id

		    order by ism.sort_order
		} {
		    if { ! [exists_and_not_null assessment_id] } {
			lappend assessment_search_options [list "...... $option_item_title" $option_item_id]
		    } else {
			lappend assessment_search_options [list "... $option_item_title" $option_item_id]
		    }

		    set one_item_type [db_string get_item_type {
			select oi.object_type
			from cr_items i, as_item_rels it, as_item_rels dt, acs_objects oi
			where dt.item_rev_id = it.item_rev_id
			and it.rel_type = 'as_item_type_rel'
			and dt.rel_type = 'as_item_display_rel'
			and oi.object_id = it.target_rev_id
			and i.latest_revision = it.item_rev_id
			and i.item_id = :option_item_id
		    }]

		    set one_item_choices [db_list_of_lists item_choices {
			select r.title, c.choice_id
			
			from cr_revisions r, as_item_choices c
			left outer join cr_revisions r2 on (c.content_value = r2.revision_id)
			
			where r.revision_id = c.choice_id
			and c.mc_id = (select max(t.as_item_type_id)
				       from as_item_type_mc t, cr_revisions c, as_item_rels r
				       where t.as_item_type_id = r.target_rev_id
				       and r.item_rev_id = :option_revision_id
				       and r.rel_type = 'as_item_type_rel'
				       and c.revision_id = t.as_item_type_id
				       group by c.title, t.increasing_p, t.allow_negative_p,
				       t.num_correct_answers, t.num_answers)
			
			order by c.sort_order
		    }]

		    append search_js_array "searchItems\['$option_item_id'\] = '$one_item_type'\n"

		    if { [lsearch [as::list::as_items] $option_item_id] != -1 } {
			if { $one_item_type eq "as_item_type_mc" } {
			    set values $one_item_choices
			    set search_clause [subst { 
				exists (select 1
					from as_item_data_choices dc
					where dd.item_data_id = dc.item_data_id
					and dc.choice_id = :as_item_id_$option_item_id)
			    }]
			} else {
			    set values [set as_item_id_$option_item_id]
			    set search_clause "lower(dd.text_answer) like '%'||lower(:as_item_id_$option_item_id)||'%' "
			}

			lappend list_filters "as_item_id_$option_item_id" \
			    [list \
				 label $option_item_title \
				 values $values \
				 where_clause [subst {
				     (:as_item_id_$option_item_id is null
				      or
				      exists (select 1
					      from as_itemsi ii, as_item_data dd,
					      (select oi.object_type, it.item_rev_id as as_item_id
					       from as_item_rels it, as_item_rels dt, acs_objects oi
					       where dt.item_rev_id = it.item_rev_id
					       and it.rel_type = 'as_item_type_rel'
					       and dt.rel_type = 'as_item_display_rel'
					       and oi.object_id = it.target_rev_id) tt,
					      cr_items ci
					      
					      where ii.item_id = $option_item_id
					      and ii.as_item_id = dd.as_item_id
					      and ii.as_item_id = tt.as_item_id
					      and dd.session_id = m.session_id
					      and ii.as_item_id = ci.latest_revision
					      and $search_clause
					      ))
				 }]]
		    }
		}
	    }
	}

	return [list list_filters $list_filters assessment_search_options $assessment_search_options search_js_array $search_js_array]
    }
    
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
		    lappend paramlist $param
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