<?xml version="1.0"?>
<queryset>

<fullquery name="item_type_data">
<querytext>

    select c.title, t.increasing_p, t.allow_negative_p, t.num_correct_answers, t.num_answers,
           max(t.as_item_type_id) as as_item_type_id
    from as_item_type_mc t, cr_revisions c, as_item_rels r
    where t.as_item_type_id = r.target_rev_id
    and r.item_rev_id = :as_item_id
    and r.rel_type = 'as_item_type_rel'
    and c.revision_id = t.as_item_type_id
    group by c.title, t.increasing_p, t.allow_negative_p,
           t.num_correct_answers, t.num_answers
</querytext>
</fullquery>

<fullquery name="item_type_id">
<querytext>

    select max(t.as_item_type_id) as as_item_type_id
    from as_item_type_mc t, cr_revisions c, as_item_rels r
    where t.as_item_type_id = r.target_rev_id
    and r.item_rev_id = :as_item_id
    and r.rel_type = 'as_item_type_rel'
    and c.revision_id = t.as_item_type_id
    group by c.title, t.increasing_p, t.allow_negative_p,
    t.num_correct_answers, t.num_answers
</querytext>
</fullquery>

<fullquery name="get_choices">
      <querytext>

    select r.title, r.item_id
    from as_item_choices c, cr_revisions r
    where r.revision_id = c.choice_id
    and c.mc_id = :as_item_type_id
    order by c.sort_order

      </querytext>
</fullquery>

<fullquery name="get_question">
<querytext>
   select title 
   from cr_revisions 
   where revision_id = :as_item_id
</querytext>
</fullquery>

<fullquery name="get_check_properties">
<querytext>
	select * from as_inter_item_checks where inter_item_check_id=:inter_item_check_id
</querytext>
</fullquery>

<fullquery name="update_check">
<querytext>
	update as_inter_item_checks set name=:name,section_id_from=:section_id_from,action_p=:action_p,postcheck_p=:postcheck_p,check_sql=:check_sql where inter_item_check_id=:inter_item_check_id
</querytext>
</fullquery>

<fullquery name="get_item_id">
<querytext>
	select check_sql from as_inter_item_checks where inter_item_check_id = :inter_item_check_id
</querytext>
</fullquery>

<fullquery name="get_item_sec_id">
<querytext>
  select item_id from cr_revisions where revision_id=:section_id

</querytext>
</fullquery>


</queryset>
