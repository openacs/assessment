<center>
<table>
 <if @type_check@ eq t>
      <tr><td><b> Trigger Name</td><td><b> Action Related </td><td><b>Parameters Related</td></tr>
 </if>
 <else>
      <tr><td><b> Trigger Name</td><td><b> Section to Branch </td></tr>
 </else>
       @display_info;noquote@
</table>

