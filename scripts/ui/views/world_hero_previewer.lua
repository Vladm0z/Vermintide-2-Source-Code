-- chunkname: @scripts/ui/views/world_hero_previewer.lua

HeroPreviewer = class(HeroPreviewer)

HeroPreviewer.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.profile_synchronizer = arg_1_1.profile_synchronizer
	arg_1_0.character_unit = nil
	arg_1_0.mesh_unit = nil
	arg_1_0.world = nil
	arg_1_0._item_info_by_slot = {}
	arg_1_0._props_data = {}
	arg_1_0._equipment_units = {}
	arg_1_0._hidden_units = {}
	arg_1_0._delayed_material_changes = {}
	arg_1_0.character_location = {
		0,
		0,
		0
	}
	arg_1_0.character_look_target = {
		0,
		3,
		1
	}
	arg_1_0.character_rotation = 0
	arg_1_0.unique_id = arg_1_2
	arg_1_0._session_id = 0
	arg_1_0._requested_mip_streaming_units = {}
	arg_1_0._delayed_spawn = arg_1_3
	arg_1_0._activated = not arg_1_3
	arg_1_0._loading_done = false
	arg_1_0._delayed_pose_animation = false
	arg_1_0._equipment_units[InventorySettings.slots_by_name.slot_melee.slot_index] = {}
	arg_1_0._equipment_units[InventorySettings.slots_by_name.slot_ranged.slot_index] = {}
end

HeroPreviewer.activate = function (arg_2_0, arg_2_1, arg_2_2)
	if not arg_2_0._delayed_spawn then
		return
	end

	if arg_2_1 == arg_2_0._activated then
		return
	end

	if arg_2_1 then
		arg_2_0:on_enter(arg_2_2)
	else
		arg_2_0.world = nil
	end

	arg_2_0._activated = arg_2_1
end

HeroPreviewer.destroy = function (arg_3_0)
	arg_3_0._session_id = arg_3_0._session_id + 1

	GarbageLeakDetector.register_object(arg_3_0, "HeroPreviewer")
end

local var_0_0 = {}

HeroPreviewer.on_enter = function (arg_4_0, arg_4_1)
	table.clear(arg_4_0._requested_mip_streaming_units)
	table.clear(arg_4_0._hidden_units)

	arg_4_0.world = arg_4_1

	Application.set_render_setting("max_shadow_casting_lights", 16)

	arg_4_0._session_id = arg_4_0._session_id or 0

	if arg_4_0._delayed_spawn then
		arg_4_0._requested_hero_spawn_data = arg_4_0._delayed_hero_spawn_data or var_0_0
	end
end

HeroPreviewer.prepare_exit = function (arg_5_0)
	arg_5_0:clear_units()
end

HeroPreviewer.on_exit = function (arg_6_0)
	arg_6_0:_unload_all_packages()

	arg_6_0._hero_loading_package_data = nil

	local var_6_0 = Application.user_setting("render_settings", "max_shadow_casting_lights")

	Application.set_render_setting("max_shadow_casting_lights", var_6_0)

	arg_6_0._session_id = arg_6_0._session_id + 1
end

HeroPreviewer.update = function (arg_7_0, arg_7_1, arg_7_2)
	return
end

HeroPreviewer.post_update = function (arg_8_0, arg_8_1, arg_8_2)
	arg_8_0:_update_units_visibility(arg_8_1)
	arg_8_0:_update_lerped_location(arg_8_2)
	arg_8_0:_handle_hero_spawn_request()
	arg_8_0:_poll_hero_package_loading()
	arg_8_0:_poll_item_package_loading()
	arg_8_0:_update_delayed_material_changes()
end

HeroPreviewer._update_lerped_location = function (arg_9_0, arg_9_1)
	if not arg_9_0._character_destination_location then
		return
	end

	if arg_9_1 < arg_9_0._lerp_end_time then
		local var_9_0 = 1 - (arg_9_0._lerp_end_time - arg_9_1) / arg_9_0._lerp_time
		local var_9_1 = math.easeOutCubic(var_9_0)
		local var_9_2 = math.lerp(arg_9_0.character_location[1], arg_9_0._character_destination_location[1], var_9_1)
		local var_9_3 = math.lerp(arg_9_0.character_location[2], arg_9_0._character_destination_location[2], var_9_1)
		local var_9_4 = math.lerp(arg_9_0.character_location[3], arg_9_0._character_destination_location[3], var_9_1)
		local var_9_5 = arg_9_0.character_unit

		if var_9_5 and Unit.alive(var_9_5) then
			Unit.set_local_position(var_9_5, 0, Vector3(var_9_2, var_9_3, var_9_4))
		end
	else
		arg_9_0.character_location = arg_9_0._character_destination_location
		arg_9_0._character_destination_location = nil
		arg_9_0._lerp_time = nil
		arg_9_0._lerp_end_time = nil
	end
end

HeroPreviewer._update_unit_mip_streaming = function (arg_10_0)
	local var_10_0 = true
	local var_10_1 = 0
	local var_10_2 = arg_10_0._requested_mip_streaming_units

	for iter_10_0, iter_10_1 in pairs(var_10_2) do
		if Renderer.is_all_mips_loaded_for_unit(iter_10_0) then
			var_10_2[iter_10_0] = nil
		else
			var_10_0 = false
		end

		var_10_1 = var_10_1 + 1
	end

	if not var_10_0 then
		return true
	elseif var_10_1 > 0 then
		Renderer.set_automatic_streaming(true)
	end
end

