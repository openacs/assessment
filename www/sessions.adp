<master>
<property name="title">Assessment</property>
<property name="context">@context;noquote@</property>

<multiple name="sessions">
	<ul>
		<li>
			<a href="session?session_id=@sessions.session_id@">@sessions.first_names@ @sessions.last_name@</a>
		</li>
	</ul>
</multiple>

</master>
