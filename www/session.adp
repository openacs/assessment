<master>
<property name="title">Assessment</property>
<property name="context">@context;noquote@</property>
	<table border="1">
		<multiple name="items">
			<tr>
				<td valign="top">@items.rownum@.-</td>
				<td colspan="3">
					<blockquote>@items.title@</blockquote>
					@items.choice_html;noquote@
				</td>
			</tr>
		</multiple>
	</table>
</master>