HeroPreviewer._update_delayed_material_changes = function (arg_11_0)
	if not arg_11_0._activated then
		return
	end

	local var_11_0 = arg_11_0.character_unit
	local var_11_1 = arg_11_0.mesh_unit

	if not Unit.alive(var_11_0) then
		return
	end

	if not arg_11_0._delayed_material_changes[var_11_0] or arg_11_0.character_unit_hidden_after_spawn then
		return
	end

	local var_11_2 = false
	local var_11_3 = arg_11_0._delayed_material_changes[var_11_0]

	for iter_11_0 = 1, #var_11_3 do
		local var_11_4 = var_11_3[iter_11_0]

		for iter_11_1, iter_11_2 in pairs(var_11_4) do
			Unit.set_material(var_11_1, iter_11_1, iter_11_2)

			var_11_2 = true
		end
	end

	if var_11_2 and arg_11_0._use_highest_mip_levels or UISettings.wait_for_mip_streaming_character then
		arg_11_0:_request_mip_streaming_for_unit(var_11_0)
	end

	arg_11_0._delayed_material_changes[var_11_0] = nil
end

HeroPreviewer._request_mip_streaming_for_unit = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._requested_mip_streaming_units

	var_12_0[arg_12_1] = true

	Renderer.set_automatic_streaming(false)

	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		Renderer.request_to_stream_all_mips_for_unit(iter_12_0)
	end
end

HeroPreviewer._update_units_visibility = function (arg_13_0, arg_13_1)
	if not arg_13_0._activated then
		return
	end

	if not arg_13_0:_is_all_items_loaded() then
		return
	end

	if arg_13_0:_update_unit_mip_streaming() then
		return
	end

	local var_13_0 = arg_13_0.character_unit

	if not Unit.alive(var_13_0) then
		return
	end

	if arg_13_0._stored_character_animation then
		local var_13_1 = true

		arg_13_0:play_character_animation(arg_13_0._stored_character_animation, var_13_1)

		arg_13_0._stored_character_animation = nil

		return
	end

	if arg_13_0.character_unit_hidden_after_spawn then
		arg_13_0.character_unit_hidden_after_spawn = false

		if Unit.has_animation_state_machine(arg_13_0.mesh_unit) and Unit.has_animation_event(arg_13_0.mesh_unit, "enable") then
			Unit.animation_event(arg_13_0.mesh_unit, "enable")
		end

		if arg_13_0._draw_character == false then
			arg_13_0:_set_character_visibility(false)
		else
			arg_13_0:_set_character_visibility(true)
		end
	end

	if arg_13_0._draw_character and not table.is_empty(arg_13_0._hidden_units) then
		for iter_13_0, iter_13_1 in pairs(arg_13_0._hidden_units) do
			if Unit.alive(iter_13_0) then
				Unit.set_unit_visibility(iter_13_0, true)
			end

			arg_13_0._hidden_units[iter_13_0] = nil
		end

		arg_13_0:_trigger_equip_events()
	end

	if arg_13_0._draw_character then
		for iter_13_2, iter_13_3 in pairs(arg_13_0._props_data) do
			if not iter_13_3.visible and iter_13_3.unit then
				iter_13_3.visible = true

				Unit.set_unit_visibility(iter_13_3.unit, true)

				local var_13_2 = iter_13_3.settings

				if var_13_2.animation_event then
					Unit.animation_event(iter_13_3.unit, var_13_2.animation_event)
				end

				if var_13_2.spawn_callback then
					var_13_2.spawn_callback(iter_13_3.unit)
				end
			end
		end
	end

	arg_13_0._loading_done = true
end

HeroPreviewer.loading_done = function (arg_14_0)
	return arg_14_0._loading_done
end

HeroPreviewer._set_character_visibility = function (arg_15_0, arg_15_1)
	arg_15_0._draw_character = arg_15_1

	if arg_15_0.character_unit_hidden_after_spawn then
		return
	end

	local var_15_0 = arg_15_0.character_unit
	local var_15_1 = arg_15_0.mesh_unit

	if Unit.alive(var_15_1) then
		Unit.set_unit_visibility(var_15_1, arg_15_1)

		local var_15_2 = InventorySettings.slots_by_slot_index
		local var_15_3 = arg_15_1 and "lua_attachment_unhidden" or "lua_attachment_hidden"

		Unit.flow_event(var_15_1, var_15_3)

		local var_15_4 = arg_15_1 and "lua_ui_vfx_unhidden" or "lua_ui_vfx_hidden"

		Unit.flow_event(var_15_1, var_15_4)

		local var_15_5 = arg_15_0._equipment_units

		for iter_15_0, iter_15_1 in pairs(var_15_5) do
			local var_15_6 = var_15_2[iter_15_0]
			local var_15_7 = var_15_6.category
			local var_15_8 = var_15_6.type
			local var_15_9 = var_15_7 == "weapon"
			local var_15_10

			if var_15_9 then
				var_15_10 = arg_15_1 and var_15_8 == arg_15_0._wielded_slot_type
			else
				var_15_10 = arg_15_1
			end

			local var_15_11 = var_15_10 and "lua_wield" or "lua_unwield"

			if type(iter_15_1) == "table" then
				local var_15_12 = iter_15_1.left
				local var_15_13 = iter_15_1.right

				if Unit.alive(var_15_12) then
					Unit.flow_event(var_15_12, var_15_11)
					Unit.set_unit_visibility(var_15_12, var_15_10)

					arg_15_0._hidden_units[var_15_12] = nil
				end

				if Unit.alive(var_15_13) then
					Unit.flow_event(var_15_13, var_15_11)
					Unit.set_unit_visibility(var_15_13, var_15_10)

					arg_15_0._hidden_units[var_15_13] = nil
				end
			elseif Unit.alive(iter_15_1) then
				if not var_15_9 then
					local var_15_14 = var_15_10 and "lua_attachment_unhidden" or "lua_attachment_hidden"

					Unit.flow_event(iter_15_1, var_15_14)
				end

				Unit.flow_event(iter_15_1, var_15_11)
				Unit.set_unit_visibility(iter_15_1, var_15_10)

				if var_15_8 == "hat" then
					local var_15_15 = arg_15_0.character_unit_skin_data.equip_hat_event or "using_skin_default"

					if var_15_15 then
						Unit.flow_event(iter_15_1, var_15_15)
					end
				end

				arg_15_0._hidden_units[iter_15_1] = nil
			end
		end

		if arg_15_1 then
			local var_15_16 = arg_15_0.character_unit_skin_data
			local var_15_17 = var_15_16.material_changes
			local var_15_18 = var_15_16.equip_skin_event or "using_skin_default"

			Unit.flow_event(var_15_0, var_15_18)

			if var_15_17 then
				local var_15_19 = var_15_17.third_person

				for iter_15_2, iter_15_3 in pairs(var_15_19) do
					Unit.set_material(var_15_1, iter_15_2, iter_15_3)
				end
			end

			for iter_15_4, iter_15_5 in pairs(arg_15_0._item_info_by_slot) do
				if iter_15_5.loaded then
					local var_15_20 = iter_15_5.name
					local var_15_21 = ItemHelper.get_template_by_item_name(var_15_20).show_attachments_event

					if var_15_21 then
						Unit.flow_event(var_15_1, var_15_21)
						Unit.flow_event(var_15_0, var_15_21)
					end
				end
			end
		end

		arg_15_0.character_unit_visible = arg_15_1
	end
