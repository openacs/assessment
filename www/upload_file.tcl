#www/upload_file.tcl

ad_page_contract {
    @author alvaro@it.uc3m.es
    @creation-date 2004-04-14
} {
} -properties {
    zipfile
    context:onevalue
}

set context [list "Upload File"]

ad_form -name form_upload_file -action {unzip_file} -html {enctype multipart/form-data}  -form {
    {zipfile:file {label "File:"}}
}

ad_return_template
