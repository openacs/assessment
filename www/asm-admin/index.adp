<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<if @admin_p@ eq 1>
<a
href="@categories_url@cadmin/one-object?object_id=@package_id@">#assessment.admin_categories#</a>
| <a href=../admin/asm-action-admin>#assessment.admin_actions#</a> | <a href=../admin/admin-request>#assessment.admin_requests#</a> | <a href="permissions?object_id=@package_id@">#assessment.permissions#</a>

</if>

<p>

<formtemplate id="form_upload_file"></formtemplate>
<p>
<listtemplate name="assessments"></listtemplate>
