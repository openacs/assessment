update acs_objects set context_id=(select parent_id 
        from cr_items 
        where item_id=object_id) 
    where object_id in 
        (select item_id 
         from cr_items 
         where content_type='as_assessments');

update acs_objects set context_id=package_id
where object_id in (select cf.folder_id 
    from cr_folders cf,
    cr_items ci,
    apm_packages p
    where ci.parent_id=-100
    and ci.item_id=cf.folder_id
    and p.package_key='assessment'
    and p.package_id=cf.package_id);
