-- chunkname: @scripts/ui/views/hero_view/loot_item_unit_previewer.lua

local num = 0

LootItemUnitPreviewer = class(LootItemUnitPreviewer)

LootItemUnitPreviewer.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9, arg_1_10)
	-- function 1
	self._unique_id = arg_1_5
	self._loaded_packages = {}
	self._packages_to_load = {}
	self._requested_all_mips_units = {}
	self._camera_xy_angle_target = num
	self._camera_xy_angle_current = num
	self._invert_start_rotation = arg_1_6
	self._display_unit_key = arg_1_7
	self._spawn_position = arg_1_2
	self._item = arg_1_1
	self._use_highest_mip_levels = arg_1_8
	self._career_name_override = arg_1_10
	self._delayed_spawn = arg_1_9

	if not self._delayed_spawn then
		self._background_world = arg_1_3
		self._background_viewport = arg_1_4
		self._link_unit = self:_spawn_link_unit(arg_1_1)
	end

	self._activated = not self._delayed_spawn
	self._units_to_spawn = self:_load_item_units(arg_1_1)
end

LootItemUnitPreviewer.activate = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	if not self._delayed_spawn then
		return
	end

	if arg_2_1 == self._activated then
		return
	end

	if not arg_2_1 then
		self._background_world = arg_2_2
		self._background_viewport = arg_2_3
		self._link_unit = self:_spawn_link_unit(self._item)
	else
		self:_destroy_units()

		self._background_world = nil
		self._background_viewport = nil
	end

	self._activated = arg_2_1
	self._force_present = arg_2_4
end

LootItemUnitPreviewer.activate_auto_spin = function (self)
	-- function 3
	self._auto_spin_random_seed = math.random(5, 30000)
end

LootItemUnitPreviewer.register_spawn_callback = function (self, arg_4_1)
	-- function 4
	self._spawn_callback = arg_4_1
end

LootItemUnitPreviewer.destroy = function (self)
	-- function 5
	self:_destroy_units()
	self:_unload_packages()
	table.clear(self._loaded_packages)
	table.clear(self._packages_to_load)
	Renderer.set_automatic_streaming(true)
end

LootItemUnitPreviewer._destroy_units = function (self)
	-- function 6
	local _background_world = self._background_world
	local _spawned_units = self._spawned_units

	if not _spawned_units then
		for i, v in ipairs(_spawned_units) do
			World.destroy_unit(_background_world, v)
		end

		self._spawned_units = nil
	end

	local _link_unit = self._link_unit

	if not _link_unit then
		World.destroy_unit(_background_world, _link_unit)
	end

	self._link_unit = nil
	self.units_spawned = nil
	self._items_spawned = nil
end

LootItemUnitPreviewer.update = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	if not self._activated then
		return
	end

	if not self._items_spawned then
		if not self._request_show_settings and not self:_update_manual_mip_streaming() then
			local _request_show_settings = self._request_show_settings
			local item_key = _request_show_settings.item_key
			local ignore_spin = _request_show_settings.ignore_spin
			local flag = true

			self:_enable_item_units_visibility(item_key, ignore_spin, flag)

			self._request_show_settings = nil
		elseif not self._force_present then
			local key = self._item.key

			self:present_item(key, true)

			self._force_present = false
		end

		if not arg_7_3 then
			local input = Managers.input

			if not input:is_device_active("mouse") then
				self:_handle_mouse_input(arg_7_3, arg_7_1)
			elseif not input:is_device_active("gamepad") then
				self:_handle_controller_input(arg_7_3, arg_7_1)
			end
		end

		if self._camera_xy_angle_target > math.pi * 2 then
			self._camera_xy_angle_current = self._camera_xy_angle_current - math.pi * 2
			self._camera_xy_angle_target = self._camera_xy_angle_target - math.pi * 2
		end

		local lerp = math.lerp(self._camera_xy_angle_current, self._camera_xy_angle_target, 0.1)

		self._camera_xy_angle_current = lerp

		local _auto_spin_values, var_7_8 = self:_auto_spin_values(arg_7_1, arg_7_2)
		local flag_2

		flag_2 = not self._invert_start_rotation and 0 and math.pi

		local axis_angle = Quaternion.axis_angle(Vector3(0, _auto_spin_values, 1), -(lerp + var_7_8 + flag_2))
		local _link_unit = self._link_unit

		if not _link_unit then
			Unit.set_local_rotation(_link_unit, 0, axis_angle)
		end

		if not self._zoom_dirty then
			local _zoom_fraction = self._zoom_fraction

			_zoom_fraction = _zoom_fraction or 0

			local unbox = self._unit_start_position_boxed:unbox()

			unbox[1] = unbox[1] * (1 - _zoom_fraction)
			unbox[2] = unbox[2] * (1 - _zoom_fraction)

			Unit.set_local_position(_link_unit, 0, unbox)

			self._zoom_dirty = nil
		end
	end
