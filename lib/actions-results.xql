<?xml version="1.0"?>
<queryset>

<fullquery name="get_actions">
<querytext>

    select *
    from as_actions_log al, as_action_map am, as_actions a
    where al.session_id=:session_id
    and al.inter_item_check_id=am.inter_item_check_id
    and am.action_id=a.action_id

</querytext>
</fullquery>

</queryset>
