ad_page_contract {
    
    This page allows to add branches or actions to the question and its choices.    
   
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @date 2005-01-07
} {
    assessment_id:integer
    section_id
}

as::assessment::data -assessment_id $assessment_id
set new_assessment_revision $assessment_data(assessment_rev_id)


if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set title "$assessment_data(title)"
set context_bar [ad_context_bar [list "one-a?assessment_id=$assessment_id" $title] "$title [_ assessment.Administration]"]

db_multirow aa_checks get_aa_checks {} 

template::list::create \
    -name aa_checks \
    -multirow aa_checks \
    -key inter_item_check_id \
    -bulk_actions {
	"\#assessment.Delete\#" "confirm-delete" "\#assessment.delete_checked\#"
    }\
    -bulk_action_method post \
    -bulk_action_export_vars {
	inter_item_check_id
	assessment_id
	section_id
	{type_check t}
    }\
    -row_pretty_plural "[_ assessment.Assessment] [_ assessment.triggers]" \
    -elements {
	name {
	    label "[_ assessment.Name]"
	    display_template {
		<a href=add-edit-check?assessment_id=$assessment_id&inter_item_check_id=@aa_checks.inter_item_check_id@&edit_check=t><img border=0 src=images/Edit16.gif></a>  @aa_checks.name@
	    }
	}
	action_name {
	    label "[_ assessment.action_to_perform]"
	}
	counter {
	    display_template {    
		<if @aa_checks.order_by@ lt @aa_checks:rowcount@>
		<a href="swap-actions?assessment_id=$assessment_id&check_id=@aa_checks.inter_item_check_id@&order_by=@aa_checks.order_by@&section_id=@aa_checks.section_id_from@&action_perform=@aa_checks.action_perform@&direction=d"><img src="/resources/assessment/down" border="0" alt="#assessment.Move_Down#"></a>
		</if>
		<if @aa_checks.order_by@ gt 1>
		<a href="swap-actions?assessment_id=$assessment_id&check_id=@aa_checks.inter_item_check_id@&order_by=@aa_checks.order_by@&section_id=@aa_checks.section_id_from@&action_perform=@aa_checks.action_perform@&direction=u"><img src="/resources/assessment/up.gif" border="0" alt="#assessment.Move_Up#"></a>
		</if>
		<a href=request-notification?assessment_id=$assessment_id&inter_item_check_id=@aa_checks.inter_item_check_id@&section_id=$section_id>#assessment.notify_user#</a>
		
	    }
	    
	}
    }


db_multirow i_checks  get_i_checks {}
template::list::create \
    -name i_checks \
    -multirow i_checks \
    -key inter_item_check_id \
    -bulk_actions {
	"\#assessment.Delete\#" "confirm-delete" "\#assessment.delete_checked\#"
    }\
    -bulk_action_method post \
    -bulk_action_export_vars {
	inter_item_check_id
	assessment_id
	section_id
	{type_check t}
    }\
    -row_pretty_plural "[_ assessment.Assessment] [_ assessment.triggers]" \
    -elements {
	name {
	    label "[_ assessment.Name]"
	    display_template {
		<a href=add-edit-check?assessment_id=$assessment_id&inter_item_check_id=@i_checks.inter_item_check_id@&edit_check=t><img border=0 src=images/Edit16.gif></a>  @i_checks.name@
	    }
	}
	action_name {
	    label "[_ assessment.action_to_perform]"
	}
	inter_item_check_id {
	    display_template {    
		<if @i_checks.order_by@ lt @i_checks:rowcount@>
		<a href="swap-actions?assessment_id=$assessment_id&check_id=@i_checks.inter_item_check_id@&order_by=@i_checks.order_by@&section_id=@i_checks.section_id_from@&action_perform=@i_checks.action_perform@&direction=d"><img src="/resources/assessment/down.gif" border="0" alt="#assessment.Move_Down#"></a>
		</if>
		<if @i_checks.order_by@ gt 1>
		    <a href="swap-actions?assessment_id=$assessment_id&check_id=@i_checks.inter_item_check_id@&order_by=@i_checks.order_by@&section_id=@i_checks.section_id_from@&action_perform=@i_checks.action_perform@&direction=u"><img src="/resources/assessment/up.gif" border="0" alt="#assessment.Move_Up#"></a>
		</if>
		<a href=request-notification?assessment_id=$assessment_id&inter_item_check_id=@i_checks.inter_item_check_id@&section_id=$section_id>#assessment.notify_user#</a>
	    }
	}
    }



db_multirow m_checks  get_m_checks {}
template::list::create \
    -name m_checks \
    -multirow m_checks \
    -key inter_item_check_id \
    -bulk_actions {
	"\#assessment.Delete\#" "confirm-delete" "\#assessment.delete_checked\#"
    }\
    -bulk_action_method post \
    -bulk_action_export_vars {
	inter_item_check_id
	assessment_id
	section_id
	{type_check t}
    }\
    -row_pretty_plural "[_ assessment.Assessment] [_ assessment.triggers]" \
    -elements {
	name {
	    label "[_ assessment.Name]"
	    display_template {
		<a href=add-edit-check?assessment_id=$assessment_id&inter_item_check_id=@m_checks.inter_item_check_id@&edit_check=t><img border=0 src=images/Edit16.gif></a>  @m_checks.name@
	    }
	}
	action_name {
	    label "[_ assessment.action_to_perform]"
	}
	inter_item_check_id {
	    display_template {
		<a href=request-notification?assessment_id=$assessment_id&inter_item_check_id=@m_checks.inter_item_check_id@&section_id=$section_id>#assessment.notify_user#</a>
	    }
	}
    }

db_multirow branches  get_branches {}
template::list::create \
    -name branches \
    -multirow branches \
    -key inter_item_check_id \
    -bulk_actions {
	"\#assessment.Delete\#" "confirm-delete" "\#assessment.delete_checked\#"
    }\
    -bulk_action_method post \
    -bulk_action_export_vars {
	inter_item_check_id
	assessment_id
	section_id
	{type_check f}
    }\
    -row_pretty_plural "[_ assessment.Assessment] [_ assessment.triggers]" \
    -elements {
	name {
	    label "[_ assessment.Name]"
	    display_template {
		<a href=add-edit-check?assessment_id=$assessment_id&inter_item_check_id=@branches.inter_item_check_id@&edit_check=t&type=b><img border=0 src=images/Edit16.gif></a>  @branches.name@
	    }
	}
	section_id_to {
	    label "[_ assessment.goes_to_section]"
	    display_col sname
	}
	
    }

