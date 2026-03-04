-- chunkname: @scripts/ui/views/hero_view/loot_item_unit_previewer.lua

local var_0_0 = 0

LootItemUnitPreviewer = class(LootItemUnitPreviewer)

function LootItemUnitPreviewer.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9, arg_1_10)
	arg_1_0._unique_id = arg_1_5
	arg_1_0._loaded_packages = {}
	arg_1_0._packages_to_load = {}
	arg_1_0._requested_all_mips_units = {}
	arg_1_0._camera_xy_angle_target = var_0_0
	arg_1_0._camera_xy_angle_current = var_0_0
	arg_1_0._invert_start_rotation = arg_1_6
	arg_1_0._display_unit_key = arg_1_7
	arg_1_0._spawn_position = arg_1_2
	arg_1_0._item = arg_1_1
	arg_1_0._use_highest_mip_levels = arg_1_8
	arg_1_0._career_name_override = arg_1_10
	arg_1_0._delayed_spawn = arg_1_9

	if not arg_1_0._delayed_spawn then
		arg_1_0._background_world = arg_1_3
		arg_1_0._background_viewport = arg_1_4
		arg_1_0._link_unit = arg_1_0:_spawn_link_unit(arg_1_1)
	end

	arg_1_0._activated = not arg_1_0._delayed_spawn
	arg_1_0._units_to_spawn = arg_1_0:_load_item_units(arg_1_1)
end

