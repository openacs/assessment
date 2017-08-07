
<property name="context">{/doc/assessment {Assessment}} {5. Action Triggers}</property>
<property name="doc(title)">5. Action Triggers</property>
<master>
<include src="/packages/acs-core-docs/lib/navheader"
		    leftLink="ch02s04" leftLabel="Prev"
		    title="Chapter 2. User
Manual"
		    rightLink="ch02s06" rightLabel="Next">
		<div class="section" lang="en">
<div class="titlepage"><div><div><h2 class="title" style="clear: both">
<a name="d0e204" id="d0e204"></a>5. Action Triggers</h2></div></div></div><p>To define an Action Trigger, the field "Type" in the
form must be checked as "Action".</p><p>The condition field shows the question and its possible anwers,
it means that when the user is responding the assessment, if this
answer is given for this question, the action will be executed.</p><div class="screenshot"><div class="mediaobject"><img src="resources/action_trigger.JPG"></div></div><p>After the trigger is created, the action related must be chosen,
also the time when the action will be executed, and the message
shown to the user when the action is executed.</p><p>The actions can be executed in three different times:</p><div class="orderedlist"><ol type="1">
<li><p>Immediately: it means that the action will be executed after the
user finish to respond the current section.</p></li><li><p>At the end of this Assessment: it means that the action will be
executed when the user finish to respond all the sections of the
assessment.</p></li><li><p>Manually:this means that the action will be executed by an
administrator (i.e. in case that the request needs approval).</p></li>
</ol></div><div class="screenshot"><div class="mediaobject"><img src="resources/select_action.JPG"></div></div><p>After select the action related to the trigger, the parameters
for the action must be set, the select boxes display the options
depending on the type of the parameter.</p><div class="itemizedlist"><ul type="disc"><li><p>Query: display the values returned by the query defined for the
parameter.</p></li></ul></div><div class="itemizedlist"><ul type="disc"><li>
<p>Name: the options displayed depends on the time of
execution:</p><div class="itemizedlist"><ul type="circle"><li><p>Immediately: display all the questions defined in previuos
sections.</p></li></ul></div><div class="itemizedlist"><ul type="circle"><li><p>At the end of the assessment and Manually: display all the
questions defined in the assessment.</p></li></ul></div>
</li></ul></div><div class="screenshot"><div class="mediaobject"><img src="resources/set_params.JPG"></div></div>
</div>
<include src="/packages/acs-core-docs/lib/navfooter"
		    leftLink="ch02s04" leftLabel="Prev" leftTitle="4. Branch
Triggers "
		    rightLink="ch02s06" rightLabel="Next" rightTitle=" 6. Trigger
Administration"
		    homeLink="index" homeLabel="Home" 
		    upLink="ch02" upLabel="Up"> 
		