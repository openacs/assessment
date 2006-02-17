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
set title "[_ assessment.Administration]"
set context [list "[_ assessment.admin]"]
set package_id [ad_conn package_id]
set folder_id [as::assessment::folder_id -package_id $package_id]
set categories_url [db_string get_category_url {}]
set user_id [ad_conn user_id]
set package_admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege "admin"]

if { $package_admin_p == 0} {
    set m_name "get_all_assessments_admin"
} else {
    set m_name "get_all_assessments"
}

#form to upload a QTI ZIP file
ad_form -name form_upload_file -action {unzip-file} -html {enctype multipart/form-data}  -form {
    {zipfile:file {label "[_ assessment.Import_QTI_ZIP_File]"}}
}

set actions [list "[_ assessment.New_Assessment]" assessment-form "[_ assessment.New_Assessment2]"]

if {[ad_permission_p [acs_magic_object "security_context_root"] "admin"]} {
    # lappend actions "[_ assessment.Admin_catalog]" "catalog/" "[_ assessment.Admin_catalog]"
}

#get all assessments order by title
db_multirow -extend { export permissions admin_request} assessments $m_name {} {
    set export "[_ assessment.Export]"
    set permissions "[_ assessment.permissions]"
    set admin_request "[_ assessment.Request] [_ assessment.Administration]"
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
	    link_url_eval "[export_vars -base one-a { assessment_id }]"
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
