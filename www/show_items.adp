<master>
<property name="title">Assessment</property>
<property name="context">@context;noquote@</property>

<formtemplate id="show_item_form">
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
</formtemplate>

<br>
<a href="show_assessments">Show assessments</a>
<a href="upload_file">Upload files</a>
</master>
