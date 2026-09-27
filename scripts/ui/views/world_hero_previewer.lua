-- chunkname: @scripts/ui/views/world_hero_previewer.lua

HeroPreviewer = class(HeroPreviewer)

HeroPreviewer.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.profile_synchronizer = arg_1_1.profile_synchronizer
	self.character_unit = nil
	self.mesh_unit = nil
	self.world = nil
	self._item_info_by_slot = {}
	self._props_data = {}
	self._equipment_units = {}
	self._hidden_units = {}
	self._delayed_material_changes = {}
	self.character_location = {
		0,
		0,
		0
	}
	self.character_look_target = {
		0,
		3,
		1
	}
	self.character_rotation = 0
	self.unique_id = arg_1_2
	self._session_id = 0
	self._requested_mip_streaming_units = {}
	self._delayed_spawn = arg_1_3
	self._activated = not arg_1_3
	self._loading_done = false
	self._delayed_pose_animation = false
	self._equipment_units[InventorySettings.slots_by_name.slot_melee.slot_index] = {}
	self._equipment_units[InventorySettings.slots_by_name.slot_ranged.slot_index] = {}
end

HeroPreviewer.activate = function (self, arg_2_1, arg_2_2)
	-- function 2
	if not self._delayed_spawn then
		return
	end

	if arg_2_1 == self._activated then
		return
	end

	if not arg_2_1 then
		self:on_enter(arg_2_2)
	else
		self.world = nil
	end

	self._activated = arg_2_1
end

HeroPreviewer.destroy = function (self)
	-- function 3
	self._session_id = self._session_id + 1

	GarbageLeakDetector.register_object(self, "HeroPreviewer")
end

local tbl = {}

HeroPreviewer.on_enter = function (self, arg_4_1)
	-- function 4
	table.clear(self._requested_mip_streaming_units)
	table.clear(self._hidden_units)

	self.world = arg_4_1

	Application.set_render_setting("max_shadow_casting_lights", 16)

	local _session_id = self._session_id

	_session_id = _session_id or 0
	self._session_id = _session_id

	if not self._delayed_spawn then
		local _delayed_hero_spawn_data = self._delayed_hero_spawn_data

		_delayed_hero_spawn_data = _delayed_hero_spawn_data or tbl
		self._requested_hero_spawn_data = _delayed_hero_spawn_data
	end
end

HeroPreviewer.prepare_exit = function (self)
	-- function 5
	self:clear_units()
end

HeroPreviewer.on_exit = function (self)
	-- function 6
	self:_unload_all_packages()

	self._hero_loading_package_data = nil

	local user_setting = Application.user_setting("render_settings", "max_shadow_casting_lights")

	Application.set_render_setting("max_shadow_casting_lights", user_setting)

	self._session_id = self._session_id + 1
end

HeroPreviewer.update = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

HeroPreviewer.post_update = function (self, arg_8_1, arg_8_2)
	-- function 8
	self:_update_units_visibility(arg_8_1)
	self:_update_lerped_location(arg_8_2)
	self:_handle_hero_spawn_request()
	self:_poll_hero_package_loading()
	self:_poll_item_package_loading()
	self:_update_delayed_material_changes()
end

HeroPreviewer._update_lerped_location = function (self, arg_9_1)
	-- function 9
	if not self._character_destination_location then
		return
	end

	if arg_9_1 < self._lerp_end_time then
		local num = 1 - (self._lerp_end_time - arg_9_1) / self._lerp_time
		local easeOutCubic = math.easeOutCubic(num)
		local lerp = math.lerp(self.character_location[1], self._character_destination_location[1], easeOutCubic)
		local lerp_2 = math.lerp(self.character_location[2], self._character_destination_location[2], easeOutCubic)
		local lerp_3 = math.lerp(self.character_location[3], self._character_destination_location[3], easeOutCubic)
		local character_unit = self.character_unit

		if not character_unit and not Unit.alive(character_unit) then
			Unit.set_local_position(character_unit, 0, Vector3(lerp, lerp_2, lerp_3))
		end
	else
		self.character_location = self._character_destination_location
		self._character_destination_location = nil
		self._lerp_time = nil
		self._lerp_end_time = nil
	end
end

HeroPreviewer._update_unit_mip_streaming = function (self)
	-- function 10
	local flag = true
	local num = 0
	local _requested_mip_streaming_units = self._requested_mip_streaming_units

	for k, v in pairs(_requested_mip_streaming_units) do
		if not Renderer.is_all_mips_loaded_for_unit(k) then
			_requested_mip_streaming_units[k] = nil
		else
			flag = false
		end

		num = num + 1
	end

	if not flag then
		return true
	elseif num > 0 then
		Renderer.set_automatic_streaming(true)
	end
end

HeroPreviewer._update_delayed_material_changes = function (self)
	-- function 11
	if not self._activated then
		return
	end

	local character_unit = self.character_unit
	local mesh_unit = self.mesh_unit

	if not Unit.alive(character_unit) then
		return
	end

	if not self._delayed_material_changes[character_unit] and not self.character_unit_hidden_after_spawn then
		return
	end

	local flag = false
	local var_11_3 = self._delayed_material_changes[character_unit]

	for i = 1, #var_11_3 do
		local var_11_4 = var_11_3[i]

		for k, v in pairs(var_11_4) do
			Unit.set_material(mesh_unit, k, v)

			flag = true
		end
	end

	if not flag and self._use_highest_mip_levels and not UISettings.wait_for_mip_streaming_character then
		self:_request_mip_streaming_for_unit(character_unit)
	end

	self._delayed_material_changes[character_unit] = nil
