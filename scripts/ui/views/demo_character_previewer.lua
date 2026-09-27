-- chunkname: @scripts/ui/views/demo_character_previewer.lua

DemoCharacterPreviewer = class(DemoCharacterPreviewer)

DemoCharacterPreviewer.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	-- function 1
	self._world = arg_1_1
	self._profile_name = arg_1_2
	self._career_index = arg_1_3
	self._position = arg_1_4 or Vector3Box(0, 0, 0)
	self._rotation = arg_1_5 or QuaternionBox(Quaternion.identity())
	self._zoom_offset = arg_1_6 or Vector3Box(Vector3.identity())
	self.item_spawn_data = {}
	self.item_names = {}
	self._packages_to_load = {}
	self._loaded_packages = {}
	self._equipment_units = {}
	self._equipment_units[InventorySettings.slots_by_name.slot_melee.slot_index] = {}
	self._equipment_units[InventorySettings.slots_by_name.slot_ranged.slot_index] = {}

	if not (BUILD == "dev" or BUILD ~= "debug") then
		self._line_object = World.create_line_object(self._world)
	end

	self:_spawn_character()
end

DemoCharacterPreviewer.reset_state = function (self)
	-- function 2
	self._is_hover = nil
	self._is_pressed = nil

	self:outline_unit(false)
end

DemoCharacterPreviewer._spawn_character = function (self, arg_3_1)
	-- function 3
	self._position = arg_3_1 or self._position

	self:_reset_hero()

	local _profile_name = self._profile_name
	local _career_index = self._career_index

	self:_spawn_hero_unit(_profile_name, _career_index)
end

DemoCharacterPreviewer._color_from_table = function (arg_4_0, arg_4_1)
	-- function 4
	return Color(arg_4_1[1], arg_4_1[2], arg_4_1[3], arg_4_1[4])
end

DemoCharacterPreviewer.outline_unit = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	if self._outlined == arg_5_1 then
		return
	end

	if not Unit.alive(self._character_unit) then
		local str = "outline_unit"
		local _character_unit = self._character_unit

		Unit.set_shader_pass_flag_for_meshes_in_unit_and_childs(_character_unit, str, arg_5_1)

		if not arg_5_1 then
			local _color_from_table = self:_color_from_table(arg_5_2.channel)
			local flag = arg_5_3 or 0

			Unit.set_color_for_materials_in_unit_and_childs(_character_unit, "outline_color", _color_from_table)
			Unit.set_scalar_for_materials_in_unit_and_childs(_character_unit, "outline_time", World.time(self._world) + flag)
		end

		self._outlined = arg_5_1
	end
end

DemoCharacterPreviewer.is_outlined = function (self)
	-- function 6
	return self._outlined
end

DemoCharacterPreviewer._reset_hero = function (self)
	-- function 7
	if not self._character_unit then
		World.destroy_unit(self._world, self._character_unit)

		self._character_unit = nil
	end

	local clone = table.clone(self._equipment_units)

	for k, v in pairs(clone) do
		if type(v) == "table" then
			if not v.left then
				World.destroy_unit(self._world, v.left)

				self._equipment_units[k].left = nil
			end

			if not v.right then
				World.destroy_unit(self._world, v.right)

				self._equipment_units[k].right = nil
			end
		else
			World.destroy_unit(self._world, v)

			self._equipment_units[k] = nil
		end
	end

	for k_2, v_2 in pairs(self._packages_to_load) do
		Managers.package:unload(k_2, "DemoCharacterPreviewer")
	end

	self._packages_to_load = {}

	for k_3, v_3 in pairs(self._loaded_packages) do
		Managers.package:unload(k_3, "DemoCharacterPreviewer")
	end

	self._loaded_packages = {}

	if not self._line_object then
		LineObject.reset(self._line_object)
		LineObject.dispatch(self._world, self._line_object)
	end
end

