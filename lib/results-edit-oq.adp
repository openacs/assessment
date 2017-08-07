<table>
  <tr><th>#assessment.User_Answer#</th><th>&nbsp;&nbsp;</th>
      <th><if @refereence_naswer@ not nil>#assessment.oq_Reference_Answer#</if></th></tr>
  <tr><td>@answer_text;noquote@</td><td>&nbsp;</td>
      <td>@reference_answer@</td></tr>
</table>
<if @keywords@ not nil><p><strong>#assessment.oq_Keywords#:</strong>
<pre>@keywords@</pre></if>
