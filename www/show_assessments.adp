<master>
<property name="title">Assessment</property>
<property name="context">@context;noquote@</property>

<multiple name="assessment_info">
	<ul>
		<li>
			<a href="assessment?assessment_id=@assessment_info.assessment_id@">@assessment_info.title@</a>
			<ul><li>@assessment_info.description@</li></ul>
		</li>
	</ul>
</multiple>

<a href="show_items">Show items</a>
<a href="upload_file">Upload files</a>
</master>
