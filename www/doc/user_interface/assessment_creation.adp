
<property name="context">{/doc/assessment {Assessment}} {Assessment Creation}</property>
<property name="doc(title)">Assessment Creation</property>
<master>
<!-- START HEADER --><span class="context"><span class="reg">When
creating an assessment the administrator has a couple of fields to
determine the look and feel of the assessment along with the option
to view the responses. This is a list of attributes the
administrator can edit when creating an assessment. The grouping is
based on the UI and not on the datamodell. So you should follow
this with regards to the UI:</span></span>
<ul>
<li><span class="context">Title: Title of the
accessment</span></li><li><span class="context">Anonymous Accessment: boolean (yes/no).
This shows whether the creator of the accessment will have the
possibility to see the personal details of the respondee or not. In
particular this will exclude the user_id from the CSV files. It
shall still be possible to see the user that have not finished the
survey though.</span></li><li><span class="context">Secure access only: boolean (yes/no). The
assessment can only be taken if a secure connection (https) is
used.</span></li><li>
<span class="context">Presentation Options: These options allow
the respondee to select between different presentation styles. At
least one of the checkboxes mentioned below has to be
selected.</span><ul>
<li><span class="context">All questions at once</span></li><li><span class="context">One question per page. If you have
selected respondee may not edit their reponses, it will not be
possible for them to go back and choose another answer to that
question.</span></li><li><span class="context">Sectioned</span></li>
</ul>
</li><li><span class="context">Reuse responses: boolean (yes/no). If
yes, the system will look for previous responses to the the
questions and prefill the last answer the respondee has given in
the assessment form of the respondee. <em>It is debatable whether
this function should be per assessment and/or per
question</em>
</span></li><li><span class="context">Navigation of sections: select (default
path, randomized, rule-based branching, maybe looping in the
future).</span></li><li><span class="context">Show question titles: boolean (yes/no).
If yes, the respondee will see the title of the question in
addition to the question itself when taking the survey.</span></li><li>Consent Pages: richtext. <span class="context"><span class="reg"><span class="context">An assessment author should be able
optionally to specify some consent statement that a user must agree
to in order to proceed with the assessment. The datamodel needs to
store the user&#39;s response positive response with a timestamp
(in as_sessions). This isn&#39;t relevant in educational testing,
but it is an important feature to include for other settings,
notably medical and financial ones.<br>
</span></span></span>
</li><li>Progress bar: select. (no progress bar, different styles). What
kind of progress bar shall be displayed to the respondee while
taking the assessment.</li><li>Styles
<ul>
<li>Custom header / footer: richtext. Custom header and footer that
will be displayed the the respondee when answering an assessment.
Possibility to include system variables (e.g. first name).</li><li>Select presentation style. Style (form_template) that will be
used for this assesment</li><li>Upload new: file. Possibility to upload a new style</li><li>Edit (brings up a page with the possibility to edit the
selected style)</li><li>Customizable Entry page: richtext. The page that will be
displayed before the first response.</li><li>Customizable buttons for Submit, Save, continue, cancel (e.g.
using the style?)</li><li>Customizable thank you page: richtext.</li><li>Return_URL: text. URL the respondee will be redirected to after
finishing the assessment. Should be redirected directly if no Thank
you page is there. Otherwise the return_url should be set in the
thank you page context, so we can have a "continue"
URL.</li>
</ul>
</li><li>Times
<ul>
<li>Availabilty: 2 date widgets (from, and to). This will set the
time the time the survey will become visible for the respondees. It
is overriden by the parameter enabled (if a accessment is not
enabled, it will never be visible, regardless of date).</li><li>How often can a accessment be taken: Number of times a survey
can be taken by a respondee.</li><li>How long has a user to pause: Number of hours a respondee has
to wait before he can take the accessment again.</li><li>Answer_time: integer: Time in minutes a respondee has to answer
a survey.</li>
</ul>
</li><li>Show comments to the user
<ul>
<li>No comments: the user will not see the comments stored with the
questions at all</li><li>All comments: the user will see all the comments associated
with his answers to the questions</li><li>Only wrong comments: the user will only see the comments to
questions which he answered in correctly.</li>
</ul>
</li><li>Permissions
<ul>
<li>Grant explicit permissions: Link to a seperate page that will
allow the creator to grant and revoke permission for this survey.
Permissions are (take_survey, administer_survey)</li><li>Grant permission on status in curriculum. Needs to be exactly
defined. Otherwise we will write a small page, that allows the
admin to select exams and a minimum point number the student has to
have achieved in that exam.</li><li>Bulk upload: file. Upload a CSV file with email addresses to
allow access to the accessment. Add users to the system if not
already part of it. Notify users via email that they should take
the accessment.</li><li>Password: short_text. Password that has to be typed in before
the respondee get&#39;s access to the accessment. This should be
done by creating a registered filter that returns a 401 to popup an
HTTP auth box. look in oacs_dav::authenticate for an example of how
to check the username/password<br>
</li><li>IP Netmask. short_text. Netmask that will be matched against
the IP-Adress of the respondee. If it does not match, the user will
not be given access. Again this should be handled by the creation
of a registered filter on the URL where the assessment resides (for
the respondee that is, meaning the entry URL for responding to the
assessment).<br>
</li>
</ul>
</li><li>Notifications
<ul>
<li>Notifications will be done using the notification system of
OpenACS.<br>
</li><li>For all notifications allow system variables should be
used.</li><li style="list-style: none"><ul>
<li>System_name</li><li>User_name</li><li>user_id</li><li>... (free for the developer to think about what is
useful)<br>
</li>
</ul></li><li>Links to spam the following group of people (information can be
taken out of as_sessions):</li><li style="list-style: none"><ul>
<li>All respondees having access to the assessment</li><li>All respondees that have not started the assessment</li><li>All respondees with unfinished assessments<br>
</li><li>All respondees with finished assessment</li>
</ul></li><li>Notification message: richtext. This will allow the creator to
supply a message that will be send to the respondee, Possible
messages:<br><ul>
<li>To invite the respondee</li><li>To remind him for filling out the survey</li><li>To thank them for performing</li>
</ul>
</li><li>Possible Messages for the staff
<ul>
<li>Inform the staff about reponses to be looked at</li><li>Remind the staff about responses</li>
</ul>
</li><li>Reminder period for notification messages.</li>
</ul>
</li><li>Reponses
<ul>
<li>View responses per User (resulting in a page with all responses
with checkboxes in front for deletion and a check/uncheck all
link)</li><li>View responses per Question</li><li>View responses by Filter / Groups / Values (e.g. search for
questions with a negative distractor)</li><li>Grant access to responses (using the permission
system):<br>
</li><li style="list-style: none"><ul>
<li>Closed - Only the owner of the assessment can see the
responses<br>
</li><li>Admin - Only admins of the assessment can see the
reponses<br>
</li><li>Respondees - Only respondees can see the responses<br>
</li><li>Registered_Users - Only registered users can see the
responses</li><li>Public - Everyone can see the responses<br>
</li><li>grant permission to special parties<br>
</li>
</ul></li><li>Import / Export
<ul>
<li>Import/export style: WebCT, CVS, Blackboard, IMS</li><li>Import Filename: file, select file that shall be imported</li><li>Import and export button</li>
</ul>
</li>
</ul>
</li><li>Statistics
<ul>
<li>Number of completed assessments</li><li>Number of unfinished assessments</li><li>Average score (only with scoring module)</li>
</ul>
</li><li>Survey Import / Export
<ul>
<li>Type: (select box): CSV, WebCT, SCORM, Blackboard, IMS</li><li>File: file (file for import)</li><li>Download file name: short_text. Filename for the download of
the export.</li>
</ul>
</li><li>Delete assessment with / without responses</li><li>Assign category to the assessment<br>
</li><li>Link to a mapping and browsing page to link sections to this
assessment (or to create new sections).</li><li>
<span class="context"><span class="reg">(Optional) For each
section in the assessment display:</span></span><ul>
<li><span class="context">Section name</span></li><li><span class="context">Link to section page</span></li><li><span class="context">Reorder section buttons.</span></li>
</ul>
</li><li>Instant survey preview (needs to be defined how exactly this is
going to happen)</li><li><span class="context">One additional option that should be
included is a consent form; an assessment author should be able
optionally to specify some consent statement that a user must agree
to in order to proceed with the assessment. The datamodel needs to
store the user&#39;s response whether it is positive or negative,
along with a timestamp. This isn&#39;t relevant in educational
testing, but it is an important feature to include for other
settings, notably medical and financial ones.</span></li>
</ul>
<span class="etp-link"><a class="top" href="etp?name=assessment_creation"></a></span>
<!-- END ETP LINK -->