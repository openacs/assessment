ad_page_contract {

    This page lets the user add an item from the catalog to a section.

    @param  assessment_id integer specifying assessment
    @param  section_id integer specifying section

    @author timo@timohentschel.de
    @date   November 10, 2004
    @cvs-id $Id: 
} {
    assessment_id:integer
    section_id:integer
    after:integer
    {orderby:optional "title,asc"}
    {page:optional 1}
    {itype:optional ""}
    {subtree_p:optional f}
    {letter:optional all}
    {category_ids:integer,multiple,optional ""}
    {join_cat:optional or}
    {join_key:optional and}
    {keywords:optional ""}
}

ad_require_permission $assessment_id admin

# Get the assessment data
as::assessment::data -assessment_id $assessment_id

if {![info exists assessment_data(assessment_id)]} {
    ad_return_complaint 1 "[_ assessment.Requested_assess_does]"
    ad_script_abort
}

db_1row section_title {}

set page_title "[_ assessment.Add_Existing_1]"
set context_bar [ad_context_bar [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] "[_ assessment.Add_Existing]"]
set package_id [ad_conn package_id]

set __category__ad_form__category_id_1114 1115
set combine_options [list [list "[_ assessment.and]" and] [list "[_ assessment.or]" or]]
set subtree_options [list [list "[_ assessment.Categorization_exact]" f] [list "[_ assessment.Categorization_sub]" t]]
set letter_options [list [list "[_ assessment.Letter_all]" all] {A a} {B b} {C c} {D d} {E e} {F f} {G g} {H h} {I i} {J j} {K k} {L l} {M m} {N n} {O o} {P p} {Q q} {R r} {S s} {T t} {U u} {V v} {W w} {X x} {Y y} {Z z} [list "[_ assessment.Letter_other]" other]]

set item_types [list [list "[_ assessment.Letter_all]" ""]]
foreach one_item_type [db_list item_types {}] {
    lappend item_types [list "[_ assessment.item_type_$one_item_type]" $one_item_type]
}


ad_form -name item_search -action item-add-existing -export { assessment_id after } -form {
    {section_id:text(hidden) {value $section_id}}
}

if {![empty_string_p [category_tree::get_mapped_trees $package_id]]} {
    category::ad_form::add_widgets -container_object_id $package_id -categorized_object_id 0 -form_name item_search
}
ad_form -extend -name item_search -form {
    {join_cat:text(radio),optional {label "[_ assessment.Categories_combine]"} {options $combine_options} {value $join_cat} {help_text "[_ assessment.categories_combine_help]"}}
    {subtree_p:text(radio),optional {label "[_ assessment.Categorization]"} {options $subtree_options} {value $subtree_p} {help_text "[_ assessment.Categorization_help]"}}
    {keywords:text,optional {label "[_ assessment.Keywords]"} {html {size 80 maxlength 500}} {value $keywords} {help_text "[_ assessment.Keywords_help]"}}
    {join_key:text(radio),optional {label "[_ assessment.Keywords_combine]"} {options $combine_options} {value $join_key} {help_text "[_ assessment.keywords_combine_help]"}}
    {letter:text(select),optional {label "[_ assessment.Letter]"} {options $letter_options} {value $letter} {help_text "[_ assessment.Letter_help]"}}
    {itype:text(select),optional {label "[_ assessment.Item_Type]"} {options $item_types} {value $itype} {help_text "[_ assessment.Item_Type_help]"}}
}

ad_form -extend -name item_search -select_query {
}


# somehow this should be done in a better way...
switch -- $orderby {
    "title,desc" { set orderby_clause "order by lower(cr.title) desc" }
    "title,asc" { set orderby_clause "order by lower(cr.title) asc" }
    "type,desc" { set orderby_clause "order by o.object_type desc, lower(cr.title) desc" }
    "type,asc" { set orderby_clause "order by o.object_type asc, lower(cr.title) asc" }
    "name,desc" { set orderby_clause "order by lower(ci.name) desc" }
    "name,asc" { set orderby_clause "order by lower(ci.name) asc" }
    "author,desc" { set orderby_clause "order by lower(p.last_name) desc, lower(p.first_names) desc, lower(cr.title) desc" }
    "author,asc" { set orderby_clause "order by lower(p.last_name) asc, lower(p.first_names) asc, lower(cr.title) asc" }
}


set bulk_actions [list "[_ assessment.Add_to_section]" item-add-existing-2]


list::create \
    -name items \
    -key as_item_id \
    -pass_properties { assessment_id section_id after join_cat subtree_p keywords join_key letter itype category_ids } \
    -no_data "[_ assessment.None]" \
    -filters { assessment_id {} section_id {} after {} } \
    -elements {
	title {
	    label "[_ assessment.Title]"
	    orderby "lower(cr.title)"
	}
	type {
	    label "[_ assessment.Item_Type]"
	    display_template "@items.item_type@"
	    orderby_asc "o.object_type asc, lower(cr.title) asc"
	    orderby_desc "o.object_type desc, lower(cr.title) desc"
	}
	name {
	    label "[_ assessment.Name]"
	    orderby "lower(ci.name)"
	}
	author {
	    label "Author"
	    display_template "@items.last_name@, @items.first_names@"
	    orderby_asc "lower(p.last_name) asc, lower(p.first_names) asc, lower(cr.title) asc"
	    orderby_desc "lower(p.last_name) desc, lower(p.first_names) desc, lower(cr.title) desc"
	}
    } -bulk_actions $bulk_actions -bulk_action_export_vars { assessment_id section_id after } -page_size 20 -page_query_name item_list


set orderby_clause [list::orderby_clause -orderby -name items]
set page_clause [list::page_where_clause -and -name items]

db_multirow items unmapped_items_to_section "" {
    set item_type "[_ assessment.item_type_[string range $item_type end-1 end]]"
}

ad_return_template
return
