<formtemplate id="session_results_@section_id@">
    <if @items:rowcount@ eq 0>
      #assessment.not_answered#
    </if>

    <multiple name="items">
<if @admin_p;literal@ true><p><a href="@items.item_edit_general_url@">Edit this question</a></p></if>
<if @feedback_only_p;literal@ false or @items.has_feedback_p;literal@ true>
     <if @show_item_name_p;literal@ true><p style="font-weight:bold;">@items.name@:</p></if>
      <if @survey_p;literal@ false and @items.as_item_id@ ne @items.next_as_item_id@>
	<if @items.max_time_to_complete@ not nil> (#assessment.max_time# @items.max_time_to_complete@) </if>
      </if>
     </if>
<div class="feedback-message"><if @items.correct_p;literal@ true>
<if @show_feedback@ eq correct or @show_feedback@ eq all><if @items.feedback_right@ ne ""><div class="right">@items.feedback_right;noquote@</div></if></if></if>
	    <if @items.correct_p;literal@ false><if @show_feedback@ eq all or @show_feedback@ eq incorrect><if @items.feedback_wrong@ ne ""><div class="wrong">@items.feedback_wrong;noquote@</div></if></if></if>
</div>
	  <if @items.presentation_type@ ne fitb>
	     @items.content;noquote@
	</if>
	    <group column=as_item_id>
	      @items.description;noquote@
		<if @survey_p;literal@ false>
		  <if @items.as_item_id@ eq @items.next_as_item_id@ or @items.groupnum@ gt 1>
		    <if @items.presentation_type@ eq @items.next_pr_type@ or @items.choice_orientation@ eq horizontal>

			    <if @show_feedback@ ne none>
			      <if @items.feedback@ not nil>:<br>@items.feedback;noquote@</if>
			    </if>
		      <!--- fixme --->
		      <else>
			<if @items.answered_p;literal@ true><p style="font-weight:bold;">#assessment.not_yet_reviewed#</p> </if>
			<else><p style="font-weight:bold;">#assessment.not_answered#</p></else>
		      </else>
		      <if @edit_p;literal@ true and @items.answered_p;literal@ true><a href="@items.results_edit_url@">#assessment.Edit#</a></if>
		      <include src="/packages/assessment/lib/results-messages" session_id="@session_id;literal@" section_id="@section_id;literal@" as_item_id="@items.as_item_id;literal@">
		    </if>
		    <else>
		      <if @items.answered_p;literal@ true><p style="font-weight:bold">#assessment.not_yet_reviewed#</p> </if>
		      <else><p style="font-weight:bold">#assessment.not_answered#</p> </else>
		    </else>
		    <if @edit_p;literal@ true and @items.answered_p;literal@ true>
              <a href="@items.results_edit_url@">#assessment.Edit#</a>
            </if>
		    <include src="/packages/assessment/lib/results-messages" session_id="@session_id;literal@" section_id="@section_id;literal@" as_item_id="@items.as_item_id;literal@">
		  </if>
		</if>
	      <if @items.presentation_type@ eq rb or @items.presentation_type@ eq cb>
		  <if @items.choice_orientation@ ne horizontal>
		    <formgroup id="response_to_item.@items.as_item_id@">
		      <div>@formgroup.widget;noquote@ @formgroup.label;noquote@</div>
		    </formgroup>
		  </if>
		  <elseif @items.as_item_id@ ne @items.next_as_item_id@ and @items.groupnum@ eq 1>
		    <formgroup id="response_to_item.@items.as_item_id@">
		      @formgroup.widget;noquote@ @formgroup.label;noquote@
		    </formgroup>
		    <br>
		  </elseif>
		  <else>
		    <formgroup id="response_to_item.@items.as_item_id@">
		      @formgroup.widget;noquote@ @formgroup.label;noquote@
		    </formgroup>
        </else>
	</if>
	  <elseif @items.presentation_type@ eq fitb>
	    @items.html;noquote@
	  </elseif>
	  <elseif @items.presentation_type@ eq f>
  	    <a href="@items.view@" id="p-type-f-@items.as_item_id"><formwidget id="response_to_item.@items.as_item_id@"></a>
	  </elseif>
	  <else>
	    <div><formwidget id="response_to_item.@items.as_item_id@"></div>
	  </else>
	  <if @items.subtext@ not nil>
	    <div class="form-help-text">
	      <img src="/shared/images/info.gif" width="12" height="9" alt="[i]" title="Help text" border="0">
		<noparse>@items.subtext@</noparse>
	    </div>
	  </if>
    </group>

  <include src="/packages/assessment/lib/results-messages" session_id="@session_id;literal@" section_id="@section_id;literal@" as_item_id="@items.as_item_id;literal@" &=assessment>
  <if @edit_p;literal@ true and @items.answered_p;literal@ true>
    <p><a href="@items.results_edit_url@" class="button">#assessment.Add_Comment#</a></p>
  </if>
  <if @feedback_only_p;literal@ false and @assessment_data.type@ ne survey and @items.result_points@ not nil and @showpoints@ true and @items.points@ gt 0>
    <p style="font-weight: bold">@items.result_points@ / @items.points@ #assessment.points#</p>
  </if>

<hr>
</multiple>

</formtemplate>
