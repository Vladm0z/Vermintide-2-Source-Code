-- chunkname: @scripts/ui/views/demo_character_previewer.lua

DemoCharacterPreviewer = class(DemoCharacterPreviewer)

function DemoCharacterPreviewer.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	arg_1_0._world = arg_1_1
	arg_1_0._profile_name = arg_1_2
	arg_1_0._career_index = arg_1_3
	arg_1_0._position = arg_1_4 or Vector3Box(0, 0, 0)
	arg_1_0._rotation = arg_1_5 or QuaternionBox(Quaternion.identity())
	arg_1_0._zoom_offset = arg_1_6 or Vector3Box(Vector3.identity())
	arg_1_0.item_spawn_data = {}
	arg_1_0.item_names = {}
	arg_1_0._packages_to_load = {}
	arg_1_0._loaded_packages = {}
	arg_1_0._equipment_units = {}
	arg_1_0._equipment_units[InventorySettings.slots_by_name.slot_melee.slot_index] = {}
	arg_1_0._equipment_units[InventorySettings.slots_by_name.slot_ranged.slot_index] = {}

	if BUILD == "dev" or BUILD == "debug" then
		arg_1_0._line_object = World.create_line_object(arg_1_0._world)
	end

	arg_1_0:_spawn_character()
end

function DemoCharacterPreviewer.reset_state(arg_2_0)
	arg_2_0._is_hover = nil
	arg_2_0._is_pressed = nil

	arg_2_0:outline_unit(false)
end

function DemoCharacterPreviewer._spawn_character(arg_3_0, arg_3_1)
	arg_3_0._position = arg_3_1 or arg_3_0._position

	arg_3_0:_reset_hero()

	local var_3_0 = arg_3_0._profile_name
	local var_3_1 = arg_3_0._career_index

	arg_3_0:_spawn_hero_unit(var_3_0, var_3_1)
end

function DemoCharacterPreviewer._color_from_table(arg_4_0, arg_4_1)
	return Color(arg_4_1[1], arg_4_1[2], arg_4_1[3], arg_4_1[4])
end

