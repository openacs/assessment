#www/show_assessments.tcl

ad_page_contract {
	@author alvaro@it.uc3m.es
	@creation-date 2004-06-07
} {
} -properties {
	context:onevalue
	assessment_info:multirow
}

set context [list "Show Assessments"]

set i 0
db_multirow assessment_info asssessment_id_name_definition {} {
	set assessment_id_matriz($i) $assessment_id
	incr i 1
}

#for {set i 0} {$i < [array size assessment_id_matriz]} {incr i 1} {
#	set assessment_id assessment_id_matriz($i)
#	db_multirow section_info section_id_name_definition {}
#}

#debug_print 1 "Assessments.tcl" ${assessment_info:1(assessment_id)}
#debug_print 1 "Assessments.tcl" ${assessment_info:rowcount}

ad_return_template