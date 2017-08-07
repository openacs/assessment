ad_page_contract {
    This page admin the new actions to be used on the checks
    @authos vivian@viaro.net Viaro Networks (www.viaro.net)
    @date 07-01-2005
    @cvs-id $Id:
} {
   
}
set context [list Actions]
set package_id [ad_conn package_id]
#See the params we already have
template::list::create \
    -name actions \
    -elements {
	name {
	    label "[_ assessment.Name]"
	}	    
	description {
	    label "[_ assessment.parameter_description]"
	}
	edit_url {
	    label {[_ assessment.action_edit]}
	    display_template {

		<a href="asm-action-new?action_id=@actions.action_id@">[_ assessment.Edit]</a>
		| <a href="asm-action-delete?action_id=@actions.action_id@">[_ assessment.Delete]</a>
	    }
	}
    }



db_multirow -extend { edit_url } actions action_select {}


 




# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