end

HeroPreviewer._request_mip_streaming_for_unit = function (self, arg_12_1)
	-- function 12
	local _requested_mip_streaming_units = self._requested_mip_streaming_units

	_requested_mip_streaming_units[arg_12_1] = true

	Renderer.set_automatic_streaming(false)

	for k, v in pairs(_requested_mip_streaming_units) do
		Renderer.request_to_stream_all_mips_for_unit(k)
	end
end

HeroPreviewer._update_units_visibility = function (self, arg_13_1)
	-- function 13
	if not self._activated then
		return
	end

	if not self:_is_all_items_loaded() then
		return
	end

	if not self:_update_unit_mip_streaming() then
		return
	end

	local character_unit = self.character_unit

	if not Unit.alive(character_unit) then
		return
	end

	if not self._stored_character_animation then
		local flag = true

		self:play_character_animation(self._stored_character_animation, flag)

		self._stored_character_animation = nil

		return
	end

	if not self.character_unit_hidden_after_spawn then
		self.character_unit_hidden_after_spawn = false

		if not Unit.has_animation_state_machine(self.mesh_unit) and not Unit.has_animation_event(self.mesh_unit, "enable") then
			Unit.animation_event(self.mesh_unit, "enable")
		end

		if self._draw_character == false then
			self:_set_character_visibility(false)
		else
			self:_set_character_visibility(true)
		end
	end

	if not (not self._draw_character and table.is_empty(self._hidden_units)) then
		for k, v in pairs(self._hidden_units) do
			if not Unit.alive(k) then
				Unit.set_unit_visibility(k, true)
			end

			self._hidden_units[k] = nil
		end

		self:_trigger_equip_events()
	end

	if not self._draw_character then
		for k_2, v_2 in pairs(self._props_data) do
			if v_2.visible or not v_2.unit then
				v_2.visible = true

				Unit.set_unit_visibility(v_2.unit, true)

				local settings = v_2.settings

				if not settings.animation_event then
					Unit.animation_event(v_2.unit, settings.animation_event)
				end

				if not settings.spawn_callback then
					settings.spawn_callback(v_2.unit)
				end
			end
		end
	end

	self._loading_done = true
end

HeroPreviewer.loading_done = function (self)
	-- function 14
	return self._loading_done
end

HeroPreviewer._set_character_visibility = function (self, arg_15_1)
	-- function 15
	self._draw_character = arg_15_1

	if not self.character_unit_hidden_after_spawn then
		return
	end

	local character_unit = self.character_unit
	local mesh_unit = self.mesh_unit

	if not Unit.alive(mesh_unit) then
		Unit.set_unit_visibility(mesh_unit, arg_15_1)

		local slots_by_slot_index = InventorySettings.slots_by_slot_index
		local flag

		flag = not arg_15_1 and "lua_attachment_unhidden" and "lua_attachment_hidden"

		Unit.flow_event(mesh_unit, flag)

		local flag_2

		flag_2 = not arg_15_1 and "lua_ui_vfx_unhidden" and "lua_ui_vfx_hidden"

		Unit.flow_event(mesh_unit, flag_2)

		local _equipment_units = self._equipment_units

		for k, v in pairs(_equipment_units) do
			local var_15_6 = slots_by_slot_index[k]
			local category = var_15_6.category
			local type = var_15_6.type
			local flag_3 = category == "weapon"
			local var_15_10

			if not flag_3 then
				var_15_10 = not arg_15_1 and type == self._wielded_slot_type
			else
				var_15_10 = arg_15_1
			end

			local flag_4

			flag_4 = not var_15_10 and "lua_wield" and "lua_unwield"

			if type(v) == "table" then
				local left = v.left
				local right = v.right

				if not Unit.alive(left) then
					Unit.flow_event(left, flag_4)
					Unit.set_unit_visibility(left, var_15_10)

					self._hidden_units[left] = nil
				end

				if not Unit.alive(right) then
					Unit.flow_event(right, flag_4)
					Unit.set_unit_visibility(right, var_15_10)

					self._hidden_units[right] = nil
				end
			elseif not Unit.alive(v) then
				if not flag_3 then
					local flag_5

					flag_5 = not var_15_10 and "lua_attachment_unhidden" and "lua_attachment_hidden"

					Unit.flow_event(v, flag_5)
				end

				Unit.flow_event(v, flag_4)
				Unit.set_unit_visibility(v, var_15_10)

				if type == "hat" then
					local equip_hat_event = self.character_unit_skin_data.equip_hat_event

					equip_hat_event = equip_hat_event or "using_skin_default"

					if not equip_hat_event then
						Unit.flow_event(v, equip_hat_event)
					end
				end

				self._hidden_units[v] = nil
			end
		end

		if not arg_15_1 then
			local character_unit_skin_data = self.character_unit_skin_data
			local material_changes = character_unit_skin_data.material_changes
			local equip_skin_event = character_unit_skin_data.equip_skin_event

			equip_skin_event = equip_skin_event or "using_skin_default"

			Unit.flow_event(character_unit, equip_skin_event)

			if not material_changes then
				local third_person = material_changes.third_person

				for k_2, v_2 in pairs(third_person) do
					Unit.set_material(mesh_unit, k_2, v_2)
				end
			end

			for k_3, v_3 in pairs(self._item_info_by_slot) do
				if not v_3.loaded then
					local name = v_3.name
					local show_attachments_event = ItemHelper.get_template_by_item_name(name).show_attachments_event

					if not show_attachments_event then
						Unit.flow_event(mesh_unit, show_attachments_event)
						Unit.flow_event(character_unit, show_attachments_event)
					end
				end
			end
		end

		self.character_unit_visible = arg_15_1
	end
