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

set context [list "[_ assessment.Import_Results]"]

# Generate a random directory name
set tmpdirectory [ns_tmpnam]
# Create a temporary directory
file mkdir $tmpdirectory

# UNZIP the zip file in the temporary directory
catch { exec unzip ${zipfile.tmpfile} -d $tmpdirectory } outMsg

# Read the content of the temporary directory
foreach file_i [ glob -directory $tmpdirectory *{.xml}  ] {
	as::qti::parse_qti_xml $file_i
}

# Delete the temporary directory
file delete -force $tmpdirectory

ad_return_template
