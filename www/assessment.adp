<master>
<property name="title">Assessment</property>
<property name="context">@context;noquote@</property>

<table width="100%" cellpadding="3" cellspacing="0" border="0">
<tr><th colspan="3">@assessment_name@</th></tr>
<tr><td><i><font size="1">@assessment_instruction@</font></i></td></tr>
<!--for future data of assessment-->
<tr>
<td colspan="3"><hr></td>
</tr>
</table>

<formtemplate id="show_item_form">
    <input type="hidden" name="as_session_id" value="@as_session_id@">
    <multiple name="items">
        <table border="0">
	   <tr bgcolor="#d0d0d0"><td><b>#assessment.section#: @items.section_title@ </b></td></tr>
	   <tr><td><i> @items.section_description@ </i><br></td></tr>
	</table>

	<br>&nbsp;&nbsp;
	<b>#assessment.Items#</b><br><br>
	<table border="0">

		     <group column="section_title">
			<tr>
				<tr bgcolor="#e4eaef"><td colspan="2" nowrap><b>#assessment.Question# @items.rownum@:</b></td><td><b><if @items.presentation_type@ not in fitb>@items.title@</if></b></td></tr>
				<tr><td colspan="4">
					<blockquote>
						<if @items.presentation_type@ in radio checkbox>
							<formgroup id="response_to_item.@items.as_item_id@">
								@formgroup.widget;noquote@
								@formgroup.label;noquote@
								<br/>
							</formgroup>
						</if>
						<elseif @items.presentation_type@ in fitb>
							@items.html;noquote@
						</elseif>
						<else>
							<formwidget id="response_to_item.@items.as_item_id@">
						</else>
					</blockquote>
					<hr>
				</td>
			</tr>
		     </group>

	</table>
    </multiple>
<table align="center"><tr><td><input type=submit value="#assessment.Submit#"></td></tr></table>
</formtemplate>

<br>
</master>
