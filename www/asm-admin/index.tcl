ad_page_contract {

    Presents a form to upload a QTI ZIP file,
    lists all assessments and shows a link to 
    assessment editor and another to assessment
    catalog.
    
    @author eperez@it.uc3m.es
    @creation-date 2004-09-21
} {
} -properties {
    zipfile
    context:onevalue
}
set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
set title [_ assessment.Administration]
set context [list [_ assessment.admin]]
set package_id [ad_conn package_id]
set folder_id [as::assessment::folder_id -package_id $package_id]
set categories_url [db_string get_category_url {}]
set user_id [ad_conn user_id]
set sw_admin_p [acs_user::site_wide_admin_p -user_id $user_id]
set package_admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege "admin"]

#form to upload a QTI ZIP file
ad_form -name form_upload_file -action {unzip-file} -html {enctype multipart/form-data}  -form {
    {zipfile:file {label "[_ assessment.Import_QTI_ZIP_File]"}}
}

set actions [list]
set advanced_options_p [parameter::get -parameter ShowAdvancedOptions -default 1]
if { $advanced_options_p } {
    lappend actions [_ assessment.New_Survey] {assessment-form?type=survey} [_ assessment.New_Survey] \
	[_ assessment.New_Review_Assessment]  {assessment-form?type=3}      [_ assessment.New_Review_Assessment] \
	[_ assessment.New_Partial_Assessment] {assessment-form?type=4}      [_ assessment.New_Partial_Assessment] \
	[_ assessment.New_Quick_Assessment]   {assessment-form?type=5}      [_ assessment.New_Quick_Assessment]
}

lappend actions [_ assessment.New_Assessment] {assessment-form?type=test} [_ assessment.New_Assessment2]

if { $sw_admin_p && $advanced_options_p } {
    lappend actions [_ assessment.set_reg_asm] "../admin/set-reg-assessment" [_ assessment.set_reg_asm]
}

if {[permission::permission_p -object_id [acs_magic_object "security_context_root"] -privilege "admin"]} {
    # lappend actions "[_ assessment.Admin_catalog]" "catalog/" "[_ assessment.Admin_catalog]"
}

#get all assessments order by title
db_multirow -extend { export permissions admin_request} assessments get_all_assessments {} {
    set title [as::assessment::title -title $title]
    set export "[_ assessment.Export]"
    set permissions "[_ assessment.permissions]"
    set admin_request "[_ assessment.Request] [_ assessment.Administration]"
    switch -- $publish_status {
	live {
	    set publish_status "[_ assessment.Live]"
	} 
	default {
	    set publish_status "[_ assessment.Not_Live]"
	}
    }
	    
}

# Bulk action for mass setting the start and endtime of assessments.
set bulk_actions  [list \
		       "[_ assessment.Change_timings]" \
		       "change-timing" \
		       "[_ assessment.Change_multiple_timings]"]

#list all assessments
list::create \
    -name assessments \
    -key assessment_id \
    -no_data "[_ assessment.None]" \
    -elements {
	title {
	    label "[_ assessment.Title]"
	    display_template {<a href="one-a?assessment_id=@assessments.assessment_id@">@assessments.title;noquote@</a>} 
	}
	publish_status {
	    label "[_ assessment.Publish_Status]"
        }
	export {
	    label "[_ assessment.Export]"
	    link_url_eval "[export_vars -base export { assessment_id }]"
	}
	permissions {
	    label "[_ assessment.permissions]"
	    link_url_eval "[export_vars -base permissions { {object_id $assessment_id} }]"
	}
	admin_request {
	    label "[_ assessment.Request] [_ assessment.Administration]"
	    link_url_eval "[export_vars -base admin-request { {assessment $assessment_id} }]"
	}

       
    } -actions $actions \
    -bulk_actions $bulk_actions

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