DemoCharacterPreviewer._spawn_hero_unit = function (self, arg_8_1, arg_8_2)
	-- function 8
	local var_8_0 = FindProfileIndex(arg_8_1)
	local var_8_1 = SPProfiles[var_8_0]
	local var_8_2 = var_8_1.careers[arg_8_2]
	local base_skin = var_8_2.base_skin
	local var_8_4 = Cosmetics[base_skin]
	local third_person = var_8_4.third_person

	if not Managers.package:has_loaded(third_person) then
		self:cb_spawn_hero_unit(var_8_1, var_8_2, var_8_4)
	else
		Managers.package:load(third_person, "DemoCharacterPreviewer", callback(self, "cb_spawn_hero_unit", var_8_1, var_8_2, var_8_4), true, true)
	end
end

DemoCharacterPreviewer.cb_spawn_hero_unit = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local _world = self._world
	local third_person = arg_9_3.third_person
	local color_tint = arg_9_3.color_tint
	local spawn_unit = World.spawn_unit(_world, third_person, self._position:unbox(), self._rotation:unbox())

	if not color_tint then
		local gradient_variation = color_tint.gradient_variation
		local gradient_value = color_tint.gradient_value

		CosmeticUtils.color_tint_unit(spawn_unit, self._profile_name, gradient_variation, gradient_value)
	end

	self._character_unit = spawn_unit

	if not Unit.has_lod_object(spawn_unit, "lod") then
		local lod_object = Unit.lod_object(spawn_unit, "lod")

		LODObject.set_static_height(lod_object, 1)
	end

	local box, var_9_8 = Unit.box(spawn_unit)

	if not var_9_8 then
		local num = 1.7
		local num_2 = var_9_8.z - num
		local flag

		flag = not (num < var_9_8.z) or not 1.5 or 0.9
		self.unit_max_look_height = flag
	else
		self.unit_max_look_height = 0.9
	end

	self:_spawn_inventory(arg_9_2)
end

DemoCharacterPreviewer.update = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	self:_update_aim_constraint(arg_10_2, arg_10_3)

	if not arg_10_1 then
		self:_update_hover(arg_10_2, arg_10_3)
		self:_update_pressed(arg_10_2, arg_10_3)
	end
end

DemoCharacterPreviewer._update_hover = function (self)
	-- function 11
	local get = Managers.input:get_service("main_menu"):get("cursor")

	if not get then
		return
	else
		local scale = RESOLUTION_LOOKUP.scale

		get.x = get.x * scale
		get.y = get.y * scale
	end

	if not Unit.alive(self._character_unit) then
		return
	end

	local viewport = ScriptWorld.viewport(self._world, "title_screen_viewport")
	local camera = ScriptViewport.camera(viewport)
	local screen_to_world = Camera.screen_to_world(camera, Vector3(get.x, get.y, 0), 0)
	local num = Camera.screen_to_world(camera, Vector3(get.x, get.y, 0), 1) - screen_to_world
	local physics_world = World.physics_world(self._world)
	local box, var_11_8 = Unit.box(self._character_unit)

	var_11_8[1] = var_11_8[1] * 0.25
	var_11_8[2] = var_11_8[2] * 0.25

	if not Intersect.ray_box(screen_to_world, num, box, var_11_8) then
		if not self._is_hover then
			Managers.music:trigger_event("Play_demo_hud_character_hover")
			self:outline_unit(true, OutlineSettings.colors.interactable)

			self._is_hover = true
		end
	else
		if not self._is_pressed then
			self:outline_unit(false, OutlineSettings.colors.interactable)
		end

		self._is_hover = false
	end
end

DemoCharacterPreviewer._update_pressed = function (self, arg_12_1, arg_12_2)
	-- function 12
	self._was_pressed_this_frame = nil

	if not Managers.input:get_service("main_menu"):get("start") then
		if not self._is_hover then
			if not self._is_pressed then
				self._is_pressed = true
				self._was_pressed_this_frame = true
				self._outlined = false

				self:outline_unit(true, OutlineSettings.colors.ally)
				Managers.music:trigger_event("Play_demo_hud_character_select")
			end
		else
			self._is_pressed = false

			self:outline_unit(false, OutlineSettings.colors.ally)
		end
	end
