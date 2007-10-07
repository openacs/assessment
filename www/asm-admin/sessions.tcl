# packages/assessment/www/asm-admin/sessions.tcl

ad_page_contract {
    
    List subjects who completed assessment
    
    @author Roel Canicula (roel@solutiongrove.com)
    @creation-date 2006-06-05

    @arch-tag: cdb2d596-15fc-45ba-9ce1-d648a49a20b7
    @cvs-id $Id$
} {
    assessment_id:integer,optional,notnull
    subject_id:integer,optional,notnull
    status:optional,notnull
} -properties {
} -validate {
} -errors {
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
set folder_id [as::assessment::folder_id -package_id $package_id]
set user_id [ad_conn user_id]
set context_object_id $package_id
set form [rp_getform]
ns_set delkey $form status
set page_title [_ assessment.All_Users]
if {[info exists assessment_id]} {
    as::assessment::data -assessment_id $assessment_id
    set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] $page_title]
} else {
    set context [list [list index [_ assessment.admin]] $page_title]
}
set base_url [ad_return_url]

set actions [list]

if { [info exists subject_id] } {
    set actions [list "[_ assessment.All_Users]" ? "[_ assessment.All_Users]"]    
    set person_name [person::name -person_id $subject_id]
}

lappend actions \
    "[_ assessment.Complete]" [export_vars -base $base_url {{status complete}}] "[_ assessment.Complete]" \
    "[_ assessment.Incomplete]" [export_vars -base $base_url {{status incomplete}}] "[_ assessment.Incomplete]" \
    "[_ assessment.Not_Taken]" [export_vars -base $base_url {{status nottaken}}] "[_ assessment.Not_Taken]" \
    "[_ assessment.All]" [export_vars -base $base_url] "[_ assessment.All]"

if { [info exists assessment_id] } {
    as::assessment::data -assessment_id $assessment_id
    set context_object_id $assessment_id
    set actions [linsert $actions 0 "[_ assessment.All_Assessments]" ? "[_ assessment.All_Assessments]"]
    lappend actions "[_ assessment.Summary]" [export_vars -base item-stats { assessment_id {return_url [ad_return_url]} }] "[_ assessment.Summary]"
}

if { [exists_and_not_null status] } {
        if { $status == "complete" } {
                set whereclause "cs.completed_datetime is not null"
        } elseif { $status == "incomplete" } {
                set whereclause "cs.completed_datetime is null and ns.session_id is not null"
        } else {
                set whereclause "cs.completed_datetime is null and ns.session_id is null"
        }
} else {
        set whereclause "cs.completed_datetime is null and ns.session_id is null"
}

# Check membership

template::list::create \
    -name sessions \
    -actions $actions \
    -no_data "[_ assessment.No_sessions_found]" \
    -elements {
	name {
	    label "[_ assessment.Name]"
	    display_template {
		<a href="?subject_id=@sessions.user_id@">@sessions.last_name@, @sessions.first_names@</a>
	    }
	    hide_p {[info exists subject_id]}
	}
	title {
	    label "[_ assessment.Assessment]"
	    display_template {
		<a href="?assessment_id=@sessions.item_id@">@sessions.title@</a>
	    }
	    hide_p {[info exists assessment_id]}
	}
	status {
	    label "[_ assessment.Status]"
	    display_template {
		<if @sessions.session_id@ nil>
		[_ assessment.Not_Taken]
		</if>		
		<elseif @sessions.completed_datetime@ nil>
		[_ assessment.Incomplete]
		</elseif>
		<else>
		[_ assessment.Complete]
		</else>
	    }
	}
	last_mod_datetime {
	    label "[_ assessment.Last_Updated]"	    
	}
	percent_score {
	    label {[_ assessment.Percent_Score]}
	    html {align right nowrap}
	    display_template {
		<if @sessions.session_id@ not nil>
		<a href="../session?session_id=@sessions.session_id@">
		<if @sessions.percent_score@ not nil>
		@sessions.percent_score@%
		</if>
		<img src="/resources/right.gif" border=0 /></a>
		</if>
	    }
	    hide_p {[expr {[info exists assessment_data(type)] && $assessment_data(type) != "test"}]}
	}
    } \
    -filters {
	assessment_id {
	    where_clause {
		a.item_id = :assessment_id
	    }
	}
	subject_id {
	    where_clause {
		cs.subject_id = :subject_id
	    }
	}
	status {
	    values {{"[_ assessment.Complete]" complete} {"[_ assessment.Incomplete]" incomplete} {"[_ assessment.Not_Taken]" nottaken}}
	    where_clause {
			$whereclause
	    }
	}
    }

db_multirow sessions get_sessions ""
