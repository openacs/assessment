<master>
<property name="title">Assessment</property>
<property name="context">@context;noquote@</property>

<formtemplate id="show_item_form">
	<table border="1">
		<br>&nbsp;&nbsp;
		<b>#assessment.Items#</b>
		<multiple name="items">
			<tr>
				<td valign="top">@items.rownum@.-</td>	
				<td colspan="3">
					<blockquote>@items.title@
						<if @items.presentation_type@ in radio checkbox>
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
<a href="upload-file">#assessment.Upload_files#</a>
</master>
