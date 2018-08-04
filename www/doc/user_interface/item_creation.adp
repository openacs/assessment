
<property name="context">{/doc/assessment {Assessment}} {Question Catalogue}</property>
<property name="doc(title)">Question Catalogue</property>
<master>
<!-- START HEADER --><span class="context"><span class="reg">
<strong>Question Catalogue: Summary</strong>:</span></span>
<p><span class="context">The question catalogue is a central part
of the assessment system. It deals with the storing of the various
questions that can be used in a survey. You are able to
add/edit/delete a question of a certain type to a certain scope.
Furthermore it allows you to search and browse for questions for
inclusion in your assessment as well as import and export multiple
questions using various formats. This concept is new to survey 0.1d
and changes the design of the survey module considerably. No
mockups available.</span></p>
<p><span class="context">
<strong>Spec</strong>:<br>
All questions have some common ground.</span></p>
<ul>
<li>
<span class="context">Questions must be scopeable, scope should
be:</span><ul>
<li><span class="context">site-wide for questions that are useful
for the whole site</span></li><li><span class="context">package-wide, which is useful for dotLRN
communities, so you can have questions which are just useful for
your class</span></li><li><span class="context">survey-wide, so you can add questions,
that are only useful for one survey. This is the default if you add
a question using the normal survey interface</span></li>
</ul>
</li><li><span class="context">Questions should be able to be assigned
to multiple categories with multiple hierarchies (e.g. catogorize
by symptoms or by classes). These categories must be editable site
wide.</span></li><li><span class="context">Questions will have a title, so they can
easily be found again.</span></li><li><span class="context">Questions have to be versionable. This
allows a survey to use the older version of a question, if the
question is changed.</span></li>
</ul>
<span class="context">For each of the various question types, there
will be a separate input form instead of the currently used method.
A user selects a question type to add and is then redirected to the
question type add form.</span>
<ul>
<li>
<span class="context">True for all Question types<br>
The following fields are true for every question type:</span><ul>
<li><span class="context">Category</span></li><li><span class="context">Title</span></li><li><span class="context">Scope</span></li><li><span class="context">Question: An richtext HTML widget (look
at bug-tracker for an example of this widget)</span></li><li><span class="context">Graphik: A file for upload from the local
harddisk to the content repository</span></li><li><span class="context">Use old answers: boolean (yes/no). If
yes, the latest response of the user to this question will be given
as a default value</span></li><li>
<span class="context">Data validation steps are fairly complex
because we need two layers of data validation checks:</span><ul>
<li><span class="context">
<em>Intra-item checks</em>: the user
input { exactly matches | falls within narrow "target"
bounds | falls within broader "acceptable" bounds with
explanation}</span></li><li><span class="context">
<em>Inter-item checks</em>: if { a user
input for item a is A, item b is B, ... item n is N } then { user
input for item z is Z }</span></li>
</ul><p><span class="context">Both levels involve stringing together
multiple binary comparisons (eg 0 &lt; input &lt; 3 means checks
that 0 &lt; input <em>and</em> input &lt; 3), so we need to express
a grammar consisting of</span></p><ul>
<li><span class="context">comparison1 <em>conjunction</em>
comparison2 <em>conjunction</em> ... comparison n</span></li><li><span class="context">appropriate grouping to define precedence
order (or simply agree to evaluate left to right)</span></li>
</ul>
</li>
</ul>
</li><li>
<span class="context">Open Question<br>
Besides categories and title (which is the same for all questions),
open questions have the following entry fields:</span><ul>
<li><span class="context">Size of the reply box: Radio buttons
(small/medium/large)</span></li><li><span class="context">Prefilled Answer Box: richtext widget.
The content of this field will be prefilled in the response of the
user taking the survey</span></li><li><span class="context">Correct Answer Box: richtext widget. The
person correcting the answers will see the contents of this box as
correct answer for comparison with the user response.</span></li><li><span class="context">[NTH]: Button to add predefined comments
next to the correct answer box. This would be shown to the manual
corrector to quickly choose from when manually scoring the
answer.</span></li>
</ul>
</li><li>
<span class="context">Calculation:<br>
This type of question will not be supported. But we should make
sure we can take care of that type while importing the data.
Therefore we have to know the values. And while we are at it, we
can as well just generate the input form :-).</span><ul>
<li><span class="context">Formula: string</span></li><li><span class="context">Units</span></li><li><span class="context">Value (in %): integer</span></li><li><span class="context">Required (boolean)</span></li><li><span class="context">Ignore Space (boolean)</span></li><li><span class="context">Ignore spell checking
(boolean)</span></li><li><span class="context">General Feedback: richtext</span></li>
</ul>
</li><li>
<span class="context">Short Answer Question:<br>
</span><ul>
<li><span class="context">Number of Answerboxes: Integer Selectbox.
This will control how many answer boxes the respondee will
see.</span></li><li><span class="context">Upper/Lowercase: Radio boolean. This will
control, whether we treat the response case sensitive when
comparing it to the correct answers or not.</span></li><li>
<span class="context">The questioneer has the option to define
multiple possible correct answers that will be matched with the
response of the user in various ways. For each of the possible
answers the following fields are given:</span><ul>
<li><span class="context">Answer: short_text. This contains the
answer string that will be matched against the response</span></li><li><span class="context">Value in %: short integer: How many
percentage points a match will awarded.</span></li><li><span class="context">Size: Integer Select: size of the input
box (small, medium, large)</span></li><li><span class="context">Compare by: Select (equal, contains,
regexp). This defines how the comparison between the answer string
and the response shall happen.</span></li><li><span class="context">Allow in answerbox: (multiple select box
with "All" and the numbers from 1 to x where x is the
number of answerboxes from above. For sure this only works with JS
enabled :)). Defines the answerboxes the user can fill out that
shall be matched with this answer. w</span></li>
</ul>
</li>
</ul>
</li><li>
<span class="context">Matching Question:<br>
Matching questions are useful for matching some items on the left
with pull down menues on the right hand side of a survey. The
number of the items is identical to the number of items on the
right hand side.</span><ul>
<li>
<span class="context">Settings:</span><ul>
<li><span class="context">Distribution of points: boolean (all or
nothing / increasing). All or nothing will either give 100%, if all
correct answers are given, or 0% else. Increasing will give (number
of correct matches / number of total matches) *100%
points.</span></li><li><span class="context">Allow negative: boolean (yes/no). This
will allow a negative percentage as well (as the total
result).</span></li>
</ul>
</li><li>
<span class="context">A couple of match entries will be
presented below the settings. Each one will consist of:</span><ul>
<li><span class="context">Match item: This is the item which will
be displayed on the left side of the question presented to the
respondee.</span></li><li><span class="context">Matched item: This is the correct item
from the select box on the right side. For each match item on the
left there will be a select box on the right with ALL the matched
items (when taking the survey, that is...)</span></li>
</ul>
</li><li><span class="context">In addition to submit, there is another
button to allow further answers to be filled in. Typed in values
shall be remembered and 4 more answerboxes be shown.</span></li>
</ul>
</li><li><span class="context">File upload question: A file upload
question will allow the respondent to upload a file. No additional
settings but the usual for every question.</span></li><li>
<span class="context">Multiple Choice question: Multiple Choice
questions allow the respondee to choose from multiple alternatives
with the possibility to answer more than one at a time.</span><ul>
<li>
<span class="context">Settings:</span><ul>
<li><span class="context">Allow Multiple: boolean (yes/no). This
will determine if the respondee has the option to choose multiple
possible answers for his response.</span></li><li><span class="context">Select Box: boolean (yes/no). Will
display a select box or radio/checkbox otherwise.</span></li><li><span class="context">Distribution of points: boolean (all or
nothing / increasing). All or nothing will either give 100%, if all
correct answers are given, or 0% else. Increasing will give (number
of correct matches / number of total matches) *100%
points.</span></li><li><span class="context">Allow negative: boolean (yes/no). This
will allow a negative percentage as well (as the total
result).</span></li>
</ul><span class="context">For each (possible) answer we have a couple
of fields:</span><ul>
<li><span class="context">Correct answer: boolean, radio with
grafik (red x, green y) (yes/no). This marks if the current answer
is a correct one.</span></li><li><span class="context">Answer: Richtext widget.</span></li><li><span class="context">Value: percentage value this answer gives
to the respondee</span></li><li><span class="context">Reply: richtext widget. This is a reply
the student can see at the end of the test giving him some more
information on the question he choose.</span></li>
</ul>
</li><li><span class="context">In addition to submit, there is another
button to allow further answers to be filled in. Typed in values
shall be remembered and 4 more answerboxes be shown.</span></li><li><span class="context">Additionally there is a button
"copy", which copies the contents of this question to a
new question, after you gave it a new title.</span></li><li>
<span class="context">[FE]: Possibility to randomly choose from
the options. This would add a couple of fields:</span><ul>
<li><span class="context">To each answer: Fixed position: Select
Box, Choose the mandatory position when displaying the option (e.g.
"none of the above").</span></li><li><span class="context">Number of correct answers: integer,
defining how many correct options have to be displayed. Check if
enough correct answers have been defined.</span></li><li><span class="context">Number of answers: integer, defining how
many options shall be displayed in total (correct and incorrect).
Check if enough answers are available.</span></li><li><span class="context">Display of options: Numerical,
alphabetic, randomized or by order of entry.</span></li>
</ul>
</li>
</ul>
</li><li>
<span class="context">[FE]: Rank question.<br>
Rank questions ask for the answers to be ranked.</span><ul>
<li><span class="context">Rank Type: Boolean (alphabetic, numeric).
Shall the rank be from a to z or from 1 to n.</span></li><li><span class="context">Only unique rank: Boolean (yes/no). Shall
the ranking only allow unique ranks (like 1,2,3,5,6 instead of
1,2,2,4,5)</span></li><li><span class="context">Straight order: Boolean (alphabetic,
numeric). Shall the rank be in a straight order or is it allowed to
skip values (1,2,3 vs. 1,3,4)</span></li><li>
<span class="context">For each answer we ask the following
questions:</span><ul>
<li><span class="context">Answer: Richtext widget.</span></li><li><span class="context">Rank: correct rank</span></li>
</ul>
</li><li><span class="context">In addition to submit, there is another
button to allow further answers to be filled in. Typed in values
shall be remembered and 4 more answerboxes be shown.</span></li>
</ul>
</li><li><span class="context">[FE]: Matrix table (blocked
questions)<br>
A matric table allows multiple questions with the same answer to be
displayed in one block. At the moment this is done in the section
setup (if all questions in a section have the same answers they
would be shown in a matrix). One could think about making this a
special question type on it&#39;s own.</span></li>
</ul>
<span class="context">Only site wide admins will get to see the
following question types:</span>
<ul><li>
<span class="context">Database question:<br>
The answer to this question will be stored in the database. The
question has the following additional fields:</span><ul>
<li><span class="context">Table Name: short_string. This is the
name of the table that is being used for storing the
responses.</span></li><li><span class="context">Column: short_string. This is the column
of the table that is used for storing the responses.</span></li><li><span class="context">Key Column: short_string. This is the
column of the table that matches the user_id of the
respondee.</span></li>
</ul>
</li></ul>
<span class="context">Concerning permissions here is the current
thinking:</span>
<ul>
<li><span class="context">A question can be changed only by the
creator or any person that the creator authorizes. To keep it
simple for the moment, a person that is authorized by the creator
has the same rights as the creator himself.</span></li><li><span class="context">If a question is changed, all survey
administrators, whose survey use the question, are notified of the
change and given the opportunity to upgrade to the new version, or
stick with their revision of the question.</span></li><li><span class="context">If an upgrade happens we have to make
sure that the survey gets reevaluated. Unsure about the exact
procedure here.</span></li>
</ul>
<span class="context">There needs to be an option to search the
question catalogue:</span>
<ul>
<li><span class="context">Search term: short_text. What shall be
searched for</span></li><li><span class="context">Search type: select {exact, all, either}.
Search for the exact term, for all terms or for one of the terms
given.</span></li><li><span class="context">Search in: Checkboxes (Title, Question,
Answer, Category, Type). Search for the term(s) in the Title,
Question, Answer, Category and question type (multiple,
short_answer ...). Obviously search only in these areas which have
their checkbox set to true.</span></li><li><span class="context">Browse by category (link). Link to allow
browsing for a question in the category tree.</span></li><li>
<span class="context">The result should show the question
title, the type of the question, a checkbox for inclusion in a
survey. The following actions are possible:</span><ul>
<li><span class="context">Include the marked questions to the
current section, if section_id was delivered with the
search.</span></li><li><span class="context">Delete selected questions</span></li><li><span class="context">Change scope of selected
questions</span></li><li><span class="context">Export questions in CSV, Blackboard,
WebCT or IMS format.</span></li>
</ul>
</li>
</ul>
<span class="context">Operations on questions:</span>
<ul>
<li><span class="context">View. View the question in more detail
(all settings along with a preview of the question)</span></li><li>
<span class="context">Edit. Edit the current question. On
submit:</span><ul>
<li><span class="context">Store a new version of the
question.</span></li><li><span class="context">Mail all current survey administrators
using this question about the update.</span></li><li><span class="context">Include a link which allows the
administrators to update their survey to the latest revision of the
question.</span></li><li><span class="context">Don&#39;t relink the survey to the latest
revision if not explicitly asked for by the survey
administrator.</span></li>
</ul>
</li><li><span class="context">Copy. Copy the current question and allow
for a new title. The edit screen should be presented with an empty
Title field.</span></li><li><span class="context">Delete. Delete a question. On the
confirmation page show all the Possibility to include images in
answers. Currently this can be done using HTML linking. A more
sophisticated system which links to a media database is thinkable,
once the media database is ready.</span></li>
</ul>
<span class="context">For the future we&#39;d like to see a more
sophisticated way to include images in questions. Currently this
can be done using HTML linking, but a media database would be
considerably more helpful and could be reused for the CMS as
well.</span>
<br clear="left">
<h4>Calculation and Database Questions</h4>

