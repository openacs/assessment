<master>
<property name="title">Assessment</property>
<property name="context">@context;noquote@</property>

<multiple name="assessment_info">
	<ul>
		<li>
			<if @assessment_info.enable_p@ eq f>
				@assessment_info.name@
			</if>
			<else>
				<a href="">@assessment_info.name@</a>
			</else>
			<ul><li>@assessment_info.definition@</li></ul>
		</li>
	</ul>
</multiple>

<a href="show_items">Show items</a>
<a href="upload_file">Upload files</a>
</master>