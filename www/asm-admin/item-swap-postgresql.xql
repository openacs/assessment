<?xml version="1.0"?>
<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>



<fullquery name="swap_items">
      <querytext>
update as_item_section_map
set sort_order = (case when sort_order = (cast (:sort_order as integer)) then
      cast (:next_sort_order as integer)
      when 
sort_order = (cast (:next_sort_order as integer)) then cast (:sort_order as integer) end)
where section_id = :new_section_id
and sort_order in (:sort_order, :next_sort_order)
      </querytext>
</fullquery>

 
</queryset>
