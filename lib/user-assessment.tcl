#packages/assessment/lib/user-assessment.tcl
ad_page_contract {
    
    testing background
    
    @author Natalia Pérez (nperper@it.uc3m.es)
    @creation-date 2004-11-24    
} {
    
} -properties {
} -validate {
} -errors {
}

#get community_id
set community_id [db_string get_assessment_package_id {select dotlrn_community_applets.community_id from dotlrn_community_applets where package_id=:package_id}]
set community_name [dotlrn_community::get_community_name $community_id]

#set package_id $list_of_packages_ids
template::list::create \
    -name assessments \
    -multirow assessments \
    -pass_properties { package_id community_id } \
    -key assessment_id \
    -elements {         
	title {
	    label {[_ assessment.Assessment] ($community_name)}	    
	    link_url_eval {[site_node::get_url_from_object_id -object_id $package_id][export_vars -base assessment {assessment_id}]}
	    link_html { title {description} }
	    
	}
	session {	    
	    label {[_ assessment.Sessions]}	    
	    link_url_eval {[site_node::get_url_from_object_id -object_id $package_id][export_vars -base last-session {assessment_id}]}
	}
    } \
    -main_class {
	narrow
    }

    
foreach package $package_id {
    db_multirow -extend { session } -append  assessments asssessment_id_name_definition { } {
	set session {Sessions}
    }
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
