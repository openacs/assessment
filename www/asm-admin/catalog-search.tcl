ad_page_contract {

    This page lets the user search for objects in the catalog to add them

    @param  assessment_id integer specifying assessment
    @param  section_id integer specifying section

    @author timo@timohentschel.de
    @date   2004-12-08
    @cvs-id $Id: 
} {
    assessment_id:naturalnum,notnull
    section_id:naturalnum,optional
    after:integer
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
    set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] "[_ assessment.Search_Item]"]
} else {
    set page_title "[_ assessment.Search_Section_1]"
    set context [list [list index [_ assessment.admin]] [list [export_vars -base one-a {assessment_id}] $assessment_data(title)] "[_ assessment.Search_Section]"]
}

set package_id [ad_conn package_id]
set combine_options [list [list "[_ assessment.and]" and] [list "[_ assessment.or]" or]]
set subtree_options [list [list "[_ assessment.Categorization_exact]" f] [list "[_ assessment.Categorization_sub]" t]]
set letter_options [list [list "[_ assessment.Letter_all]" all] {A a} {B b} {C c} {D d} {E e} {F f} {G g} {H h} {I i} {J j} {K k} {L l} {M m} {N n} {O o} {P p} {Q q} {R r} {S s} {T t} {U u} {V v} {W w} {X x} {Y y} {Z z} [list "[_ assessment.Letter_other]" other]]


ad_form -name catalog_search -action catalog-search -export { section_id after } -form {
    {assessment_id:key}
}

if {[category_tree::get_mapped_trees $package_id] ne ""} {
    category::ad_form::add_widgets -container_object_id $package_id -form_name catalog_search

    ad_form -extend -name catalog_search -form {
	{join:text(radio),optional {label "[_ assessment.Categories_combine]"} {options $combine_options} {help_text "[_ assessment.categories_combine_help]"}}
	{subtree_p:text(radio),optional {label "[_ assessment.Categorization]"} {options $subtree_options} {help_text "[_ assessment.Categorization_help]"}}
    }
}

ad_form -extend -name catalog_search -form {
    {keywords:text,optional,nospell {label "[_ assessment.Keywords]"} {html {size 80 maxlength 500}} {help_text "[_ assessment.Keywords_help]"}}
    {letter:text(select),optional {label "[_ assessment.Letter]"} {options $letter_options} {help_text "[_ assessment.Letter_help]"}}
    {search_again_url:text(hidden) {value "[ad_return_url]"}}
}

if {[info exists section_id]} {
    set item_types [list [list "[_ assessment.Letter_all]" ""]]
    foreach one_item_type [db_list item_types {}] {
	lappend item_types [list "[_ assessment.item_type_$one_item_type]" $one_item_type]
    }
    ad_form -extend -name catalog_search -form {
	{itype:text(select),optional {label "[_ assessment.Item_Type]"} {options $item_types} {help_text "[_ assessment.Item_Type_help]"}}
    }
}

ad_form -extend -name catalog_search -edit_request {
    set join or
    set subtree_p f
    set keywords ""
    set letter and
    set itype ""
} -on_submit {
    set category_ids [category::ad_form::get_categories -container_object_id $package_id]
} -after_submit {
    # now go to item-type specific form (i.e. multiple choice)
    ad_returnredirect [export_vars -base catalog-browse {assessment_id section_id after category_ids:multiple join subtree_p keywords letter itype search_again_url}]
    ad_script_abort
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
