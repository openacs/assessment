<master>
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context;literal@</property>
<if @asm_p;literal@ false>
	#acs-subsite.no_assessment#
</if>
<else>
<a href="../asm-admin/assessment-new?permission_p=1" class="button">#acs-subsite.create_asm#</a>
<br>
<br>
<formtemplate id="get_assessment"></formtemplate>
</else>
