<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN"
"http://www.thecodemill.biz/repository/xql.dtd">
<!--  -->
<!-- @author Dave Bauer (dave@thedesignexperience.org) -->
<!-- @creation-date 2005-05-15 -->
<!-- @arch-tag: 32f31df3-14ba-4494-b6b7-2bd22569a2f9 -->
<!-- @cvs-id $Id$ -->

<queryset>
  <fullquery name="get_trees">
    <querytext>
      select ctt.name, ctt.tree_id
      from category_tree_translations ctt, category_trees ct
      where ctt.tree_id=ct.tree_id
      and ctt.locale=:locale
    </querytext>
  </fullquery>

  
<fullquery name="item_type">
      <querytext>

	select r.target_rev_id as as_item_type_id, o.object_type
	from as_item_rels r, acs_objects o
	where r.item_rev_id = :as_item_id
	and r.rel_type = 'as_item_type_rel'
	and o.object_id = r.target_rev_id

      </querytext>
</fullquery>

<fullquery name="update_item_type">
      <querytext>

		update as_item_rels
		set target_rev_id = :as_item_type_id
		where item_rev_id = :as_item_id
		and rel_type = 'as_item_type_rel'

      </querytext>
</fullquery>
  
</queryset>