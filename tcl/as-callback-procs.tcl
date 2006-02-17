ad_library {
    assessment -- callback routines
    @author eduardo.perez@uc3m.es
    @creation-date 2005-05-23
    @cvs-id $Id$
}

ad_proc -public -callback imsld::import -impl qti {} {
    this is the imsld qti importer
} {
    if {$res_type == "imsqti_xmlv1p0" || $res_type == "imsqti_xmlv1p1" || $res_type =="imsqti_item_xmlv2p0"} {
	return [as::qti::register_xml_object_id \
		    -xml_file $tmp_dir/$res_href \
		    -community_id $community_id]
    }
}
