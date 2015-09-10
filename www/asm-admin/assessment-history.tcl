ad_page_contract {

    Lists the change history of the assessment

    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2005-04-15
} {
    assessment_id:naturalnum,notnull
} -properties {
    context:onevalue
    page_title:onevalue
}

permission::require_permission \
    -object_id $assessment_id \
    -party_id [ad_conn user_id] \
    -privilege admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

set user_id [ad_conn user_id]
set page_title "[_ assessment.history]"
set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]
set format "[lc_get formbuilder_date_format], [lc_get formbuilder_time_format]"

template::list::create \
    -name history \
    -multirow history \
    -key revision_id \
    -elements {
	user_name {
	    label {[_ assessment.Modified_User]}
	    display_template {<a href="@history.user_url@">@history.user_name@</a>}
	}
	creation_date {
	    label {[_ assessment.Modified_Time]}
	    html {style white-space:nowrap}
	}
    } -main_class {
	narrow
    } 


db_multirow -extend { user_url } history assessment_history {
} {
    set user_url [acs_community_member_url -user_id $person_id]
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
