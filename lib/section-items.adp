    <formtemplate id="admin_section_@section_id@">
      <div class="action-list">
      <ul>
      <if @items:rowcount@ eq 0>
          <li><a class="button" href="@item_add_new_url@">#assessment.Add_New#</a></li>
          <li><a class="button" href="@catalog_search_url@">#assessment.Search_Item#</a></li>
      </if>
        
        <li><a class="button" href="@item_add_top_url@">#assessment.lt_Insert_new_question_h#</a></li>
        </ul>

      </div>

      <multiple name="items">

	<div class="section-item">

	  <a name="Q@items.as_item_id@">
	  </a>
	  <h4>#assessment.Question_Number#</h4>
	  <if @items.presentation_type@ ne fitb>
	    <p>@items.question_text;noquote@</p>
	    <if @items.description@ not nil>@items.description;noquote@<br></if>
	  </if>
	  <if @items.presentation_type@ eq rb or @items.presentation_type@ eq cb>
	    <if @items.choice_orientation@ ne horizontal>
	      <formgroup id="response_to_item.@items.as_item_id@">
		@formgroup.widget;noquote@ @formgroup.label;noquote@<br>
	      </formgroup>
	    </if>
	    <else>
	      <formgroup id="response_to_item.@items.as_item_id@">
		@formgroup.widget;noquote@ @formgroup.label;noquote@
	      </formgroup>
	      <br>
	    </else>
	  </if>
	  <elseif @items.presentation_type@ eq fitb>
	    @items.html;noquote@
	  </elseif>
	  <else>
	    <formwidget id="response_to_item.@items.as_item_id@">
	  </else>
	  <if @items.subtext@ not nil>
	    <div class="form-help-text">
	      <img src="/shared/images/info.gif" width="12" height="9" alt="[i]" title="Help text" border="0" />
		<noparse>@items.subtext@</noparse>
	    </div>
	  </if>

	  <p>
	    <if @items.max_time_to_complete@ not nil> (#assessment.max_time# @items.max_time_to_complete@) </if>
	    (@items.points@ #assessment.points#) 
	    <if @items.item_type@ eq "mc" and @admin_trigger_p@>
            <a class="button" href="@items.add_edit_check_url@">#assessment.add_trigger#</a> 
            (<a href="@items.checks_admin_url@">@items.checks_related@</a>)<img src="/resources/assessment/spacer.gif" style="border:0" alt="" width="10">
	    </if>
	  </p>
	  <p>
	    <if @assessment_data.type@ ne 1>
	      <a class="button" href="@items.item_edit_url@" title="#assessment.Edit#">#assessment.Edit#</a>
	      <a class="button" href="@items.item_copy_url@" title="#assessment.Copy#">#assessment.Copy#</a>
	      <a class="button" href="@items.item_delete_url@" title="#assessment.remove_item#">#assessment.remove_item#</a>
	    </if>
	    <if @items.rownum@ lt @items:rowcount@>
	      <a href="@items.item_swap_down_url@">
		<img src="/resources/assessment/down.gif" style="border:0" alt="#assessment.Move_Down#">
	      </a>
	    </if>
	    <if @items.rownum@ gt 1>
	      <a href="@items.item_swap_down_url@">
		<img src="/resources/assessment/up.gif" style="border:0" alt="#assessment.Move_Up#">
	      </a>
	    </if>
	  </p>
	</div>

    <p><a class="button" href="@items.item_add_url@">#assessment.lt_Insert_new_question_h#</a></p>

      </multiple>

    </formtemplate>