end

HeroPreviewer.character_visible = function (arg_16_0)
	return arg_16_0.character_unit_visible and Unit.alive(arg_16_0.character_unit)
end

HeroPreviewer.play_character_animation = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0.character_unit

	if var_17_0 == nil then
		return
	end

	if not arg_17_0.character_unit_visible and not arg_17_2 then
		arg_17_0._stored_character_animation = arg_17_1
	else
		Unit.animation_event(var_17_0, arg_17_1)
	end
end

HeroPreviewer.clear_asynchronous_data = function (arg_18_0)
	arg_18_0._delayed_pose_animation = false
	arg_18_0._pose_animation_event = nil
end

HeroPreviewer.request_spawn_hero_unit = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	arg_19_0:clear_asynchronous_data()

	arg_19_0._requested_hero_spawn_data = {
		frame_delay = 1,
		profile_name = arg_19_1,
		career_index = arg_19_2,
		callback = arg_19_3,
		optional_skin = arg_19_4,
		optional_breed = arg_19_5
	}

	if arg_19_0._delayed_spawn then
		arg_19_0._delayed_hero_spawn_data = table.clone(arg_19_0._requested_hero_spawn_data)
	end

	arg_19_0:clear_units()
end

HeroPreviewer._handle_hero_spawn_request = function (arg_20_0)
	if arg_20_0._requested_hero_spawn_data then
		local var_20_0 = arg_20_0._requested_hero_spawn_data
		local var_20_1 = var_20_0.frame_delay

		if var_20_1 == 0 then
			local var_20_2 = var_20_0.profile_name
			local var_20_3 = var_20_0.career_index
			local var_20_4 = var_20_0.callback
			local var_20_5 = var_20_0.optional_skin
			local var_20_6 = var_20_0.optional_breed

			arg_20_0:_load_hero_unit(var_20_2, var_20_3, var_20_4, var_20_5, nil, var_20_6)

			arg_20_0._requested_hero_spawn_data = nil
		else
			var_20_0.frame_delay = var_20_1 - 1
		end
	end
end

HeroPreviewer._load_hero_unit = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6)
	arg_21_0:_unload_all_packages()

	arg_21_0._current_profile_name = arg_21_6 and arg_21_6.name or arg_21_1

	local var_21_0 = FindProfileIndex(arg_21_1)
	local var_21_1 = SPProfiles[var_21_0].careers[arg_21_2]
	local var_21_2 = var_21_1.name
	local var_21_3 = BackendUtils.get_loadout_item(var_21_2, "slot_skin")
	local var_21_4 = var_21_3 and var_21_3.data
	local var_21_5 = arg_21_4 or var_21_4 and var_21_4.name or var_21_1.base_skin

	GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", var_21_2 == "bw_necromancer")

	arg_21_0._current_career_name = var_21_2
	arg_21_0.character_unit_skin_data = nil

	local var_21_6 = CosmeticsUtils.retrieve_skin_packages_for_preview(var_21_5)
	local var_21_7 = Cosmetics[var_21_5]

	arg_21_0._hero_loading_package_data = {
		num_loaded_packages = 0,
		career_name = var_21_2,
		skin_data = var_21_7,
		career_index = arg_21_2,
		optional_scale = arg_21_5,
		package_names = var_21_6,
		num_packages = #var_21_6,
		callback = arg_21_3
	}, arg_21_0:_load_packages(var_21_6)
end

HeroPreviewer._poll_hero_package_loading = function (arg_22_0)
	local var_22_0 = arg_22_0._hero_loading_package_data

	if not var_22_0 or var_22_0.loaded then
		return
	end

	if arg_22_0._requested_hero_spawn_data then
		return
	end

	local var_22_1 = arg_22_0:_reference_name()
	local var_22_2 = Managers.package
	local var_22_3 = var_22_0.package_names
	local var_22_4 = true

	for iter_22_0 = 1, #var_22_3 do
		local var_22_5 = var_22_3[iter_22_0]

		if not var_22_2:has_loaded(var_22_5, var_22_1) then
			var_22_4 = false

			break
		end
	end

	if var_22_4 and arg_22_0._activated then
		local var_22_6 = var_22_0.skin_data
		local var_22_7 = var_22_0.optional_scale
		local var_22_8 = var_22_0.career_index

		arg_22_0:_spawn_hero_unit(var_22_6, var_22_7, var_22_8)

		local var_22_9 = var_22_0.callback

		if var_22_9 then
			var_22_9()
		end

		var_22_0.loaded = true
	end
end

