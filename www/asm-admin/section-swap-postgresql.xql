<?xml version="1.0"?>
<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="swap_sections">
      <querytext>

update as_assessment_section_map
set sort_order = (case when sort_order = (cast (:sort_order as integer)) then
      cast (:next_sort_order as integer)
      when 
sort_order = (cast (:next_sort_order as integer)) then cast (:sort_order as integer) end)
where assessment_id = :new_assessment_rev_id
and sort_order in (:sort_order, :next_sort_order)

      </querytext>
</fullquery>

</queryset>
