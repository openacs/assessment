<center>
<table>
 <if @type_check@ eq t>
      <tr><td><strong>#assessment.trigger# #assessment.Name#</td><td><strong>#assessment.action# #assessment.related# </td>
          <td><strong>#assessment.parameters# #assessment.related#</td></tr>
 </if>
 <else>
      <tr><td><strong>#assessment.trigger# #assessment.Name#</td><td><strong>#assessment.section_to_branch#</td></tr>
 </else>
       @display_info;noquote@
</table>

