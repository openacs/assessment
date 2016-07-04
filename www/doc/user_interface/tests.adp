
<property name="context">{/doc/assessment {Assessment}} {Tests}</property>
<property name="doc(title)">Tests</property>
<master>
<!-- START HEADER --><span class="context"><span class="reg">A test
is a special kind of accessment that allows the respondee&#39;s
answers to be rated immediatly. Unless otherwise stated, all pages
described are admin viewable only.</span></span>
<ul>
<li>
<span class="context">Settings</span><ul>
<li><span class="context">Assessment: a selectbox containing all
the assessment in the same subnode as the test package, so the
administrator knows for which survey he will create an
test.</span></li><li><span class="context">Valid Results: select (first, last,
highest, median). Describes which points to choose if a user has
the option to take a test multiple times. Median is the median of
all tries.</span></li><li><span class="context">Publication of Results: radio. Publicate
results once test is submitted, once test has been evaluated by a
TA, never. This is always with regards to the respondee. Admins can
view the results all the time.</span></li><li>
<span class="context">What to show in publication:
checkboxes.</span><ul>
<li><span class="context">Question. The question that has been
asked</span></li><li><span class="context">Answer. The answer the respondee has
given</span></li><li><span class="context">Points. The number of Points the
respondee has gotten for the answer</span></li><li><span class="context">Evaluation comment. The evaluation
comment given by the evaluator</span></li><li><span class="context">Correct Answer. The correct answer of the
question</span></li><li><span class="context">Feedback. The feedback that is stored
with the given answer</span></li><li><span class="context">Feeback for question. The feedback that
is stored with the question</span></li><li><span class="context">Total result. The total result of the
test (at the buttoms)</span></li>
</ul>
</li><li><span class="context">Submit each answer seperatly: boolean
(yes/no). Does the user have to submit each answer
seperatly.</span></li><li><span class="context">Answer changeable: boolean (yes/no). Can
the user change a submitted answer.</span></li><li><span class="context">Finish button: boolean (yes/no). Allow
the respondee to finish the test early, despite not having answered
all the questions. The respondee will not have the option to go
back and continue the test afterwards (like handing out your
written test to the TA in an on site exam).</span></li><li><span class="context">Allow answers to be seen: boolean
(yes/no). This will disallow the respondee to revisit his
answers.</span></li>
</ul>
</li><li>
<span class="context">Evaluation overview. This is a page with
a table of all respondees with</span><ul>
<li><span class="context">Smart display (to limit the number of
respondees per page)</span></li><li><span class="context">Name. Name of the respondee, maybe with
email address</span></li><li><span class="context">Test result (with max number of points in
the header). Number of Points the respondee has achieved in this
test</span></li><li>
<span class="context">All tries with</span><ul>
<li><span class="context">Points. Number of Points for this try
(out of the scoring system)</span></li><li><span class="context">Time. Time taken for a try (yes, we will
have to store the time needed for a try)</span></li><li><span class="context">Status. Status of the try (not finished,
finished, auto-graded, manually graded)</span></li><li><span class="context">Link to evaluate single response (human
grading in test-processing.html)</span></li><li><span class="context">The try that is used for scoring the
respondee is diplayed with a green background. If we take the
median of all tries, mark all of them green.</span></li>
</ul>
</li><li><span class="context">Furthermore links to details about the
test, reports and summary are given.</span></li>
</ul>
</li>
</ul>
<span class="context"><span class="reg">Test processing happens in
a multiple stage process.</span></span>
<ol>
<li><span class="context">The system evaluates the test as good as
it can.</span></li><li><span class="context">The results of this auto-grading are
displayed in the evaluation table for the admin (see test
specifications)</span></li><li><span class="context">The test result is stored in the scoring
system.</span></li><li><span class="context">Staff can manually Human Grade the test.
This is mandatory for open questions for the test to be completly
graded.</span></li><li><span class="context">The result of the human grading
overwrites the auto grading in the scoring system.</span></li>
</ol>
<span class="context">Autograding is different for the types of
questions the test has. For future versions it should be possible
to easily add other types of information that will be autograded.
All autograding follow this scheme:</span>
<ol>
<li><span class="context">The answer is taken from the respondee
response</span></li><li><span class="context">It is compared with the correct
answer</span></li><li><span class="context">A percentage value is
returned</span></li><li><span class="context">The percentage value is multiplied with
the points for the question in the section (see assessment document
for more info).</span></li><li><span class="context">The result will be stored together with a
link to the response for the particular question in the scoring
system.</span></li><li><span class="context">Once finished with all the questions, the
result for the test is computed and stored with a link to the
response in the scoring system.</span></li>
</ol>
<span class="context">Autograding is different for each type of
question.</span>
<ul>
<li>
<span class="context">Multiple Choice</span><ul>
<li><span class="context">All or nothing. In this scenario it will
be looked, if all correct answers have been chosen by the respondee
and none of the incorrect ones. If this is the case, respondee
get&#39;s 100%, otherwise nothing.</span></li><li><span class="context">Cumultative. Each answer has a certain
percentage associated with it. This can also be negative. For each
option the user choose he will get the according percentage. If
negative points are allowed, the user will get a negative
percentage. In any case, a user can never get more than 100% or
less then -100%.</span></li>
</ul>
</li><li>
<span class="context">Matching question</span><ul>
<li><span class="context">All or nothing: User get&#39;s 100% if
all matches are correct, 0% otherwise.</span></li><li><span class="context">Equally weigthed: Each match is worth
100/{number of matches} percent. Each correct match will give the
according percentage and the end result will be the sum of all
correct matches.</span></li><li><span class="context">Allow negative: If we have equally
weigthed matches, each correct match adds the match percentage (see
above) to the total. Each wrong match distracts the match
percentage from the total.</span></li><li><span class="context">Obviously it is only possible to get up
to 100% and not less than -100%.</span></li>
</ul>
</li><li>
<span class="context">Short answer question</span><ol>
<li><span class="context">For each answerbox the possible answers
are selected.</span></li><li>
<span class="context">The response is matched with each of the
possible answers</span><ul>
<li><span class="context">Equals: Only award the percentage if the
the strings match exactly (case senstivity depends on the setting
for the question).</span></li><li><span class="context">Contains: If the answer contains exactly
the string, points are granted. If you want to give percentages for
multiple words, add another answer to the answerbox (so instead of
having one answerbox containing "rugby soccer football",
have three, one for each word).</span></li><li><span class="context">Regexp: A regular expression will be run
on the answer. If the result is 1, grant the
percentage.</span></li>
</ul>
</li><li><span class="context">The sum of all answerbox percentages will
be granted to the response. If allow negative is true, even a
negative percentage can be the result.</span></li>
</ol>
</li>
</ul>
<span class="context">Human grading will display all the questions
and answers of response along with the possibility to reevalutate
the points and give comments. The header will display the following
information:</span>
<ul>
<li><span class="context">Title of the test</span></li><li><span class="context">Name of the respondee</span></li><li><span class="context">Number of the try / total number of
tries</span></li><li><span class="context">Status of the try (finished, unfinished,
autograded, human graded (by whom))</span></li><li><span class="context">Start and Endtime for this
try</span></li><li><span class="context">Time needed for the try</span></li><li><span class="context">Total number of Points for this
test:Integer. Prefilled with the current value for the
response.</span></li><li><span class="context">Comment: richtext. Comment for the number
of points given. Prefilled with the current version of the
comment.</span></li>
</ul>
<span class="context">For each question the following will be
displayed</span>
<ul>
<li><span class="context">Question Title.</span></li><li><span class="context">Maximum number of points for this
question.</span></li><li><span class="context">Question.</span></li><li><span class="context">New Points: Integer. Prefilled with the
current value for the response. This is the possibility for staff
to give a different number of points for whatever
reason.</span></li><li><span class="context">Comment: richtext. Comment for the number
of points given. Prefilled with the current version of the
comment.</span></li><li>
<span class="context">Answer. The answer depends on the
question type.</span><ul>
<li><span class="context">Multiple Choice: The answer is made up of
all the options, with a correct/wrong statement (in case we have an
all or nothing type of multiple choice) or a percentage in front of
them (depending on the response) and a small marker that shows
which option the respondee picked. The correct / wrong depends
whether the respondee has answered correct or wrong for this option
(if he picked an option that he should not have picked, this option
will get a wrong in front).</span></li><li><span class="context">Matching question: The item on the left
side and the picked item are displayed in a connecting manner. A
correct / wrong statment will be added depending whether the
displayed (and responded) match is correct.</span></li><li><span class="context">Open Question: The answer is displayed as
written by the user. Furthermore the correct answer is displayed as
well. This should allow the TA to easily come to a conclusion
concerning the number of points.</span></li><li><span class="context">Short Answer: For each answerbox the
response will be displayed along with the percentage it got and all
the correct answers for this answerbox (with percentage). Might be
interesting to display regexps here :-).</span></li>
</ul>
</li>
</ul>
<span class="context">
<span class="etp-link"><a class="top" href="etp?name=tests"></a></span><!-- END ETP LINK -->
</span>