function LootItemUnitPreviewer.activate(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	if not arg_2_0._delayed_spawn then
		return
	end

	if arg_2_1 == arg_2_0._activated then
		return
	end

	if arg_2_1 then
		arg_2_0._background_world = arg_2_2
		arg_2_0._background_viewport = arg_2_3
		arg_2_0._link_unit = arg_2_0:_spawn_link_unit(arg_2_0._item)
	else
		arg_2_0:_destroy_units()

		arg_2_0._background_world = nil
		arg_2_0._background_viewport = nil
	end

	arg_2_0._activated = arg_2_1
	arg_2_0._force_present = arg_2_4
end

function LootItemUnitPreviewer.activate_auto_spin(arg_3_0)
	arg_3_0._auto_spin_random_seed = math.random(5, 30000)
end

function LootItemUnitPreviewer.register_spawn_callback(arg_4_0, arg_4_1)
	arg_4_0._spawn_callback = arg_4_1
end

function LootItemUnitPreviewer.destroy(arg_5_0)
	arg_5_0:_destroy_units()
	arg_5_0:_unload_packages()
	table.clear(arg_5_0._loaded_packages)
	table.clear(arg_5_0._packages_to_load)
	Renderer.set_automatic_streaming(true)
end

function LootItemUnitPreviewer._destroy_units(arg_6_0)
	local var_6_0 = arg_6_0._background_world
	local var_6_1 = arg_6_0._spawned_units

	if var_6_1 then
		for iter_6_0, iter_6_1 in ipairs(var_6_1) do
			World.destroy_unit(var_6_0, iter_6_1)
		end

		arg_6_0._spawned_units = nil
	end

	local var_6_2 = arg_6_0._link_unit

	if var_6_2 then
		World.destroy_unit(var_6_0, var_6_2)
	end

	arg_6_0._link_unit = nil
	arg_6_0.units_spawned = nil
	arg_6_0._items_spawned = nil
end

function LootItemUnitPreviewer.update(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if not arg_7_0._activated then
		return
	end

	if arg_7_0._items_spawned then
		if arg_7_0._request_show_settings and arg_7_0:_update_manual_mip_streaming() then
			local var_7_0 = arg_7_0._request_show_settings
			local var_7_1 = var_7_0.item_key
			local var_7_2 = var_7_0.ignore_spin
			local var_7_3 = true

			arg_7_0:_enable_item_units_visibility(var_7_1, var_7_2, var_7_3)

			arg_7_0._request_show_settings = nil
		elseif arg_7_0._force_present then
			local var_7_4 = arg_7_0._item.key

			arg_7_0:present_item(var_7_4, true)

			arg_7_0._force_present = false
		end

		if arg_7_3 then
			local var_7_5 = Managers.input

			if var_7_5:is_device_active("mouse") then
				arg_7_0:_handle_mouse_input(arg_7_3, arg_7_1)
			elseif var_7_5:is_device_active("gamepad") then
				arg_7_0:_handle_controller_input(arg_7_3, arg_7_1)
			end
		end

		if arg_7_0._camera_xy_angle_target > math.pi * 2 then
			arg_7_0._camera_xy_angle_current = arg_7_0._camera_xy_angle_current - math.pi * 2
			arg_7_0._camera_xy_angle_target = arg_7_0._camera_xy_angle_target - math.pi * 2
		end

		local var_7_6 = math.lerp(arg_7_0._camera_xy_angle_current, arg_7_0._camera_xy_angle_target, 0.1)

		arg_7_0._camera_xy_angle_current = var_7_6

		local var_7_7, var_7_8 = arg_7_0:_auto_spin_values(arg_7_1, arg_7_2)
		local var_7_9 = arg_7_0._invert_start_rotation and 0 or math.pi
		local var_7_10 = Quaternion.axis_angle(Vector3(0, var_7_7, 1), -(var_7_6 + var_7_8 + var_7_9))
		local var_7_11 = arg_7_0._link_unit

		if var_7_11 then
			Unit.set_local_rotation(var_7_11, 0, var_7_10)
		end

		if arg_7_0._zoom_dirty then
			local var_7_12 = arg_7_0._zoom_fraction or 0
			local var_7_13 = arg_7_0._unit_start_position_boxed:unbox()

			var_7_13[1] = var_7_13[1] * (1 - var_7_12)
			var_7_13[2] = var_7_13[2] * (1 - var_7_12)

			Unit.set_local_position(var_7_11, 0, var_7_13)

			arg_7_0._zoom_dirty = nil
		end
	end
end

function LootItemUnitPreviewer.set_zoom_fraction(arg_8_0, arg_8_1)
	arg_8_0._zoom_fraction = math.clamp(arg_8_1, 0, 1)
	arg_8_0._zoom_dirty = true
end

function LootItemUnitPreviewer.zoom_fraction(arg_9_0)
	return arg_9_0._zoom_fraction or 0
end

function LootItemUnitPreviewer._auto_spin_values(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._auto_spin_random_seed

	if not var_10_0 then
		return 0, 0
	end

	local var_10_1 = 0.2
	local var_10_2 = 0.3
	local var_10_3 = math.sin((var_10_0 + arg_10_2) * var_10_1) * var_10_2
	local var_10_4 = -(var_10_3 * 0.5)
	local var_10_5 = -(var_10_3 * math.pi / 2)

	return var_10_4, var_10_5
end

local var_0_1 = {}

function LootItemUnitPreviewer._handle_mouse_input(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_1:get("cursor")

	if not var_11_0 then
		return
	end

	local var_11_1 = true

	if var_11_1 then
		if arg_11_1:get("left_press") then
			arg_11_0._is_moving_camera = true
			arg_11_0._last_mouse_position = nil
		elseif arg_11_1:get("right_press") then
			arg_11_0._camera_xy_angle_target = var_0_0
		end
	end

	local var_11_2 = arg_11_0._is_moving_camera
	local var_11_3 = arg_11_1:get("left_hold")

	if var_11_2 and var_11_3 then
		if arg_11_0._last_mouse_position then
			arg_11_0._camera_xy_angle_target = arg_11_0._camera_xy_angle_target - (var_11_0.x - arg_11_0._last_mouse_position[1]) * 0.01
		end

		var_0_1[1] = var_11_0.x
		var_0_1[2] = var_11_0.y
		arg_11_0._last_mouse_position = var_0_1
	elseif var_11_2 then
		arg_11_0._is_moving_camera = false
	end
end

function LootItemUnitPreviewer._handle_controller_input(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_1:get("gamepad_right_axis")

	if var_12_0 and Vector3.length(var_12_0) > 0.01 then
		arg_12_0._camera_xy_angle_target = arg_12_0._camera_xy_angle_target + -var_12_0.x * arg_12_2 * 5
	end
end

function LootItemUnitPreviewer.post_update(arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_0._activated then
		return
	end

	if arg_13_0._spawn_callback and arg_13_0._items_spawned then
		arg_13_0._spawn_callback()

		arg_13_0._spawn_callback = nil
	end

	if not arg_13_0._items_spawned and arg_13_0:_packages_loaded() then
		arg_13_0._items_spawned = arg_13_0:_spawn_items()
	end
end

function LootItemUnitPreviewer._load_item_units(arg_14_0, arg_14_1)
	if not arg_14_1 then
		return
	end

	local var_14_0 = arg_14_1.data
	local var_14_1 = arg_14_1.backend_id
	local var_14_2 = arg_14_1.skin
	local var_14_3 = var_14_0.key or arg_14_1.key
	local var_14_4 = ItemMasterList[var_14_3]
	local var_14_5
	local var_14_6 = var_14_4.item_type

	if var_14_6 == "rune" or var_14_6 == "material" or var_14_6 == "ring" or var_14_6 == "necklace" then
		var_14_4 = ItemMasterList[var_14_3]
	elseif var_14_6 == "weapon_skin" then
		local var_14_7 = var_14_4.matching_item_key

		var_14_5 = ItemHelper.get_template_by_item_name(var_14_7)
		var_14_2 = var_14_2 or var_14_3
	end

	var_14_5 = var_14_5 or ItemHelper.get_template_by_item_name(var_14_3)

	local var_14_8 = BackendUtils.get_item_units(var_14_4, var_14_1, var_14_2, arg_14_0._career_name_override)
	local var_14_9 = {}
	local var_14_10 = var_14_4.slot_type

	if var_14_10 == "melee" or var_14_10 == "ranged" or var_14_10 == "weapon_skin" then
		local var_14_11 = var_14_8.left_hand_unit
		local var_14_12 = var_14_8.right_hand_unit
		local var_14_13 = var_14_8.ammo_unit
		local var_14_14 = var_14_8.is_ammo_weapon
		local var_14_15 = var_14_8.material_settings_name

		if var_14_11 then
			if var_14_14 then
				var_14_11 = var_14_13
			end

			local var_14_16 = var_14_11 .. "_3p"

			arg_14_0:load_package(var_14_16)

			var_14_9[#var_14_9 + 1] = {
				unit_name = var_14_16,
				unit_attachment_node_linking = var_14_5.left_hand_attachment_node_linking.third_person.display,
				material_settings_name = var_14_15
			}
		end

		if var_14_12 then
			if var_14_14 then
				var_14_12 = var_14_13
			end

			local var_14_17 = var_14_12 .. "_3p"

			if var_14_12 ~= var_14_11 then
				arg_14_0:load_package(var_14_17)
			end

			var_14_9[#var_14_9 + 1] = {
				unit_name = var_14_17,
				unit_attachment_node_linking = var_14_5.right_hand_attachment_node_linking.third_person.display,
				material_settings_name = var_14_15
			}
		end
	elseif var_14_10 == "frame" or var_14_10 == "chips" then
		local var_14_18 = var_14_5.attachment_node.unit

		if var_14_18 then
			arg_14_0:load_package(var_14_18)
		end

		if var_14_5.texture_package_name and Application.can_get("package", var_14_5.texture_package_name) then
			arg_14_0:load_package(var_14_5.texture_package_name)
		end

		local var_14_19 = var_14_5.material_settings_name

		var_14_9[#var_14_9 + 1] = {
			unit_name = var_14_18,
			unit_attachment_node_linking = var_14_5.attachment_node.attachment_node,
			material_settings_name = var_14_19,
			additional_packages = {
				var_14_5.texture_package_name
			}
		}
	else
		local var_14_20 = var_14_8.unit

		if var_14_20 then
			arg_14_0:load_package(var_14_20)

			var_14_9[#var_14_9 + 1] = {
				unit_name = var_14_20,
				unit_attachment_node_linking = var_14_10 == "trinket" and var_14_5.attachment_node_linking.slot_trinket_1 or var_14_5.attachment_node_linking.slot_hat
			}
		end
	end

	return var_14_9
end

function LootItemUnitPreviewer._trigger_unit_flow_event(arg_15_0, arg_15_1, arg_15_2)
	if arg_15_1 and Unit.alive(arg_15_1) then
		Unit.flow_event(arg_15_1, arg_15_2)
	end
end

function LootItemUnitPreviewer._get_world(arg_16_0)
	return arg_16_0._background_world, arg_16_0._background_viewport
end

function LootItemUnitPreviewer._get_camera_position(arg_17_0)
	local var_17_0 = arg_17_0._background_viewport
	local var_17_1 = ScriptViewport.camera(var_17_0)

	return ScriptCamera.position(var_17_1)
end

function LootItemUnitPreviewer._get_camera_rotation(arg_18_0)
	local var_18_0 = arg_18_0._background_viewport
	local var_18_1 = ScriptViewport.camera(var_18_0)

	return ScriptCamera.rotation(var_18_1)
end

function LootItemUnitPreviewer._packages_loaded(arg_19_0)
	local var_19_0 = arg_19_0._units_to_spawn
	local var_19_1 = arg_19_0._loaded_packages

	for iter_19_0, iter_19_1 in ipairs(var_19_0) do
		if not var_19_1[iter_19_1.unit_name] then
			return false
		end

		if iter_19_1.additional_packages then
			for iter_19_2, iter_19_3 in ipairs(iter_19_1.additional_packages) do
				if not var_19_1[iter_19_3] then
					return false
				end
			end
		end
	end

	return true
end

function LootItemUnitPreviewer.load_package(arg_20_0, arg_20_1)
	if arg_20_0._packages_to_load[arg_20_1] ~= nil then
		return
	end

	arg_20_0._packages_to_load[arg_20_1] = true

	local var_20_0 = Managers.package
	local var_20_1 = callback(arg_20_0, "_on_load_complete", arg_20_1)
	local var_20_2 = "LootItemUnitPreviewer"

	if arg_20_0._unique_id then
		var_20_2 = var_20_2 .. tostring(arg_20_0._unique_id)
	end

	var_20_0:load(arg_20_1, var_20_2, var_20_1, true)
end

function LootItemUnitPreviewer._on_load_complete(arg_21_0, arg_21_1)
	arg_21_0._loaded_packages[arg_21_1] = true
	arg_21_0._packages_to_load[arg_21_1] = false
end

function LootItemUnitPreviewer._unload_packages(arg_22_0)
	local var_22_0 = "LootItemUnitPreviewer"

	if arg_22_0._unique_id then
		var_22_0 = var_22_0 .. tostring(arg_22_0._unique_id)
	end

	local var_22_1 = arg_22_0._loaded_packages

	if var_22_1 then
		local var_22_2 = Managers.package

		for iter_22_0, iter_22_1 in pairs(var_22_1) do
			var_22_2:unload(iter_22_0, var_22_0)
		end
	end

	local var_22_3 = arg_22_0._packages_to_load

	if var_22_3 then
		local var_22_4 = Managers.package

		for iter_22_2, iter_22_3 in pairs(var_22_3) do
			if iter_22_3 then
				var_22_4:unload(iter_22_2, var_22_0)
			end
		end
	end
end

function LootItemUnitPreviewer._spawn_link_unit(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_1.data
	local var_23_1 = arg_23_1.key or var_23_0.key
	local var_23_2 = arg_23_1.skin or var_23_1
	local var_23_3 = arg_23_0._spawn_position
	local var_23_4 = ItemMasterList[var_23_1]
	local var_23_5 = var_23_4.item_type

	if var_23_5 ~= "rune" and var_23_5 ~= "material" and var_23_5 ~= "ring" and var_23_5 == "necklace" then
		-- block empty
	end

	local var_23_6 = arg_23_0._display_unit_key
	local var_23_7 = "display_unit"
	local var_23_8 = var_23_4[var_23_6] or var_23_4[var_23_7]

	if var_23_5 == "weapon_skin" then
		local var_23_9 = WeaponSkins.skins[var_23_2]

		var_23_8 = var_23_9[var_23_6] or var_23_9[var_23_7] or var_23_8
	elseif not var_23_8 then
		local var_23_10 = ItemHelper.get_template_by_item_name(var_23_1)

		var_23_8 = var_23_10[var_23_6] or var_23_10[var_23_7]
	end

	if not var_23_8 or var_23_8 == "" then
		Application.warning(string.format("[LootItemUnitPreviewer] Couldn't find any display unit for item %q", var_23_1))

		return nil
	end

	local var_23_11 = arg_23_0:_get_camera_rotation()
	local var_23_12 = Quaternion.forward(var_23_11)
	local var_23_13 = Quaternion.look(var_23_12, Vector3.up())
	local var_23_14 = Quaternion.axis_angle(Vector3.up(), 0)
	local var_23_15 = Quaternion.multiply(var_23_13, var_23_14)
	local var_23_16 = arg_23_0:_get_camera_position() + var_23_12 + Vector3(var_23_3[1], var_23_3[2], var_23_3[3])
	local var_23_17 = arg_23_0._background_world
	local var_23_18 = World.spawn_unit(var_23_17, var_23_8, var_23_16, var_23_15)
	local var_23_19 = Unit.world_position(var_23_18, 0)

	arg_23_0._unit_start_position_boxed = Vector3Box(var_23_19)

	return var_23_18
end

function LootItemUnitPreviewer._spawn_items(arg_24_0)
	local var_24_0 = true
	local var_24_1 = arg_24_0._units_to_spawn

	for iter_24_0, iter_24_1 in ipairs(var_24_1) do
		local var_24_2 = iter_24_1.unit_name

		if not arg_24_0._loaded_packages[var_24_2] then
			var_24_0 = false

			break
		end
	end

	if var_24_0 then
		local var_24_3 = arg_24_0._item.data.key
		local var_24_4 = arg_24_0:spawn_units(var_24_1)

		if arg_24_0._use_highest_mip_levels then
			for iter_24_2 = 1, #var_24_4 do
				local var_24_5 = var_24_4[iter_24_2]

				arg_24_0:_request_all_mips_for_unit(var_24_5)
			end
		end

		arg_24_0._spawned_units = var_24_4
	end

	return var_24_0
end

function LootItemUnitPreviewer.spawn_units(arg_25_0, arg_25_1)
	local var_25_0 = {}
	local var_25_1 = arg_25_0._link_unit

	if arg_25_1 and var_25_1 then
		local var_25_2 = {}
		local var_25_3 = arg_25_0._background_world

		for iter_25_0 = 1, #arg_25_1 do
			local var_25_4 = arg_25_1[iter_25_0]
			local var_25_5 = var_25_4.unit_name
			local var_25_6 = var_25_4.unit_attachment_node_linking
			local var_25_7 = var_25_4.material_settings_name
			local var_25_8 = World.spawn_unit(var_25_3, var_25_5)

			Unit.set_unit_visibility(var_25_8, false)

			var_25_0[#var_25_0 + 1] = var_25_8

			GearUtils.link(var_25_3, var_25_6, var_25_2, var_25_1, var_25_8)

			if var_25_7 then
				GearUtils.apply_material_settings(var_25_8, var_25_7)
			end
		end

		arg_25_0.units_spawned = true
	end

	return var_25_0
end

function LootItemUnitPreviewer.present_item(arg_26_0, arg_26_1, arg_26_2)
	if arg_26_0._use_highest_mip_levels and not arg_26_0:_update_manual_mip_streaming() then
		arg_26_0._request_show_settings = {
			item_key = arg_26_1,
			ignore_spin = arg_26_2
		}
	else
		arg_26_0:_enable_item_units_visibility(arg_26_1, arg_26_2, true)
	end
end

function LootItemUnitPreviewer._enable_item_units_visibility(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	local var_27_0 = arg_27_0._spawned_units

	if var_27_0 then
		local var_27_1 = arg_27_0._link_unit

		for iter_27_0, iter_27_1 in ipairs(var_27_0) do
			if iter_27_1 and Unit.alive(iter_27_1) then
				Unit.set_unit_visibility(iter_27_1, arg_27_3)

				if arg_27_3 then
					arg_27_0:_trigger_unit_flow_event(iter_27_1, "lua_presentation")
					arg_27_0:_trigger_unit_flow_event(iter_27_1, "lua_wield")
				end
			end
		end

		if not arg_27_2 and arg_27_3 and var_27_1 then
			Unit.flow_event(var_27_1, "lua_spin_no_fx")
		end
	end
end

function LootItemUnitPreviewer._request_all_mips_for_unit(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0._requested_all_mips_units

	var_28_0[#var_28_0 + 1] = arg_28_1

	Renderer.request_to_stream_all_mips_for_unit(arg_28_1)
	Renderer.set_automatic_streaming(false)
end

function LootItemUnitPreviewer._update_manual_mip_streaming(arg_29_0)
	local var_29_0 = true
	local var_29_1 = arg_29_0._requested_all_mips_units

	for iter_29_0 = #var_29_1, 1, -1 do
		local var_29_2 = var_29_1[iter_29_0]

		if Renderer.is_all_mips_loaded_for_unit(var_29_2) then
			table.swap_delete(var_29_1, iter_29_0)
		else
			var_29_0 = false
		end
	end

	if var_29_0 then
		Renderer.set_automatic_streaming(true)
	end

	return var_29_0
end