HeroPreviewer._spawn_hero_unit = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = arg_23_0.world
	local var_23_1 = arg_23_1.third_person
	local var_23_2 = arg_23_1.third_person_attachment.unit
	local var_23_3 = arg_23_1.third_person_attachment.attachment_node_linking
	local var_23_4 = World.spawn_unit(var_23_0, var_23_1, Vector3Aux.unbox(arg_23_0.character_location), Quaternion.axis_angle(Vector3.up(), arg_23_0.character_rotation))
	local var_23_5 = World.spawn_unit(var_23_0, var_23_2, Vector3Aux.unbox(arg_23_0.character_location), Quaternion.axis_angle(Vector3.up(), arg_23_0.character_rotation))

	Unit.set_flow_variable(var_23_4, "lua_third_person_mesh_unit", var_23_5)
	AttachmentUtils.link(var_23_0, var_23_4, var_23_5, var_23_3)

	local var_23_6 = arg_23_1.material_changes

	if var_23_6 then
		local var_23_7 = var_23_6.third_person

		for iter_23_0, iter_23_1 in pairs(var_23_7) do
			Unit.set_material(var_23_5, iter_23_0, iter_23_1)
		end
	end

	local var_23_8 = arg_23_1.material_settings_name

	if var_23_8 then
		CosmeticUtils.apply_material_settings(var_23_5, var_23_8)
	end

	local var_23_9 = arg_23_1.color_tint

	if var_23_9 then
		local var_23_10 = var_23_9.gradient_variation
		local var_23_11 = var_23_9.gradient_value

		CosmeticUtils.color_tint_unit(var_23_5, arg_23_0._current_profile_name, var_23_10, var_23_11)
	end

	Unit.set_unit_visibility(var_23_5, false)

	arg_23_0.character_unit = var_23_4
	arg_23_0.mesh_unit = var_23_5
	arg_23_0.character_unit_hidden_after_spawn = true
	arg_23_0.character_unit_visible = false
	arg_23_0.character_unit_skin_data = arg_23_1
	arg_23_0._stored_character_animation = nil

	if Unit.has_lod_object(var_23_5, "lod") then
		local var_23_12 = Unit.lod_object(var_23_5, "lod")

		LODObject.set_static_height(var_23_12, 1)
	end

	local var_23_13 = Vector3Aux.unbox(arg_23_0.character_look_target)
	local var_23_14 = Unit.animation_find_constraint_target(var_23_4, "aim_constraint_target")

	Unit.animation_set_constraint_target(var_23_4, var_23_14, var_23_13)

	local var_23_15, var_23_16 = Unit.box(var_23_4)

	if var_23_16 then
		arg_23_0.unit_max_look_height = 1.7 < var_23_16.z and 1.5 or 0.9
	else
		arg_23_0.unit_max_look_height = 0.9
	end

	if arg_23_2 then
		local var_23_17 = Vector3(arg_23_2, arg_23_2, arg_23_2)

		Unit.set_local_scale(var_23_4, 0, var_23_17)
	end

	if Unit.animation_has_variable(var_23_4, "career_index") then
		local var_23_18 = Unit.animation_find_variable(var_23_4, "career_index")

		Unit.animation_set_variable(var_23_4, var_23_18, arg_23_3)
	end
end

HeroPreviewer.respawn_hero_unit = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	arg_24_0:request_spawn_hero_unit(arg_24_1, arg_24_2, arg_24_3, nil, nil)
end

HeroPreviewer.get_equipped_item_info = function (arg_25_0, arg_25_1)
	local var_25_0 = arg_25_1.type

	return arg_25_0._item_info_by_slot[var_25_0]
end

HeroPreviewer.spawn_all_props = function (arg_26_0, arg_26_1)
	for iter_26_0, iter_26_1 in pairs(arg_26_1) do
		arg_26_0:spawn_prop(iter_26_1)
	end
end

HeroPreviewer.spawn_prop = function (arg_27_0, arg_27_1)
	arg_27_0._props_data[#arg_27_0._props_data + 1] = {
		visible = false,
		loaded = false,
		settings = arg_27_1
	}

	arg_27_0:_load_packages(arg_27_1.package_names)
end

