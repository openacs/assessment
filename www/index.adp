<master>
<property name="title">Assessment</property>
<property name="context">@context;noquote@</property>
<if @admin_p@ eq "1"><p style="text-align: right;"><a href="as_admin"><img src="graphics/admin.gif" border="0" alt="Administer Surveys"></a></if>

<multiple name="assessment_info">
	<ul>
		<li>
			<a href="assessment?assessment_id=@assessment_info.assessment_id@" title="@assessment_info.description@">@assessment_info.title@</a>
		</li>
	</ul>
</multiple>

</master>
