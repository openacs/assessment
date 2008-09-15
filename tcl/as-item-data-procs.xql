<?xml version="1.0"?>
<queryset>

<fullquery name="as::item_data::new.old_item_id">
      <querytext>

	select item_id as item_data_id, latest_revision
	from cr_items
	where name = :name
	and parent_id = :folder_id

      </querytext>
</fullquery>

<fullquery name="as::item_data::new.save_choice_answer">
      <querytext>

	insert into as_item_data_choices (item_data_id, choice_id)
	values (:as_item_data_id, :choice_id)

      </querytext>
</fullquery>

<fullquery name="as::item_data::new.insert_session_map">
      <querytext>

	insert into as_session_item_map (session_id, item_data_id)
	values (:session_id, :as_item_data_id)

      </querytext>
</fullquery>

<fullquery name="as::item_data::new.update_session_map">
      <querytext>

	update as_session_item_map
	set item_data_id = :as_item_data_id
	where session_id = :session_id
	and item_data_id = :latest_revision

      </querytext>
</fullquery>

<fullquery name="as::item_data::get.last_sessions">
      <querytext>

	select d.session_id, d.as_item_id
	from as_item_data d, cr_revisions r, cr_revisions r2
	where d.subject_id = :subject_id
	and d.as_item_id = r.revision_id
        and d.section_id = :section_id
	and r2.revision_id = :as_item_id
	and r.item_id = r2.item_id
	order by d.session_id desc

      </querytext>
</fullquery>

<fullquery name="as::item_data::get.mc_response">
      <querytext>

	select choice_id
	from as_item_data_choices
	where item_data_id = :item_data_id

      </querytext>
</fullquery>

</queryset>
