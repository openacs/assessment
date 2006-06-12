<?xml version="1.0"?>
<queryset>

	<fullquery name="as::qti::parse_qti_xml.as_assessment_section_map_insert">
		<querytext>
			INSERT INTO as_assessment_section_map (assessment_id, section_id, max_time_to_complete, sort_order, points) 
			VALUES (:as_assessments__assessment_id, :section_id, :as_sections__duration, :as_asmt_sect_map__sort_order, :as_sections__points)
		</querytext>
	</fullquery>

	<fullquery name="as::qti::parse_qti_xml.as_item_section_map_insert">
		<querytext>
			INSERT INTO as_item_section_map (as_item_id, section_id, sort_order, points, max_time_to_complete, required_p) 
			VALUES (:as_item_id, :section_id, :as_item_sect_map__sort_order, :as_item__points, :as_item__duration, :as_item__required_p)
            </querytext>
        </fullquery>
	
	<fullquery name="as::qti::parse_qti_xml.get_section_points">
            <querytext>
	        select sum(aism.points) as as_sections__points
                from as_item_section_map aism, as_assessment_section_map aasm
                where aism.section_id = aasm.section_id and aasm.section_id = :section_id
            </querytext>
        </fullquery>
	
	<fullquery name="as::qti::parse_qti_xml.update_as_assessment_section_map">
            <querytext>
	        update as_assessment_section_map
	        set points = :as_sections__points
	        where section_id = :section_id
            </querytext>
        </fullquery>

  <fullquery name="update_item_in_section">
    <querytext>
      
      update as_item_section_map
      set as_item_id = :new_item_id,
      points = :points,
      required_p = :required_p
      where section_id = :new_section_id
      and as_item_id = :as_item_id
      
    </querytext>
  </fullquery>

</queryset>