end

LootItemUnitPreviewer.set_zoom_fraction = function (self, arg_8_1)
	-- function 8
	self._zoom_fraction = math.clamp(arg_8_1, 0, 1)
	self._zoom_dirty = true
end

LootItemUnitPreviewer.zoom_fraction = function (self)
	-- function 9
	local _zoom_fraction = self._zoom_fraction

	_zoom_fraction = _zoom_fraction or 0

	return _zoom_fraction
end

LootItemUnitPreviewer._auto_spin_values = function (self, arg_10_1, arg_10_2)
	-- function 10
	local _auto_spin_random_seed = self._auto_spin_random_seed

	if not _auto_spin_random_seed then
		return 0, 0
	end

	local num = 0.2
	local num_2 = 0.3
	local num_3 = math.sin((_auto_spin_random_seed + arg_10_2) * num) * num_2
	local num_4 = -(num_3 * 0.5)
	local num_5 = -(num_3 * math.pi / 2)

	return num_4, num_5
end

local tbl = {}

LootItemUnitPreviewer._handle_mouse_input = function (self, arg_11_1, arg_11_2)
	-- function 11
	local get = arg_11_1:get("cursor")

	if not get then
		return
	end

	local flag = true

	if not flag then
		if not arg_11_1:get("left_press") then
			self._is_moving_camera = true
			self._last_mouse_position = nil
		elseif not arg_11_1:get("right_press") then
			self._camera_xy_angle_target = num
		end
	end

	local _is_moving_camera = self._is_moving_camera
	local get_2 = arg_11_1:get("left_hold")

	if not _is_moving_camera and not get_2 then
		if not self._last_mouse_position then
			self._camera_xy_angle_target = self._camera_xy_angle_target - (get.x - self._last_mouse_position[1]) * 0.01
		end

		tbl[1] = get.x
		tbl[2] = get.y
		self._last_mouse_position = tbl
	elseif not _is_moving_camera then
		self._is_moving_camera = false
	end
end

LootItemUnitPreviewer._handle_controller_input = function (self, arg_12_1, arg_12_2)
	-- function 12
	local get = arg_12_1:get("gamepad_right_axis")

	if not (not get and not (Vector3.length(get) > 0.01)) then
		self._camera_xy_angle_target = self._camera_xy_angle_target + -get.x * arg_12_2 * 5
	end
end

LootItemUnitPreviewer.post_update = function (self, arg_13_1, arg_13_2)
	-- function 13
	if not self._activated then
		return
	end

	if not self._spawn_callback and not self._items_spawned then
		self._spawn_callback()

		self._spawn_callback = nil
	end

	if self._items_spawned or not self:_packages_loaded() then
		self._items_spawned = self:_spawn_items()
	end
end

