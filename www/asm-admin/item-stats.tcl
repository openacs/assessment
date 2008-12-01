# packages/assessment/www/asm-admin/item-stats.tcl

ad_page_contract {
    
    Item statistics
    
    @author Roel Canicula (roel@solutiongrove.com)
    @creation-date 2006-06-06
    @arch-tag: 5b26edbe-3bed-464a-b76c-3bf4d0b6ab3c
    @cvs-id $Id$
} {
    assessment_id:integer,optional
    assessment_id_list:optional
    return_url:notnull
    as_item_id:integer,notnull,optional
    section_id:integer,optional
    catalog_section_id:integer,optional
    session_id_list:optional
} -properties {
} -validate {
} -errors {
}

set package_id [ad_conn package_id]

# HAM : 
# if we get a dotlrn_ecommerce_section_id (catalog_section_id),
#  let's create a clause to query all the rel_ids with type membership_rels
set limit_to_section_clause ""
if { [exists_and_not_null catalog_section_id] } {
	set limit_to_section_clause "(select session_id from dotlrn_ecommerce_application_assessment_map where rel_id in (select rel_id from acs_rels where rel_type='dotlrn_member_rel' and object_id_one = (select community_id from dotlrn_ecommerce_section where section_id=:catalog_section_id)))"	
}

 if {[info exists session_id_list]} {
     set session_ids $session_id_list
     set session_id_list [list]
     foreach elm [split $session_id_list] {
 	if {$elm ne ""} {
 	    lappend session_id_list $elm
 	}
     }
 }
#if {[info exists session_id_list]} {
#    set session_id_list [split $session_id_list]
#}
permission::require_permission -object_id $package_id -privilege create
template::multirow create items item_id revision_id title data_type display_type stats section_id section_title
if {[info exists assessment_id_list]} {
    set assessment_id_list [db_list get_assessment_id_list "select distinct item_id from cr_revisions where revision_id in ([template::util::tcl_to_sql_list [split $assessment_id_list]])"]
}
if {![info exists assessment_id] && [info exists assessment_id_list] && [llength $assessment_id_list]} {
    set assessment_id [lindex $assessment_id_list 0]
} else {
    set assessment_id_list [list $assessment_id]
}
#ad_return_complaint 1 "'${assessment_id}' '${assessment_id_list}'"
as::assessment::data -assessment_id $assessment_id

db_multirow sections get_sections "
	    select distinct s.section_id, asm.sort_order, cr.title as section_title
    from as_sections s, cr_revisions cr, cr_items ci, as_assessment_section_map asm, cr_items ai
    where ci.item_id = cr.item_id
    and cr.revision_id = s.section_id
    and s.section_id = asm.section_id
    and asm.assessment_id = ai.latest_revision
    and ai.item_id in ([template::util::tcl_to_sql_list $assessment_id_list])
    order by asm.sort_order
	    "
