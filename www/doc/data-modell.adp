
<property name="context">{/doc/assessment {Assessment}} {Assessment Data Modell Overview}</property>
<property name="doc(title)">Assessment Data Modell Overview</property>
<master>
<h2>Overview</h2>
<p>At its core, the Assessment package defines a hierarchical
container model of a "survey", "questionnaire"
or "form". This approach not only follows the precedent
of existing work; it also makes excellent sense and no one has come
up with a better idea.</p>
<ul>
<li>One Assessment consists of</li><li>One or more Sections which each consist of</li><li>One or more Items which have</li><li>Zero or more Choices</li>
</ul>
<p>We choose the terms Assessment-Sections-Items-Choices over
Surveys-Sectdions-Questions-Choices partly to reduce naming clashes
during the transition from Survey/Questionnaire packages, but
mostly because these terms are more general and thus suit the
broader applicability intended for this package.</p>
<p>As is the custom in the OpenACS framework, all RDBMS tables in
the package will be prepended with "as_" to prevent
further prefent naming clashes. Judicious use of namespaces will
also be made in keeping with current OpenACS best practice.</p>
<p>Several of the Metadata entities have direct counterparts in the
Data-related partition of the data model. Some standards (notably
CDISC) rigorously name all metadata entities with a
"_def" suffix and all data entities with a
"_data" suffix -- thus "as_item_def" and
"as_item_data" tables in our case. We think this is
overkill since there are far more metadata entities than data
entities and in only a few cases do distinctions between the two
become important. In those cases, we will add the "_data"
suffix to data entities to make this difference clear.</p>
<p>A final general point (that we revisit for specific entities
below): the Assessment package data model exercises the Content
Repository (CR) in the OpenACS framework heavily. In fact, this use
of the CR for most important entities represents one of the main
advances of this package compared to the earlier versions. The
decision to use the CR is partly driven by the universal need for
versioning and reuse within the functional requirements, and partly
by the fact that the CR has become "the Right Way" to
build OpenACS systems. Note that one implication of this is that we
can&#39;t use a couple column names in our derived tables because
of naming clashes with columns in cr_items and cr_revisions: title
and description. Furthermore we can handle <a href="versioning">versioning</a> and internationalization through
the CR.</p>
<h2>Synopsis of The Data Model</h2>
<p>Here&#39;s a detailed summary view of the entities in the
Assessment package. Note that in addition to the partitioning of
the entities between Metadata Elements and Collected Data Elements,
we identify the various subsystems in the package that perform
basic functions.</p>

We discuss the following stuff in detail through the subsequent
pages, and we use a sort of "bird&#39;s eye view" of this
global graphic to keep the schema for each subsystem in perspective
while homing in on the relevent detail. Here&#39;s a brief
introduction to each of these section<br>
<ul>
<li>
<a href="as_items">core - items</a> entities (purple)
define the structure and semantics of Items, the atomic units of
the Assessment package</li><li>
<a href="grouping">core - grouping</a> entities (dark
blue) define constructs that group Items into Sections and
Assessments</li><li>
<a href="sequencing">sequencing</a> entities
(yellow-orange) handle data validation steps and conditional
navigation derived from user responses</li><li>
<a href="sequencing">scoring ("grading")</a>
entities (yellow-green) define how raw user responses are to be
processed into calculated numeric values for a given
Assessment</li><li>
<a href="display_types">display</a> entities (light blue)
define constructs that handle how Items are output into the actual
html forms returned to users for completion -- including page
layout and internationalization characteristics</li><li>
<a href="policies">scheduling</a> entities define
mechanisms for package administrators to set up when, who and how
often users should perform an Assessment</li><li>
<a href="data_collection">session data collection</a>
entities (bright green) define entities that store information
about user data collection events -- notably session status and
activities that change that status as the user users the
system</li>
</ul>
<center>
<a href="http://openacs.org/storage/download/assessment.graffle?version_id=187542"></a><p><img alt="Data Modell Graphic" src="images/assessment.jpg" style="width: 1076px; height: 1442px;"></p>
</center>
