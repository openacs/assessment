<formtemplate id="session_results_@section_id@">
  <table cellspacing=0>
    <if @items:rowcount@ eq 0>
      <tr><td>#assessment.not_answered#</td></tr>
    </if>

    <multiple name="items">
      <if @feedback_only_p@ eq 0 or @items.has_feedback_p@ eq 1>

      <tr>
	
	<td valign="top"><if @show_item_name_p@ eq t><b>@items.name@:</b></if></td>
	<td>&nbsp;</td></tr>

      <tr>

	<td>
	  <if @survey_p@ ne t and @items.title@ ne @items.next_title@>
	    <if @items.max_time_to_complete@ not nil> (#assessment.max_time# @items.max_time_to_complete@) </if>
	    <if @items.result_points@ not nil><if @showpoints@ eq 1><b>@items.result_points@ / @items.points@ #assessment.points#</if>
	      <if @show_feedback@ ne none>
		<if @items.feedback@ not nil>: @items.feedback;noquote@</if>
	      </if>
	    </b>
	    </if>
	    <else>
	      <if @items.answered_p@ eq t><b>#assessment.not_yet_reviewed#</b> </if>
	      <else><b>#assessment.not_answered#</b> </else>
	    </else>
	    <if @edit_p@ eq 1 and @items.answered_p@ eq t><a href="results-edit?session_id=@session_id@&section_id=@section_id@&as_item_id=@items.as_item_id@">#assessment.Edit#</a></if>
	    <include src="/packages/assessment/lib/results-messages" session_id="@session_id@" section_id="@section_id@" as_item_id="@items.as_item_id@">
	  </if>
	</td><td>&nbsp;</td></tr>

      <tr>
	<td>
	  <if @items.presentation_type@ ne fitb>
	    <b>@items.title;noquote@</b>
	    @items.content;noquote@
	</td><td>
	  <if @items.title@ ne @items.next_title@>
	</td></tr>

      <tr>
	<td colspan=2>
	</if>
	</if>
	  <table>
	    <group column=title>
	      <td valign=top>@items.description;noquote@
		<if @survey_p@ ne t>
		  <if @items.title@ eq @items.next_title@ or @items.groupnum@ gt 1>
		    <if @items.presentation_type@ eq @items.next_pr_type@ or @items.choice_orientation@ eq horizontal>
		      <if @items.result_points@ not nil><br><b>@items.result_points@ / @items.points@ #assessment.points#
			    <if @show_feedback@ ne none>
			      <if @items.feedback@ not nil>:<br>@items.feedback;noquote@</if>
			    </if>
			  </b>
		      </if>
		      <else>
			<if @items.answered_p@ eq t><br><b>#assessment.not_yet_reviewed#</b> </if>
			<else><br><b>#assessment.not_answered#</b> </else>
		      </else>
		      <if @edit_p@ eq 1 and @items.answered_p@ eq t><a href="results-edit?session_id=@session_id@&section_id=@section_id@&as_item_id=@items.as_item_id@">#assessment.Edit#</a></if>
		      <include src="/packages/assessment/lib/results-messages" session_id="@session_id@" section_id="@section_id@" as_item_id="@items.as_item_id@">
		    </if>
		    <else>
		      <if @items.answered_p@ eq t><br><b>#assessment.not_yet_reviewed#</b> </if>
		      <else><br><b>#assessment.not_answered#</b> </else>
		    </else>
		    <if @edit_p@ eq 1 and @items.answered_p@ eq t><a href="results-edit?session_id=@session_id@&section_id=@section_id@&as_item_id=@items.as_item_id@">#assessment.Edit#</a></if>
		    <include src="/packages/assessment/lib/results-messages" session_id="@session_id@" section_id="@section_id@" as_item_id="@items.as_item_id@"> 
		  </if>
		</if>
	      </td>
	      <if @items.presentation_type@ eq rb or @items.presentation_type@ eq cb>
		<fieldset class="radio">
		  <if @items.choice_orientation@ ne horizontal>
		    <formgroup id="response_to_item.@items.as_item_id@">
		      @formgroup.widget;noquote@ @formgroup.label;noquote@<br>
		    </formgroup>
		  </if>
		  <elseif @items.title@ ne @items.next_title@ and @items.groupnum@ eq 1>
		    <formgroup id="response_to_item.@items.as_item_id@">
		      @formgroup.widget;noquote@ @formgroup.label;noquote@
		    </formgroup>
		    <br>
		  </elseif>
		  <else>
		    <formgroup id="response_to_item.@items.as_item_id@">
		      @formgroup.widget;noquote@ @formgroup.label;noquote@
		    </formgroup>
      </tr><tr><td></td><td colspan=10>
        </else>
	</fieldset>
	</if>
	  <elseif @items.presentation_type@ eq fitb>
	    <td>@items.html;noquote@ 
	  </elseif>
	  <elseif @items.presentation_type@ eq f>
	    <a href= "@items.view@" onclick= "var w=window.open(this.href, 'newWindow', 'width=650,height=400'); return !w;"><formwidget id="response_to_item.@items.as_item_id@"></a>
	  </elseif>
	  <else>
	    <td colspan=10><formwidget id="response_to_item.@items.as_item_id@">
	  </else>
	  <if @items.subtext@ not nil>
	    <div class="form-help-text">
	      <img src="/shared/images/info.gif" width="12" height="9" alt="[i]" title="Help text" border="0">
		<noparse>@items.subtext@</noparse>
	    </div>
	  </if>
	</td></tr>
    </group></table>
</td></tr>
</if>
</multiple>
</table>      
</formtemplate>
