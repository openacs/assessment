--
-- Reduce dependency on acs_permissions_all
--
UPDATE as_action_params
SET query = 'select pretty_name,community_id from dotlrn_communities from dotlrn_communities where acs_permission.permission_p(community_id, :user_id, ''read'')'
WHERE varname = 'community_id';