HeroPreviewer.equip_item = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	local var_28_0 = arg_28_0.character_unit_skin_data

	if var_28_0 and var_28_0.always_hide_attachment_slots then
		local var_28_1 = false

		for iter_28_0, iter_28_1 in ipairs(var_28_0.always_hide_attachment_slots) do
			if arg_28_2.name == iter_28_1 then
				printf("[HeroPreviewer]:equip_item() - Skipping equipping of item(%s), because equipped skin(%s) wants to hide it", arg_28_1, var_28_0.name)

				var_28_1 = true

				break
			end
		end

		if var_28_1 then
			return
		end
	end

	arg_28_0._loading_done = false

	local var_28_2 = arg_28_2.type
	local var_28_3 = arg_28_2.slot_index
	local var_28_4 = ItemMasterList[arg_28_1]
	local var_28_5 = BackendUtils.get_item_units(var_28_4, arg_28_3, arg_28_4, arg_28_0._current_career_name)
	local var_28_6 = ItemHelper.get_template_by_item_name(arg_28_1)
	local var_28_7 = {}
	local var_28_8 = {}

	if var_28_2 == "melee" or var_28_2 == "ranged" then
		local var_28_9 = var_28_5.left_hand_unit
		local var_28_10 = var_28_5.right_hand_unit
		local var_28_11 = var_28_5.material_settings_name
		local var_28_12 = var_28_10 == nil or var_28_9 == nil

		if var_28_9 then
			local var_28_13 = var_28_6.left_hand_attachment_node_linking.third_person

			if var_28_5.is_ammo_weapon then
				var_28_9 = var_28_5.ammo_unit
				var_28_13 = var_28_6.ammo_data.ammo_unit_attachment_node_linking.third_person
			end

			local var_28_14 = var_28_9 .. "_3p"

			var_28_7[#var_28_7 + 1] = {
				left_hand = true,
				despawn_both_hands_units = var_28_12,
				unit_name = var_28_14,
				item_slot_type = var_28_2,
				slot_index = var_28_3,
				unit_attachment_node_linking = var_28_13,
				material_settings_name = var_28_11,
				is_ammo_unit = var_28_5.ammo_unit ~= nil,
				skip_wield_anim = arg_28_5
			}
			var_28_8[#var_28_8 + 1] = var_28_14
		end

		if var_28_10 then
			local var_28_15 = var_28_6.right_hand_attachment_node_linking.third_person

			if var_28_5.is_ammo_weapon then
				var_28_10 = var_28_5.ammo_unit
				var_28_15 = var_28_6.right_hand_attachment_node_linking.third_person
			end

			local var_28_16 = var_28_10 .. "_3p"

			var_28_7[#var_28_7 + 1] = {
				right_hand = true,
				despawn_both_hands_units = var_28_12,
				unit_name = var_28_16,
				item_slot_type = var_28_2,
				slot_index = var_28_3,
				unit_attachment_node_linking = var_28_15,
				material_settings_name = var_28_11,
				is_ammo_unit = var_28_5.ammo_unit ~= nil,
				skip_wield_anim = arg_28_5
			}

			if var_28_10 ~= var_28_9 then
				var_28_8[#var_28_8 + 1] = var_28_16
			end
		end
	elseif var_28_2 == "hat" then
		local var_28_17 = var_28_5.unit

		if var_28_17 then
			local var_28_18 = 3

			if var_28_2 == "hat" then
				var_28_18 = 1
			end

			local var_28_19 = var_28_6.slots[var_28_18]
			local var_28_20 = var_28_6.character_material_changes

			var_28_7[#var_28_7 + 1] = {
				unit_name = var_28_17,
				item_slot_type = var_28_2,
				slot_index = var_28_3,
				unit_attachment_node_linking = var_28_6.attachment_node_linking[var_28_19],
				character_material_changes = var_28_20
			}
			var_28_8[#var_28_8 + 1] = var_28_17

			if var_28_20 then
				var_28_8[#var_28_8 + 1] = var_28_20.package_name
			end
		end
	end

	if #var_28_8 > 0 then
		local var_28_21 = arg_28_0._item_info_by_slot

		if var_28_21[var_28_2] then
			arg_28_0:_destroy_item_units_by_slot(var_28_2)
			arg_28_0:_unload_item_packages_by_slot(var_28_2)
		end

		var_28_21[var_28_2] = {
			name = arg_28_1,
			backend_id = arg_28_3,
			skin_name = arg_28_4,
			package_names = var_28_8,
			spawn_data = var_28_7
		}

		arg_28_0:_load_packages(var_28_8)
	end
end

HeroPreviewer._poll_item_package_loading = function (arg_29_0)
	local var_29_0 = arg_29_0.character_unit

	if not Unit.alive(var_29_0) then
		return
	end

	if arg_29_0._requested_hero_spawn_data then
		return
	end

	local var_29_1 = arg_29_0:_reference_name()
	local var_29_2 = Managers.package

	for iter_29_0, iter_29_1 in pairs(arg_29_0._props_data) do
		if not iter_29_1.loaded then
			local var_29_3 = iter_29_1.settings.package_names
			local var_29_4 = true

			for iter_29_2 = 1, #var_29_3 do
				if not var_29_2:has_loaded(var_29_3[iter_29_2], var_29_1) then
					var_29_4 = false

					break
				end
			end

			if var_29_4 and arg_29_0._activated then
				iter_29_1.loaded = true

				arg_29_0:_spawn_prop(iter_29_1)
			end
		end
	end

	local var_29_5 = arg_29_0._item_info_by_slot
	local var_29_6 = true

	for iter_29_3, iter_29_4 in pairs(var_29_5) do
		if not iter_29_4.loaded then
			local var_29_7 = iter_29_4.package_names
			local var_29_8 = true

			for iter_29_5 = 1, #var_29_7 do
				local var_29_9 = var_29_7[iter_29_5]

				if not var_29_2:has_loaded(var_29_9, var_29_1) then
					var_29_8 = false

					break
				end
			end

			if var_29_8 and arg_29_0._activated then
				iter_29_4.loaded = true

				local var_29_10 = iter_29_4.name
				local var_29_11 = iter_29_4.spawn_data

				arg_29_0:_spawn_item(var_29_10, var_29_11)
			else
				var_29_6 = false
			end
		end
	end

	if var_29_6 and arg_29_0._delayed_pose_animation then
		arg_29_0:trigger_pose_animation()
	end
end

HeroPreviewer._is_all_items_loaded = function (arg_30_0)
	local var_30_0 = arg_30_0._item_info_by_slot
	local var_30_1 = true

	for iter_30_0, iter_30_1 in pairs(var_30_0) do
		if not iter_30_1.loaded then
			var_30_1 = false

			break
		end
	end

	return var_30_1
end

HeroPreviewer._spawn_prop = function (arg_31_0, arg_31_1)
	local var_31_0 = arg_31_1.settings
	local var_31_1 = arg_31_0.world
	local var_31_2 = World.spawn_unit(var_31_1, var_31_0.unit_name)

	if Unit.has_lod_object(var_31_2, "lod") then
		local var_31_3 = Unit.lod_object(var_31_2, "lod")

		LODObject.set_static_height(var_31_3, 1)
	end

	arg_31_1.unit = var_31_2

	local var_31_4 = var_31_0.offset

	Unit.set_local_position(var_31_2, 0, Vector3(var_31_4[1], var_31_4[2], var_31_4[3]))
	Unit.set_unit_visibility(var_31_2, false)
end

HeroPreviewer._spawn_item = function (arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = arg_32_0.world
	local var_32_1 = arg_32_0.character_unit
	local var_32_2 = arg_32_0.mesh_unit
	local var_32_3 = {}
	local var_32_4 = ItemHelper.get_template_by_item_name(arg_32_1)
	local var_32_5 = false
	local var_32_6 = false
	local var_32_7 = {}

	for iter_32_0, iter_32_1 in ipairs(arg_32_2) do
		local var_32_8 = iter_32_1.unit_name
		local var_32_9 = iter_32_1.item_slot_type
		local var_32_10 = iter_32_1.slot_index
		local var_32_11 = iter_32_1.unit_attachment_node_linking
		local var_32_12 = iter_32_1.character_material_changes
		local var_32_13 = iter_32_1.material_settings_name
		local var_32_14 = iter_32_1.skip_wield_anim

		if var_32_9 == "melee" or var_32_9 == "ranged" then
			local var_32_15 = World.spawn_unit(var_32_0, var_32_8)

			arg_32_0:_spawn_item_unit(var_32_15, var_32_9, var_32_4, var_32_11, var_32_3, var_32_13, var_32_14)

			local var_32_16 = arg_32_0._wielded_slot_type == var_32_9

			if iter_32_1.right_hand then
				arg_32_0._equipment_units[var_32_10].right = var_32_15

				if var_32_16 then
					if iter_32_1.is_ammo_unit then
						var_32_7.right_hand_ammo_unit_3p = var_32_15
					else
						var_32_7.right_hand_wielded_unit_3p = var_32_15
					end

					var_32_6 = true
				end
			elseif iter_32_1.left_hand then
				arg_32_0._equipment_units[var_32_10].left = var_32_15

				if var_32_16 then
					if iter_32_1.is_ammo_unit then
						var_32_7.left_hand_ammo_unit_3p = var_32_15
					else
						var_32_7.left_hand_wielded_unit_3p = var_32_15
					end

					var_32_6 = true
				end
			end
		else
			local var_32_17 = World.spawn_unit(var_32_0, var_32_8)

			arg_32_0._equipment_units[var_32_10] = var_32_17

			arg_32_0:_spawn_item_unit(var_32_17, var_32_9, var_32_4, var_32_11, var_32_3, nil, var_32_14)
		end

		local var_32_18 = var_32_4.show_attachments_event

		if var_32_18 and arg_32_0.character_unit_visible then
			Unit.flow_event(var_32_2, var_32_18)
			Unit.flow_event(var_32_1, var_32_18)
		end

		if var_32_12 then
			if arg_32_0.character_unit_hidden_after_spawn then
				arg_32_0._delayed_material_changes[var_32_1] = arg_32_0._delayed_material_changes[var_32_1] or {}
				arg_32_0._delayed_material_changes[var_32_1][#arg_32_0._delayed_material_changes[var_32_1] + 1] = var_32_12.third_person
			else
				local var_32_19 = var_32_12.third_person

				for iter_32_2, iter_32_3 in pairs(var_32_19) do
					Unit.set_material(var_32_2, iter_32_2, iter_32_3)

					var_32_5 = true
				end
			end
		end
	end

	if var_32_6 then
		Unit.set_data(var_32_1, "equipment", var_32_7)
	end

	return var_32_5
end

local function var_0_1(arg_33_0, arg_33_1, arg_33_2)
	return arg_33_1 and arg_33_1[arg_33_2] or arg_33_0
end

HeroPreviewer.reset_pose_animation = function (arg_34_0)
	if not arg_34_0._pose_animation_event then
		return
	end

	local var_34_0 = arg_34_0._wielded_slot_type
	local var_34_1 = arg_34_0._item_info_by_slot[var_34_0]
	local var_34_2 = var_34_1.name
	local var_34_3 = ItemHelper.get_template_by_item_name(var_34_2)
	local var_34_4 = var_34_1.spawn_data
	local var_34_5 = arg_34_0.character_unit
	local var_34_6 = arg_34_0:character_visible()
	local var_34_7 = var_34_3.wield_anim

	if var_34_7 then
		local var_34_8 = var_0_1(nil, var_34_3.wield_anim_career_3p, arg_34_0._current_career_name) or var_0_1(var_34_7, var_34_3.wield_anim_career, arg_34_0._current_career_name)

		Unit.animation_event(var_34_5, var_34_8)
	end

	arg_34_0._pose_animation_event = nil
end

HeroPreviewer.set_pose_animation = function (arg_35_0, arg_35_1, arg_35_2)
	arg_35_0._pose_animation_event = arg_35_1

	if arg_35_2 then
		local var_35_0 = arg_35_0.character_unit

		if var_35_0 == nil then
			return
		end

		if not arg_35_0._loading_done then
			arg_35_0._delayed_pose_animation = true

			return
		end

		if arg_35_1 then
			Unit.animation_event(var_35_0, arg_35_1)
		else
			arg_35_0:reset_animation()
		end
	end
end

HeroPreviewer.trigger_pose_animation = function (arg_36_0)
	local var_36_0 = arg_36_0._pose_animation_event
	local var_36_1 = arg_36_0.character_unit

	if var_36_1 == nil or var_36_0 == nil then
		return
	end

	Unit.animation_event(var_36_1, var_36_0)

	arg_36_0._delayed_pose_animation = false
end

HeroPreviewer._spawn_item_unit = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5, arg_37_6, arg_37_7)
	local var_37_0 = arg_37_0.world
	local var_37_1 = arg_37_0.character_unit
	local var_37_2 = arg_37_0:character_visible()

	if arg_37_2 == "melee" or arg_37_2 == "ranged" then
		if arg_37_0._wielded_slot_type == arg_37_2 then
			arg_37_4 = arg_37_4.wielded

			if not script_data.disable_third_person_weapon_animation_events then
				local var_37_3 = not arg_37_7 and arg_37_3.wield_anim

				if var_37_3 then
					local var_37_4 = var_0_1(nil, arg_37_3.wield_anim_career_3p, arg_37_0._current_career_name) or var_0_1(var_37_3, arg_37_3.wield_anim_career, arg_37_0._current_career_name)

					Unit.animation_event(var_37_1, var_37_4)
				end
			end

			arg_37_0._hidden_units[arg_37_1] = true

			local var_37_5 = var_37_2 and "lua_wield" or "lua_unwield"

			Unit.flow_event(arg_37_1, var_37_5)
		else
			arg_37_4 = arg_37_4.unwielded

			Unit.flow_event(arg_37_1, "lua_unwield")
		end
	else
		local var_37_6 = var_37_2 and "lua_attachment_unhidden" or "lua_attachment_hidden"

		Unit.flow_event(arg_37_1, var_37_6)

		arg_37_0._hidden_units[arg_37_1] = true
	end

	Unit.set_unit_visibility(arg_37_1, false)

	if Unit.has_lod_object(arg_37_1, "lod") then
		local var_37_7 = Unit.lod_object(arg_37_1, "lod")

		LODObject.set_static_height(var_37_7, 1)
	end

	local var_37_8 = var_37_1

	if arg_37_3.link_to_skin then
		var_37_8 = arg_37_0.mesh_unit
	end

	GearUtils.link(var_37_0, arg_37_4, arg_37_5, var_37_8, arg_37_1)

	if arg_37_6 then
		GearUtils.apply_material_settings(arg_37_1, arg_37_6)
	end
end

HeroPreviewer._destroy_item_units_by_slot = function (arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0.world
	local var_38_1 = arg_38_0._hidden_units
	local var_38_2 = arg_38_0._requested_mip_streaming_units
	local var_38_3 = arg_38_0._item_info_by_slot[arg_38_1].spawn_data

	if var_38_3 then
		for iter_38_0, iter_38_1 in ipairs(var_38_3) do
			local var_38_4 = iter_38_1.item_slot_type
			local var_38_5 = iter_38_1.slot_index

			if var_38_4 == "melee" or var_38_4 == "ranged" then
				if iter_38_1.right_hand or iter_38_1.despawn_both_hands_units then
					local var_38_6 = arg_38_0._equipment_units[var_38_5].right

					if var_38_6 ~= nil then
						var_38_1[var_38_6] = nil
						var_38_2[var_38_6] = nil

						World.destroy_unit(var_38_0, var_38_6)

						arg_38_0._equipment_units[var_38_5].right = nil
					end
				end

				if iter_38_1.left_hand or iter_38_1.despawn_both_hands_units then
					local var_38_7 = arg_38_0._equipment_units[var_38_5].left

					if var_38_7 ~= nil then
						var_38_1[var_38_7] = nil
						var_38_2[var_38_7] = nil

						World.destroy_unit(var_38_0, var_38_7)

						arg_38_0._equipment_units[var_38_5].left = nil
					end
				end
			else
				local var_38_8 = arg_38_0._equipment_units[var_38_5]

				if var_38_8 ~= nil then
					var_38_1[var_38_8] = nil
					var_38_2[var_38_8] = nil

					World.destroy_unit(var_38_0, var_38_8)

					arg_38_0._equipment_units[var_38_5] = nil
				end
			end
		end
	end
end

HeroPreviewer.wield_weapon_slot = function (arg_39_0, arg_39_1)
	arg_39_0._wielded_slot_type = arg_39_1

	local var_39_0 = arg_39_0._item_info_by_slot.melee

	if var_39_0 then
		local var_39_1 = var_39_0.name
		local var_39_2 = var_39_0.backend_id
		local var_39_3 = var_39_0.skin_name

		arg_39_0:equip_item(var_39_1, InventorySettings.slots_by_name.slot_melee, var_39_2, var_39_3)
	end

	local var_39_4 = arg_39_0._item_info_by_slot.ranged

	if var_39_4 then
		local var_39_5 = var_39_4.name
		local var_39_6 = var_39_4.backend_id
		local var_39_7 = var_39_4.skin_name

		arg_39_0:equip_item(var_39_5, InventorySettings.slots_by_name.slot_ranged, var_39_6, var_39_7)
	end
end

HeroPreviewer.set_wielded_weapon_slot = function (arg_40_0, arg_40_1)
	arg_40_0._wielded_slot_type = arg_40_1
end

HeroPreviewer.item_name_by_slot_type = function (arg_41_0, arg_41_1)
	local var_41_0 = arg_41_0._item_info_by_slot[arg_41_1]

	return var_41_0 and var_41_0.name
end

HeroPreviewer.wielded_slot_type = function (arg_42_0)
	return arg_42_0._wielded_slot_type
end

HeroPreviewer._reference_name = function (arg_43_0)
	local var_43_0 = "HeroPreviewer"

	if arg_43_0.unique_id then
		var_43_0 = var_43_0 .. tostring(arg_43_0.unique_id)
	end

	return var_43_0
end

HeroPreviewer._trigger_equip_events = function (arg_44_0)
	if not Unit.alive(arg_44_0.mesh_unit) then
		return
	end

	local var_44_0 = arg_44_0._equipment_units

	if arg_44_0.character_unit_skin_data then
		local var_44_1 = var_44_0[InventorySettings.slots_by_name.slot_hat.slot_index]
		local var_44_2 = arg_44_0.character_unit_skin_data.equip_hat_event or "using_skin_default"

		if var_44_1 and var_44_2 then
			Unit.flow_event(var_44_1, var_44_2)
		end
	end
end

HeroPreviewer._load_packages = function (arg_45_0, arg_45_1)
	local var_45_0 = arg_45_0:_reference_name()
	local var_45_1 = Managers.package

	for iter_45_0, iter_45_1 in ipairs(arg_45_1) do
		var_45_1:load(iter_45_1, var_45_0, nil, true, true)
	end
end

HeroPreviewer._unload_all_packages = function (arg_46_0)
	arg_46_0:_unload_hero_packages()
	arg_46_0:_unload_all_items()
	arg_46_0:_unload_all_prop_packages()
end

HeroPreviewer._unload_all_prop_packages = function (arg_47_0)
	local var_47_0 = arg_47_0._props_data

	for iter_47_0, iter_47_1 in pairs(var_47_0) do
		arg_47_0:_unload_prop_packages(iter_47_1)

		var_47_0[iter_47_0] = nil
	end
end

HeroPreviewer._unload_hero_packages = function (arg_48_0)
	local var_48_0 = arg_48_0._hero_loading_package_data

	if not var_48_0 then
		return
	end

	local var_48_1 = var_48_0.package_names
	local var_48_2 = Managers.package
	local var_48_3 = arg_48_0:_reference_name()

	for iter_48_0, iter_48_1 in pairs(var_48_1) do
		if var_48_2:has_loaded(iter_48_1, var_48_3) or var_48_2:is_loading(iter_48_1, var_48_3) then
			var_48_2:unload(iter_48_1, var_48_3)
		end
	end

	arg_48_0._hero_loading_package_data = nil
end

HeroPreviewer._unload_all_items = function (arg_49_0)
	local var_49_0 = arg_49_0._item_info_by_slot

	for iter_49_0, iter_49_1 in pairs(var_49_0) do
		arg_49_0:_unload_item_packages_by_slot(iter_49_0)
	end
end

HeroPreviewer._unload_prop_packages = function (arg_50_0, arg_50_1)
	local var_50_0 = Managers.package
	local var_50_1 = arg_50_0:_reference_name()

	for iter_50_0, iter_50_1 in ipairs(arg_50_1.settings.package_names) do
		if var_50_0:has_loaded(iter_50_1, var_50_1) or var_50_0:is_loading(iter_50_1, var_50_1) then
			var_50_0:unload(iter_50_1, var_50_1)
		end
	end
end

HeroPreviewer._unload_item_packages_by_slot = function (arg_51_0, arg_51_1)
	local var_51_0 = arg_51_0._item_info_by_slot

	if var_51_0[arg_51_1] then
		local var_51_1 = var_51_0[arg_51_1].package_names
		local var_51_2 = Managers.package
		local var_51_3 = arg_51_0:_reference_name()

		for iter_51_0, iter_51_1 in ipairs(var_51_1) do
			if var_51_2:has_loaded(iter_51_1, var_51_3) or var_51_2:is_loading(iter_51_1, var_51_3) then
				var_51_2:unload(iter_51_1, var_51_3)
			end
		end

		var_51_0[arg_51_1] = nil
	end
end

HeroPreviewer.clear_units = function (arg_52_0)
	table.clear(arg_52_0._requested_mip_streaming_units)

	local var_52_0 = arg_52_0.world

	for iter_52_0 = 1, 6 do
		if type(arg_52_0._equipment_units[iter_52_0]) == "table" then
			if arg_52_0._equipment_units[iter_52_0].left then
				World.destroy_unit(var_52_0, arg_52_0._equipment_units[iter_52_0].left)

				arg_52_0._equipment_units[iter_52_0].left = nil
			end

			if arg_52_0._equipment_units[iter_52_0].right then
				World.destroy_unit(var_52_0, arg_52_0._equipment_units[iter_52_0].right)

				arg_52_0._equipment_units[iter_52_0].right = nil
			end
		elseif arg_52_0._equipment_units[iter_52_0] then
			World.destroy_unit(var_52_0, arg_52_0._equipment_units[iter_52_0])

			arg_52_0._equipment_units[iter_52_0] = nil
		end
	end

	if arg_52_0.mesh_unit then
		World.destroy_unit(var_52_0, arg_52_0.mesh_unit)

		arg_52_0.mesh_unit = nil
	end

	if arg_52_0.character_unit then
		World.destroy_unit(var_52_0, arg_52_0.character_unit)

		arg_52_0.character_unit = nil
	end

	for iter_52_1, iter_52_2 in pairs(arg_52_0._props_data) do
		if iter_52_2.unit then
			World.destroy_unit(var_52_0, iter_52_2.unit)

			iter_52_2.unit = nil
		end
	end
end

HeroPreviewer.set_hero_location = function (arg_53_0, arg_53_1)
	if arg_53_1 then
		arg_53_0.character_location = arg_53_1

		local var_53_0 = arg_53_0.character_unit

		if var_53_0 and Unit.alive(var_53_0) then
			Unit.set_local_position(var_53_0, 0, Vector3Aux.unbox(arg_53_1))
		end
	end
end

HeroPreviewer.set_hero_location_lerped = function (arg_54_0, arg_54_1, arg_54_2)
	arg_54_0._character_destination_location = arg_54_1
	arg_54_0._lerp_time = arg_54_2
	arg_54_0._lerp_end_time = Managers.time:time("game") + arg_54_2
end

HeroPreviewer.set_hero_rotation = function (arg_55_0, arg_55_1)
	if arg_55_1 then
		arg_55_0.character_rotation = arg_55_1

		local var_55_0 = arg_55_0.character_unit

		if var_55_0 and Unit.alive(var_55_0) then
			local var_55_1 = Quaternion.axis_angle(Vector3.up(), arg_55_1)

			Unit.set_local_rotation(var_55_0, 0, var_55_1)
		end
	end
end

HeroPreviewer.set_hero_look_target = function (arg_56_0, arg_56_1)
	if arg_56_1 then
		arg_56_0.character_look_target = arg_56_1
	end
end

HeroPreviewer.get_character_unit = function (arg_57_0)
	return Unit.alive(arg_57_0.character_unit) and arg_57_0.character_unit or nil
end

HeroPreviewer.current_profile_name = function (arg_58_0)
	return arg_58_0._current_profile_name
end
