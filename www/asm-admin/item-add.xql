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

<fullquery name="update_name">
      <querytext>

    update cr_items
    set name = :name
    where latest_revision = :as_item_id

      </querytext>
</fullquery>

<fullquery name="delete_files">
      <querytext>

    delete from as_item_rels
    where item_rev_id = :as_item_id
    and rel_type = 'as_item_content_rel'

      </querytext>
</fullquery>

</queryset>
