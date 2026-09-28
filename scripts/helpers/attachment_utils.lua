-- chunkname: @scripts/helpers/attachment_utils.lua

AttachmentUtils = {}

AttachmentUtils.create_attachment = function (world, owner_unit, attachments, slot_name, item_data, show)
	-- function 1
	assert(attachments.slots[slot_name] == nil, "Slot is not empty, remove attachment before creating a new one.")

	local item_template = BackendUtils.get_item_template(item_data)
	local unit

	if item_data.unit then
		local item_units = BackendUtils.get_item_units(item_data)
		local unit_spawner = Managers.state.unit_spawner

		if item_units.unit and item_units.unit ~= "" then
			unit = unit_spawner:spawn_local_unit(item_units.unit)

			Unit.set_unit_visibility(unit, show)

			if not show then
				Unit.flow_event(unit, "lua_attachment_hidden")
			end
		end
	end

	if item_template.attachment_node_linking and item_template.attachment_node_linking[slot_name] then
		AttachmentUtils.link(world, owner_unit, unit, item_template.attachment_node_linking[slot_name])
	end

	if Unit.num_lod_objects(owner_unit) ~= 0 and unit and Unit.num_lod_objects(unit) ~= 0 then
		local owner_lod_object = Unit.lod_object(owner_unit, 0)
		local attachment_lod_object = Unit.lod_object(unit, 0)

		LODObject.set_bounding_volume(attachment_lod_object, LODObject.bounding_volume(owner_lod_object))
		World.link_unit(world, unit, LODObject.node(attachment_lod_object), owner_unit, LODObject.node(owner_lod_object))
	end

	local slot_data = {
		unit = unit,
		name = item_data.name,
		item_data = item_data
	}

	return slot_data
end

AttachmentUtils.create_weapon_visual_attachment = function (world, owner_unit, unit_to_spawn, attachment_node_linking)
	-- function 2
	local unit_spawner = Managers.state.unit_spawner
	local unit = unit_spawner:spawn_local_unit(unit_to_spawn)

	AttachmentUtils.link(world, owner_unit, unit, attachment_node_linking)

	return unit
end

AttachmentUtils.destroy_attachment = function (world, owner_unit, slot_data)
	-- function 3
	local unit = slot_data.unit
	local unit_spawner = Managers.state.unit_spawner

	if unit then
		AttachmentUtils.unlink(world, unit)
		unit_spawner:mark_for_deletion(unit)
	end
end

AttachmentUtils.link = function (world, source, target, node_linking)
	-- function 4
	for _, link_data in ipairs(node_linking) do
		local source_node = link_data.source
		local target_node = link_data.target
		local node

		if type(source_node) == "string" then
			node = Unit.node(source, source_node)

			if not node then
				-- Nothing
			end
		end

		node = source_node

		local source_node_index = node

		do
			local node_2
		end

		::label_4_0::

		if type(target_node) == "string" then
			node_2 = Unit.node(target, target_node)

			if not node_2 then
				-- Nothing
			end
		end

		node_2 = target_node

		local target_node_index = node_2

		::label_4_1::

		World.link_unit(world, target, target_node_index, source, source_node_index)
	end
end

AttachmentUtils.unlink = function (world, target)
	-- function 5
	World.unlink_unit(world, target)
end

AttachmentUtils.hot_join_sync = function (peer_id, unit, slots, synced_buffs)
	-- function 6
	local is_marked_for_deletion = Managers.state.unit_spawner:is_marked_for_deletion(unit)

	if is_marked_for_deletion then
		return
	end

	local unit_go_id = Managers.state.unit_storage:go_id(unit)

	for slot_name, slot_data in pairs(slots) do
		repeat
			local slot = InventorySettings.slots_by_name[slot_name]

			if slot.category ~= "attachment" then
				break
			end

			local slot_id = NetworkLookup.equipment_slots[slot_name]
			local attachment_id = NetworkLookup.item_names[slot_data.name]
			local channel_id = PEER_ID_TO_CHANNEL[peer_id]

			RPC.rpc_create_attachment(channel_id, unit_go_id, slot_id, attachment_id)

			local slot_synced_buffs = synced_buffs[slot_name]

			if slot_synced_buffs then
				local rpc_params = BuffUtils.buffs_to_rpc_params(slot_synced_buffs)
				local num_buffs, buff_ids, buff_value_type_ids, buff_values = unpack(rpc_params)

				RPC.rpc_add_attachment_buffs(channel_id, unit_go_id, slot_id, num_buffs, buff_ids, buff_value_type_ids, buff_values)
			end
		until true
	end
