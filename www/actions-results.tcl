ad_page_contract {
    
    Shows the actions performed for this session

    @author Anny Flores (annyflores@viaro.net)
    @date_created 2005-01-21
} {
    session_id
}


db_multirow actions get_actions {select * from as_actions_log al, as_action_map am, as_actions a where al.session_id=:session_id and al.inter_item_check_id=am.inter_item_check_id and am.action_id=a.action_id}