<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "http://www.thecodemill.biz/repository/xql.dtd">
<!-- packages/assessment/tcl/test/as-assessment-procs-postgresql.xql -->
<!-- @author Dave Bauer (dave@thedesignexperience.org) -->
<!-- @creation-date 2007-04-07 -->
<!-- @cvs-id $Id$ -->
<queryset>

  <rdbms>
    <type>postgresql</type>
    <version>8.0</version>
  </rdbms>

  <fullquery name="_assessment__as_instantiate.update_session">
      <querytext>
        update as_sessions set last_mod_datetime=now()
        where session_id=:session_id
      </querytext>
  </fullquery>
</queryset>    