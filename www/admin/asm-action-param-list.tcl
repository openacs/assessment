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
	    label "[_ assessment.Name]"
	}	    
	description {
	    label "[_ assessment.action_description]"
	}
	type {
	    label "[_ assessment.parameter_type]"
	    display_template {
		<if @parameter_list.type@ eq n>
		#assessment.var#
		</if>
		<else>
		#assessment.query#
		</else>
	    }
	}

	query {
	    label "[_ assessment.parameter_query]"
	}

	edit_url {
	    label {[_ assessment.action_edit]}
	    display_template {
		<a href=asm-action-param-admin?parameter_id=@parameter_list.parameter_id@&action_id=@parameter_list.action_id@>[_ assessment.Edit]</a> | <a href=asm-action-param-delete?parameter_id=@parameter_list.parameter_id@&action_id=@parameter_list.action_id@ >[_ assessment.Delete]</a>
	    }
	}
	
    }

db_multirow parameter_list param_select {}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
