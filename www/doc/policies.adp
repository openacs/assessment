
<property name="context">{/doc/assessment {Assessment}} {Policies and Events}</property>
<property name="doc(title)">Policies and Events</property>
<master>
<h2>Policies and Events<br>
</h2>
<ul>
<li>Assessment-Policies (as_assessment_policies) abstract out from
Assessments a variety of attributes that describe deployment
particulars. This allows multiple users of an Assessment to define
beginning and ending dates, eg:
<ul>
<li>policy_id</li><li>policy_name</li><li>start_date</li><li>end_date</li><li>anonymous_p - whether anonymous subjects are allowed</li><li>repetition_interval_granularity - minutes, hours, days</li><li>repetition_interval - an integer that (along with the
granularity) defines the minimum interval between sequential
assessments by a subject; an interval of zero means that only a
single time through is allowed</li><li>editable_p - whether user can alter submitted responses</li><li>max_edits_allowed - optional max number of times subject can
change responses</li><li>max_time_to_complete - optional max number of seconds to
perform Assessment</li><li>interruptable_p - whether user can "save&amp;resume"
session</li><li>data_entry_mode - (presumes that the necessary UI output procs
are implemented in the APIs) to produce different deployment
formats: standard web page, handheld gizmo, kiosk "one
question at a time", AVR over phone, etc etc</li><li>consent_required_p - whether subjects must give formal consent
before doing Assessment</li><li>consent - optional text to which the subject needs to agree
before doing the Assessment (this may be more appropriate to
abstract to Assessment-Events)</li><li>logo - optional graphic that can appear on each page</li><li>electronic_signature_p - whether subject must check
"attestation box" and provide password to
"sign"</li><li>digital_signature_p - whether in addition to the electronic
signature, the response must be hashed and encrypted</li><li>shareable_p - whether Policy is shareable; defaults to
't' since this is the whole intent of this
"repository" approach, but authors' should have
option to prevent reuse</li><li>feedback_text - where optionally some preset feedback can be
specified by the author</li><li>double_entry_p - do two staff need to enter data before
it&#39;s accepted?</li><li>require_annotations_with_rev_p - is an annotation required if a
user modifies a submitted response?</li>
</ul>
</li><li>Assessment Events (as_assessment_events) define an planned,
scheduled or intended "data collection event". It
abstracts out from Assessment Policies details that define specific
instances of an Assessment&#39;s deployment. Attributes include:
<ul>
<li>event_id</li><li>name</li><li>description</li><li>instructions</li><li>target_days_post_enroll - an interval after the
"enrollment" date which could be the time a subject is
enrolled in a trial or the beginning of a term</li><li>optimal_days_pre - along with the next attribute, defines a
range of dates when the Assessment should be performed (if zero,
then the date must be exact)</li><li>optimal_days_post</li><li>required_days_pre - as above, only the range within which the
Assessment must be performed</li><li>required_days_post</li><li style="font-family: monospace;"><center><p><img alt="Data model" src="images/assessment-schedfocus.jpg" style="width: 716px; height: 653px;"></p></center></li>
</ul>
</li>
</ul>
