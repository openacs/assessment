<master>
<property name="title">Assessment</property>
<property name="context">@context;noquote@</property>

<formtemplate id="show_item_form">
    <input type="hidden" name="assessment_id" value="@assessment_id@">
	<table border="1">
		<br>&nbsp;&nbsp;
		<b>Items</b>
		<multiple name="items">
			<tr>
				<td valign="top">@items.rownum@.-</td>	
				<td colspan="3">
					<blockquote>@items.title@
						<if @items.presentation_type@ in radiobutton checkbox>
							<br/>
							<br/>
							<formgroup id="response_to_item.@items.as_item_id@">
								@formgroup.widget;noquote@
								@formgroup.label;noquote@
								<br/>
							</formgroup>
						</if>
						<else>
							<formwidget id="response_to_item.@items.as_item_id@">
						</else>
					</blockquote>
				</td>
			</tr>
		</multiple>
	</table>
<input type=submit value="Submit">
</formtemplate>

<br>
</master>
