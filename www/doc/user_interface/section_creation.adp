
<property name="context">{/doc/assessment {Assessment}} {Sections}</property>
<property name="doc(title)">Sections</property>
<master>
<!-- START HEADER --><span class="context"><span class="reg">Section page. This page is for editing information about a
section and adding questions to it. It contains a couple of
subpages. Datamodell can be found <a href="http://sussdorff.de/assessment/doc/grouping.html">here.</a><br><br>
On the Top of the page display the title and description along with
the display type for information purposes. Below this put links to
the following pages.<br><br>
The section edit page contains the following
Items:<br>
</span></span>
<ul>
<li><span class="context">Title: Title of the section</span></li><li><span class="context">Description: text used for identification
and selection in admin pages, not for end-user pages</span></li><li><span class="context">Instructions: text displayed on user
pages describing the user how to fill out the section.</span></li><li><span class="context">
<a href="../display_types">Display Type</a>: section
display type to use. Select box of display types in use by this
user, as well as "new display type" and "display
type from catalogue".<br>
</span></li><li><span class="context">Seconds allowed for completion: integer.
Seconds allowed for completing the section.</span></li><li><span class="context">Feedback Text: textarea. Feedback given
to the user after finishing the section.</span></li><li><span class="context">
<span class="context"><span class="reg">Number of questions: Number of questions that will be
displayed in this section. Only useful if we
randomize.</span></span> If the number of questions added to this
section is higher than number of questions to display then we
randomly pick from the questions, but definitely add the mandatory
questions.<br>
</span></li><li style="list-style: none"><br></li>
</ul>

The branch conditions page allows the conditions to be added under
which this section will be called (branch conditions). This is
still work in progress and will not be developed in the first
phase.<br>
<ul>
<li><span class="context">
<a href="../sequencing"><span style="color: rgb(204, 102, 0);">Sequencing
Information</span></a><br>
</span></li><li style="list-style: none; display: inline"><ul>
<li style="color: rgb(204, 102, 0);">Display of the Pre Display
Checks (with an edit and a remove link).</li><li style="color: rgb(204, 102, 0);">Add new Pre Display
Check.</li><li style="color: rgb(204, 102, 0);">Add new Post Display
Check.<br>
</li><li style="color: rgb(204, 102, 0);">Use one or all conditions:
boolean. Is it mandatory that all conditions have been met or is
one condition enough (for not displaying this section)</li>
</ul></li>
</ul>
<ul>
<li style="color: rgb(204, 102, 0);">
<span class="context">Branch
by question. This kind of branch depends on previous answers. A
table of all multiple choice / boolean questions will be given to
the creator along with their possible answers.</span><ul>
<li><span class="context">Each question has a checkbox to determine
if this question shall be included in this branch condition and a
radio button, if all answers or just one have to be given (e.g. if
we have multiple correct answers, we might want to branch into this
section all answers have been selected by the respondee or just
one).</span></li><li><span class="context">The answers have checkboxes, with the
correct answers checked by default for multiple choice question.
All other questions will only be displayed if they give a
percentage value to the answer. In this case a textfield is given
with the possibility to give a range (10-100) or separate
percentages (10, 100, 200).</span></li><li><span class="context">The display of this section depends on
whether the valid answers have been given to all or just one of the
questions that have been checked (as you might have guessed, we
need a radio button for this below the table).</span></li>
</ul><span class="context">Questions that will be displayed depend on
the position of the section. Only questions that could have been
answered in the assessment before this section is displayed will be
shown.</span>
</li><li style="color: rgb(204, 102, 0);">
<span class="context">Branch
by result. Instead of relying on one or multiple answers we check
for a result in a previous section. This can only work in a test
environment (so don&#39;t display this option if we are not dealing
with a test).</span><ul>
<li><span class="context">Section: select. This will display a list
of all previous sections. The selected section will be used for the
computation.</span></li><li><span class="context">Calculation: select (median, distractor,
absolute number of points). What shall be computed to determine
whether the user is allowed to see this section.</span></li><li><span class="context">From / To value: integer. Two fields to
display the valid range for which this section will be displayed to
the user.</span></li>
</ul>
</li><li><span class="context"><span style="color: rgb(204, 102, 0);">It
is imagineable that a combination of both methods makes sense, so
we should take this into account when creating the
UI.</span></span></li>
</ul>
<br>

Below this information we have a paragraph where all questions are
displayed with the options to<br>
<ul>
<li>Edit question<br>
</li><li>Search and add question(s) from question database: Link to the
search page which allows one to search for questions that can be added
to this section (multiple add possibility).</li><li>Add question: Link to the question catalogue entry form with a
return_url that adds the question from the catalogue to this
section and return to the section page.</li><li>Change order of questions (arrow navigation) Title of the
question Link to edit question properties with regards to this
section</li><li>Points: integer. Number of Points this question is worth in
this section.<br>
</li><li>Mandatory: boolean (yes/no). Is this question mandatory in this
section. It will be displayed in any case, regardless of
randomizing.</li><li>Fixed Position: select (1,2..., buttom). Position the question
has to be displayed, regardless of randomizing.</li>
</ul>
<span class="context">
<span class="etp-link"><a class="top" href="etp?name=sections"></a></span><!-- END ETP LINK -->
</span>
