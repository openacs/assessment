<center>
<table>
 <if @type_check@ eq t>
      <tr><td><b>#assessment.trigger# #assessment.Name#</td><td><b>#assessment.action# #assessment.related# </td>
          <td><b>#assessment.parameters# #assessment.related#</td></tr>
 </if>
 <else>
      <tr><td><b>#assessment.trigger# #assessment.Name#</td><td><b>#assessment.section_to_branch#</td></tr>
 </else>
       @display_info;noquote@
</table>

