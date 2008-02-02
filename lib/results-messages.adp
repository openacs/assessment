<if @results:rowcount@ gt 0>
  <ul>
    <multiple name="results">
      <li>@results.description@ <if @results.session_id@ eq @session_id@>#assessment.Results_change_display#</if><else>#assessment.Results_change_display_previous#</else></li>
    </multiple>
  </ul>
</if>