end

AttachmentUtils.get_syncable_buff_params = function (synced_buffs)
	-- function 7
	local buff_name_1, buff_variable_data_1, buff_data_type_1, buff_value_1, buff_name_2, buff_variable_data_2, buff_data_type_2, buff_value_2, buff_name_3, buff_variable_data_3, buff_data_type_3, buff_value_3, buff_name_4, buff_variable_data_4, buff_data_type_4, buff_value_4

	buff_name_1, buff_variable_data_1 = next(synced_buffs)

	if buff_name_1 then
		buff_data_type_1, buff_value_1 = next(buff_variable_data_1)
		buff_name_2, buff_variable_data_2 = next(synced_buffs, buff_name_1)

		if buff_name_2 then
			buff_data_type_2, buff_value_2 = next(buff_variable_data_2)
			buff_name_3, buff_variable_data_3 = next(synced_buffs, buff_name_2)

			if buff_name_3 then
				buff_data_type_3, buff_value_3 = next(buff_variable_data_3)
				buff_name_4, buff_variable_data_4 = next(synced_buffs, buff_name_3)

				if buff_name_4 then
					buff_data_type_4, buff_value_4 = next(buff_variable_data_4)
				end
			end
		end
	end

	local default_buff_id = NetworkLookup.buff_templates["n/a"]
	local var_7_0

	if buff_name_1 then
		var_7_0 = NetworkLookup.buff_templates[buff_name_1]

		if not var_7_0 then
			-- Nothing
		end
	end

	var_7_0 = default_buff_id

	local buff_1_id = var_7_0

	do
		local var_7_1
	end

	::label_7_0::

	if buff_name_2 then
		var_7_1 = NetworkLookup.buff_templates[buff_name_2]

		if not var_7_1 then
			-- Nothing
		end
	end

	var_7_1 = default_buff_id

	local buff_2_id = var_7_1

	do
		local var_7_2
	end

	::label_7_1::

	if buff_name_3 then
		var_7_2 = NetworkLookup.buff_templates[buff_name_3]

		if not var_7_2 then
			-- Nothing
		end
	end

	var_7_2 = default_buff_id

	local buff_3_id = var_7_2

	do
		local var_7_3
	end

	::label_7_2::

	if buff_name_4 then
		var_7_3 = NetworkLookup.buff_templates[buff_name_4]

		if not var_7_3 then
			-- Nothing
		end
	end

	var_7_3 = default_buff_id

	local buff_4_id = var_7_3

	::label_7_3::

	local default_buff_data_type_id = NetworkLookup.buff_data_types["n/a"]
	local var_7_4

	if buff_name_1 then
		var_7_4 = NetworkLookup.buff_data_types[buff_data_type_1]

		if not var_7_4 then
			-- Nothing
		end
	end

	var_7_4 = default_buff_data_type_id

	local buff_data_type_1_id = var_7_4

	do
		local var_7_5
	end

	::label_7_4::

	if buff_name_2 then
		var_7_5 = NetworkLookup.buff_data_types[buff_data_type_2]

		if not var_7_5 then
			-- Nothing
		end
	end

	var_7_5 = default_buff_data_type_id

	local buff_data_type_2_id = var_7_5

	do
		local var_7_6
	end

	::label_7_5::

	if buff_name_3 then
		var_7_6 = NetworkLookup.buff_data_types[buff_data_type_3]

		if not var_7_6 then
			-- Nothing
		end
	end

	var_7_6 = default_buff_data_type_id

	local buff_data_type_3_id = var_7_6

	do
		local var_7_7
	end

	::label_7_6::

	if buff_name_4 then
		var_7_7 = NetworkLookup.buff_data_types[buff_data_type_4]

		if not var_7_7 then
			-- Nothing
		end
	end

	var_7_7 = default_buff_data_type_id

	local buff_data_type_4_id = var_7_7

	::label_7_7::

	buff_value_1 = not not buff_value_1 or not not 1
	buff_value_2 = not not buff_value_2 or not not 1
	buff_value_3 = not not buff_value_3 or not not 1
	buff_value_4 = not not buff_value_4 or not not 1

	local params = {
		buff_1_id,
		buff_data_type_1_id,
		buff_value_1,
		buff_2_id,
		buff_data_type_2_id,
		buff_value_2,
		buff_3_id,
		buff_data_type_3_id,
		buff_value_3,
		buff_4_id,
		buff_data_type_4_id,
		buff_value_4
	}

	return params
end