end

HeroPreviewer.character_visible = function (self)
	-- function 16
	local character_unit_visible = self.character_unit_visible

	character_unit_visible = not character_unit_visible and Unit.alive(self.character_unit)

	return character_unit_visible
end

HeroPreviewer.play_character_animation = function (self, arg_17_1, arg_17_2)
	-- function 17
	local character_unit = self.character_unit

	if character_unit == nil then
		return
	end

	if not (self.character_unit_visible or arg_17_2) then
		self._stored_character_animation = arg_17_1
	else
		Unit.animation_event(character_unit, arg_17_1)
	end
end

HeroPreviewer.clear_asynchronous_data = function (self)
	-- function 18
	self._delayed_pose_animation = false
	self._pose_animation_event = nil
end

HeroPreviewer.request_spawn_hero_unit = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	-- function 19
	self:clear_asynchronous_data()

	self._requested_hero_spawn_data = {
		frame_delay = 1,
		profile_name = arg_19_1,
		career_index = arg_19_2,
		callback = arg_19_3,
		optional_skin = arg_19_4,
		optional_breed = arg_19_5
	}

	if not self._delayed_spawn then
		self._delayed_hero_spawn_data = table.clone(self._requested_hero_spawn_data)
	end

	self:clear_units()
end

HeroPreviewer._handle_hero_spawn_request = function (self)
	-- function 20
	if not self._requested_hero_spawn_data then
		local _requested_hero_spawn_data = self._requested_hero_spawn_data
		local frame_delay = _requested_hero_spawn_data.frame_delay

		if frame_delay == 0 then
			local profile_name = _requested_hero_spawn_data.profile_name
			local career_index = _requested_hero_spawn_data.career_index
			local callback = _requested_hero_spawn_data.callback
			local optional_skin = _requested_hero_spawn_data.optional_skin
			local optional_breed = _requested_hero_spawn_data.optional_breed

			self:_load_hero_unit(profile_name, career_index, callback, optional_skin, nil, optional_breed)

			self._requested_hero_spawn_data = nil
		else
			_requested_hero_spawn_data.frame_delay = frame_delay - 1
		end
	end
end

HeroPreviewer._load_hero_unit = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6)
	-- function 21
	self:_unload_all_packages()

	local name

	if not arg_21_6 then
		name = arg_21_6.name

		if not name then
			-- Nothing
		end
	end

	name = arg_21_1

	::label_21_0::

	self._current_profile_name = name

	local var_21_1 = FindProfileIndex(arg_21_1)
	local var_21_2 = SPProfiles[var_21_1].careers[arg_21_2]
	local name_2 = var_21_2.name
	local get_loadout_item = BackendUtils.get_loadout_item(name_2, "slot_skin")
	local flag = not get_loadout_item and get_loadout_item.data

	if not arg_21_4 then
		-- Nothing
	end

	do
		local name_3
	end

	::label_21_1::

	if not flag then
		name_3 = flag.name

		if not name_3 then
			-- Nothing
		end
	end

	name_3 = var_21_2.base_skin

	::label_21_2::

	GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", name_2 == "bw_necromancer")

	self._current_career_name = name_2
	self.character_unit_skin_data = nil

	local retrieve_skin_packages_for_preview = CosmeticsUtils.retrieve_skin_packages_for_preview(name_3)
	local var_21_8 = Cosmetics[name_3]

	self._hero_loading_package_data = {
		num_loaded_packages = 0,
		career_name = name_2,
		skin_data = var_21_8,
		career_index = arg_21_2,
		optional_scale = arg_21_5,
		package_names = retrieve_skin_packages_for_preview,
		num_packages = #retrieve_skin_packages_for_preview,
		callback = arg_21_3
	}, self:_load_packages(retrieve_skin_packages_for_preview)
end

HeroPreviewer._poll_hero_package_loading = function (self)
	-- function 22
	local _hero_loading_package_data = self._hero_loading_package_data

	if not _hero_loading_package_data and not _hero_loading_package_data.loaded then
		return
	end

	if not self._requested_hero_spawn_data then
		return
	end

	local _reference_name = self:_reference_name()
	local package = Managers.package
	local package_names = _hero_loading_package_data.package_names
	local flag = true

	for i = 1, #package_names do
		local var_22_5 = package_names[i]

		if not package:has_loaded(var_22_5, _reference_name) then
			flag = false

			break
		end
	end

	if not flag and not self._activated then
		local skin_data = _hero_loading_package_data.skin_data
		local optional_scale = _hero_loading_package_data.optional_scale
		local career_index = _hero_loading_package_data.career_index

		self:_spawn_hero_unit(skin_data, optional_scale, career_index)

		local callback = _hero_loading_package_data.callback

		if not callback then
			callback()
		end

		_hero_loading_package_data.loaded = true
	end
