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

ad_return_template
