<?xml version="1.0"?>
<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="swap_items">
      <querytext>
update as_item_section_map
set sort_order = (case when sort_order = :sort_order then :next_sort_order when sort_order = :next_sort_order then :sort_order end)
where section_id = :new_section_id
and sort_order in (:sort_order, :next_sort_order)
      </querytext>
</fullquery>

 
</queryset>
