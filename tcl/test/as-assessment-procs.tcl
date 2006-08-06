# packages/assessment/tcl/test/as-assessment-procs.tcl

ad_library {
    
    Tests for assessment procs
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2006-08-03
    @cvs-id $Id$
}

aa_register_case pretty_time {
    Test pretty_time proc
} {
    foreach seconds {"" 0} {
        catch {as::assessment::pretty_time -seconds $seconds} pretty_time
    aa_true "\"$seconds\" returns \"$seconds\"" [expr {$pretty_time eq $seconds}]
    }
}
