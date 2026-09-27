-- chunkname: @scripts/helpers/attachment_utils.lua

AttachmentUtils = {}

AttachmentUtils.create_attachment = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	assert(arg_1_2.slots[arg_1_3] == nil, "Slot is not empty, remove attachment before creating a new one.")

	local get_item_template = BackendUtils.get_item_template(arg_1_4)
	local var_1_1

	if not arg_1_4.unit then
		local get_item_units = BackendUtils.get_item_units(arg_1_4)
		local unit_spawner = Managers.state.unit_spawner

		if not (not get_item_units.unit and get_item_units.unit == "") then
			var_1_1 = unit_spawner:spawn_local_unit(get_item_units.unit)

			Unit.set_unit_visibility(var_1_1, arg_1_5)

			if not arg_1_5 then
				Unit.flow_event(var_1_1, "lua_attachment_hidden")
			end
		end
	end

	if not get_item_template.attachment_node_linking and not get_item_template.attachment_node_linking[arg_1_3] then
		AttachmentUtils.link(arg_1_0, arg_1_1, var_1_1, get_item_template.attachment_node_linking[arg_1_3])
	end

	if not ((Unit.num_lod_objects(arg_1_1) == 0 or not var_1_1) and Unit.num_lod_objects(var_1_1) == 0) then
		local lod_object = Unit.lod_object(arg_1_1, 0)
		local lod_object_2 = Unit.lod_object(var_1_1, 0)

		LODObject.set_bounding_volume(lod_object_2, LODObject.bounding_volume(lod_object))
		World.link_unit(arg_1_0, var_1_1, LODObject.node(lod_object_2), arg_1_1, LODObject.node(lod_object))
	end

	return {
		unit = var_1_1,
		name = arg_1_4.name,
		item_data = arg_1_4
	}
end

AttachmentUtils.create_weapon_visual_attachment = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local spawn_local_unit = Managers.state.unit_spawner:spawn_local_unit(arg_2_2)

	AttachmentUtils.link(arg_2_0, arg_2_1, spawn_local_unit, arg_2_3)

	return spawn_local_unit
end

AttachmentUtils.destroy_attachment = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local unit = arg_3_2.unit
	local unit_spawner = Managers.state.unit_spawner

	if not unit then
		AttachmentUtils.unlink(arg_3_0, unit)
		unit_spawner:mark_for_deletion(unit)
	end
end

AttachmentUtils.link = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	for i, v in ipairs(arg_4_3) do
		local source = v.source
		local target = v.target
		local node

		if type(source) == "string" then
			node = Unit.node(arg_4_1, source)

			if not node then
				-- Nothing
			end
		end

		node = source

		do
			local node_2
		end

		::label_4_0::

		if type(target) == "string" then
			node_2 = Unit.node(arg_4_2, target)

			if not node_2 then
				-- Nothing
			end
		end

		node_2 = target

		::label_4_1::

		World.link_unit(arg_4_0, arg_4_2, node_2, arg_4_1, node)
	end
end

AttachmentUtils.unlink = function (arg_5_0, arg_5_1)
	-- function 5
	World.unlink_unit(arg_5_0, arg_5_1)
end

AttachmentUtils.hot_join_sync = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	if not Managers.state.unit_spawner:is_marked_for_deletion(arg_6_1) then
		return
	end

	local go_id = Managers.state.unit_storage:go_id(arg_6_1)

	for k, v in pairs(arg_6_2) do
		repeat
			if InventorySettings.slots_by_name[k].category ~= "attachment" then
				break
			end

			local var_6_1 = NetworkLookup.equipment_slots[k]
			local var_6_2 = NetworkLookup.item_names[v.name]
			local var_6_3 = PEER_ID_TO_CHANNEL[arg_6_0]

			RPC.rpc_create_attachment(var_6_3, go_id, var_6_1, var_6_2)

			local var_6_4 = arg_6_3[k]

			if not var_6_4 then
				local buffs_to_rpc_params = BuffUtils.buffs_to_rpc_params(var_6_4)
				local var_6_6, var_6_7, var_6_8, var_6_9 = unpack(buffs_to_rpc_params)

				RPC.rpc_add_attachment_buffs(var_6_3, go_id, var_6_1, var_6_6, var_6_7, var_6_8, var_6_9)
			end
		until true
	end
