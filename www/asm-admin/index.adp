<master>
<property name="doc(title)">@title;literal@</property>
<property name="context">@context;literal@</property>

<p>
<if @package_admin_p;literal@ true>
<a
href="@categories_url@cadmin/one-object?object_id=@package_id@">#assessment.admin_categories#</a>
|<if @sw_admin_p;literal@ true> <a href="../admin/asm-action-admin">#assessment.admin_actions#</a> |</if> <a href="../asm-admin/admin-request">#assessment.admin_requests#</a> | <a href="permissions?object_id=@package_id@">#assessment.permissions#</a> | <a href="sessions">#assessment.View_Sessions#</a>
</if> <else>
<a href="../asm-admin/admin-request">#assessment.admin_requests#</a>
</else>
</p>

<formtemplate id="form_upload_file"></formtemplate>

<listtemplate name="assessments"></listtemplate>
