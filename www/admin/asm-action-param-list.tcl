ad_page_contract {
    This page display the parameters that receive the actions
    @authos vivian@viaro.net Viaro Networks (www.viaro.net)
    @date 07-01-2005
    @cvs-id $Id:
} {

}



template::list::create \
    -name parameter_list \
    -elements {
	varname {
	    label "Name"
	}	    
	description {
	    label "Description"
	}
	type {
	    label "Type"
	}

	query {
	    label "Query"
	}

	edit_url {
	    label {[_ assessment.action_edit]}
	    display_template {
		<a href=asm-action-param-admin?parameter_id=@parameter_list.parameter_id@&action_id=@parameter_list.action_id@>Edit</a> | <a href=asm-action-param-delete?parameter_id=@parameter_list.parameter_id@&action_id=@parameter_list.action_id@ >Delete</a>
	    }
	}
	
    }

db_multirow parameter_list param_select {}