
<property name="context">{/doc/assessment {Assessment}} {2. Actions Administration}</property>
<property name="doc(title)">2. Actions Administration</property>
<master>
<include src="/packages/acs-core-docs/lib/navheader"
			leftLink="ch02s01" leftLabel="Prev"
			title="Chapter 2. User
Manual"
			rightLink="ch02s03" rightLabel="Next">
		    <div class="section" lang="en">
<div class="titlepage"><div><div><h2 class="title" style="clear: both">
<a name="d0e87" id="d0e87"></a>2. Actions Administration</h2></div></div></div><p>To be able to administrate actions the user must have site wide
admin privileges. To admin actions the user must follow the link
"Action Administration" in the assessment admin page.</p><div class="screenshot"><div class="mediaobject"><img src="resources/admin_actions.JPG"></div></div><div class="orderedlist"><ol type="1">
<li><p>Register User: create a new user account in the system.</p></li><li><p>Event Registration: register the user to an event.</p></li><li><p>Add to Community: register the user to dotlrn and also to a
dotlrn class/community.</p></li>
</ol></div><p>Actions can be also created, following the link "Add new
action":</p><div class="screenshot"><div class="mediaobject"><img src="resources/add_action.JPG"></div></div><p>The action is formed mainlly by four things:</p><div class="orderedlist"><ol type="1">
<li><p>Name: the desire name that gives an idea of what the action
do.</p></li><li><p>Description: short explanation of what the action do, and how
its done.</p></li><li><p>Tcl code: the code that its executed to performe the action.</p></li><li><p>Parameter: this are the variables needed in the tcl code, that
depends of the user.</p></li>
</ol></div><div class="screenshot"><div class="mediaobject"><img src="resources/create_action.JPG"></div></div><p>After the action is created, a link to add the parameters is
shown.</p><div class="screenshot"><div class="mediaobject"><img src="resources/add_params.JPG"></div></div><p>When the link is followed, then a form to create the parameter
is shown, there are two types of parameters:</p><div class="orderedlist"><ol type="1">
<li><p>Name: this will take the value from a response given by the user
to an item of the assessment.</p></li><li><p>Query: for this type of parameter, the field query is used, and
the parameter will take the value or values that the query
returns.</p></li>
</ol></div><div class="screenshot"><div class="mediaobject"><img src="resources/create_param.JPG"></div></div><p>To delete an action the link "delete" in the action
administration page must be followed:</p><div class="screenshot"><div class="mediaobject"><img src="resources/delete_action.JPG"></div></div><p>Before deleting an action, a confirm message will be displayed,
the action will not be deleted if there is some reference to this
action (i.e. a trigger that wil execute this action).</p><div class="screenshot"><div class="mediaobject"><img src="resources/action_del_confirm.JPG"></div></div>
</div>
<include src="/packages/acs-core-docs/lib/navfooter"
			leftLink="ch02s01" leftLabel="Prev" leftTitle="1. Manage
Permissions "
			rightLink="ch02s03" rightLabel="Next" rightTitle=" 3. Trigger
Definition"
			homeLink="index" homeLabel="Home" 
			upLink="ch02" upLabel="Up"> 
		    