function DemoCharacterPreviewer.outline_unit(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if arg_5_0._outlined == arg_5_1 then
		return
	end

	if Unit.alive(arg_5_0._character_unit) then
		local var_5_0 = "outline_unit"
		local var_5_1 = arg_5_0._character_unit

		Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(var_5_1, var_5_0, arg_5_1)

		if arg_5_1 then
			local var_5_2 = arg_5_0:_color_from_table(arg_5_2.channel)
			local var_5_3 = arg_5_3 or 0

			Unit.set_color_for_materials_in_unit_and_childs(var_5_1, "outline_color", var_5_2)
			Unit.set_scalar_for_materials_in_unit_and_childs(var_5_1, "outline_time", World.time(arg_5_0._world) + var_5_3)
		end

		arg_5_0._outlined = arg_5_1
	end
end

function DemoCharacterPreviewer.is_outlined(arg_6_0)
	return arg_6_0._outlined
end

function DemoCharacterPreviewer._reset_hero(arg_7_0)
	if arg_7_0._character_unit then
		World.destroy_unit(arg_7_0._world, arg_7_0._character_unit)

		arg_7_0._character_unit = nil
	end

	local var_7_0 = table.clone(arg_7_0._equipment_units)

	for iter_7_0, iter_7_1 in pairs(var_7_0) do
		if type(iter_7_1) == "table" then
			if iter_7_1.left then
				World.destroy_unit(arg_7_0._world, iter_7_1.left)

				arg_7_0._equipment_units[iter_7_0].left = nil
			end

			if iter_7_1.right then
				World.destroy_unit(arg_7_0._world, iter_7_1.right)

				arg_7_0._equipment_units[iter_7_0].right = nil
			end
		else
			World.destroy_unit(arg_7_0._world, iter_7_1)

			arg_7_0._equipment_units[iter_7_0] = nil
		end
	end

	for iter_7_2, iter_7_3 in pairs(arg_7_0._packages_to_load) do
		Managers.package:unload(iter_7_2, "DemoCharacterPreviewer")
	end

	arg_7_0._packages_to_load = {}

	for iter_7_4, iter_7_5 in pairs(arg_7_0._loaded_packages) do
		Managers.package:unload(iter_7_4, "DemoCharacterPreviewer")
	end

	arg_7_0._loaded_packages = {}

	if arg_7_0._line_object then
		LineObject.reset(arg_7_0._line_object)
		LineObject.dispatch(arg_7_0._world, arg_7_0._line_object)
	end
end

function DemoCharacterPreviewer._spawn_hero_unit(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = FindProfileIndex(arg_8_1)
	local var_8_1 = SPProfiles[var_8_0]
	local var_8_2 = var_8_1.careers[arg_8_2]
	local var_8_3 = var_8_2.base_skin
	local var_8_4 = Cosmetics[var_8_3]
	local var_8_5 = var_8_4.third_person

	if Managers.package:has_loaded(var_8_5) then
		arg_8_0:cb_spawn_hero_unit(var_8_1, var_8_2, var_8_4)
	else
		Managers.package:load(var_8_5, "DemoCharacterPreviewer", callback(arg_8_0, "cb_spawn_hero_unit", var_8_1, var_8_2, var_8_4), true, true)
	end
end

function DemoCharacterPreviewer.cb_spawn_hero_unit(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_0._world
	local var_9_1 = arg_9_3.third_person
	local var_9_2 = arg_9_3.color_tint
	local var_9_3 = World.spawn_unit(var_9_0, var_9_1, arg_9_0._position:unbox(), arg_9_0._rotation:unbox())

	if var_9_2 then
		local var_9_4 = var_9_2.gradient_variation
		local var_9_5 = var_9_2.gradient_value

		CosmeticUtils.color_tint_unit(var_9_3, arg_9_0._profile_name, var_9_4, var_9_5)
	end

	arg_9_0._character_unit = var_9_3

	if Unit.has_lod_object(var_9_3, "lod") then
		local var_9_6 = Unit.lod_object(var_9_3, "lod")

		LODObject.set_static_height(var_9_6, 1)
	end

	local var_9_7, var_9_8 = Unit.box(var_9_3)

	if var_9_8 then
		local var_9_9 = 1.7
		local var_9_10 = var_9_8.z - var_9_9

		arg_9_0.unit_max_look_height = var_9_9 < var_9_8.z and 1.5 or 0.9
	else
		arg_9_0.unit_max_look_height = 0.9
	end

	arg_9_0:_spawn_inventory(arg_9_2)
end

function DemoCharacterPreviewer.update(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	arg_10_0:_update_aim_constraint(arg_10_2, arg_10_3)

	if arg_10_1 then
		arg_10_0:_update_hover(arg_10_2, arg_10_3)
		arg_10_0:_update_pressed(arg_10_2, arg_10_3)
	end
end

function DemoCharacterPreviewer._update_hover(arg_11_0)
	local var_11_0 = Managers.input:get_service("main_menu"):get("cursor")

	if not var_11_0 then
		return
	else
		local var_11_1 = RESOLUTION_LOOKUP.scale

		var_11_0.x = var_11_0.x * var_11_1
		var_11_0.y = var_11_0.y * var_11_1
	end

	if not Unit.alive(arg_11_0._character_unit) then
		return
	end

	local var_11_2 = ScriptWorld.viewport(arg_11_0._world, "title_screen_viewport")
	local var_11_3 = ScriptViewport.camera(var_11_2)
	local var_11_4 = Camera.screen_to_world(var_11_3, Vector3(var_11_0.x, var_11_0.y, 0), 0)
	local var_11_5 = Camera.screen_to_world(var_11_3, Vector3(var_11_0.x, var_11_0.y, 0), 1) - var_11_4
	local var_11_6 = World.physics_world(arg_11_0._world)
	local var_11_7, var_11_8 = Unit.box(arg_11_0._character_unit)

	var_11_8[1] = var_11_8[1] * 0.25
	var_11_8[2] = var_11_8[2] * 0.25

	if Intersect.ray_box(var_11_4, var_11_5, var_11_7, var_11_8) then
		if not arg_11_0._is_hover then
			Managers.music:trigger_event("Play_demo_hud_character_hover")
			arg_11_0:outline_unit(true, OutlineSettings.colors.interactable)

			arg_11_0._is_hover = true
		end
	else
		if not arg_11_0._is_pressed then
			arg_11_0:outline_unit(false, OutlineSettings.colors.interactable)
		end

		arg_11_0._is_hover = false
	end
end

function DemoCharacterPreviewer._update_pressed(arg_12_0, arg_12_1, arg_12_2)
	arg_12_0._was_pressed_this_frame = nil

	if Managers.input:get_service("main_menu"):get("start") then
		if arg_12_0._is_hover then
			if not arg_12_0._is_pressed then
				arg_12_0._is_pressed = true
				arg_12_0._was_pressed_this_frame = true
				arg_12_0._outlined = false

				arg_12_0:outline_unit(true, OutlineSettings.colors.ally)
				Managers.music:trigger_event("Play_demo_hud_character_select")
			end
		else
			arg_12_0._is_pressed = false

			arg_12_0:outline_unit(false, OutlineSettings.colors.ally)
		end
	end
end

function DemoCharacterPreviewer.cb_on_select_animation_complete(arg_13_0)
	local var_13_0 = "j_neck"
	local var_13_1 = arg_13_0._character_unit

	if Unit.alive(var_13_1) then
		local var_13_2 = Unit.has_node(var_13_1, var_13_0) and Unit.node(var_13_1, var_13_0)
		local var_13_3 = Unit.world_position(var_13_1, var_13_2)
		local var_13_4 = Managers.world:wwise_world(arg_13_0._world)
		local var_13_5 = WwiseWorld.make_auto_source(var_13_4, var_13_3)

		WwiseWorld.trigger_event(var_13_4, DemoSettings.play_on_select[arg_13_0._profile_name], var_13_5)
	end
end

function DemoCharacterPreviewer.pressed_pose(arg_14_0)
	local var_14_0 = ScriptWorld.viewport(arg_14_0._world, "title_screen_viewport")
	local var_14_1 = ScriptViewport.camera(var_14_0)
	local var_14_2 = ScriptCamera.rotation(var_14_1)
	local var_14_3 = Vector3.flat(Quaternion.forward(var_14_2))
	local var_14_4 = Vector3.flat(Quaternion.right(var_14_2))
	local var_14_5 = Quaternion.look(var_14_3, Vector3.up())
	local var_14_6 = "j_neck"
	local var_14_7 = arg_14_0._character_unit
	local var_14_8 = Unit.has_node(var_14_7, var_14_6) and Unit.node(var_14_7, var_14_6)
	local var_14_9 = Unit.world_position(var_14_7, var_14_8)
	local var_14_10 = arg_14_0._zoom_offset:unbox()
	local var_14_11 = var_14_9 + var_14_4 * var_14_10[1] + var_14_3 * var_14_10[2] + Vector3.up() * var_14_10[3]

	return Matrix4x4Box(Matrix4x4.from_quaternion_position(var_14_2, var_14_11))
end

function DemoCharacterPreviewer._update_aim_constraint(arg_15_0, arg_15_1, arg_15_2)
	if not Unit.alive(arg_15_0._character_unit) then
		return
	end

	local var_15_0 = ScriptWorld.viewport(arg_15_0._world, "title_screen_viewport")
	local var_15_1 = ScriptViewport.camera(var_15_0)
	local var_15_2 = ScriptCamera.position(var_15_1)
	local var_15_3 = arg_15_0._character_unit
	local var_15_4 = Unit.animation_find_constraint_target(var_15_3, "aim_constraint_target")

	Unit.animation_set_constraint_target(var_15_3, var_15_4, var_15_2)
end

function DemoCharacterPreviewer.is_hover(arg_16_0)
	return arg_16_0._is_hover
end

function DemoCharacterPreviewer.is_pressed(arg_17_0)
	return arg_17_0._is_pressed
end

function DemoCharacterPreviewer.was_pressed_this_frame(arg_18_0)
	local var_18_0 = arg_18_0._was_pressed_this_frame

	arg_18_0._was_pressed_this_frame = nil

	return var_18_0
end

function DemoCharacterPreviewer.profile_information(arg_19_0)
	return arg_19_0._profile_name, arg_19_0._career_index
end

function DemoCharacterPreviewer._spawn_inventory(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_1.preview_animation
	local var_20_1 = arg_20_1.preview_wield_slot
	local var_20_2 = arg_20_1.preview_items

	if var_20_2 then
		for iter_20_0, iter_20_1 in ipairs(var_20_2) do
			local var_20_3 = iter_20_1.item_name
			local var_20_4 = ItemMasterList[var_20_3].slot_type
			local var_20_5 = InventorySettings.slot_names_by_type[var_20_4][1]
			local var_20_6 = InventorySettings.slots_by_name[var_20_5]

			arg_20_0:_equip_item(var_20_3, var_20_6)
		end

		if var_20_1 then
			arg_20_0:wield_weapon_slot(var_20_1)
		end
	end

	if var_20_0 then
		arg_20_0:play_character_animation(var_20_0)
	end

	arg_20_0._character_spawned = true
end

function DemoCharacterPreviewer.character_spawned(arg_21_0)
	return arg_21_0._character_spawned
end

function DemoCharacterPreviewer.wield_weapon_slot(arg_22_0, arg_22_1)
	arg_22_0._wielded_slot_type = arg_22_1

	if arg_22_0.item_names.melee then
		arg_22_0:_equip_item(arg_22_0.item_names.melee, InventorySettings.slots_by_name.slot_melee)
	end

	if arg_22_0.item_names.ranged then
		arg_22_0:_equip_item(arg_22_0.item_names.ranged, InventorySettings.slots_by_name.slot_ranged)
	end
end

function DemoCharacterPreviewer.play_character_animation(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0._character_unit

	if var_23_0 == nil then
		return
	end

	Unit.animation_event(var_23_0, arg_23_1)
end

function DemoCharacterPreviewer._equip_item(arg_24_0, arg_24_1, arg_24_2)
	arg_24_0.items_loaded = nil

	local var_24_0 = arg_24_2.type
	local var_24_1 = arg_24_2.slot_index
	local var_24_2 = ItemMasterList[arg_24_1]
	local var_24_3 = BackendUtils.get_item_units(var_24_2)
	local var_24_4 = ItemHelper.get_template_by_item_name(arg_24_1)
	local var_24_5 = {}
	local var_24_6 = {}

	if var_24_0 == "melee" or var_24_0 == "ranged" then
		local var_24_7 = var_24_3.left_hand_unit
		local var_24_8 = var_24_3.right_hand_unit
		local var_24_9 = var_24_3.material_settings_name
		local var_24_10 = var_24_8 == nil or var_24_7 == nil

		if var_24_7 then
			local var_24_11 = var_24_7 .. "_3p"

			var_24_5[#var_24_5 + 1] = {
				left_hand = true,
				despawn_both_hands_units = var_24_10,
				unit_name = var_24_11,
				item_slot_type = var_24_0,
				slot_index = var_24_1,
				unit_attachment_node_linking = var_24_4.left_hand_attachment_node_linking.third_person,
				material_settings_name = var_24_9
			}
			var_24_6[#var_24_6 + 1] = var_24_11
		end

		if var_24_8 then
			local var_24_12 = var_24_8 .. "_3p"

			var_24_5[#var_24_5 + 1] = {
				right_hand = true,
				despawn_both_hands_units = var_24_10,
				unit_name = var_24_12,
				item_slot_type = var_24_0,
				slot_index = var_24_1,
				unit_attachment_node_linking = var_24_4.right_hand_attachment_node_linking.third_person,
				material_settings_name = var_24_9
			}

			if var_24_8 ~= var_24_7 then
				var_24_6[#var_24_6 + 1] = var_24_12
			end
		end
	elseif var_24_0 == "hat" then
		local var_24_13 = var_24_3.unit

		if var_24_13 then
			local var_24_14 = 3

			if var_24_0 == "hat" then
				var_24_14 = 1
			end

			local var_24_15 = var_24_4.slots[var_24_14]

			var_24_5[#var_24_5 + 1] = {
				unit_name = var_24_13,
				item_slot_type = var_24_0,
				slot_index = var_24_1,
				unit_attachment_node_linking = var_24_4.attachment_node_linking[var_24_15]
			}
			var_24_6[#var_24_6 + 1] = var_24_13
		end
	end

	if #var_24_6 > 0 then
		arg_24_0.item_spawn_data[arg_24_1] = var_24_5
		arg_24_0.item_names[var_24_0] = arg_24_1

		arg_24_0:load_package(var_24_6, arg_24_1)
	end
end

function DemoCharacterPreviewer.load_package(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = {}

	for iter_25_0, iter_25_1 in ipairs(arg_25_1) do
		if not arg_25_0._packages_to_load[iter_25_1] then
			arg_25_0._packages_to_load[iter_25_1] = true
			var_25_0[#var_25_0 + 1] = iter_25_1
		end
	end

	for iter_25_2, iter_25_3 in ipairs(var_25_0) do
		local var_25_1 = Managers.package
		local var_25_2 = callback(arg_25_0, "on_load_complete", iter_25_3, arg_25_2)

		var_25_1:load(iter_25_3, "DemoCharacterPreviewer", var_25_2, true, true)
	end
end

function DemoCharacterPreviewer.on_load_complete(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_0._loaded_packages

	var_26_0[arg_26_1] = true
	arg_26_0._packages_to_load[arg_26_1] = nil

	local var_26_1 = arg_26_0.item_names
	local var_26_2 = arg_26_0.item_spawn_data[arg_26_2]

	for iter_26_0, iter_26_1 in ipairs(var_26_2) do
		if var_26_1[iter_26_1.item_slot_type] ~= arg_26_2 then
			return
		end

		if not var_26_0[iter_26_1.unit_name] then
			return
		end
	end

	arg_26_0:_spawn_item(arg_26_2)
end

function DemoCharacterPreviewer._spawn_item(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0._world
	local var_27_1 = arg_27_0._character_unit
	local var_27_2 = {}
	local var_27_3 = ItemMasterList[arg_27_1]
	local var_27_4 = BackendUtils.get_item_units(var_27_3)
	local var_27_5 = ItemHelper.get_template_by_item_name(arg_27_1)
	local var_27_6 = arg_27_0.item_spawn_data[arg_27_1]

	if var_27_6 then
		for iter_27_0, iter_27_1 in ipairs(var_27_6) do
			local var_27_7 = iter_27_1.unit_name
			local var_27_8 = iter_27_1.item_slot_type
			local var_27_9 = iter_27_1.slot_index
			local var_27_10 = iter_27_1.unit_attachment_node_linking
			local var_27_11 = iter_27_1.material_settings_name

			if var_27_8 == "melee" or var_27_8 == "ranged" then
				if iter_27_1.right_hand or iter_27_1.despawn_both_hands_units then
					local var_27_12 = arg_27_0._equipment_units[var_27_9].right

					if var_27_12 ~= nil then
						World.destroy_unit(var_27_0, var_27_12)

						arg_27_0._equipment_units[var_27_9].right = nil
					end
				end

				if iter_27_1.left_hand or iter_27_1.despawn_both_hands_units then
					local var_27_13 = arg_27_0._equipment_units[var_27_9].left

					if var_27_13 ~= nil then
						World.destroy_unit(var_27_0, var_27_13)

						arg_27_0._equipment_units[var_27_9].left = nil
					end
				end

				local var_27_14 = World.spawn_unit(var_27_0, var_27_7)

				arg_27_0:equip_item_unit(var_27_14, var_27_8, var_27_5, var_27_10, var_27_2, var_27_11)

				if iter_27_1.right_hand then
					arg_27_0._equipment_units[var_27_9].right = var_27_14
				elseif iter_27_1.left_hand then
					arg_27_0._equipment_units[var_27_9].left = var_27_14
				end
			else
				local var_27_15 = arg_27_0._equipment_units[var_27_9]

				if var_27_15 ~= nil then
					World.destroy_unit(var_27_0, var_27_15)

					arg_27_0._equipment_units[var_27_9] = nil
				end

				local var_27_16 = World.spawn_unit(var_27_0, var_27_7)

				arg_27_0._equipment_units[var_27_9] = var_27_16

				arg_27_0:equip_item_unit(var_27_16, var_27_8, var_27_5, var_27_10, var_27_2)
			end

			local var_27_17 = var_27_5.show_attachments_event

			if var_27_17 then
				Unit.flow_event(var_27_1, var_27_17)
			end
		end
	end
end

function DemoCharacterPreviewer.equip_item_unit(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6)
	local var_28_0 = arg_28_0._world
	local var_28_1 = arg_28_0._character_unit

	if arg_28_2 == "melee" or arg_28_2 == "ranged" then
		if arg_28_0._wielded_slot_type == arg_28_2 then
			arg_28_4 = arg_28_4.wielded

			Unit.flow_event(arg_28_1, "lua_wield")

			if arg_28_3.wield_anim then
				Unit.animation_event(var_28_1, arg_28_3.wield_anim)
			end
		else
			arg_28_4 = arg_28_4.unwielded

			Unit.flow_event(arg_28_1, "lua_unwield")
		end
	end

	if Unit.has_lod_object(arg_28_1, "lod") then
		local var_28_2 = Unit.lod_object(arg_28_1, "lod")

		LODObject.set_static_height(var_28_2, 1)
	end

	GearUtils.link(var_28_0, arg_28_4, arg_28_5, var_28_1, arg_28_1)

	if arg_28_6 then
		GearUtils.apply_material_settings(arg_28_1, arg_28_6)
	end
end

function DemoCharacterPreviewer.destroy(arg_29_0)
	arg_29_0:_reset_hero()

	if arg_29_0._line_object then
		World.destroy_line_object(arg_29_0._world, arg_29_0._line_object)

		arg_29_0._line_object = nil
	end
end
