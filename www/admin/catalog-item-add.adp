<master>
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>


<h3>#assessment.Items#</h3>

<formtemplate id="show_items">
<table cellspacing=0>
<if @items:rowcount@ eq 0>
</if>

<multiple name="items">

  <if @items.rownum@ odd>
    <tr class="odd">
  </if>
  <else>
    <tr class="even">
  </else>

<td valign="top">@items.rownum@.</td>

<td colspan="3">
  <blockquote>
    <if @items.presentation_type@ ne fitb>@items.title;noquote@<br></if>
    <if @items.presentation_type@ eq radio or @items.presentation_type@ eq checkbox>
      <formgroup id="response_to_item.@items.as_item_id@">
        @formgroup.widget;noquote@ @formgroup.label;noquote@<br>
      </formgroup>
    </if>
    <elseif @items.presentation_type@ eq fitb>
      @items.html;noquote@
    </elseif>
    <else>
      <formwidget id="response_to_item.@items.as_item_id@">
    </else>
  </blockquote>
</td></tr>

</multiple>
</table>      
</formtemplate>

<formtemplate id="catalog_item_add"></formtemplate>
