<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!-- packages/assessment/tcl/test/as-assessment-procs.xql -->
<!-- @author Dave Bauer (dave@thedesignexperience.org) -->
<!-- @creation-date 2007-04-07 -->
<!-- @cvs-id $Id$ -->
<queryset>
  <fullquery name="_assessment__as_instantiate.update_session">
    <querytext>
      update as_sessions set last_mod_datetime=current_timestamp
      where session_id=:session_id
    </querytext>
  </fullquery>
</queryset>
