<?xml version="1.0"?>
<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="swap_choices">
      <querytext>
update as_item_choices
set sort_order = (case when sort_order = (cast (:sort_order as integer)) then
      cast (:next_sort_order as integer)
      when 
sort_order = (cast (:next_sort_order as integer)) then cast (:sort_order as integer) end)
where mc_id = :new_mc_id
and sort_order in (:sort_order, :next_sort_order)
      </querytext>
</fullquery>

 
</queryset>
