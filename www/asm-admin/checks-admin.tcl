ad_page_contract {
    
    This page allows to add branches or actions to the question and its choices.    
   
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @date 2005-01-07
} {
    assessment_id:naturalnum,notnull
    section_id:naturalnum,notnull
    item_id:naturalnum,optional
      
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin
as::assessment::data -assessment_id $assessment_id
set new_assessment_revision $assessment_data(assessment_rev_id)
set check_list ""
set show_p 1
set by_item_p 0
set item_p ""
set item_id_check ""

if {([info exists item_id] && $item_id ne "")} {
    set show_p 0
    set by_item_p 1
    set item_p "&item_id=$item_id"
    set item_id_check $item_id 
    set as_item_id_i [db_string get_item_id { select item_id from cr_revisions where revision_id = :item_id}]
    set check_list "and c.inter_item_check_id in ("
    set checks [db_list_of_lists get_all_checks {}]
    set count  0
    
    foreach check $checks {
	set cond_list  [split [lindex $check 1] "="]
	set as_item_id [lindex [split [lindex $cond_list 2] ")"] 0]
	if { $as_item_id_i == $as_item_id} {
	    incr count
	    append check_list "[lindex $check 0],"
	}
	
    } 
    if {$count == 0} {
	append check_list "0,"
    }
    set check_list [string range $check_list 0 [string length $check_list]-2]
    append  check_list ")"
} 

db_multirow  or_checks get_or_checks {}  
db_multirow  sa_checks get_sa_checks {}  
db_multirow  aa_checks get_aa_checks {}  
db_multirow  i_checks  get_i_checks {}  
db_multirow  branches  get_branches {} 
db_multirow  m_checks  get_m_checks {} 


if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set title "$assessment_data(title)"
set context [list [list index [_ assessment.admin]] [list "one-a?assessment_id=$assessment_id" $title] "[_ assessment.Triggers]"]



template::list::create \
    -name or_checks \
    -multirow or_checks \
    -key inter_item_check_id \
    -bulk_actions {
	"\#assessment.Delete\#" "confirm-delete" "\#assessment.delete_checked\#"
    }\
    -bulk_action_method post \
    -bulk_action_export_vars {
	assessment_id
	section_id
	{type_check t}
	item_id_check
	by_item_p
    }\
    -row_pretty_plural "[_ assessment.Assessment] [_ assessment.triggers]" \
    -elements {
	name {
	    label "[_ assessment.Name]"
	    display_template {
		<a href=add-edit-section-check?assessment_id=$assessment_id&inter_item_check_id=@or_checks.inter_item_check_id@&section_id=@or_checks.section_id_from@&edit_check=t&by_item_p=$by_item_p$item_p><img border=0 src=images/Edit16.gif></a>  @or_checks.name@
	    }
	}
	action_name {
	    label "[_ assessment.action_to_perform]"
	}
	counter {
	    display_template {    
		<if $show_p eq 1>
		<if @or_checks.order_by@ lt @or_checks:rowcount@>
		<a href="swap-actions?assessment_id=$assessment_id&check_id=@or_checks.inter_item_check_id@&order_by=@or_checks.order_by@&section_id=@or_checks.section_id_from@&action_perform=@or_checks.action_perform@&direction=d"><img src="/resources/assessment/down.gif" border="0" alt="#assessment.Move_Down#"></a>
		</if>
		<if @or_checks.order_by@ gt 1>
		<a href="swap-actions?assessment_id=$assessment_id&check_id=@or_checks.inter_item_check_id@&order_by=@or_checks.order_by@&section_id=@or_checks.section_id_from@&action_perform=@or_checks.action_perform@&direction=u"><img src="/resources/assessment/up.gif" border="0" alt="#assessment.Move_Up#"></a>
		</if>
		</if>
		<a href=request-notification?assessment_id=$assessment_id&inter_item_check_id=@or_checks.inter_item_check_id@&section_id=$section_id>#assessment.notify_user#</a>
		
	    }
	    
	}
    }


template::list::create \
    -name sa_checks \
    -multirow sa_checks \
    -key inter_item_check_id \
    -bulk_actions {
	"\#assessment.Delete\#" "confirm-delete" "\#assessment.delete_checked\#"
    }\
    -bulk_action_method post \
    -bulk_action_export_vars {
	assessment_id
	section_id
	{type_check t}
	item_id_check
	by_item_p
    }\
    -row_pretty_plural "[_ assessment.Assessment] [_ assessment.triggers]" \
    -elements {
	name {
	    label "[_ assessment.Name]"
	    display_template {
		<a href=add-edit-section-check?assessment_id=$assessment_id&inter_item_check_id=@sa_checks.inter_item_check_id@&section_id=@sa_checks.section_id_from@&edit_check=t&by_item_p=$by_item_p$item_p><img border=0 src=images/Edit16.gif></a>  @sa_checks.name@
	    }
	}
	action_name {
	    label "[_ assessment.action_to_perform]"
	}
	counter {
	    display_template {    
		<if $show_p eq 1>
		<if @sa_checks.order_by@ lt @sa_checks:rowcount@>
		<a href="swap-actions?assessment_id=$assessment_id&check_id=@sa_checks.inter_item_check_id@&order_by=@sa_checks.order_by@&section_id=@sa_checks.section_id_from@&action_perform=@sa_checks.action_perform@&direction=d"><img src="/resources/assessment/down.gif" border="0" alt="#assessment.Move_Down#"></a>
		</if>
		<if @sa_checks.order_by@ gt 1>
		<a href="swap-actions?assessment_id=$assessment_id&check_id=@sa_checks.inter_item_check_id@&order_by=@sa_checks.order_by@&section_id=@sa_checks.section_id_from@&action_perform=@sa_checks.action_perform@&direction=u"><img src="/resources/assessment/up.gif" border="0" alt="#assessment.Move_Up#"></a>
		</if>
		</if>
		<a href=request-notification?assessment_id=$assessment_id&inter_item_check_id=@sa_checks.inter_item_check_id@&section_id=$section_id>#assessment.notify_user#</a>
		
	    }
	    
	}
    }


template::list::create \
    -name aa_checks \
    -multirow aa_checks \
    -key inter_item_check_id \
    -bulk_actions {
	"\#assessment.Delete\#" "confirm-delete" "\#assessment.delete_checked\#"
    }\
    -bulk_action_method post \
    -bulk_action_export_vars {
	assessment_id
	section_id
	{type_check t}
	item_id_check
	by_item_p
    }\
    -row_pretty_plural "[_ assessment.Assessment] [_ assessment.triggers]" \
    -elements {
	name {
	    label "[_ assessment.Name]"
	    display_template {
		<a href=add-edit-check?assessment_id=$assessment_id&inter_item_check_id=@aa_checks.inter_item_check_id@&edit_check=t&by_item_p=$by_item_p$item_p&section_id=$section_id><img border=0 src=images/Edit16.gif></a>  @aa_checks.name@
	    }
	}
	action_name {
	    label "[_ assessment.action_to_perform]"
	}
	counter {
	    display_template {    
		<if $show_p eq 1>
		<if @aa_checks.order_by@ lt @aa_checks:rowcount@>
		<a href="swap-actions?assessment_id=$assessment_id&check_id=@aa_checks.inter_item_check_id@&order_by=@aa_checks.order_by@&section_id=@aa_checks.section_id_from@&action_perform=@aa_checks.action_perform@&direction=d"><img src="/resources/assessment/down.gif" border="0" alt="#assessment.Move_Down#"></a>
		</if>
		<if @aa_checks.order_by@ gt 1>
		<a href="swap-actions?assessment_id=$assessment_id&check_id=@aa_checks.inter_item_check_id@&order_by=@aa_checks.order_by@&section_id=@aa_checks.section_id_from@&action_perform=@aa_checks.action_perform@&direction=u"><img src="/resources/assessment/up.gif" border="0" alt="#assessment.Move_Up#"></a>
		</if>
		</if>
		<a href=request-notification?assessment_id=$assessment_id&inter_item_check_id=@aa_checks.inter_item_check_id@&section_id=$section_id>#assessment.notify_user#</a>
		
	    }
	    
	}
    }



template::list::create \
    -name i_checks \
    -multirow i_checks \
    -key inter_item_check_id \
    -bulk_actions {
	"\#assessment.Delete\#" "confirm-delete" "\#assessment.delete_checked\#"
    }\
    -bulk_action_method post \
    -bulk_action_export_vars {
	assessment_id
	section_id
	{type_check t}
	item_id_check
	by_item_p

    }\
    -row_pretty_plural "[_ assessment.Assessment] [_ assessment.triggers]" \
    -elements {
	name {
	    label "[_ assessment.Name]"
	    display_template {
		<a href=add-edit-check?assessment_id=$assessment_id&section_id=$section_id&inter_item_check_id=@i_checks.inter_item_check_id@&edit_check=t&by_item_p=$by_item_p$item_p><img border=0 src=images/Edit16.gif></a>  @i_checks.name@
	    }
	}
	action_name {
	    label "[_ assessment.action_to_perform]"
	}
	inter_item_check_id {
	    display_template {   
		<if $show_p eq 1>
		<if @i_checks.order_by@ lt @i_checks:rowcount@>
		<a href="swap-actions?assessment_id=$assessment_id&check_id=@i_checks.inter_item_check_id@&order_by=@i_checks.order_by@&section_id=@i_checks.section_id_from@&action_perform=@i_checks.action_perform@&direction=d"><img src="/resources/assessment/down.gif" border="0" alt="#assessment.Move_Down#"></a>
		</if>
		<if @i_checks.order_by@ gt 1>
		    <a href="swap-actions?assessment_id=$assessment_id&check_id=@i_checks.inter_item_check_id@&order_by=@i_checks.order_by@&section_id=@i_checks.section_id_from@&action_perform=@i_checks.action_perform@&direction=u"><img src="/resources/assessment/up.gif" border="0" alt="#assessment.Move_Up#"></a>
		</if>
		</if>
		<a href=request-notification?assessment_id=$assessment_id&inter_item_check_id=@i_checks.inter_item_check_id@&section_id=$section_id>#assessment.notify_user#</a>
	    }
	}
    }




template::list::create \
    -name m_checks \
    -multirow m_checks \
    -key inter_item_check_id \
    -bulk_actions {
	"\#assessment.Delete\#" "confirm-delete" "\#assessment.delete_checked\#"
    }\
    -bulk_action_method post \
    -bulk_action_export_vars {
	assessment_id
	section_id
	{type_check t}
	item_id_check
	by_item_p
	
    }\
    -row_pretty_plural "[_ assessment.Assessment] [_ assessment.triggers]" \
    -elements {
	name {
	    label "[_ assessment.Name]"
	    display_template {
		<a href=add-edit-check?assessment_id=$assessment_id&inter_item_check_id=@m_checks.inter_item_check_id@&edit_check=t&by_item_p=$by_item_p$item_p&section_id=$section_id><img border=0 src=images/Edit16.gif></a>  @m_checks.name@
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


template::list::create \
    -name branches \
    -multirow branches \
    -key inter_item_check_id \
    -bulk_actions {
	"\#assessment.Delete\#" "confirm-delete" "\#assessment.delete_checked\#"
    }\
    -bulk_action_method post \
    -bulk_action_export_vars {
	assessment_id
	section_id
	{type_check f}
	item_id_check
	by_item_p

    }\
    -row_pretty_plural "[_ assessment.Assessment] [_ assessment.triggers]" \
    -elements {
	name {
	    label "[_ assessment.Name]"
	    display_template {
		<a href=add-edit-check?assessment_id=$assessment_id&inter_item_check_id=@branches.inter_item_check_id@&edit_check=t&type=b&by_item_p=$by_item_p$item_p&section_id=$section_id><img border=0 src=images/Edit16.gif></a>  @branches.name@
	    }
	}
	section_id_to {
	    label "[_ assessment.goes_to_section]"
	    display_col sname
	}
	
    }


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