template::multirow foreach sections {
    db_foreach items {
select i.as_item_id, i.subtext, ci.item_id, cr.title, cr.revision_id, cr.content as
       question_text, cr.description, i.field_name,asr.item_id as as_item_id_i,
       ism.required_p, ism.section_id, ism.sort_order,
       ism.max_time_to_complete, ism.points, i.data_type
from as_items i, cr_revisions cr, cr_items ci, as_item_section_map ism, cr_revisions asr
where ci.item_id = cr.item_id
and cr.revision_id = i.as_item_id
and i.as_item_id = ism.as_item_id
and ism.section_id = :section_id
and asr.revision_id = i.as_item_id
order by ism.sort_order
    } {
	set display_type [string range [db_string get_display_type {
	    select o.object_type
	    from acs_objects o, as_item_rels r
	    where r.item_rev_id = :revision_id
	    and r.rel_type = 'as_item_display_rel'
	    and o.object_id = r.target_rev_id
	}] end-1 end]

	set stats ""

	if { $display_type eq "rb" || $display_type eq "cb" || $display_type eq "sb" } {
	    set total_responses 0
	    set total_correct 0
	    set total_choices 0

	    set choices [list]
	    set visited_session_ids [list]

	    set item_choices_limit_session ""
	    if { [exists_and_not_null limit_to_section_clause] } { set item_choices_limit_session "and d.session_id in $limit_to_section_clause" }
if {[exists_and_not_null session_id_list]} {set item_choices_limit_session " and d.session_id in ([template::util::tcl_to_sql_list $session_id_list]) " }
	    set item_choices_query "select r.title as choice_title, c.choice_id, c.correct_answer_p,
			(select count(*)
			 from as_item_data_choices
			 where choice_id = c.choice_id
			 and item_data_id in (select item_data_id
				    from as_item_data d, as_sessions s, cr_revisions a
				    where d.session_id = s.session_id
				    and s.assessment_id = a.revision_id
                                    and s.completed_datetime is not null
                                    and a.item_id = :assessment_id
                                    $item_choices_limit_session)) as choice_responses		
			
			from cr_revisions r, as_item_choices c
			left outer join cr_revisions r2 on (c.content_value = r2.revision_id)		
			where r.revision_id = c.choice_id
			and c.mc_id = (select max(t.as_item_type_id)
				       from as_item_type_mc t, cr_revisions c, as_item_rels r
				       where t.as_item_type_id = r.target_rev_id
				       and r.item_rev_id = :revision_id
				       and r.rel_type = 'as_item_type_rel'
				       and c.revision_id = t.as_item_type_id
				       group by c.title, t.increasing_p, t.allow_negative_p,
				       t.num_correct_answers, t.num_answers)		
			order by c.sort_order"
		
	    db_foreach item_choices $item_choices_query {
		incr total_choices
		lappend choices [list choice_title $choice_title \
				     choice_responses $choice_responses \
				     correct_answer_p [template::util::is_true $correct_answer_p]]
		incr total_responses $choice_responses
		# Review the computation of correct percentage
		if { [template::util::is_true $correct_answer_p] } {
		    incr total_correct $choice_responses
		}
	    }
    
	    set total_responses_limit_session ""
	    if { [exists_and_not_null limit_to_section_clause] } { set total_responses_limit_session "and s.session_id in $limit_to_section_clause" }

if {[exists_and_not_null session_id_list]} {
    set total_responses_limit_session " and s.session_id in ([template::util::tcl_to_sql_list $session_id_list]) "
}
	    set total_responses [db_string count_responses "select count(*) from (select distinct s.session_id from as_sessions s, as_item_data, cr_revisions cr1, cr_revisions cr2 where cr1.revision_id=:revision_id and cr1.item_id=cr2.item_id and as_item_id = cr2.revision_id and s.session_id = as_item_data.session_id and s.completed_datetime is not null $total_responses_limit_session ) d"]

	    if { $total_responses } {
		append stats "<table>\n"
		set first_p 1
		foreach choice $choices {
		    array set r $choice

		    append stats "<tr>"
		    if { $r(correct_answer_p) && $assessment_data(type) ne "survey"} {
			append stats "<td><img src=\"/resources/assessment/correct.gif\"></td>"
		    } else {
			append stats "<td>&nbsp;</td>"
		    }
		    append stats "<td width=250>$r(choice_title):</td><td style='text-align: right; padding-right: 10px'>$r(choice_responses)</td><td style='text-align: right; padding-right: 20px'>[format "%.2f" [expr double($r(choice_responses)) / $total_responses * 100]]%</td>\n"

		    if { $first_p } {
			append stats "
<td rowspan=$total_choices>
<b>[_ assessment.Total_Responses]</b> $total_responses<br>"
			if {$assessment_data(type) ne "survey"} {
			    append stats "
<b>[_ assessment.Total_Correct]</b> $total_correct"
			
			if { $total_correct > 0 } {
			    append stats ", [format "%.2f" [expr double($total_correct) / $total_responses * 100]]%"
			}
			}
			append stats "</td></tr>\n"

			set first_p 0
		    } else {
			append stats "</tr>\n"
		    }
		}
		append stats "</table>\n"
	    } else {
		append stats "[_ assessment.No_responses]"
	    }
	} else {
	    switch $data_type {
                "content_type" -
		"file" -
		"date" -
		"timestamp" -
		"text" -
		"varchar" {
		    set stats "<a href=\"[export_vars -base view-item-responses { item_id {return_url [ad_return_url]} section_id }]\">[_ assessment.View_Responses_1]</a>"
		}
		"boolean" {
		    append stats "<table>\n"
		    db_foreach get_boolean_answers {
			select boolean_answer, count(*) as n_responses
			from as_item_data
			where as_item_id = :revision_id
			group by boolean_answer
			order by boolean_answer
		    } {
			append stats "<tr><td>$boolean_answer: </td><td>$n_responses</td></tr>\n"
		    }
		    append stats "</table>\n"
		}
		"integer" -
		"float" {
		    set stats "<table>\n"

		    set number_answers [list]
		    set total_reponses 0
		    db_foreach get_number_answers {
			select count(*) as n_responses, numeric_answer
			from as_item_data
			where as_item_id = :revision_id
			group by numeric_answer
			order by numeric_answer
		    } {
			lappend number_answers [list numeric_answer $numeric_answer n_responses $n_responses]
			incr total_responses
		    }

		    set first_p 0
		    foreach number_answer $number_answers {
			array set r $number_answer

			append stats "<tr><td>$r(number_answer):</td><td>$r(n_responses)</td></tr>\n"

			if { $first_p } {
			    db_1row get_number_average {
				select avg(numeric_answers) as mean, stddev(numeric_answers) as standard_deviation
				from as_item_data
				where as_item_id = :revision_id
				group by numeric_answers
			    }

			    append stats "
<td rowspan=$total_responses valign=\"middle\">
[_ assessment.Mean] $mean<br>
[_ assessment.Standard_Deviation] $standard_deviation
</td>
"
			    set first_p 0
			}
		    }
		}
	    }
	}
	
	template::multirow append items $item_id $revision_id $title $data_type $display_type $stats $section_id $section_title
    }
}