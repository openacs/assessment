ad_page_contract {
    @author eperez@it.uc3m.es
    @creation-date 2004-09-21
} {
} -properties {
    zipfile
    context:onevalue
}

set title "[_ assessment.Administration]"
set context {}

ad_form -name form_upload_file -action {unzip-file} -html {enctype multipart/form-data}  -form {
    {zipfile:file {label "[_ assessment.Import_QTI_ZIP_File]"}}
}

set actions [list "[_ assessment.New_Assessment]" assessment-form "[_ assessment.New_Assessment2]"]

if {[ad_permission_p [acs_magic_object "security_context_root"] "admin"]} {
    lappend actions "[_ assessment.Admin_catalog]" "catalog/" "[_ assessment.Admin_catalog]"
}

db_multirow assessments get_all_assessments {}

list::create \
    -name assessments \
    -key assessment_id \
    -no_data "[_ assessment.None]" \
    -elements {
	title {
	    label "[_ assessment.Title]"
	    link_url_eval "[export_vars -base one-a { assessment_id }]"
	}
    } -actions $actions

ad_return_template
