
<property name="context">{/doc/assessment {Assessment}} {Item Types and Item Display Types}</property>
<property name="doc(title)">Item Types and Item Display Types</property>
<master>
<h2><span class="context">Overview</span></h2>
<p><span class="context">What to do to add new item types or item
display types:</span></p>
<ul>
<li><span class="context">add new table to
assessment-item-types-create.sql</span></li><li><span class="context">add entry to matrix table item_type -&gt;
display_type in assessment-types-create.sql</span></li><li><span class="context">add content type data to
tcl/as-install-procs.tcl. adhere to the naming
standards!!</span></li><li><span class="context">add tcl procs to
tcl/as-item-type-$$-procs or tcl/as-item-display-$$-procs with
::new, ::edit, ::copy procs. adhere to naming
standards!!</span></li><li><span class="context">add admin pages to add new instance:
www/admin/item-add-$$ or www/admin/item-add-display-$$</span></li><li><span class="context">add admin pages to edit new instance:
www/admin/item-edit-$$ or
www/admin/item-edit-display-$$</span></li><li><span class="context">add pages to display data:
lib/item-show-$$ or lib/item-show-display-$$</span></li>
</ul>
