# packages/assessment/www/asm-admin/item-stats.tcl

ad_page_contract {
    
    Item statistics
    
    @author Roel Canicula (roel@solutiongrove.com)
    @creation-date 2006-06-06
    @arch-tag: 5b26edbe-3bed-464a-b76c-3bf4d0b6ab3c
    @cvs-id $Id$
} {
    assessment_id:integer,notnull
    return_url:notnull
} -properties {
} -validate {
} -errors {
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
template::multirow create items item_id revision_id title data_type display_type stats

foreach section_id [db_list sections {
    select s.section_id
    from as_sections s, cr_revisions cr, cr_items ci, as_assessment_section_map asm, cr_items ai
    where ci.item_id = cr.item_id
    and cr.revision_id = s.section_id
    and s.section_id = asm.section_id
    and asm.assessment_id = ai.latest_revision
    and ai.item_id = :assessment_id
    order by asm.sort_order
}] {
    db_foreach items {
	select ci.item_id, cr.title, cr.revision_id, i.data_type

	from as_items i, cr_revisions cr, cr_items ci, as_item_section_map ism

	where ci.latest_revision = cr.revision_id
	and cr.revision_id = i.as_item_id
	and i.as_item_id = ism.as_item_id
	and ism.section_id = :section_id

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

	if { $display_type eq "rb" || $display_type eq "cb" } {
	    set total_responses 0
	    set total_correct 0
	    set total_choices 0

	    set choices [list]
	    db_foreach item_choices {
		select r.title as choice_title, c.choice_id, c.correct_answer_p,
		(select count(*)
		 from as_item_data_choices
		 where choice_id = c.choice_id
		 and item_data_id in (select item_data_id
				      from as_item_data d, as_sessions s
				      where d.session_id = s.session_id
				      and s.assessment_id = (select latest_revision
							     from cr_items
							     where item_id = :assessment_id))) as choice_responses		
		
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
		
		order by c.sort_order
	    } {
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

	    append stats "<table>\n"
	    set first_p 1
	    foreach choice $choices {
		array set r $choice

		append stats "<tr>"
		if { $r(correct_answer_p) } {
		    append stats "<td><img src=/resources/assessment/correct.gif /></td>"
		} else {
		    append stats "<td>&nbsp;</td>"
		}
		append stats "<td width=250>$r(choice_title):</td><td style='text-align: right; padding-right: 10px'>$r(choice_responses)</td><td style='text-align: right; padding-right: 20px'>[expr double($r(choice_responses)) / $total_responses * 100]%</td>\n"

		if { $first_p } {
		    append stats "
<td rowspan=$total_choices>
<b>[_ assessment.Total_Responses]</b> $total_responses<br />
<b>[_ assessment.Total_Correct]</b> $total_correct"
		    
		    if { $total_correct > 0 } {
			append stats ", [expr double($total_correct) / $total_responses * 100]%"
		    }
		    append stats "</td></tr>\n"

		    set first_p 0
		} else {
		    append stats "</tr>\n"
		}
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
[_ assessment.Mean] $mean<br />
[_ assessment.Standard_Deviation] $standard_deviation
</td>
"
			    set first_p 0
			}
		    }
		}
	    }
	}
	
	template::multirow append items $item_id $revision_id $title $data_type $display_type $stats
    }
}