end

DemoCharacterPreviewer.cb_on_select_animation_complete = function (self)
	-- function 13
	local str = "j_neck"
	local _character_unit = self._character_unit

	if not Unit.alive(_character_unit) then
		local has_node = Unit.has_node(_character_unit, str)

		has_node = not has_node and Unit.node(_character_unit, str)

		local world_position = Unit.world_position(_character_unit, has_node)
		local wwise_world = Managers.world:wwise_world(self._world)
		local make_auto_source = WwiseWorld.make_auto_source(wwise_world, world_position)

		WwiseWorld.trigger_event(wwise_world, DemoSettings.play_on_select[self._profile_name], make_auto_source)
	end
end

DemoCharacterPreviewer.pressed_pose = function (self)
	-- function 14
	local viewport = ScriptWorld.viewport(self._world, "title_screen_viewport")
	local camera = ScriptViewport.camera(viewport)
	local rotation = ScriptCamera.rotation(camera)
	local flat = Vector3.flat(Quaternion.forward(rotation))
	local flat_2 = Vector3.flat(Quaternion.right(rotation))
	local look = Quaternion.look(flat, Vector3.up())
	local str = "j_neck"
	local _character_unit = self._character_unit
	local has_node = Unit.has_node(_character_unit, str)

	has_node = not has_node and Unit.node(_character_unit, str)

	local world_position = Unit.world_position(_character_unit, has_node)
	local unbox = self._zoom_offset:unbox()
	local num = world_position + flat_2 * unbox[1] + flat * unbox[2] + Vector3.up() * unbox[3]

	return Matrix4x4Box(Matrix4x4.from_quaternion_position(rotation, num))
end

DemoCharacterPreviewer._update_aim_constraint = function (self, arg_15_1, arg_15_2)
	-- function 15
	if not Unit.alive(self._character_unit) then
		return
	end

	local viewport = ScriptWorld.viewport(self._world, "title_screen_viewport")
	local camera = ScriptViewport.camera(viewport)
	local position = ScriptCamera.position(camera)
	local _character_unit = self._character_unit
	local animation_find_constraint_target = Unit.animation_find_constraint_target(_character_unit, "aim_constraint_target")

	Unit.animation_set_constraint_target(_character_unit, animation_find_constraint_target, position)
end

DemoCharacterPreviewer.is_hover = function (self)
	-- function 16
	return self._is_hover
end

DemoCharacterPreviewer.is_pressed = function (self)
	-- function 17
	return self._is_pressed
end

DemoCharacterPreviewer.was_pressed_this_frame = function (self)
	-- function 18
	local _was_pressed_this_frame = self._was_pressed_this_frame

	self._was_pressed_this_frame = nil

	return _was_pressed_this_frame
end

DemoCharacterPreviewer.profile_information = function (self)
	-- function 19
	return self._profile_name, self._career_index
end

DemoCharacterPreviewer._spawn_inventory = function (self, arg_20_1)
	-- function 20
	local preview_animation = arg_20_1.preview_animation
	local preview_wield_slot = arg_20_1.preview_wield_slot
	local preview_items = arg_20_1.preview_items

	if not preview_items then
		for i, v in ipairs(preview_items) do
			local item_name = v.item_name
			local slot_type = ItemMasterList[item_name].slot_type
			local var_20_5 = InventorySettings.slot_names_by_type[slot_type][1]
			local var_20_6 = InventorySettings.slots_by_name[var_20_5]

			self:_equip_item(item_name, var_20_6)
		end

		if not preview_wield_slot then
			self:wield_weapon_slot(preview_wield_slot)
		end
	end

	if not preview_animation then
		self:play_character_animation(preview_animation)
	end

	self._character_spawned = true
end

DemoCharacterPreviewer.character_spawned = function (self)
	-- function 21
	return self._character_spawned
end

