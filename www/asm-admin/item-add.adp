  <master>
    <property name="title">@page_title;noquote@</property>
    <property name="context">@context;noquote@</property>
    <property name="body(class)">yui-skin-sam</property>
    <h1>#assessment.Add_Question#</h1>
    <formtemplate id="item-add">
      <!-- wrap the form item in the form-item-wrapper class -->
      <div class="form-item-wrapper form-item-wrapper-asm">
	<if @formerror.question_text@ not nil>
	  <div class="form-label form-label-error">
	    <if richtext in radio checkbox date inform>
	      #assessment.Question#
	    </if>
	    <else>
	      <label for="question_text">#assessment.Question#</label>
	    </else>
	</if>
	<else>
	  <div class="form-label">
	    <if edit eq display or richtext in radio checkbox date inform>
	      #assessment.Question#
	    </if>
	    <else>
	      <label for="question_text">#assessment.Question#</label>
	    </else>
	</else>
	<div class="form-required-mark">
	  <br />#assessment.required#
	</div>
      </div>
      <!-- /form-label or /form-error -->
      <if @formerror.question_text@ not nil>
	<div class="form-widget form-widget-error">
      </if>
      <else>
	<div class="form-widget">
      </else>
      <formwidget id="question_text" />
      </div>
	<!-- /form-widget -->
	<formerror id="question_text">
	  <div class="form-error">
	    @formerror.question_text;noquote@
	  </div>
	  <!-- /form-error -->
	</formerror>
	<div class="form-help-text">
	  <img src="/shared/images/info.gif" width="12" height="9" alt="[i]" title="Help text" border="0" />
	    <formhelp id="question_text" />
	</div>
	<!-- /form-help-text -->
      </div>
	<!-- wrap the form item in the form-item-wrapper-asm class -->
	<div class="form-item-wrapper form-item-wrapper-asm">
	  <if @formerror.required_p@ not nil>
	    <div class="form-label form-label-error">
	      <if select in radio checkbox date inform>
		#assessment.Answer_Required#
	      </if>
	      <else>
		<label for="required_p">#assessment.Answer_Required#</label>
	      </else>
	  </if>
	  <else>
	    <div class="form-label">
	      <if edit eq display or select in radio checkbox date inform>
		#assessment.Required#
	      </if>
	      <else>
		<label for="required_p">#assessment.Answer_Required#</label>
	      </else>
	  </else>
	  <div class="form-required-mark">
	    <br />#assessment.required#
	  </div>
	</div>
	<!-- /form-label or /form-error -->
	<if @formerror.required_p@ not nil>
	  <div class="form-widget form-widget-error">
	</if>
	<else>
	  <div class="form-widget">
	</else>
	<formwidget id="required_p" />
	</div>
	  <!-- /form-widget -->
	  <formerror id="required_p">
	    <div class="form-error">
	      @formerror.required_p;noquote@
	    </div>
	    <!-- /form-error -->
	  </formerror>
	  <div class="form-help-text">
	    <img src="/shared/images/info.gif" width="12" height="9" alt="[i]" title="Help text" border="0" />
	      <formhelp id="required_p" />
	  </div>
	  <!-- /form-help-text -->
	</div>
       <if @type@ ne "survey">
	    <formwidget id="field_name" />
	    <formwidget id="validate_block" />
	  <div class="form-item-wrapper form-item-wrapper-asm">
	    <if @formerror.points@ not nil>
	      <div class="form-label form-label-error">
		<if text in radio checkbox date inform>
		  #assessment.Points#
		</if>
		<else>
		  <label for="points">#assessment.Points#</label>
		</else>
	    </if>
	    <else>
	      <div class="form-label">
		<if edit eq display or text in radio checkbox date inform>
		  #assessment.Points#
		</if>
		<else>
		  <label for="points">#assessment.Points# </label>
		</else>
	    </else>
	  </div>
	  <!-- /form-label or /form-error -->
	  <if @formerror.points@ not nil>
	    <div class="form-widget form-widget-error">
	  </if>
	  <else>
	    <div class="form-widget">
	  </else>
	  <formwidget id="points" />
	  </div>
	    <!-- /form-widget -->
	    <formerror id="points">
	      <div class="form-error">
		@formerror.points;noquote@
	      </div>
	      <!-- /form-error -->
	    </formerror>
	    <div class="form-help-text">
	      <img src="/shared/images/info.gif" width="12" height="9" alt="[i]" title="Help text" border="0" />
		<formhelp id="points" />
	    </div>
	    <!-- /form-help-text -->
	  </div>
       </if>
       <else>
       	  <!-- wrap the form item in the form-item-wrapper-asm class -->
	  <div class="form-item-wrapper form-item-wrapper-asm">
            <div class="form-label form-label-error">
            <label for="field_name">Field Name</label>
            </div>
            <div class="form-widget"><formwidget id="field_name" /></div>
            <div class="form-label form-label-error">
            <label for="field_name">Validate Block</label>
            </div>
            <div class="form-widget"><formwidget id="validate_block" /></div>
	    <formwidget id="points" />
     </else>
	  <div class="form-item-wrapper form-item-wrapper-asm">
	    <formwidget id="field_code" />
            <formwidget id="max_time_to_complete" />
	    <formwidget id="content" />
	    <formwidget id="description" />
	    <formwidget id="data_type" />
         </div>
			  <!-- wrap the form item in the form-item-wrapper-asm class -->
			  <div class="form-item-wrapper form-item-wrapper-asm">
			    <if @formerror.item_type@ not nil>
			      <div class="form-label form-label-error">
				<if radio in radio checkbox date inform>
				  #assessment.lt_Question_Type_and_Ans#
				</if>
				<else>
				  <label for="item_type">#assessment.lt_Question_Type_and_Ans#</label>
				</else>
			    </if>
			    <else>
			      <div class="form-label">
				<if edit eq display or radio in radio checkbox date inform>
				  <label for="item_type">#assessment.lt_Question_Type_and_Ans#</label>
				</if>
				<else>
				  <label for="item_type">#assessment.lt_Question_Type_and_Ans#</label>
				</else>
			    </else>
			    <div class="form-required-mark">
			      <br />#assessment.required#
			    </div>
			  </div>
			  <!-- /form-label or /form-error -->
			  <if @formerror.item_type@ not nil>
			    <div class="form-widget form-widget-error">
			  </if>
			  <else>
			    <div class="form-widget">
			  </else>
			  <formgroup id="item_type">
			    @formgroup.widget;noquote@
			    <label for="item-add:elements:item_type:@formgroup.option@">
			      @formgroup.label;noquote@
			    </label>
			    <br/>
			  </formgroup>
			</div>
			  <!-- /form-widget -->
			  <formerror id="item_type">
			    <div class="form-error">
			      @formerror.item_type;noquote@
			    </div>
			    <!-- /form-error -->
			  </formerror>
			  <div class="form-help-text">
			    <formhelp id="item_type" />
			  </div>
			  <!-- /form-help-text -->
			  <div id="mc-options" class="<if @item_type@ not nil>
			    <if @item_type@ eq "mc" or @item_type@ eq "ms" or @item_type@ eq "sb">is-visible</if>
			    <else>not-visible</else>
			  </if>
			    <else>not-visible</else>">
			    <formwidget id="num_choices" />
			      <if @formerror.add_existing_mc_id@ not nil>
				<div class="form-label form-label-error">
				  <if select in radio checkbox date inform>
                                    #assessment.Answer_Set#
                                  </if>
				  <else>
				    <label for="add_existing_mc_id">#assessment.Answer_Set#</label>
				  </else>
			      </if>
			      <else>
				<div class="form-label">
				  <if edit eq display or select in radio checkbox date inform>
                                    #assessment.Answer_Set#
                                  </if>
				  <else>
				    <label for="add_existing_mc_id">#assessment.Answer_Set#</label>
				  </else>
			      </else>
			  </div>
			  <!-- /form-label or /form-error -->
			  <if @formerror.add_existing_mc_id@ not nil>
			    <div class="form-widget form-widget-error">
			  </if>
			  <else>
			    <div class="form-widget">
			  </else>
			  <formwidget id="add_existing_mc_id" />
			  </div>
			    <!-- /form-widget -->
			    <formerror id="add_existing_mc_id">
			      <div class="form-error">
				@formerror.add_existing_mc_id;noquote@
			      </div>
			      <!-- /form-error -->
			    </formerror>
			    <div class="form-help-text">
			      <img src="/shared/images/info.gif" width="12" height="9" alt="[i]" title="Help text" border="0" />
				<formhelp id="add_existing_mc_id" />
			    </div>
			    <!-- /form-help-text -->
			    <div class="form-element-wrapper">
			      <multiple name="choice_elements">
				<div class="form-item-wrapper form-item-wrapper-asm" style="border: none;">
				  <div class="form-label">
				    <label for="choice.@choice_elements.id@">#assessment.lt_Choice_choice_element#</label>
				  </div>
				  <div class="form-widget">
				    <formwidget id="choice.@choice_elements.id@" />
				      <br />
				  </div>
				  <div class="form-label">#assessment.correct_answer#</div>
				  <div class="form-widget">
				    <formgroup id="correct.@choice_elements.id@">
				      @formgroup.widget;noquote@
				    </formgroup>
				  </div>
				</div>
			      </multiple>
			      <!-- if form submit button wrap it in the form-button class -->
			      <div class="form-button">
				<formwidget id="formbutton_add_another_choice" />
			      </div>
			    </div>
			    <div class="form-item-wrapper form-item-wrapper-asm"  style="border: none;">
			      <!-- radio button groups and checkbox groups get their own fieldsets -->
			      <fieldset  class="checkbox">
				<legend >
				</legend>
				<if @formerror.allow_other_p@ not nil>
				  <div class="form-label form-label-error">
				    <if checkbox in radio checkbox date inform>
				      <label for="allow_other_p">#assessment.Show_Other_option#</label>
				    </if>
				    <else>
				      <label for="allow_other_p">#assessment.Show_Other_option#</label>
				    </else>
				</if>
				<else>
				  <div class="form-label">
				    <if edit eq display or checkbox in radio checkbox date inform>
				      <label for="allow_other_p">#assessment.Show_Other_option#</label>
				    </if>
				    <else>
				      <label for="allow_other_p">#assessment.Show_Other_option#</label>
				    </else>
				</else>
			    </div>
			    <!-- /form-label or /form-error -->
			    <if @formerror.allow_other_p@ not nil>
			      <div class="form-widget form-widget-error">
			    </if>
			    <else>
			      <div class="form-widget">
			    </else>
			    <formgroup id="allow_other_p">
			      @formgroup.widget;noquote@
			      <label for="item-add:elements:allow_other_p:@formgroup.option@">
				@formgroup.label;noquote@
			      </label>
			      <br/>
			    </formgroup>
			  </div>
			    <!-- /form-widget -->
			    <formerror id="allow_other_p">
			      <div class="form-error">
				@formerror.allow_other_p;noquote@
			      </div>
			      <!-- /form-error -->
			    </formerror>
			    <div class="form-help-text">
			      <img src="/shared/images/info.gif" width="12" height="9" alt="[i]" title="Help text" border="0" />
				<formhelp id="allow_other_p" />
			    </div>
			    <!-- /form-help-text -->
			  </fieldset>
			    <!-- other option -->
			  </div>
			    <!-- radio button groups and checkbox groups get their own fieldsets -->
			    <fieldset class="checkbox">
			      <legend >
			      </legend>
			      <if @formerror.save_answer_set@ not nil>
				<div class="form-label form-label-error">
				  <if checkbox in radio checkbox date inform>
                                    #assessment.lt_Save_choices_as_answe#
                                  </if>
				  <else>
				    <label for="save_answer_set">#assessment.lt_Save_choices_as_answe#</label>
				  </else>
			      </if>
			      <else>
				<div class="form-label">
				  <if edit eq display or checkbox in radio checkbox date inform>
                                    #assessment.lt_Save_choices_as_answe#
                                  </if>
				  <else>
				    <label for="save_answer_set">#assessment.lt_Save_choices_answer_s#</label>
				  </else>
			      </else>
			    </div>
			      <!-- /form-label or /form-error -->
			      <formwidget id="save_answer_set" />
			      </formwidget>
			    </fieldset>
			    <!-- save answer set option -->
			  </div>
			    <!-- end of mc-options -->
			    <div id="open-options" class="not-visible">
			      <!-- open options -->
			      <if @formerror.reference_answer@ not nil>
				<div class="form-label form-label-error">
				  <if textarea in radio checkbox date inform>
                                    #assessment.Reference_Answer#
                                  </if>
				  <else>
				    <label for="reference_answer">#assessment.Reference_Answer#</label>
				  </else>
			      </if>
			      <else>
				<div class="form-label">
				  <if edit eq display or textarea in radio checkbox date inform>
                                    #assessment.Reference_Answer#
                                  </if>
				  <else>
				    <label for="reference_answer">#assessment.Reference_Answer#</label>
				  </else>
			      </else>
			    </div>
			    <!-- /form-label or /form-error -->
			    <if @formerror.reference_answer@ not nil>
			      <div class="form-widget form-widget-error">
			    </if>
			    <else>
			      <div class="form-widget">
			    </else>
			    <formwidget id="reference_answer" />
			    </div>
			      <!-- /form-widget -->
			      <formerror id="reference_answer">
				<div class="form-error">
				  @formerror.reference_answer;noquote@
				</div>
				<!-- /form-error -->
			      </formerror>
			      <div class="form-help-text">
				<img src="/shared/images/info.gif" width="12" height="9" alt="[i]" title="Help text" border="0" />
				  <formhelp id="reference_answer" />
			      </div>
			      <!-- /form-help-text -->
			    </div>
			      <!-- end of open-option -->
			    </div>
			      <div>
				<a id="link-add-feedback" href="javascript:void(0)">#assessment.lt_Show_feedback_options#</a>
				<a id="link-hide-feedback" href="javascript:void(0)" class="not-visible">#assessment.lt_Hide_feedback_options#</a>
			      </div>
			      <div id="feedback-options" class="not-visible">
				<!-- feedback options -->
				<!-- wrap the form item in the form-item-wrapper-asm class -->
				<div class="form-item-wrapper form-item-wrapper-asm">
				  <if @formerror.feedback_right@ not nil>
				    <div class="form-label form-label-error">
				      <if richtext in radio checkbox date inform>
					#assessment.lt_Correct_Response_Feed#<br />#assessment.Optional#
				      </if>
				      <else>
					<label for="feedback_right">#assessment.lt_Correct_Response_Feed#<br />#assessment.Optional#</label>
				      </else>
				  </if>
				  <else>
				    <div class="form-label">
				      <if edit eq display or richtext in radio checkbox date inform>
					#assessment.lt_Correct_Response_Feed#<br />#assessment.Optional#
				      </if>
				      <else>
					<label for="feedback_right">#assessment.lt_Correct_Response_Feed#<br />#assessment.Optional#</label>
				      </else>
				  </else>
				</div>
				<!-- /form-label or /form-error -->
				<if @formerror.feedback_right@ not nil>
				  <div class="form-widget form-widget-error">
				</if>
				<else>
				  <div class="form-widget">
				</else>
				<formwidget id="feedback_right" />
			      </div>
			      <!-- /form-widget -->
			      <formerror id="feedback_right">
				<div class="form-error">
				  @formerror.feedback_right;noquote@
				</div>
				<!-- /form-error -->
			      </formerror>
			      <div class="form-help-text">
				<img src="/shared/images/info.gif" width="12" height="9" alt="[i]" title="Help text" border="0" />
				  <formhelp id="feedback_right" />
			      </div>
			      <!-- /form-help-text -->
			    </div>
			      <!-- wrap the form item in the form-item-wrapper-asm class -->
			      <div class="form-item-wrapper form-item-wrapper-asm">
				<if @formerror.feedback_wrong@ not nil>
				  <div class="form-label form-label-error">
				    <if richtext in radio checkbox date inform>
				      #assessment.lt_Incorrect_Response_Fe#<br />#assessment.Optional#
				    </if>
				    <else>
				      <label for="feedback_wrong">#assessment.lt_Incorrect_Response_Fe#<br />#assessment.Optional#</label>
				    </else>
				</if>
				<else>
				  <div class="form-label">
				    <if edit eq display or richtext in radio checkbox date inform>
				      #assessment.lt_Incorrect_Response_Fe#<br />#assessment.Optional#
				    </if>
				    <else>
				      <label for="feedback_wrong">#assessment.lt_Incorrect_Response_Fe#<br />#assessment.Optional#</label>
				    </else>
				</else>
			      </div>
			      <!-- /form-label or /form-error -->
			      <if @formerror.feedback_wrong@ not nil>
				<div class="form-widget form-widget-error">
			      </if>
			      <else>
				<div class="form-widget">
			      </else>
			      <formwidget id="feedback_wrong" />
			      </div>
				<!-- /form-widget -->
				<formerror id="feedback_wrong">
				  <div class="form-error">
				    @formerror.feedback_wrong;noquote@
				  </div>
				  <!-- /form-error -->
				</formerror>
				<div class="form-help-text">
				  <img src="/shared/images/info.gif" width="12" height="9" alt="[i]" title="Help text" border="0" />
				    <formhelp id="feedback_wrong" />
				</div>
				<!-- /form-help-text -->
			      </div>
				<!-- end of feedback options -->
			      </div>
				<!-- if form submit button wrap it in the form-button class -->
				<div class="form-button">
				  <formwidget id="formbutton_ok" />
				    <formwidget id="formbutton_add_another_question" />
				</div>
    </formtemplate>
    <script type="text/javascript">
      @js_listeners;noquote@
    </script>


