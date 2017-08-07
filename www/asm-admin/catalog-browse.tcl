ad_page_contract {

    This page lets the user browse the catalog and select items/sections to add.

    @param  assessment_id integer specifying assessment
    @param  section_id integer specifying section

    @author timo@timohentschel.de
    @date   2004-12-08
    @cvs-id $Id: 
} {
    assessment_id:naturalnum,notnull
    {section_id:naturalnum,optional}
    after:integer
    {itype:optional}
    {subtree_p:boolean,optional}
    letter:optional
    {category_ids:integer,multiple,optional ""}
    {join:optional}
    keywords:optional
    {orderby:token,optional "title,asc"}
    {page:optional 1}
    {search_again_url:optional ""}
    {page_size:optional 20}
} -properties {
    title:onevalue
    context:onevalue
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege create
permission::require_permission -object_id $assessment_id -privilege admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

if {[info exists section_id]} {
    db_1row section_title {}
    set page_title "[_ assessment.Search_Item_1]"
    set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] "[_ assessment.Search_Results]"]
} else {
    set page_title "[_ assessment.Search_Section_1]"
    set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] "[_ assessment.Search_Results]"]
}

set package_id [ad_conn package_id]

# somehow this should be done in a better way...
switch -exact $orderby {
    "title,desc" { set orderby_clause "order by lower(cr.title) desc" }
    "title,asc" { set orderby_clause "order by lower(cr.title) asc" }
    "type,desc" { set orderby_clause "order by o.object_type desc, lower(cr.title) desc" }
    "type,asc" { set orderby_clause "order by o.object_type asc, lower(cr.title) asc" }
    "name,desc" { set orderby_clause "order by lower(ci.name) desc" }
    "name,asc" { set orderby_clause "order by lower(ci.name) asc" }
    "author,desc" { set orderby_clause "order by lower(p.last_name) desc, lower(p.first_names) desc, lower(cr.title) desc" }
    "author,asc" { set orderby_clause "order by lower(p.last_name) asc, lower(p.first_names) asc, lower(cr.title) asc" }
}

switch -exact $letter {
    other {
	set letter_where_clause [db_map other_letter]
    }
    all {
	set letter_where_clause ""
    }
    default {
	set bind_letter "$letter%"
	set letter_where_clause [db_map regular_letter]
    }
}

set itype_where_clause ""
if {([info exists itype] && $itype ne "")} {
    set obj_type "as_item_type_$itype"
    set itype_where_clause [db_map item_type]
}

set category_ids_length [llength $category_ids]
if {$category_ids_length > 0} {
    set category_id_sql [join $category_ids ,]
    if {$join eq "and"} {
	# combining categories with and
	if {$subtree_p == "t"} {
	    # generate sql for exact categorizations plus subcategories
	    set subtree_sql [db_map include_subtree_and]
	} else {
	    # generate sql for exact categorization
	    set subtree_sql [db_map exact_categorization_and]
	}
    } else {
	# combining categories with or
	if {$subtree_p == "t"} {
	    # generate sql for exact categorizations plus subcategories
	    set subtree_sql [db_map include_subtree_or]
	} else {
	    # generate sql for exact categorization
	    set subtree_sql [db_map exact_categorization_or]
	}
    }
    set category_table_clause ", ($subtree_sql) s"
    set category_where_clause [db_map categories]
} else {
    set category_table_clause ""
    set category_where_clause ""
}

set keyword_where_clause ""
if {$keywords ne ""} {
    set keyword_sql [string tolower "%$keywords%"]
    if {[info exists section_id]} {
	set keyword_where_clause [db_map item_keywords]
    } else {
	set keyword_where_clause [db_map section_keywords]
    }
}


if {[info exists section_id]} {
    set bulk_actions [list "[_ assessment.Add_to_section]" catalog-item-add]
} else {
    set bulk_actions [list "[_ assessment.Add_to_assessment]" catalog-section-add]
}

set elements {
    title {
	label "[_ assessment.Title]"
	orderby "lower(cr.title)"
    }
}
if {[info exists section_id]} {
    lappend elements type {
	label "[_ assessment.Item_Type]"
	display_template "@objects.item_type@"
	orderby_asc "o.object_type asc, lower(cr.title) asc"
	orderby_desc "o.object_type desc, lower(cr.title) desc"
    }
    lappend elements field_name {
	label "[_ assessment.Field_Name]"
	orderby "lower(i.field_name)"
    }
    set key_name as_item_id
    set page_query item_list
} else {
    set assessment_rev_id $assessment_data(assessment_rev_id)
    set key_name section_id
    set page_query section_list
    lappend elements name {
	label "[_ assessment.Name]"
	orderby "lower(ci.name)"
    }
}
lappend elements author {
    label "Author"
    display_template "@objects.last_name@, @objects.first_names@"
    orderby_asc "lower(p.last_name) asc, lower(p.first_names) asc, lower(cr.title) asc"
    orderby_desc "lower(p.last_name) desc, lower(p.first_names) desc, lower(cr.title) desc"
}


list::create \
    -name objects \
    -key $key_name \
    -pass_properties { assessment_id section_id after } \
    -no_data "[_ assessment.None]" \
    -filters { 
	assessment_id {} section_id {} after {} category_ids { type multival } join_cat {} subtree_p {} keywords {} join_key {} letter {} itype {} search_again_url {} } \
    -elements $elements \
    -bulk_actions $bulk_actions \
    -bulk_action_export_vars { assessment_id section_id after } \
    -page_size $page_size \
    -page_flush_p 1 \
    -page_query_name $page_query


set orderby_clause [list::orderby_clause -orderby -name objects]
set page_where_clause [list::page_where_clause -and -name objects]

if {[info exists section_id]} {
    db_multirow objects unmapped_items_to_section "" {
	set item_type "[_ assessment.item_type_[string range $item_type end-1 end]]"
    }
} else {
    db_multirow objects unmapped_sections_to_assessment ""
}

ad_return_template
return

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
