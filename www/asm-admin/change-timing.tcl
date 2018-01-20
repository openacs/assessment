# packages/project-manager/www/assign-myself
ad_page_contract { 
    Assign all the received tasks to the received role, default to lead.
    @author Malte Sussdorff (malte.sussdorff@cognovis.de)
    @author cognovis www.cognovis.de
} {
    assessment_id:naturalnum,multiple
    {return_url:localurl "index"}
}

foreach id $assessment_id {
    permission::require_permission \
	-object_id $id \
	-privilege admin \
	-party_id [ad_conn user_id]
}
set form_format "[lc_get formbuilder_date_format] [lc_get formbuilder_time_format]"
set user_id [ad_conn user_id]
set context [list "[_ assessment.admin]"]

ad_form -name "change-timing" -form {
    {assessment_id:text(hidden)
        {value $assessment_id}
    }
    {start_time:date,to_sql(sql_date),to_html(display_date),optional 
	{label "[_ assessment.Start_Time]"} 
	{format $form_format} 
	{help} 
	{help_text "[_ assessment.as_Start_Time_help]"}
    }
    {end_time:date,to_sql(sql_date),to_html(display_date),optional 
	{label "[_ assessment.End_Time]"} 
	{format $form_format} 
	{help} 
	{help_text "[_ assessment.as_End_Time_help]"}
    }
} -on_submit {

    if {[db_type] eq "postgresql"} {
	regsub -all -- {to_date} $start_time {to_timestamp} start_time
	regsub -all -- {to_date} $end_time {to_timestamp} end_time
    }
    
    foreach assessment $assessment_id {
	set assessment_rev_id [content::item::get_latest_revision -item_id $assessment]
	if {$start_time ne ""} {
	    db_dml update_start_time {}
	}
	if {$end_time ne ""} {
	    db_dml update_end_time {}
	}
    } 
} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
}
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
