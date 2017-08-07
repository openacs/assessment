
<property name="context">{/doc/assessment {Assessment}} {Appendix A: RFC for Assessment Specs}</property>
<property name="doc(title)">Appendix A: RFC for Assessment Specs</property>
<master>
<!-- START HEADER --><h1><span class="context">Introduction</span></h1>
<span class="context">In recent times the survey system has
expanded beyond it&#39;s initial scope of providing a quick and
easy solution to conduct surveys. Due to it&#39;s flexibility it
has already expanded in the area of storing user information and
provide a tool for feedback for quality assurance.</span>
<p><span class="context">On the other hand the need for dotLRN has
risen to provide an assessment solutions that allows (automated)
tests as well with the possibility to score the test results and
store them in an easy retrievable way.</span></p>
<p><span class="context">Last but not least a new demand has risen
for the possibility to give and store ratings on objects within the
system as part of a knowledge management solution.</span></p>
<p><span class="context">The documents on these page will provide a
solution that is flexible to meet ababove needs but still be
focused enought to apply for special clients demands.</span></p>
<h1><span class="context">Assessments</span></h1>
<span class="context">The current survey system will build the
basis for a new assessment package and will consist of various
areas:</span>
<h2><span class="context">Question Catalogue</span></h2>
<span class="context">The question catalogue stores all the
questions of the assesment package. It is a pool where all the
questions from all assessments are stored in. This creates the
opportunity to make the questions reusable, allowing for statistics
across surveys and prevents the respondee from having to fill out a
question he has already filled out. Furthermore special
administrators are given the possibility to add questions that do
not store the results within the scope of the assessment package
but in other database tables (e.g. the name of the user) or trigger
some other events (e.g. send email to the email address filled out
by the respondee). A detailed description can be found <a href="question_catalogue">here</a>.</span>
<h2><span class="context">Assessment creation</span></h2>
<span class="context">An assessment is either a survey or a test.
The functionality for both is nearly identical though a test needs
additional work to allow for automated grading. A detailed
description of the options given to the creator of an assessment
can be found <a href="assessment_creation">here.</a>
</span>
<p><span class="context">Each assessment consists of various
sections, that allow for the split up of the assessment (so it will
be displayed to the respondee on multiple pages) and give the
possibility for branching depending on previous answers of the
respondee. Questions are always added into the question database
first, then added to a specific section and thus made available to
the assessment. A detailed description of the Sections can be found
<a href="sections">here</a>.</span></p>
<h2><span class="context">Tests</span></h2>
<span class="context">Tests are a special kind of assessment in
that they allow for automatic processing of the answers and storage
of the result in the grading system. They have a couple of
additional settings as well as the possibility to get an overview
of the evaluation (what have the respondees answered, how have they
done in total (points)). A description for this can be found
<a href="tests">here</a>.</span>
<p><span class="context">The backend for the test processing, that
enables the automatic tests is described in a <a href="test_processing">seperate document</a> as it will be parsed while
the respondee answers the test, not manually. In addition this
document describes how the grades are calculated (automatically or
manually) for each question. The result is beeing stored in the
grading package.</span></p>
<h1><span class="context">Scoring/Grading</span></h1>
<span class="context">The grading package will be designed first of
all to all the storing of test results. In addition to this, it
will provide functionality to other packages to allow rating of
their contents (one example of this would be Lars Rating package,
that would be used as a basis for this). In general it should
provide a very flexible way of adding scores into the system,
either automatically (as described above) or manually (e.g. this
student did a good oral exam).</span>
<p><span class="context">In addition to the possiblity to enter
scores/rates, the grading package allows for automatic aggregation
of scores. This holds especially true for tests and classes. A test
result will depend on the result of all the answers (aggregated). A
class result will depend on the result of all the tests a respondee
did in addition to any manual grades the professor can come up
with. Providing a clean UI for this is going to be the
challange.</span></p>
<p><span class="context">Furthermore the grading package offers to
transfer scores (which are stored as integer values) into a grade
(e.g. the american A-F scheme, or the German 1-6). This is where it
gets the name from I&#39;d say ;). Grading schemes are flexible and
can be created on the fly. This allows us to support any grading
scheme across the world&#39;s universities. In addition in the area
of Knowledge Management, grades could be transfered into incentive
points, that can be reused to reward employees for good work done
(where they got good ratings for).</span></p>
<p><span class="context">Last but not least, maybe embeded with the
workflow system, is the possibility to execute actions based on the
grade. An example would be the adding of the student to the
advanced class if his grade or score reaches a certain level.
Alternatively this looks like a good thing for the curriculum
module to achieve.</span></p>
<h1><span class="context">User Experience</span></h1>
<span class="context">So far we have only talked about the
administrators point of view. A respondee will be directed to an
assessment from various possible entry points. Depending on the
settings for the assessment the respondee will be presented with
the assessment that he is allowed to answer. Though a lot of it is
redundant, a <a href="user_experience">special page</a> has been
created to describe this. For the implementation though there might
be additional things depending on the specifications of the various
administrator settings.</span>
<h1><span class="context">Use Cases</span></h1>
<span class="context">The most obvious use case would be a class in
a school or university, that offers automated tests to the students
and wants to have them graded automatically. The description of the
assessment system has been written mainly with this in mind.</span>
<p><span class="context">Additionally you can use the assessment
system to collect user information. When signing up to a site the
user could be asked to fill out an assessment where part of the
questions will be stored in the acs_users table, some other
questions in other tables and the rest in the accessment package.
This way a quick view can be given about the user (aggregating user
information in a flexible way). Best explanation would be to treat
the /pvt/home page as a collection of assessment data and the
"change basic information" as one assessment among
many.</span></p>
<p><span class="context">With a little bit of tweaking and the
possiblity to add instant gratification, aka aggregated result
display, it could include the poll package and make it
redundant.</span></p>
<p><span class="context">Last but not least with the ability to
display questions in a multi dimensional way to the user, the
assessment system is usefull for quality assurance (how important
is this feature / how good do you think we implemented it). And as
you might have guessed, for anything the current survey module has
been used for as well (e.g. plain and simple surveys).</span></p>
<p><span class="context">The grading system on it&#39;s own would
be usefull for the OpenACS community as it would allow the handing
out of "zorkmints" along with any benefits the collection
of mints gives to the users. As mentioned earlier, this is also
very important in a Knowledge Management environment, where you
want to give rated feedback to users.</span></p>
<blockquote><p><span class="context">
<strong><a href="question_catalogue">Question Catalogue</a></strong><br><br><strong><a href="assessment_creation">Assessment
Creation</a></strong><br><br><strong><a href="sections">Sections</a></strong><br><br><strong><a href="tests">Tests</a></strong><br><br><strong><a href="test_processing">Test Processing</a></strong><br><br><strong><a href="user_experience">User Experience</a></strong><br><br><strong><a href="current/"><br></a></strong>
</span></p></blockquote>
<span class="context">
<span class="etp-link"><a class="top" href="etp?name=index"></a></span><!-- END ETP LINK -->
</span>
