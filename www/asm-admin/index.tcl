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

set title "[_ assessment.Administration]"
set context {}
set package_id [ad_conn package_id]
set categories_url [db_string get_category_url {}]
set user_id [ad_conn user_id]
set admin_p [ad_permission_p $package_id admin]
set package_admin [permission::permission_p -party_id $user_id -object_id $package_id -privilege "admin"]
set m_name ""

if { $package_admin == 0} {
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
db_multirow -extend { export permissions} assessments $m_name {} {
    set export "[_ assessment.Export]"
    set permissions "[_ assessment.permissions]"
}

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
	
    } -actions $actions

ad_return_template
