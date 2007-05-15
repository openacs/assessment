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

# hack for dotlrn ideally ad_conn subsite_id would pretend dotlrn was a subsite
if {![apm_package_installed_p dotlrn] \
	|| [set members_party_id [dotlrn_community::get_community_id]] eq ""} {
    set members_party_id [application_group::group_id_from_package_id \
			      -package_id [ad_conn subsite_id]]
}

set form [rp_getform]
ns_set delkey $form status
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

    set actions [linsert $actions 0 "[_ assessment.All_Assessments]" ? "[_ assessment.All_Assessments]"]
    lappend actions "[_ assessment.Summary]" [export_vars -base item-stats { assessment_id {return_url [ad_return_url]} }] "[_ assessment.Summary]"
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
		(case when :status = 'complete'
		 then not cs.completed_datetime is null
		 when :status = 'incomplete'
		 then cs.completed_datetime is null and not ns.session_id is null
		 else cs.completed_datetime is null and ns.session_id is null end)
	    }
	}
    }

db_multirow sessions get_sessions [subst {
    select a.*,
    to_char(cs.completed_datetime, 'YYYY-MM-DD HH24:MI:SS') as completed_datetime,
    to_char(coalesce(cs.last_mod_datetime, ns.last_mod_datetime), 'YYYY-MM-DD HH24:MI:SS') as last_mod_datetime,
    coalesce(cs.subject_id, ns.subject_id) as subject_id,
    coalesce(cs.session_id, ns.session_id) as session_id,
    cs.percent_score
 
    from (select a.assessment_id, cr.title, cr.item_id, cr.revision_id,
	  u.user_id, u.first_names, u.last_name
	  
	  from as_assessments a, cr_revisions cr, cr_items ci, acs_users_all u,
          group_member_map g
	  
	  where a.assessment_id = cr.revision_id
	  and cr.revision_id = ci.latest_revision
	  and ci.parent_id = :folder_id
	  
	  and g.group_id = :members_party_id
	  and g.member_id = u.user_id
	  and acs_permission__permission_p(cr.item_id, u.user_id, 'read')) a

    left join (select as_sessions.*, cr.item_id
	       from as_sessions, cr_revisions cr
	       where session_id in (select max(session_id)
				    from as_sessions, acs_objects o
				    where not completed_datetime is null
	       and o.object_id = session_id
               and o.package_id = :package_id
				    group by subject_id, assessment_id )
               and revision_id=assessment_id) cs
    on (a.user_id = cs.subject_id and a.item_id = cs.item_id)

    left join (select *
	       from as_sessions
	       where session_id in (select max(session_id)
				    from as_sessions, acs_objects o
				    where completed_datetime is null
	       and o.object_id = session_id
               and o.package_id = :package_id
  	    group by subject_id, assessment_id)) ns
    on (a.user_id = ns.subject_id and a.assessment_id = ns.assessment_id)

    where true
    [list::filter_where_clauses -and -name "sessions"]

    order by lower(a.title), lower(a.last_name), lower(a.first_names)
}]







