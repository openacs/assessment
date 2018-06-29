ad_page_contract {

    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @creation-date 2005-01-13

    This page allows to swap action up and down
} {
    section_id:naturalnum,notnull
    check_id:naturalnum,notnull
    action_perform
    order_by:integer
    direction
    assessment_id:naturalnum,notnull
}

permission::require_permission \
    -object_id $assessment_id \
    -party_id [ad_conn user_id] \
    -privilege "admin"

as::assessment::check::swap_actions \
    -check_id $check_id \
    -action_perform $action_perform \
    -section_id $section_id \
    -direction $direction \
    -order_by $order_by


ad_returnredirect [export_vars -base checks-admin {assessment_id section_id}]
ad_script_abort

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
