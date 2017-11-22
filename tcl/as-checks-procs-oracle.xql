<?xml version="1.0"?>
<queryset>

<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="as::assessment::check::action_log.get_next_val">
      <querytext>
      select action_log_id_seq.nextval from dual
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::manual_action_log.get_next_val">
      <querytext>
	      select action_log_id_seq.nextval from dual
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::delete_assessment_checks.delete_checks">
      <querytext>
	begin
	 as_inter_item_check.del(:check_id);
	end;
      </querytext>
</fullquery>

<fullquery name="as::assessment::check::delete_item_checks.delete_check">
      <querytext>
	begin
	 as_inter_item_check.del(:check_id);
	end;
      </querytext>
</fullquery>

</queryset>
