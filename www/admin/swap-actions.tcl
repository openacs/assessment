ad_page_contract {
    
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @date-created 2005-01-13
    
    This page allows to swap action up and down
} {
    section_id:integer
    check_id:integer
    action_perform
    order_by:integer
    direction
    assessment_id:integer
}
as::assessment::check::swap_actions -check_id $check_id -action_perform $action_perform -section_id $section_id -direction $direction -order_by $order_by


ad_returnredirect "checks-admin?assessment_id=$assessment_id&section_id=$section_id"