LootItemUnitPreviewer._load_item_units = function (self, arg_14_1)
	-- function 14
	if not arg_14_1 then
		return
	end

	local data = arg_14_1.data
	local backend_id = arg_14_1.backend_id
	local skin = arg_14_1.skin
	local key = data.key

	key = key or arg_14_1.key

	local var_14_4 = ItemMasterList[key]
	local var_14_5
	local item_type = var_14_4.item_type

	if not (item_type == "rune" or item_type == "material" or item_type == "ring" or item_type ~= "necklace") then
		var_14_4 = ItemMasterList[key]
	elseif item_type == "weapon_skin" then
		local matching_item_key = var_14_4.matching_item_key

		var_14_5 = ItemHelper.get_template_by_item_name(matching_item_key)
		skin = skin or key
	end

	var_14_5 = var_14_5 or ItemHelper.get_template_by_item_name(key)

	local get_item_units = BackendUtils.get_item_units(var_14_4, backend_id, skin, self._career_name_override)
	local tbl = {}
	local slot_type = var_14_4.slot_type

	if not (slot_type == "melee" or slot_type == "ranged" or slot_type ~= "weapon_skin") then
		local left_hand_unit = get_item_units.left_hand_unit
		local right_hand_unit = get_item_units.right_hand_unit
		local ammo_unit = get_item_units.ammo_unit
		local is_ammo_weapon = get_item_units.is_ammo_weapon
		local material_settings_name = get_item_units.material_settings_name

		if not left_hand_unit then
			if not is_ammo_weapon then
				left_hand_unit = ammo_unit
			end

			local str = left_hand_unit .. "_3p"

			self:load_package(str)

			tbl[#tbl + 1] = {
				unit_name = str,
				unit_attachment_node_linking = var_14_5.left_hand_attachment_node_linking.third_person.display,
				material_settings_name = material_settings_name
			}
		end

		if not right_hand_unit then
			if not is_ammo_weapon then
				right_hand_unit = ammo_unit
			end

			local str_2 = right_hand_unit .. "_3p"

			if right_hand_unit ~= left_hand_unit then
				self:load_package(str_2)
			end

			tbl[#tbl + 1] = {
				unit_name = str_2,
				unit_attachment_node_linking = var_14_5.right_hand_attachment_node_linking.third_person.display,
				material_settings_name = material_settings_name
			}
		end
	elseif not (slot_type == "frame" or slot_type ~= "chips") then
		local unit = var_14_5.attachment_node.unit

		if not unit then
			self:load_package(unit)
		end

		if not var_14_5.texture_package_name and not Application.can_get("package", var_14_5.texture_package_name) then
			self:load_package(var_14_5.texture_package_name)
		end

		local material_settings_name_2 = var_14_5.material_settings_name

		tbl[#tbl + 1] = {
			unit_name = unit,
			unit_attachment_node_linking = var_14_5.attachment_node.attachment_node,
			material_settings_name = material_settings_name_2,
			additional_packages = {
				var_14_5.texture_package_name
			}
		}
	else
		local unit_2 = get_item_units.unit

		if not unit_2 then
			self:load_package(unit_2)

			local num = #tbl + 1
			local tbl_2 = {
				unit_name = unit_2
			}
			local slot_trinket_1

			if slot_type == "trinket" then
				slot_trinket_1 = var_14_5.attachment_node_linking.slot_trinket_1

				if not slot_trinket_1 then
					-- Nothing
				end
			end

			slot_trinket_1 = var_14_5.attachment_node_linking.slot_hat

			::label_14_0::

			tbl_2.unit_attachment_node_linking = slot_trinket_1
			tbl[num] = tbl_2
		end
	end

	return tbl
end

