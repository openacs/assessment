<table>
  <tr><th>#assessment.User_Answer#</th><th>&nbsp;&nbsp;</th>
      <th>#assessment.oq_Reference_Answer#</th></tr>
  <tr><td>
    <formtemplate id="results_edit_mc_user">
      <if @presentation_type@ eq rb or @presentation_type@ eq cb>
        <formgroup id="response_to_item.@as_item_id@">
          @formgroup.widget;noquote@ @formgroup.label;noquote@<br>
        </formgroup>
      </if>
      <else>
        <formwidget id="response_to_item.@as_item_id@">
      </else>
    </formtemplate>
  </td><td>&nbsp;</td><td>
    <formtemplate id="results_edit_mc_reference">
      <if @presentation_type@ eq rb or @presentation_type@ eq cb>
        <formgroup id="response_to_item.@as_item_id@">
          @formgroup.widget;noquote@ @formgroup.label;noquote@<br>
        </formgroup>
      </if>
      <else>
        <formwidget id="response_to_item.@as_item_id@">
      </else>
    </formtemplate>
  </td></tr>
</table>