end

HeroPreviewer._spawn_hero_unit = function (self, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	local world = self.world
	local third_person = arg_23_1.third_person
	local unit = arg_23_1.third_person_attachment.unit
	local attachment_node_linking = arg_23_1.third_person_attachment.attachment_node_linking
	local spawn_unit = World.spawn_unit(world, third_person, Vector3Aux.unbox(self.character_location), Quaternion.axis_angle(Vector3.up(), self.character_rotation))
	local spawn_unit_2 = World.spawn_unit(world, unit, Vector3Aux.unbox(self.character_location), Quaternion.axis_angle(Vector3.up(), self.character_rotation))

	Unit.set_flow_variable(spawn_unit, "lua_third_person_mesh_unit", spawn_unit_2)
	AttachmentUtils.link(world, spawn_unit, spawn_unit_2, attachment_node_linking)

	local material_changes = arg_23_1.material_changes

	if not material_changes then
		local third_person_2 = material_changes.third_person

		for k, v in pairs(third_person_2) do
			Unit.set_material(spawn_unit_2, k, v)
		end
	end

	local material_settings_name = arg_23_1.material_settings_name

	if not material_settings_name then
		CosmeticUtils.apply_material_settings(spawn_unit_2, material_settings_name)
	end

	local color_tint = arg_23_1.color_tint

	if not color_tint then
		local gradient_variation = color_tint.gradient_variation
		local gradient_value = color_tint.gradient_value

		CosmeticUtils.color_tint_unit(spawn_unit_2, self._current_profile_name, gradient_variation, gradient_value)
	end

	Unit.set_unit_visibility(spawn_unit_2, false)

	self.character_unit = spawn_unit
	self.mesh_unit = spawn_unit_2
	self.character_unit_hidden_after_spawn = true
	self.character_unit_visible = false
	self.character_unit_skin_data = arg_23_1
	self._stored_character_animation = nil

	if not Unit.has_lod_object(spawn_unit_2, "lod") then
		local lod_object = Unit.lod_object(spawn_unit_2, "lod")

		LODObject.set_static_height(lod_object, 1)
	end

	local unbox = Vector3Aux.unbox(self.character_look_target)
	local animation_find_constraint_target = Unit.animation_find_constraint_target(spawn_unit, "aim_constraint_target")

	Unit.animation_set_constraint_target(spawn_unit, animation_find_constraint_target, unbox)

	local box, var_23_16 = Unit.box(spawn_unit)

	if not var_23_16 then
		local flag

		flag = not (1.7 < var_23_16.z) or not 1.5 or 0.9
		self.unit_max_look_height = flag
	else
		self.unit_max_look_height = 0.9
	end

	if not arg_23_2 then
		local var_23_18 = Vector3(arg_23_2, arg_23_2, arg_23_2)

		Unit.set_local_scale(spawn_unit, 0, var_23_18)
	end

	if not Unit.animation_has_variable(spawn_unit, "career_index") then
		local animation_find_variable = Unit.animation_find_variable(spawn_unit, "career_index")

		Unit.animation_set_variable(spawn_unit, animation_find_variable, arg_23_3)
	end
end

HeroPreviewer.respawn_hero_unit = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	self:request_spawn_hero_unit(arg_24_1, arg_24_2, arg_24_3, nil, nil)
end

HeroPreviewer.get_equipped_item_info = function (self, arg_25_1)
	-- function 25
	local type = arg_25_1.type

	return self._item_info_by_slot[type]
end

HeroPreviewer.spawn_all_props = function (self, arg_26_1)
	-- function 26
	for k, v in pairs(arg_26_1) do
		self:spawn_prop(v)
	end
end

HeroPreviewer.spawn_prop = function (self, arg_27_1)
	-- function 27
	self._props_data[#self._props_data + 1] = {
		visible = false,
		loaded = false,
		settings = arg_27_1
	}

	self:_load_packages(arg_27_1.package_names)
end

HeroPreviewer.equip_item = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	-- function 28
	local character_unit_skin_data = self.character_unit_skin_data

	if not character_unit_skin_data and not character_unit_skin_data.always_hide_attachment_slots then
		local flag = false

		for i, v in ipairs(character_unit_skin_data.always_hide_attachment_slots) do
			if arg_28_2.name == v then
				printf("[HeroPreviewer]:equip_item() - Skipping equipping of item(%s), because equipped skin(%s) wants to hide it", arg_28_1, character_unit_skin_data.name)

				flag = true

				break
			end
		end

		if not flag then
			return
		end
	end

	self._loading_done = false

	local type = arg_28_2.type
	local slot_index = arg_28_2.slot_index
	local var_28_4 = ItemMasterList[arg_28_1]
	local get_item_units = BackendUtils.get_item_units(var_28_4, arg_28_3, arg_28_4, self._current_career_name)
	local get_template_by_item_name = ItemHelper.get_template_by_item_name(arg_28_1)
	local tbl = {}
	local tbl_2 = {}

	if not (type == "melee" or type ~= "ranged") then
		local left_hand_unit = get_item_units.left_hand_unit
		local right_hand_unit = get_item_units.right_hand_unit
		local material_settings_name = get_item_units.material_settings_name
		local flag_2 = right_hand_unit == nil or left_hand_unit == nil

		if not left_hand_unit then
			local third_person = get_template_by_item_name.left_hand_attachment_node_linking.third_person

			if not get_item_units.is_ammo_weapon then
				left_hand_unit = get_item_units.ammo_unit
				third_person = get_template_by_item_name.ammo_data.ammo_unit_attachment_node_linking.third_person
			end

			local str = left_hand_unit .. "_3p"

			tbl[#tbl + 1] = {
				left_hand = true,
				despawn_both_hands_units = flag_2,
				unit_name = str,
				item_slot_type = type,
				slot_index = slot_index,
				unit_attachment_node_linking = third_person,
				material_settings_name = material_settings_name,
				is_ammo_unit = get_item_units.ammo_unit ~= nil,
				skip_wield_anim = arg_28_5
			}
			tbl_2[#tbl_2 + 1] = str
		end

		if not right_hand_unit then
			local third_person_2 = get_template_by_item_name.right_hand_attachment_node_linking.third_person

			if not get_item_units.is_ammo_weapon then
				right_hand_unit = get_item_units.ammo_unit
				third_person_2 = get_template_by_item_name.right_hand_attachment_node_linking.third_person
			end

			local str_2 = right_hand_unit .. "_3p"

			tbl[#tbl + 1] = {
				right_hand = true,
				despawn_both_hands_units = flag_2,
				unit_name = str_2,
				item_slot_type = type,
				slot_index = slot_index,
				unit_attachment_node_linking = third_person_2,
				material_settings_name = material_settings_name,
				is_ammo_unit = get_item_units.ammo_unit ~= nil,
				skip_wield_anim = arg_28_5
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

			local var_28_19 = get_template_by_item_name.slots[num]
			local character_material_changes = get_template_by_item_name.character_material_changes

			tbl[#tbl + 1] = {
				unit_name = unit,
				item_slot_type = type,
				slot_index = slot_index,
				unit_attachment_node_linking = get_template_by_item_name.attachment_node_linking[var_28_19],
				character_material_changes = character_material_changes
			}
			tbl_2[#tbl_2 + 1] = unit

			if not character_material_changes then
				tbl_2[#tbl_2 + 1] = character_material_changes.package_name
			end
		end
	end

	if #tbl_2 > 0 then
		local _item_info_by_slot = self._item_info_by_slot

		if not _item_info_by_slot[type] then
			self:_destroy_item_units_by_slot(type)
			self:_unload_item_packages_by_slot(type)
		end

		_item_info_by_slot[type] = {
			name = arg_28_1,
			backend_id = arg_28_3,
			skin_name = arg_28_4,
			package_names = tbl_2,
			spawn_data = tbl
		}

		self:_load_packages(tbl_2)
	end
end

HeroPreviewer._poll_item_package_loading = function (self)
	-- function 29
	local character_unit = self.character_unit

	if not Unit.alive(character_unit) then
		return
	end

	if not self._requested_hero_spawn_data then
		return
	end

	local _reference_name = self:_reference_name()
	local package = Managers.package

	for k, v in pairs(self._props_data) do
		if not v.loaded then
			local package_names = v.settings.package_names
			local flag = true

			for k_2 = 1, #package_names do
				if not package:has_loaded(package_names[k_2], _reference_name) then
					flag = false

					break
				end
			end

			if not flag and not self._activated then
				v.loaded = true

				self:_spawn_prop(v)
			end
		end
	end

	local _item_info_by_slot = self._item_info_by_slot
	local flag_2 = true

	for k_3, v_2 in pairs(_item_info_by_slot) do
		if not v_2.loaded then
			local package_names_2 = v_2.package_names
			local flag_3 = true

			for i5 = 1, #package_names_2 do
				local var_29_9 = package_names_2[i5]

				if not package:has_loaded(var_29_9, _reference_name) then
					flag_3 = false

					break
				end
			end

			if not flag_3 and not self._activated then
				v_2.loaded = true

				local name = v_2.name
				local spawn_data = v_2.spawn_data

				self:_spawn_item(name, spawn_data)
			else
				flag_2 = false
			end
		end
	end

	if not flag_2 and not self._delayed_pose_animation then
		self:trigger_pose_animation()
	end
end

HeroPreviewer._is_all_items_loaded = function (self)
	-- function 30
	local _item_info_by_slot = self._item_info_by_slot
	local flag = true

	for k, v in pairs(_item_info_by_slot) do
		if not v.loaded then
			flag = false

			break
		end
	end

	return flag
end

HeroPreviewer._spawn_prop = function (self, arg_31_1)
	-- function 31
	local settings = arg_31_1.settings
	local world = self.world
	local spawn_unit = World.spawn_unit(world, settings.unit_name)

	if not Unit.has_lod_object(spawn_unit, "lod") then
		local lod_object = Unit.lod_object(spawn_unit, "lod")

		LODObject.set_static_height(lod_object, 1)
	end

	arg_31_1.unit = spawn_unit

	local offset = settings.offset

	Unit.set_local_position(spawn_unit, 0, Vector3(offset[1], offset[2], offset[3]))
	Unit.set_unit_visibility(spawn_unit, false)
end

HeroPreviewer._spawn_item = function (self, arg_32_1, arg_32_2)
	-- function 32
	local world = self.world
	local character_unit = self.character_unit
	local mesh_unit = self.mesh_unit
	local tbl = {}
	local get_template_by_item_name = ItemHelper.get_template_by_item_name(arg_32_1)
	local flag = false
	local flag_2 = false
	local tbl_2 = {}

	for i, v in ipairs(arg_32_2) do
		local unit_name = v.unit_name
		local item_slot_type = v.item_slot_type
		local slot_index = v.slot_index
		local unit_attachment_node_linking = v.unit_attachment_node_linking
		local character_material_changes = v.character_material_changes
		local material_settings_name = v.material_settings_name
		local skip_wield_anim = v.skip_wield_anim

		if not (item_slot_type == "melee" or item_slot_type ~= "ranged") then
			local spawn_unit = World.spawn_unit(world, unit_name)

			self:_spawn_item_unit(spawn_unit, item_slot_type, get_template_by_item_name, unit_attachment_node_linking, tbl, material_settings_name, skip_wield_anim)

			local flag_3 = self._wielded_slot_type == item_slot_type

			if not v.right_hand then
				self._equipment_units[slot_index].right = spawn_unit

				if not flag_3 then
					if not v.is_ammo_unit then
						tbl_2.right_hand_ammo_unit_3p = spawn_unit
					else
						tbl_2.right_hand_wielded_unit_3p = spawn_unit
					end

					flag_2 = true
				end
			elseif not v.left_hand then
				self._equipment_units[slot_index].left = spawn_unit

				if not flag_3 then
					if not v.is_ammo_unit then
						tbl_2.left_hand_ammo_unit_3p = spawn_unit
					else
						tbl_2.left_hand_wielded_unit_3p = spawn_unit
					end

					flag_2 = true
				end
			end
		else
			local spawn_unit_2 = World.spawn_unit(world, unit_name)

			self._equipment_units[slot_index] = spawn_unit_2

			self:_spawn_item_unit(spawn_unit_2, item_slot_type, get_template_by_item_name, unit_attachment_node_linking, tbl, nil, skip_wield_anim)
		end

		local show_attachments_event = get_template_by_item_name.show_attachments_event

		if not show_attachments_event and not self.character_unit_visible then
			Unit.flow_event(mesh_unit, show_attachments_event)
			Unit.flow_event(character_unit, show_attachments_event)
		end

		if not character_material_changes then
			if not self.character_unit_hidden_after_spawn then
				local _delayed_material_changes = self._delayed_material_changes
				local var_32_20 = self._delayed_material_changes[character_unit]

				var_32_20 = var_32_20 or {}
				_delayed_material_changes[character_unit] = var_32_20
				self._delayed_material_changes[character_unit][#self._delayed_material_changes[character_unit] + 1] = character_material_changes.third_person
			else
				local third_person = character_material_changes.third_person

				for k, v_2 in pairs(third_person) do
					Unit.set_material(mesh_unit, k, v_2)

					flag = true
				end
			end
		end
	end

	if not flag_2 then
		Unit.set_data(character_unit, "equipment", tbl_2)
	end

	return flag
end

local function fn(arg_33_0, arg_33_1, arg_33_2)
	-- function 33
	local var_33_0

	if not arg_33_1 then
		var_33_0 = arg_33_1[arg_33_2]

		if not var_33_0 then
			-- Nothing
		end
	end

	var_33_0 = arg_33_0

	::label_33_0::

	return var_33_0
end

HeroPreviewer.reset_pose_animation = function (self)
	-- function 34
	if not self._pose_animation_event then
		return
	end

	local _wielded_slot_type = self._wielded_slot_type
	local var_34_1 = self._item_info_by_slot[_wielded_slot_type]
	local name = var_34_1.name
	local get_template_by_item_name = ItemHelper.get_template_by_item_name(name)
	local spawn_data = var_34_1.spawn_data
	local character_unit = self.character_unit
	local character_visible = self:character_visible()
	local wield_anim = get_template_by_item_name.wield_anim

	if not wield_anim then
		local var_34_8 = fn(nil, get_template_by_item_name.wield_anim_career_3p, self._current_career_name)

		var_34_8 = var_34_8 or fn(wield_anim, get_template_by_item_name.wield_anim_career, self._current_career_name)

		Unit.animation_event(character_unit, var_34_8)
	end

	self._pose_animation_event = nil
end

HeroPreviewer.set_pose_animation = function (self, arg_35_1, arg_35_2)
	-- function 35
	self._pose_animation_event = arg_35_1

	if not arg_35_2 then
		local character_unit = self.character_unit

		if character_unit == nil then
			return
		end

		if not self._loading_done then
			self._delayed_pose_animation = true

			return
		end

		if not arg_35_1 then
			Unit.animation_event(character_unit, arg_35_1)
		else
			self:reset_animation()
		end
	end
end

HeroPreviewer.trigger_pose_animation = function (self)
	-- function 36
	local _pose_animation_event = self._pose_animation_event
	local character_unit = self.character_unit

	if not (character_unit == nil or _pose_animation_event ~= nil) then
		return
	end

	Unit.animation_event(character_unit, _pose_animation_event)

	self._delayed_pose_animation = false
end

HeroPreviewer._spawn_item_unit = function (self, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5, arg_37_6, arg_37_7)
	-- function 37
	local world = self.world
	local character_unit = self.character_unit
	local character_visible = self:character_visible()

	if not (arg_37_2 == "melee" or arg_37_2 ~= "ranged") then
		if self._wielded_slot_type == arg_37_2 then
			arg_37_4 = arg_37_4.wielded

			if not script_data.disable_third_person_weapon_animation_events then
				local flag = not not arg_37_7 or arg_37_3.wield_anim

				if not flag then
					local var_37_4 = fn(nil, arg_37_3.wield_anim_career_3p, self._current_career_name)

					var_37_4 = var_37_4 or fn(flag, arg_37_3.wield_anim_career, self._current_career_name)

					Unit.animation_event(character_unit, var_37_4)
				end
			end

			self._hidden_units[arg_37_1] = true

			local flag_2

			flag_2 = not character_visible and "lua_wield" and "lua_unwield"

			Unit.flow_event(arg_37_1, flag_2)
		else
			arg_37_4 = arg_37_4.unwielded

			Unit.flow_event(arg_37_1, "lua_unwield")
		end
	else
		local flag_3

		flag_3 = not character_visible and "lua_attachment_unhidden" and "lua_attachment_hidden"

		Unit.flow_event(arg_37_1, flag_3)

		self._hidden_units[arg_37_1] = true
	end

	Unit.set_unit_visibility(arg_37_1, false)

	if not Unit.has_lod_object(arg_37_1, "lod") then
		local lod_object = Unit.lod_object(arg_37_1, "lod")

		LODObject.set_static_height(lod_object, 1)
	end

	local var_37_8 = character_unit

	if not arg_37_3.link_to_skin then
		var_37_8 = self.mesh_unit
	end

	GearUtils.link(world, arg_37_4, arg_37_5, var_37_8, arg_37_1)

	if not arg_37_6 then
		GearUtils.apply_material_settings(arg_37_1, arg_37_6)
	end
end

HeroPreviewer._destroy_item_units_by_slot = function (self, arg_38_1)
	-- function 38
	local world = self.world
	local _hidden_units = self._hidden_units
	local _requested_mip_streaming_units = self._requested_mip_streaming_units
	local spawn_data = self._item_info_by_slot[arg_38_1].spawn_data

	if not spawn_data then
		for i, v in ipairs(spawn_data) do
			local item_slot_type = v.item_slot_type
			local slot_index = v.slot_index

			if not (item_slot_type == "melee" or item_slot_type ~= "ranged") then
				if v.right_hand or not v.despawn_both_hands_units then
					local right = self._equipment_units[slot_index].right

					if right ~= nil then
						_hidden_units[right] = nil
						_requested_mip_streaming_units[right] = nil

						World.destroy_unit(world, right)

						self._equipment_units[slot_index].right = nil
					end
				end

				if v.left_hand or not v.despawn_both_hands_units then
					local left = self._equipment_units[slot_index].left

					if left ~= nil then
						_hidden_units[left] = nil
						_requested_mip_streaming_units[left] = nil

						World.destroy_unit(world, left)

						self._equipment_units[slot_index].left = nil
					end
				end
			else
				local var_38_8 = self._equipment_units[slot_index]

				if var_38_8 ~= nil then
					_hidden_units[var_38_8] = nil
					_requested_mip_streaming_units[var_38_8] = nil

					World.destroy_unit(world, var_38_8)

					self._equipment_units[slot_index] = nil
				end
			end
		end
	end
end

HeroPreviewer.wield_weapon_slot = function (self, arg_39_1)
	-- function 39
	self._wielded_slot_type = arg_39_1

	local melee = self._item_info_by_slot.melee

	if not melee then
		local name = melee.name
		local backend_id = melee.backend_id
		local skin_name = melee.skin_name

		self:equip_item(name, InventorySettings.slots_by_name.slot_melee, backend_id, skin_name)
	end

	local ranged = self._item_info_by_slot.ranged

	if not ranged then
		local name_2 = ranged.name
		local backend_id_2 = ranged.backend_id
		local skin_name_2 = ranged.skin_name

		self:equip_item(name_2, InventorySettings.slots_by_name.slot_ranged, backend_id_2, skin_name_2)
	end
end

HeroPreviewer.set_wielded_weapon_slot = function (self, arg_40_1)
	-- function 40
	self._wielded_slot_type = arg_40_1
end

HeroPreviewer.item_name_by_slot_type = function (self, arg_41_1)
	-- function 41
	local var_41_0 = self._item_info_by_slot[arg_41_1]

	return not var_41_0 and var_41_0.name
end

HeroPreviewer.wielded_slot_type = function (self)
	-- function 42
	return self._wielded_slot_type
end

HeroPreviewer._reference_name = function (self)
	-- function 43
	local str = "HeroPreviewer"

	if not self.unique_id then
		str = str .. tostring(self.unique_id)
	end

	return str
end

HeroPreviewer._trigger_equip_events = function (self)
	-- function 44
	if not Unit.alive(self.mesh_unit) then
		return
	end

	local _equipment_units = self._equipment_units

	if not self.character_unit_skin_data then
		local var_44_1 = _equipment_units[InventorySettings.slots_by_name.slot_hat.slot_index]
		local equip_hat_event = self.character_unit_skin_data.equip_hat_event

		equip_hat_event = equip_hat_event or "using_skin_default"

		if not var_44_1 and not equip_hat_event then
			Unit.flow_event(var_44_1, equip_hat_event)
		end
	end
end

HeroPreviewer._load_packages = function (self, arg_45_1)
	-- function 45
	local _reference_name = self:_reference_name()
	local package = Managers.package

	for i, v in ipairs(arg_45_1) do
		package:load(v, _reference_name, nil, true, true)
	end
end

HeroPreviewer._unload_all_packages = function (self)
	-- function 46
	self:_unload_hero_packages()
	self:_unload_all_items()
	self:_unload_all_prop_packages()
end

HeroPreviewer._unload_all_prop_packages = function (self)
	-- function 47
	local _props_data = self._props_data

	for k, v in pairs(_props_data) do
		self:_unload_prop_packages(v)

		_props_data[k] = nil
	end
end

HeroPreviewer._unload_hero_packages = function (self)
	-- function 48
	local _hero_loading_package_data = self._hero_loading_package_data

	if not _hero_loading_package_data then
		return
	end

	local package_names = _hero_loading_package_data.package_names
	local package = Managers.package
	local _reference_name = self:_reference_name()

	for k, v in pairs(package_names) do
		if package:has_loaded(v, _reference_name) or not package:is_loading(v, _reference_name) then
			package:unload(v, _reference_name)
		end
	end

	self._hero_loading_package_data = nil
end

HeroPreviewer._unload_all_items = function (self)
	-- function 49
	local _item_info_by_slot = self._item_info_by_slot

	for k, v in pairs(_item_info_by_slot) do
		self:_unload_item_packages_by_slot(k)
	end
end

HeroPreviewer._unload_prop_packages = function (self, arg_50_1)
	-- function 50
	local package = Managers.package
	local _reference_name = self:_reference_name()

	for i, v in ipairs(arg_50_1.settings.package_names) do
		if package:has_loaded(v, _reference_name) or not package:is_loading(v, _reference_name) then
			package:unload(v, _reference_name)
		end
	end
end

HeroPreviewer._unload_item_packages_by_slot = function (self, arg_51_1)
	-- function 51
	local _item_info_by_slot = self._item_info_by_slot

	if not _item_info_by_slot[arg_51_1] then
		local package_names = _item_info_by_slot[arg_51_1].package_names
		local package = Managers.package
		local _reference_name = self:_reference_name()

		for i, v in ipairs(package_names) do
			if package:has_loaded(v, _reference_name) or not package:is_loading(v, _reference_name) then
				package:unload(v, _reference_name)
			end
		end

		_item_info_by_slot[arg_51_1] = nil
	end
end

HeroPreviewer.clear_units = function (self)
	-- function 52
	table.clear(self._requested_mip_streaming_units)

	local world = self.world

	for i = 1, 6 do
		if type(self._equipment_units[i]) == "table" then
			if not self._equipment_units[i].left then
				World.destroy_unit(world, self._equipment_units[i].left)

				self._equipment_units[i].left = nil
			end

			if not self._equipment_units[i].right then
				World.destroy_unit(world, self._equipment_units[i].right)

				self._equipment_units[i].right = nil
			end
		elseif not self._equipment_units[i] then
			World.destroy_unit(world, self._equipment_units[i])

			self._equipment_units[i] = nil
		end
	end

	if not self.mesh_unit then
		World.destroy_unit(world, self.mesh_unit)

		self.mesh_unit = nil
	end

	if not self.character_unit then
		World.destroy_unit(world, self.character_unit)

		self.character_unit = nil
	end

	for k, v in pairs(self._props_data) do
		if not v.unit then
			World.destroy_unit(world, v.unit)

			v.unit = nil
		end
	end
end

HeroPreviewer.set_hero_location = function (self, arg_53_1)
	-- function 53
	if not arg_53_1 then
		self.character_location = arg_53_1

		local character_unit = self.character_unit

		if not character_unit and not Unit.alive(character_unit) then
			Unit.set_local_position(character_unit, 0, Vector3Aux.unbox(arg_53_1))
		end
	end
end

HeroPreviewer.set_hero_location_lerped = function (self, arg_54_1, arg_54_2)
	-- function 54
	self._character_destination_location = arg_54_1
	self._lerp_time = arg_54_2
	self._lerp_end_time = Managers.time:time("game") + arg_54_2
end

HeroPreviewer.set_hero_rotation = function (self, arg_55_1)
	-- function 55
	if not arg_55_1 then
		self.character_rotation = arg_55_1

		local character_unit = self.character_unit

		if not character_unit and not Unit.alive(character_unit) then
			local axis_angle = Quaternion.axis_angle(Vector3.up(), arg_55_1)

			Unit.set_local_rotation(character_unit, 0, axis_angle)
		end
	end
end

HeroPreviewer.set_hero_look_target = function (self, arg_56_1)
	-- function 56
	if not arg_56_1 then
		self.character_look_target = arg_56_1
	end
end

HeroPreviewer.get_character_unit = function (self)
	-- function 57
	local character_unit

	if not Unit.alive(self.character_unit) then
		character_unit = self.character_unit

		if not character_unit then
			-- Nothing
		end
	end

	character_unit = nil

	::label_57_0::

	return character_unit
end

HeroPreviewer.current_profile_name = function (self)
	-- function 58
	return self._current_profile_name
end