DemoCharacterPreviewer.wield_weapon_slot = function (self, arg_22_1)
	-- function 22
	self._wielded_slot_type = arg_22_1

	if not self.item_names.melee then
		self:_equip_item(self.item_names.melee, InventorySettings.slots_by_name.slot_melee)
	end

	if not self.item_names.ranged then
		self:_equip_item(self.item_names.ranged, InventorySettings.slots_by_name.slot_ranged)
	end
end

DemoCharacterPreviewer.play_character_animation = function (self, arg_23_1)
	-- function 23
	local _character_unit = self._character_unit

	if _character_unit == nil then
		return
	end

	Unit.animation_event(_character_unit, arg_23_1)
end

DemoCharacterPreviewer._equip_item = function (self, arg_24_1, arg_24_2)
	-- function 24
	self.items_loaded = nil

	local type = arg_24_2.type
	local slot_index = arg_24_2.slot_index
	local var_24_2 = ItemMasterList[arg_24_1]
	local get_item_units = BackendUtils.get_item_units(var_24_2)
	local get_template_by_item_name = ItemHelper.get_template_by_item_name(arg_24_1)
	local tbl = {}
	local tbl_2 = {}

	if not (type == "melee" or type ~= "ranged") then
		local left_hand_unit = get_item_units.left_hand_unit
		local right_hand_unit = get_item_units.right_hand_unit
		local material_settings_name = get_item_units.material_settings_name
		local flag = right_hand_unit == nil or left_hand_unit == nil

		if not left_hand_unit then
			local str = left_hand_unit .. "_3p"

			tbl[#tbl + 1] = {
				left_hand = true,
				despawn_both_hands_units = flag,
				unit_name = str,
				item_slot_type = type,
				slot_index = slot_index,
				unit_attachment_node_linking = get_template_by_item_name.left_hand_attachment_node_linking.third_person,
				material_settings_name = material_settings_name
			}
			tbl_2[#tbl_2 + 1] = str
		end

		if not right_hand_unit then
			local str_2 = right_hand_unit .. "_3p"

			tbl[#tbl + 1] = {
				right_hand = true,
				despawn_both_hands_units = flag,
				unit_name = str_2,
				item_slot_type = type,
				slot_index = slot_index,
				unit_attachment_node_linking = get_template_by_item_name.right_hand_attachment_node_linking.third_person,
				material_settings_name = material_settings_name
			}

			if right_hand_unit ~= left_hand_unit then
				tbl_2[#tbl_2 + 1] = str_2
			end
		end
	elseif type == "hat" then
		local unit = get_item_units.unit

		if not unit then
			local num = 3

			if type == "hat" then
				num = 1
			end

			local var_24_15 = get_template_by_item_name.slots[num]

			tbl[#tbl + 1] = {
				unit_name = unit,
				item_slot_type = type,
				slot_index = slot_index,
				unit_attachment_node_linking = get_template_by_item_name.attachment_node_linking[var_24_15]
			}
			tbl_2[#tbl_2 + 1] = unit
		end
	end

	if #tbl_2 > 0 then
		self.item_spawn_data[arg_24_1] = tbl
		self.item_names[type] = arg_24_1

		self:load_package(tbl_2, arg_24_1)
	end
end

DemoCharacterPreviewer.load_package = function (self, arg_25_1, arg_25_2)
	-- function 25
	local tbl = {}

	for i, v in ipairs(arg_25_1) do
		if not self._packages_to_load[v] then
			self._packages_to_load[v] = true
			tbl[#tbl + 1] = v
		end
	end

	for i_2, v_2 in ipairs(tbl) do
		local package = Managers.package
		local var_25_2 = callback(self, "on_load_complete", v_2, arg_25_2)

		package:load(v_2, "DemoCharacterPreviewer", var_25_2, true, true)
	end
end

DemoCharacterPreviewer.on_load_complete = function (self, arg_26_1, arg_26_2)
	-- function 26
	local _loaded_packages = self._loaded_packages

	_loaded_packages[arg_26_1] = true
	self._packages_to_load[arg_26_1] = nil

	local item_names = self.item_names
	local var_26_2 = self.item_spawn_data[arg_26_2]

	for i, v in ipairs(var_26_2) do
		if item_names[v.item_slot_type] ~= arg_26_2 then
			return
		end

		if not _loaded_packages[v.unit_name] then
			return
		end
	end

	self:_spawn_item(arg_26_2)
end

DemoCharacterPreviewer._spawn_item = function (self, arg_27_1)
	-- function 27
	local _world = self._world
	local _character_unit = self._character_unit
	local tbl = {}
	local var_27_3 = ItemMasterList[arg_27_1]
	local get_item_units = BackendUtils.get_item_units(var_27_3)
	local get_template_by_item_name = ItemHelper.get_template_by_item_name(arg_27_1)
	local var_27_6 = self.item_spawn_data[arg_27_1]

	if not var_27_6 then
		for i, v in ipairs(var_27_6) do
			local unit_name = v.unit_name
			local item_slot_type = v.item_slot_type
			local slot_index = v.slot_index
			local unit_attachment_node_linking = v.unit_attachment_node_linking
			local material_settings_name = v.material_settings_name

			if not (item_slot_type == "melee" or item_slot_type ~= "ranged") then
				if v.right_hand or not v.despawn_both_hands_units then
					local right = self._equipment_units[slot_index].right

					if right ~= nil then
						World.destroy_unit(_world, right)

						self._equipment_units[slot_index].right = nil
					end
				end

				if v.left_hand or not v.despawn_both_hands_units then
					local left = self._equipment_units[slot_index].left

					if left ~= nil then
						World.destroy_unit(_world, left)

						self._equipment_units[slot_index].left = nil
					end
				end

				local spawn_unit = World.spawn_unit(_world, unit_name)

				self:equip_item_unit(spawn_unit, item_slot_type, get_template_by_item_name, unit_attachment_node_linking, tbl, material_settings_name)

				if not v.right_hand then
					self._equipment_units[slot_index].right = spawn_unit
				elseif not v.left_hand then
					self._equipment_units[slot_index].left = spawn_unit
				end
			else
				local var_27_15 = self._equipment_units[slot_index]

				if var_27_15 ~= nil then
					World.destroy_unit(_world, var_27_15)

					self._equipment_units[slot_index] = nil
				end

				local spawn_unit_2 = World.spawn_unit(_world, unit_name)

				self._equipment_units[slot_index] = spawn_unit_2

				self:equip_item_unit(spawn_unit_2, item_slot_type, get_template_by_item_name, unit_attachment_node_linking, tbl)
			end

			local show_attachments_event = get_template_by_item_name.show_attachments_event

			if not show_attachments_event then
				Unit.flow_event(_character_unit, show_attachments_event)
			end
		end
	end
end

DemoCharacterPreviewer.equip_item_unit = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6)
	-- function 28
	local _world = self._world
	local _character_unit = self._character_unit

	if not (arg_28_2 == "melee" or arg_28_2 ~= "ranged") then
		if self._wielded_slot_type == arg_28_2 then
			arg_28_4 = arg_28_4.wielded

			Unit.flow_event(arg_28_1, "lua_wield")

			if not arg_28_3.wield_anim then
				Unit.animation_event(_character_unit, arg_28_3.wield_anim)
			end
		else
			arg_28_4 = arg_28_4.unwielded

			Unit.flow_event(arg_28_1, "lua_unwield")
		end
	end

	if not Unit.has_lod_object(arg_28_1, "lod") then
		local lod_object = Unit.lod_object(arg_28_1, "lod")

		LODObject.set_static_height(lod_object, 1)
	end

	GearUtils.link(_world, arg_28_4, arg_28_5, _character_unit, arg_28_1)

	if not arg_28_6 then
		GearUtils.apply_material_settings(arg_28_1, arg_28_6)
	end
end

DemoCharacterPreviewer.destroy = function (self)
	-- function 29
	self:_reset_hero()

	if not self._line_object then
		World.destroy_line_object(self._world, self._line_object)

		self._line_object = nil
	end
end
