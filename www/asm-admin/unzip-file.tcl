ad_page_contract {
    @author alvaro@it.uc3m.es
    @creation-date 2004-04-14
} {
    zipfile
    {zipfile.tmpfile}
} -validate {
} -properties {
    qti_items_imported_number
    context:onevalue
}
permission::require_permission \
    -object_id [ad_conn package_id] \
    -party_id [ad_conn user_id] \
    -privilege "create"

set context [list "[_ assessment.Import_Results]"]

# Generate a random directory name
set tmpdirectory [ad_tmpnam]
# Create a temporary directory
file mkdir $tmpdirectory

# UNZIP the zip file in the temporary directory
catch { exec unzip ${zipfile.tmpfile} -d $tmpdirectory } outMsg

# Read the content of the temporary directory
foreach file_i [ glob -directory $tmpdirectory *{.xml}  ] {
	as::qti::parse_qti_xml $file_i
}

# Delete the temporary directory
file delete -force -- $tmpdirectory

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
