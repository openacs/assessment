<if @results:rowcount@ gt 0>
  <ul>
    <multiple name="results">
      <li><if @results.title@ not nil><i>@results.title@</i><br></if>
          @results.description@<br>
          <b>@results.points@ #assessment.points#</b> #assessment.Results_change_display#</li>
    </multiple>
  </ul><br>
</if>