I&#39;m not clear from your description what these are. If by
Calculation questions you mean questions that produce some
calculated result from the user&#39;s raw response, then IMHO this
is an important type of question to support now and not defer. This
is the main type of question we use in quality-of-life measures
(see demo <a href="http://www.epimetrics.com/questionnaires/one-questionnaire?questionnaire_id=1">
here</a>
). These are questions scored by the Likert scale
algorithm. If there are five potential responses (1,2,3,4, and 5)
for a question, and the user choose "1" then the
"score" is calculated as 0; if "5" then 100; if
"3" then 50, and so on -- a mapping from raw responses to
a 0-100 scale. Is this what you mean by a "calculation"
question?
<p>By Database questions, do you mean free text input (via
textboxes or textareas) questions for which there is a
"correct" answer that needs to be stored during question
creation? Then when the teacher is reviewing the student&#39;s
response, she can inspect the student&#39;s response against the
stored answer and determine what degree of correctness to assign
the response?</p>
<p>-- <a href="/shared/community-member?user_id=6569">Stan
Kaufman</a> on November 09, 2003 06:29 PM (<a href="/comments/view-comment?comment%5fid=141902&amp;return%5furl=">view
details</a>)</p>
<span class="etp-link"><a class="top" href="etp?name=question_catalogue"></a></span>
<!-- END ETP LINK -->