end

AttachmentUtils.get_syncable_buff_params = function (arg_7_0)
	-- function 7
	local var_7_0
	local var_7_1
	local var_7_2
	local var_7_3
	local var_7_4
	local var_7_5
	local var_7_6
	local var_7_7
	local var_7_8
	local var_7_9
	local var_7_10
	local var_7_11
	local var_7_12
	local var_7_13
	local var_7_14
	local var_7_15
	local var_7_16, var_7_17 = next(arg_7_0)

	if not var_7_16 then
		var_7_2, var_7_3 = next(var_7_17)

		local var_7_18

		var_7_4, var_7_18 = next(arg_7_0, var_7_16)

		if not var_7_4 then
			var_7_6, var_7_7 = next(var_7_18)

			local var_7_19

			var_7_8, var_7_19 = next(arg_7_0, var_7_4)

			if not var_7_8 then
				var_7_10, var_7_11 = next(var_7_19)

				local var_7_20

				var_7_12, var_7_20 = next(arg_7_0, var_7_8)

				if not var_7_12 then
					var_7_14, var_7_15 = next(var_7_20)
				end
			end
		end
	end

	local var_7_21 = NetworkLookup.buff_templates["n/a"]
	local var_7_22

	if not var_7_16 then
		var_7_22 = NetworkLookup.buff_templates[var_7_16]

		if not var_7_22 then
			-- Nothing
		end
	end

	var_7_22 = var_7_21

	do
		local var_7_23
	end

	::label_7_0::

	if not var_7_4 then
		var_7_23 = NetworkLookup.buff_templates[var_7_4]

		if not var_7_23 then
			-- Nothing
		end
	end

	var_7_23 = var_7_21

	do
		local var_7_24
	end

	::label_7_1::

	if not var_7_8 then
		var_7_24 = NetworkLookup.buff_templates[var_7_8]

		if not var_7_24 then
			-- Nothing
		end
	end

	var_7_24 = var_7_21

	do
		local var_7_25
	end

	::label_7_2::

	if not var_7_12 then
		var_7_25 = NetworkLookup.buff_templates[var_7_12]

		if not var_7_25 then
			-- Nothing
		end
	end

	var_7_25 = var_7_21

	::label_7_3::

	local var_7_26 = NetworkLookup.buff_data_types["n/a"]
	local var_7_27

	if not var_7_16 then
		var_7_27 = NetworkLookup.buff_data_types[var_7_2]

		if not var_7_27 then
			-- Nothing
		end
	end

	var_7_27 = var_7_26

	do
		local var_7_28
	end

	::label_7_4::

	if not var_7_4 then
		var_7_28 = NetworkLookup.buff_data_types[var_7_6]

		if not var_7_28 then
			-- Nothing
		end
	end

	var_7_28 = var_7_26

	do
		local var_7_29
	end

	::label_7_5::

	if not var_7_8 then
		var_7_29 = NetworkLookup.buff_data_types[var_7_10]

		if not var_7_29 then
			-- Nothing
		end
	end

	var_7_29 = var_7_26

	do
		local var_7_30
	end

	::label_7_6::

	if not var_7_12 then
		var_7_30 = NetworkLookup.buff_data_types[var_7_14]

		if not var_7_30 then
			-- Nothing
		end
	end

	var_7_30 = var_7_26

	::label_7_7::

	var_7_3 = var_7_3 or 1
	var_7_7 = var_7_7 or 1
	var_7_11 = var_7_11 or 1
	var_7_15 = var_7_15 or 1

	return {
		var_7_22,
		var_7_27,
		var_7_3,
		var_7_23,
		var_7_28,
		var_7_7,
		var_7_24,
		var_7_29,
		var_7_11,
		var_7_25,
		var_7_30,
		var_7_15
	}
end
