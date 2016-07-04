
<property name="context">{/doc/assessment {Assessment}} {User Experience}</property>
<property name="doc(title)">User Experience</property>
<master>
<!-- START HEADER --><span class="context"><span class="reg">User
experience describes the various steps the USER sees and what he
can do when taking an assessment. When answering a section a couple
of things happen:</span></span>
<ul>
<li>
<span class="context">A permission check will be made to
determine whether the user is allowed to take the
assessment.</span><ul>
<li><span class="context">Is the user allowed to take the survey at
all (acs_permission check)</span></li><li><span class="context">Are all conditions for the taking of the
assessment fullfilled</span></li><li><span class="context">Is there still a try for the user
left</span></li>
</ul>
</li><li><span class="context">Starttime of the response will be
logged</span></li><li><span class="context">First section will be delivered to the
user for anwering.</span></li>
</ul>
<span class="context">Depending on the settings, the display of the
assessment will vary:</span>
<ul>
<li><span class="context">If all answers have to be submited
seperatly, a submit button will be shown next to each answer. If
the user hits the submit button next to the question the answer
will be stored in the response.</span></li><li><span class="context">Else the normal section view will be
displayed with a submit button at the end of the
section.</span></li><li><span class="context">If the user can change the results of a
question, the submitted question will be displayed with an edit
instead of the submit button. Otherwise only the answer will be
displayed. In either case the answer is displayed as text on the
page, not within a form element.</span></li><li><span class="context">If the respondee cannot see his old
answers, don&#39;t display them once submitted. Make sure the
backbutton does not work (e.g. using Postdata ?). Not sure how much
sense it makes to display an edit button :).</span></li><li><span class="context">If we have a time in which the respondee
has to answer the assessment, display a bar with time
left.</span></li><li><span class="context">If we have to show a progress bar, show
it and renew it after each submit (so also for each
question).</span></li><li><span class="context">Display a finish test button at the end
of the page to "hand the test to the TA" if this is
allowed</span></li><li><span class="context">Allow for chancellation of the test with
a chancel button. The result will not be stored but the test will
be marked as taken.</span></li><li><span class="context">If immediate answer validation (aka.
ad_form check) for a question is true, check the answer if it is
valid, otherwise notify the user that it is not and do not store
the result.</span></li>
</ul>
<span class="context">The processing has to take some additional
notes into consideration:</span>
<ul>
<li><span class="context">Branching does not always depend on an
answer but may also depend on the result within a section (branch
by disctractor, median)</span></li><li><span class="context">questions within a section can be
randomly displayed. Take also into account that not all questions
have to be displayed and that some of the questions migt be
mandatory and even mandatory in position.</span></li><li><span class="context">When displaying random questions the
randomizing element has to be the same for each response_id (the
user shall not have the option to see different questions just by
hitting reload).</span></li>
</ul>
<span class="context">Once the assessment has been finished</span>
<ul>
<li><span class="context">Display optional electronic signature
file upload with an "I certify this test and state it is
mine" checkbox. This will be stored in addition to the
test.</span></li><li><span class="context">Notifications shall be send to the admin,
staff and respondee.</span></li><li><span class="context">If we shall display the results to the
respondee immediatly after finishing the assessment, show it to him
/ her. Display the comments along depending on the
settings.</span></li><li><span class="context">If we have a special score, show this
result to the user (e.g. if 90% means "you are a dream
husband", display this along with the 90%).</span></li><li><span class="context">Display a link with the possibility to
show all the questions and answers for printout.</span></li><li><span class="context">Store the endtime with the
response.</span></li>
</ul>
<span class="context">An administrator can take the survey in
various modes which he can select before the first section will be
displayed.</span>
<ul>
<li><span class="context">Normal mode: The adminsitrator is treated
as a normal respondee, the response will be stored in the
system.</span></li><li><span class="context">Test mode: The administrator sees the
survey as a normal respondee, the response will not be stored in
the system.</span></li><li><span class="context">Optional: Display correct answers when
taking the assessment.</span></li>
</ul>
<span class="etp-link"><a class="top" href="etp?name=user_experience"></a></span>
<!-- END ETP LINK -->