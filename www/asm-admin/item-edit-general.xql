<?xml version="1.0"?>
<queryset>

<fullquery name="get_item_type">
      <querytext>

    select o.object_type
    from acs_objects o, as_item_rels r
    where r.item_rev_id = :as_item_id
    and r.rel_type = 'as_item_type_rel'
    and o.object_id = r.target_rev_id

      </querytext>
</fullquery>

<fullquery name="display_types">
      <querytext>

    select display_type
    from as_item_types_map
    where item_type = :item_type

      </querytext>
</fullquery>

<fullquery name="get_item_content">
      <querytext>

    select cr.title || ' (' || cr.content_length || ' bytes)' as content_name,
           cr.revision_id as content_rev_id, cr.title as content_filename
    from cr_revisions cr, as_item_rels r
    where r.item_rev_id = :as_item_id
    and r.target_rev_id = cr.revision_id
    and r.rel_type = 'as_item_content_rel'

      </querytext>
</fullquery>

<fullquery name="general_item_data">
<querytext>

	select r.title, r.description, i.subtext, i.field_name, i.field_code, i.required_p,
	       i.feedback_right, i.feedback_wrong, i.max_time_to_complete, i.data_type, i.points, i.validate_block, r.content as question_text, r.mime_type
	from cr_revisions r, as_items i
	where r.revision_id = i.as_item_id
	and i.as_item_id = :as_item_id

</querytext>
</fullquery>

<fullquery name="get_display_type">
      <querytext>

    select o.object_type
    from acs_objects o, as_item_rels r
    where r.item_rev_id = :as_item_id
    and r.rel_type = 'as_item_display_rel'
    and o.object_id = r.target_rev_id

      </querytext>
</fullquery>

<fullquery name="insert_item_content">
      <querytext>
	        insert into as_item_rels
                (target_rev_id, item_rev_id, rel_type)
                values
                (:content_rev_id, :new_item_id, 'as_item_content_rel')
      </querytext>
</fullquery>

<fullquery name="update_item_content">
      <querytext>

		update as_item_rels
		set target_rev_id = :content_rev_id
		where item_rev_id = :new_item_id
		and rel_type = 'as_item_content_rel'

      </querytext>
</fullquery>

<fullquery name="delete_item_content">
      <querytext>

		delete from as_item_rels
		where item_rev_id = :new_item_id
		and rel_type = 'as_item_content_rel'

      </querytext>
</fullquery>

<fullquery name="update_section_in_assessment">
      <querytext>

		update as_assessment_section_map
		set section_id = :new_section_id
		where assessment_id = :new_assessment_rev_id
		and section_id = :section_id

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

<fullquery name="update_title">
      <querytext>

		    update cr_revisions
		    set title = :title
		    where revision_id = :new_choice_id

      </querytext>
</fullquery>

<fullquery name="update_correct">
      <querytext>

		    update as_item_choices
		    set correct_answer_p = :correct_answer_p
		    where choice_id = :new_choice_id

      </querytext>
</fullquery>

<fullquery name="update_item_type">
      <querytext>

		update as_item_rels
		set target_rev_id = :new_item_type_id
		where item_rev_id = :new_item_id
		and rel_type = 'as_item_type_rel'

      </querytext>
</fullquery>

<fullquery name="get_sort_order">
        <querytext>
        select sort_order from as_item_choices where choice_id=:n
        </querytext>
</fullquery>


<fullquery name="existing_choice_sets_old">
      <querytext>
	select substring(title from 1 for 50) as title, revision_id from (select r.title, r.revision_id, case when m.target_rev_id is not null then 0 else 1 end as sort_key
    from cr_items i, cr_revisions r
    left join 
    (select r1.target_rev_id from
     as_item_section_map m1, as_item_rels r1, as_assessment_section_map m2,
     cr_items i2, cr_items i3, cr_items i4
     where m1.as_item_id = r1.item_rev_id and r1.rel_type = 'as_item_type_rel'
     and m1.section_id = m2.section_id 
     and m2.assessment_id = i2.latest_revision
     and m1.as_item_id = i3.latest_revision
     and m1.section_id = i4.latest_revision
     and i2.item_id = :assessment_id) m
    on m.target_rev_id = r.revision_id
    where 
    i.parent_id = :folder_id
    and r.revision_id = i.latest_revision
    and i.content_type like 'as_item_type_mc') q order by sort_key

      </querytext>
</fullquery>

<fullquery name="existing_choice_sets">
      <querytext>
    select distinct title, revision_id from (select substr(title,1,50) as title, revision_id 
    from cr_items i, cr_revisions r
    where 
    i.parent_id = :folder_id
    and r.title is not NULL
    and r.revision_id = i.latest_revision
    and i.content_type = 'as_item_type_mc') c
      </querytext>
</fullquery>

</queryset>