LootItemUnitPreviewer._trigger_unit_flow_event = function (arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	if not arg_15_1 and not Unit.alive(arg_15_1) then
		Unit.flow_event(arg_15_1, arg_15_2)
	end
end

LootItemUnitPreviewer._get_world = function (self)
	-- function 16
	return self._background_world, self._background_viewport
end

LootItemUnitPreviewer._get_camera_position = function (self)
	-- function 17
	local _background_viewport = self._background_viewport
	local camera = ScriptViewport.camera(_background_viewport)

	return ScriptCamera.position(camera)
end

LootItemUnitPreviewer._get_camera_rotation = function (self)
	-- function 18
	local _background_viewport = self._background_viewport
	local camera = ScriptViewport.camera(_background_viewport)

	return ScriptCamera.rotation(camera)
end

LootItemUnitPreviewer._packages_loaded = function (self)
	-- function 19
	local _units_to_spawn = self._units_to_spawn
	local _loaded_packages = self._loaded_packages

	for i, v in ipairs(_units_to_spawn) do
		if not _loaded_packages[v.unit_name] then
			return false
		end

		if not v.additional_packages then
			for i_2, v_2 in ipairs(v.additional_packages) do
				if not _loaded_packages[v_2] then
					return false
				end
			end
		end
	end

	return true
end

LootItemUnitPreviewer.load_package = function (self, arg_20_1)
	-- function 20
	if self._packages_to_load[arg_20_1] ~= nil then
		return
	end

	self._packages_to_load[arg_20_1] = true

	local package = Managers.package
	local var_20_1 = callback(self, "_on_load_complete", arg_20_1)
	local str = "LootItemUnitPreviewer"

	if not self._unique_id then
		str = str .. tostring(self._unique_id)
	end

	package:load(arg_20_1, str, var_20_1, true)
end

LootItemUnitPreviewer._on_load_complete = function (arg_21_0, arg_21_1)
	-- function 21
	arg_21_0._loaded_packages[arg_21_1] = true
	arg_21_0._packages_to_load[arg_21_1] = false
end

LootItemUnitPreviewer._unload_packages = function (self)
	-- function 22
	local str = "LootItemUnitPreviewer"

	if not self._unique_id then
		str = str .. tostring(self._unique_id)
	end

	local _loaded_packages = self._loaded_packages

	if not _loaded_packages then
		local package = Managers.package

		for k, v in pairs(_loaded_packages) do
			package:unload(k, str)
		end
	end

	local _packages_to_load = self._packages_to_load

	if not _packages_to_load then
		local package_2 = Managers.package

		for k_2, v_2 in pairs(_packages_to_load) do
			if not v_2 then
				package_2:unload(k_2, str)
			end
		end
	end
end

LootItemUnitPreviewer._spawn_link_unit = function (self, arg_23_1)
	-- function 23
	local data = arg_23_1.data
	local key = arg_23_1.key

	key = key or data.key

	local skin = arg_23_1.skin

	skin = skin or key

	local _spawn_position = self._spawn_position
	local var_23_4 = ItemMasterList[key]
	local item_type = var_23_4.item_type

	if not (item_type == "rune" or item_type == "material" or item_type == "ring" or item_type ~= "necklace") then
		-- Nothing
	end

	local _display_unit_key = self._display_unit_key
	local str = "display_unit"
	local var_23_8 = var_23_4[_display_unit_key]

	var_23_8 = var_23_8 or var_23_4[str]

	if item_type == "weapon_skin" then
		local var_23_9 = WeaponSkins.skins[skin]

		var_23_8 = var_23_9[_display_unit_key] or var_23_9[str] or var_23_8
	elseif not var_23_8 then
		local get_template_by_item_name = ItemHelper.get_template_by_item_name(key)

		var_23_8 = get_template_by_item_name[_display_unit_key] or get_template_by_item_name[str]
	end

	if not (not var_23_8 and var_23_8 ~= "") then
		Application.warning(string.format("[LootItemUnitPreviewer] Couldn't find any display unit for item %q", key))

		return nil
	end

	local _get_camera_rotation = self:_get_camera_rotation()
	local forward = Quaternion.forward(_get_camera_rotation)
	local look = Quaternion.look(forward, Vector3.up())
	local axis_angle = Quaternion.axis_angle(Vector3.up(), 0)
	local multiply = Quaternion.multiply(look, axis_angle)
	local num = self:_get_camera_position() + forward + Vector3(_spawn_position[1], _spawn_position[2], _spawn_position[3])
	local _background_world = self._background_world
	local spawn_unit = World.spawn_unit(_background_world, var_23_8, num, multiply)
	local world_position = Unit.world_position(spawn_unit, 0)

	self._unit_start_position_boxed = Vector3Box(world_position)

	return spawn_unit
end

LootItemUnitPreviewer._spawn_items = function (self)
	-- function 24
	local flag = true
	local _units_to_spawn = self._units_to_spawn

	for i, v in ipairs(_units_to_spawn) do
		local unit_name = v.unit_name

		if not self._loaded_packages[unit_name] then
			flag = false

			break
		end
	end

	if not flag then
		local key = self._item.data.key
		local spawn_units = self:spawn_units(_units_to_spawn)

		if not self._use_highest_mip_levels then
			for k = 1, #spawn_units do
				local var_24_5 = spawn_units[k]

				self:_request_all_mips_for_unit(var_24_5)
			end
		end

		self._spawned_units = spawn_units
	end

	return flag
end

LootItemUnitPreviewer.spawn_units = function (self, arg_25_1)
	-- function 25
	local tbl = {}
	local _link_unit = self._link_unit

	if not arg_25_1 and not _link_unit then
		local tbl_2 = {}
		local _background_world = self._background_world

		for i = 1, #arg_25_1 do
			local var_25_4 = arg_25_1[i]
			local unit_name = var_25_4.unit_name
			local unit_attachment_node_linking = var_25_4.unit_attachment_node_linking
			local material_settings_name = var_25_4.material_settings_name
			local spawn_unit = World.spawn_unit(_background_world, unit_name)

			Unit.set_unit_visibility(spawn_unit, false)

			tbl[#tbl + 1] = spawn_unit

			GearUtils.link(_background_world, unit_attachment_node_linking, tbl_2, _link_unit, spawn_unit)

			if not material_settings_name then
				GearUtils.apply_material_settings(spawn_unit, material_settings_name)
			end
		end

		self.units_spawned = true
	end

	return tbl
end

LootItemUnitPreviewer.present_item = function (self, arg_26_1, arg_26_2)
	-- function 26
	if not (not self._use_highest_mip_levels and self:_update_manual_mip_streaming()) then
		self._request_show_settings = {
			item_key = arg_26_1,
			ignore_spin = arg_26_2
		}
	else
		self:_enable_item_units_visibility(arg_26_1, arg_26_2, true)
	end
end

LootItemUnitPreviewer._enable_item_units_visibility = function (self, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	local _spawned_units = self._spawned_units

	if not _spawned_units then
		local _link_unit = self._link_unit

		for i, v in ipairs(_spawned_units) do
			if not v and not Unit.alive(v) then
				Unit.set_unit_visibility(v, arg_27_3)

				if not arg_27_3 then
					self:_trigger_unit_flow_event(v, "lua_presentation")
					self:_trigger_unit_flow_event(v, "lua_wield")
				end
			end
		end

		if (arg_27_2 or not arg_27_3) and not _link_unit then
			Unit.flow_event(_link_unit, "lua_spin_no_fx")
		end
	end
end

LootItemUnitPreviewer._request_all_mips_for_unit = function (self, arg_28_1)
	-- function 28
	local _requested_all_mips_units = self._requested_all_mips_units

	_requested_all_mips_units[#_requested_all_mips_units + 1] = arg_28_1

	Renderer.request_to_stream_all_mips_for_unit(arg_28_1)
	Renderer.set_automatic_streaming(false)
end

LootItemUnitPreviewer._update_manual_mip_streaming = function (self)
	-- function 29
	local flag = true
	local _requested_all_mips_units = self._requested_all_mips_units

	for i = #_requested_all_mips_units, 1, -1 do
		local var_29_2 = _requested_all_mips_units[i]

		if not Renderer.is_all_mips_loaded_for_unit(var_29_2) then
			table.swap_delete(_requested_all_mips_units, i)
		else
			flag = false
		end
	end

	if not flag then
		Renderer.set_automatic_streaming(true)
	end

	return flag
end
