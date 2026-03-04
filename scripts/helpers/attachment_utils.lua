-- chunkname: @scripts/helpers/attachment_utils.lua

AttachmentUtils = {}

AttachmentUtils.create_attachment = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	assert(arg_1_2.slots[arg_1_3] == nil, "Slot is not empty, remove attachment before creating a new one.")

	local var_1_0 = BackendUtils.get_item_template(arg_1_4)
	local var_1_1

	if arg_1_4.unit then
		local var_1_2 = BackendUtils.get_item_units(arg_1_4)
		local var_1_3 = Managers.state.unit_spawner

		if var_1_2.unit and var_1_2.unit ~= "" then
			var_1_1 = var_1_3:spawn_local_unit(var_1_2.unit)

			Unit.set_unit_visibility(var_1_1, arg_1_5)

			if not arg_1_5 then
				Unit.flow_event(var_1_1, "lua_attachment_hidden")
			end
		end
	end

	if var_1_0.attachment_node_linking and var_1_0.attachment_node_linking[arg_1_3] then
		AttachmentUtils.link(arg_1_0, arg_1_1, var_1_1, var_1_0.attachment_node_linking[arg_1_3])
	end

	if Unit.num_lod_objects(arg_1_1) ~= 0 and var_1_1 and Unit.num_lod_objects(var_1_1) ~= 0 then
		local var_1_4 = Unit.lod_object(arg_1_1, 0)
		local var_1_5 = Unit.lod_object(var_1_1, 0)

		LODObject.set_bounding_volume(var_1_5, LODObject.bounding_volume(var_1_4))
		World.link_unit(arg_1_0, var_1_1, LODObject.node(var_1_5), arg_1_1, LODObject.node(var_1_4))
	end

	return {
		unit = var_1_1,
		name = arg_1_4.name,
		item_data = arg_1_4
	}
end

AttachmentUtils.create_weapon_visual_attachment = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = Managers.state.unit_spawner:spawn_local_unit(arg_2_2)

	AttachmentUtils.link(arg_2_0, arg_2_1, var_2_0, arg_2_3)

	return var_2_0
end

AttachmentUtils.destroy_attachment = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_2.unit
	local var_3_1 = Managers.state.unit_spawner

	if var_3_0 then
		AttachmentUtils.unlink(arg_3_0, var_3_0)
		var_3_1:mark_for_deletion(var_3_0)
	end
end

AttachmentUtils.link = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	for iter_4_0, iter_4_1 in ipairs(arg_4_3) do
		local var_4_0 = iter_4_1.source
		local var_4_1 = iter_4_1.target
		local var_4_2 = type(var_4_0) == "string" and Unit.node(arg_4_1, var_4_0) or var_4_0
		local var_4_3 = type(var_4_1) == "string" and Unit.node(arg_4_2, var_4_1) or var_4_1

		World.link_unit(arg_4_0, arg_4_2, var_4_3, arg_4_1, var_4_2)
	end
end

AttachmentUtils.unlink = function (arg_5_0, arg_5_1)
	World.unlink_unit(arg_5_0, arg_5_1)
end

AttachmentUtils.hot_join_sync = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if Managers.state.unit_spawner:is_marked_for_deletion(arg_6_1) then
		return
	end

	local var_6_0 = Managers.state.unit_storage:go_id(arg_6_1)

	for iter_6_0, iter_6_1 in pairs(arg_6_2) do
		repeat
			if InventorySettings.slots_by_name[iter_6_0].category ~= "attachment" then
				break
			end

			local var_6_1 = NetworkLookup.equipment_slots[iter_6_0]
			local var_6_2 = NetworkLookup.item_names[iter_6_1.name]
			local var_6_3 = PEER_ID_TO_CHANNEL[arg_6_0]

			RPC.rpc_create_attachment(var_6_3, var_6_0, var_6_1, var_6_2)

			local var_6_4 = arg_6_3[iter_6_0]

			if var_6_4 then
				local var_6_5 = BuffUtils.buffs_to_rpc_params(var_6_4)
				local var_6_6, var_6_7, var_6_8, var_6_9 = unpack(var_6_5)

				RPC.rpc_add_attachment_buffs(var_6_3, var_6_0, var_6_1, var_6_6, var_6_7, var_6_8, var_6_9)
			end
		until true
	end
end

AttachmentUtils.get_syncable_buff_params = function (arg_7_0)
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

	if var_7_16 then
		var_7_2, var_7_3 = next(var_7_17)

		local var_7_18

		var_7_4, var_7_18 = next(arg_7_0, var_7_16)

		if var_7_4 then
			var_7_6, var_7_7 = next(var_7_18)

			local var_7_19

			var_7_8, var_7_19 = next(arg_7_0, var_7_4)

			if var_7_8 then
				var_7_10, var_7_11 = next(var_7_19)

				local var_7_20

				var_7_12, var_7_20 = next(arg_7_0, var_7_8)

				if var_7_12 then
					var_7_14, var_7_15 = next(var_7_20)
				end
			end
		end
	end

	local var_7_21 = NetworkLookup.buff_templates["n/a"]
	local var_7_22 = var_7_16 and NetworkLookup.buff_templates[var_7_16] or var_7_21
	local var_7_23 = var_7_4 and NetworkLookup.buff_templates[var_7_4] or var_7_21
	local var_7_24 = var_7_8 and NetworkLookup.buff_templates[var_7_8] or var_7_21
	local var_7_25 = var_7_12 and NetworkLookup.buff_templates[var_7_12] or var_7_21
	local var_7_26 = NetworkLookup.buff_data_types["n/a"]
	local var_7_27 = var_7_16 and NetworkLookup.buff_data_types[var_7_2] or var_7_26
	local var_7_28 = var_7_4 and NetworkLookup.buff_data_types[var_7_6] or var_7_26
	local var_7_29 = var_7_8 and NetworkLookup.buff_data_types[var_7_10] or var_7_26
	local var_7_30 = var_7_12 and NetworkLookup.buff_data_types[var_7_14] or var_7_26

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
