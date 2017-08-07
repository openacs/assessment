ad_library {

    Assessment Library - Service Contracts

    @creation-date jan 2006
    @author jopez@inv.it.uc3m.es
    @cvs-id $Id$
}

namespace eval as {}
namespace eval as::sc {}

ad_proc -private as::datasource { assessment_id } {
    @param assessment_id
} {
    # noop
}

ad_proc -private as::url { assessment_id } {
    @param assessment_id

    returns the url for the assessment

} {
	set package_id [db_string package_id {	
        select package_id from cr_folders where folder_id=(select context_id from acs_objects where object_id=:assessment_id)
    }]
	set url [apm_package_url_from_id $package_id]
	return "${url}assessment?assessment_id=$assessment_id"
}

ad_proc -private as::sc::register_implementations {} {
    Register the as_assessments content type fts contract
} {
    as::sc::register_fts_impl
}

ad_proc -private as::sc::unregister_implementations {} {
    acs_sc::impl::delete -contract_name FtsContentProvider -impl_name as_assessments
}

ad_proc -private as::sc::register_fts_impl {} {
    set spec {
        name "as_assessments"
        aliases {
            datasource as::datasource
            url as::url
        }
        contract_name FtsContentProvider
        owner assessment
    }

    acs_sc::impl::new_from_spec -spec $spec
}




# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
