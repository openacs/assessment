ad_page_contract {
    This page deletes checks
    @author Anny Flores (annyflores@viaro.net) Viaro Networks
    @date 2005-01-17
} {
    inter_item_check_id:multiple
    section_id
    assessment_id
}

ad_form -name delete_checks -form {

    {inter_item_check_id:text(hidden) 
	{value $inter_item_check_id}
    }
    {section_id:text(hidden) 
	{value $section_id}
    }
    {assessment_id:text(hidden) 
	{value $assessment_id}
    }
} -on_submit {
    ad_returnredirect "checks-delete?section_id=$section_id&inter_item_check_id=$inter_item_check_id&assessment_id=$assessment_id"
}