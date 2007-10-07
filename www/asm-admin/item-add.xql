<?xml version="1.0"?>
<queryset>

<fullquery name="item_types">
      <querytext>

    select distinct item_type
    from as_item_types_map

      </querytext>
</fullquery>

<fullquery name="item_exists">
      <querytext>

    select latest_revision as as_item_id
    from cr_items
    where item_id = :as_item_id

      </querytext>
</fullquery>

<fullquery name="delete_files">
      <querytext>

    delete from as_item_rels
    where item_rev_id = :as_item_id
    and rel_type = 'as_item_content_rel'

      </querytext>
</fullquery>


<fullquery name="existing_choice_sets">
      <querytext>
    select distinct title, revision_id from (select substr(title,1,50) as title, revision_id 
    from cr_items i, cr_revisions r
    where 
    i.parent_id = :folder_id
    and r.title is not NULL
    and r.revision_id = i.latest_revision
    and i.content_type = 'as_item_type_mc') c
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
		set target_rev_id = :add_existing_mc_id
		where item_rev_id = :as_item_id
		and rel_type = 'as_item_type_rel'

      </querytext>
</fullquery>

</queryset>
