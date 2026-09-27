-- chunkname: @scripts/ui/views/menu_world_previewer.lua

require("scripts/ui/views/world_hero_previewer")

local degrees_to_radians = math.degrees_to_radians(0)

MenuWorldPreviewer = class(MenuWorldPreviewer, HeroPreviewer)

local tbl = {
	witch_hunter = {
		z = 0.4,
		x = 0,
		y = 0.8
	},
	bright_wizard = {
		z = 0.2,
		x = 0,
		y = 0.4
	},
	dwarf_ranger = {
		z = 0,
		x = 0,
		y = 0
	},
	wood_elf = {
		z = 0.16,
		x = 0,
		y = 0.45
	},
	empire_soldier = {
		z = 0.4,
		x = 0,
		y = 1
	},
	empire_soldier_tutorial = {
		z = 0.4,
		x = 0,
		y = 1
	},
	vs_rat_ogre = {
		z = 0.6,
		x = 1.2,
		y = 0.5
	},
	vs_chaos_troll = {
		z = 0.4,
		x = 0,
		y = 1
	},
	vs_gutter_runner = {
		z = 0,
		x = 0,
		y = 0
	},
	vs_packmaster = {
		z = 0,
		x = 0,
		y = 0
	},
	vs_ratling_gunner = {
		z = 0,
		x = 0,
		y = 0
	},
	vs_warpfire_thrower = {
		z = 0,
		x = 0,
		y = 0
	},
	vs_poison_wind_globadier = {
		z = 0,
		x = 0,
		y = 0
	},
	default = {
		z = 0.4,
		x = 0,
		y = 1
	}
}

MenuWorldPreviewer.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	MenuWorldPreviewer.super.init(self, arg_1_1, arg_1_3, arg_1_4)

	self.input_manager = arg_1_1.input_manager
	self.ui_renderer = arg_1_1.ui_renderer
	self._character_camera_positions = arg_1_2 or tbl
	self.player_manager = Managers.player
	self.peer_id = arg_1_1.peer_id
	self._camera_default_position = {
		z = 0.9,
		x = 0,
		y = 2.8
	}
	self._default_animation_data = {
		x = {
			value = 0
		},
		y = {
			value = 0
		},
		z = {
			value = 0
		}
	}
	self._camera_position_animation_data = table.clone(self._default_animation_data)
	self._camera_character_position_animation_data = table.clone(self._default_animation_data)
	self._camera_rotation_animation_data = table.clone(self._default_animation_data)
	self._camera_gamepad_offset_data = {
		0,
		0,
		0
	}
	self._units = {}
	self._requested_unit_spawn_queue = {}
end

MenuWorldPreviewer.set_default_position = function (self, arg_2_1)
	-- function 2
	self._camera_default_position = arg_2_1
end

MenuWorldPreviewer.set_lookat_target = function (self, arg_3_1)
	-- function 3
	self._lookat_target = arg_3_1
end

MenuWorldPreviewer.destroy = function (arg_4_0)
	-- function 4
	MenuWorldPreviewer.super.destroy(arg_4_0)
	Renderer.set_automatic_streaming(true)
	GarbageLeakDetector.register_object(arg_4_0, "MenuWorldPreviewer")
end

MenuWorldPreviewer.on_enter = function (self, arg_5_1, arg_5_2)
	-- function 5
	MenuWorldPreviewer.super.on_enter(self)
	self:setup_viewport(arg_5_1, arg_5_2)
end

MenuWorldPreviewer.setup_viewport = function (self, arg_6_1, arg_6_2)
	-- function 6
	self.viewport_widget = arg_6_1

	local var_6_0 = arg_6_1.element.pass_data[1]

	self.world = var_6_0.world
	self.level = var_6_0.level
	self.viewport = var_6_0.viewport
	self.camera = ScriptViewport.camera(self.viewport)
	self.character_camera_position_adjustments = {}
	self.hero_name = arg_6_2
	self.character_look_current = {
		0,
		3,
		1
	}
	self.character_look_target = {
		0,
		3,
		1
	}
	self.camera_xy_angle_current = degrees_to_radians
	self.camera_xy_angle_target = degrees_to_radians
	self._requested_unit_spawn_queue = {}
	self._units = {}
end

local tbl_2 = {}

MenuWorldPreviewer.activate = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	if not self._delayed_spawn then
		return
	end

	if self._activated == arg_7_1 then
		return
	end

	if not arg_7_1 then
		self:setup_viewport(arg_7_2, arg_7_3)

		local _delayed_hero_spawn_data = self._delayed_hero_spawn_data

		_delayed_hero_spawn_data = _delayed_hero_spawn_data or tbl_2
		self._requested_hero_spawn_data = _delayed_hero_spawn_data

		local _delayed_unit_spawn_queue = self._delayed_unit_spawn_queue

		_delayed_unit_spawn_queue = _delayed_unit_spawn_queue or tbl_2
		self._requested_unit_spawn_queue = _delayed_unit_spawn_queue
	else
		local flag = true

		self:clear_units(flag)

		self.world = nil
	end

	self._activated = arg_7_1
end

MenuWorldPreviewer.trigger_level_event = function (self, arg_8_1)
	-- function 8
	Level.trigger_event(self.level, arg_8_1)
end

MenuWorldPreviewer.show_level_units = function (self, arg_9_1, arg_9_2)
	-- function 9
	local level = self.level

	for k, v in pairs(arg_9_1) do
		local unit_by_index = Level.unit_by_index(level, v)

		if not Unit.alive(unit_by_index) then
			Unit.set_unit_visibility(unit_by_index, arg_9_2)

			if not arg_9_2 then
				Unit.flow_event(unit_by_index, "unit_object_set_enabled")
			else
				Unit.flow_event(unit_by_index, "unit_object_set_disabled")
			end
		end
	end
end

MenuWorldPreviewer.has_units_spawned = function (self)
	-- function 10
	return self.character_unit ~= nil
end

MenuWorldPreviewer.on_exit = function (arg_11_0)
	-- function 11
	MenuWorldPreviewer.super.on_exit(arg_11_0)
	Renderer.set_automatic_streaming(true)
end

MenuWorldPreviewer.update = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local _delayed_unit_spawn_queue = self._delayed_unit_spawn_queue

	_delayed_unit_spawn_queue = _delayed_unit_spawn_queue or tbl_2
	self._requested_unit_spawn_queue = _delayed_unit_spawn_queue

	MenuWorldPreviewer.super.update(self, arg_12_1, arg_12_2)

	if not self._activated then
		return
	end

	local character_unit = self.character_unit

	if not character_unit then
		if self.camera_xy_angle_target > math.pi * 2 then
			self.camera_xy_angle_current = self.camera_xy_angle_current - math.pi * 2
			self.camera_xy_angle_target = self.camera_xy_angle_target - math.pi * 2
		end

		local lerp = math.lerp(self.camera_xy_angle_current, self.camera_xy_angle_target, 0.1)

		self.camera_xy_angle_current = lerp

		local axis_angle = Quaternion.axis_angle(Vector3(0, 0, 1), -lerp)

		Unit.set_local_rotation(character_unit, 0, axis_angle)

		local unbox = Vector3Aux.unbox(self.character_look_current)
		local animation_find_constraint_target = Unit.animation_find_constraint_target(character_unit, "aim_constraint_target")
		local rotate = Quaternion.rotate(axis_angle, unbox)

		Unit.animation_set_constraint_target(character_unit, animation_find_constraint_target, rotate)
	end

	self:_update_camera_animation_data(self._camera_position_animation_data, arg_12_1)
	self:_update_camera_animation_data(self._camera_rotation_animation_data, arg_12_1)
	self:_update_camera_animation_data(self._camera_character_position_animation_data, arg_12_1)

	local _camera_default_position = self._camera_default_position
	local zero = Vector3.zero()

	zero.x = _camera_default_position.x
	zero.y = _camera_default_position.y
	zero.z = _camera_default_position.z

	local unbox_2

	if not self._lookat_target then
		unbox_2 = self._lookat_target:unbox()

		if not unbox_2 then
			-- Nothing
		end
	end

	unbox_2 = Vector3(0, 0, 0.9)

	::label_12_0::

	local normalize = Vector3.normalize(unbox_2 - zero)
	local _camera_rotation_animation_data = self._camera_rotation_animation_data

	normalize.x = normalize.x + _camera_rotation_animation_data.x.value
	normalize.y = normalize.y + _camera_rotation_animation_data.y.value
	normalize.z = normalize.z + _camera_rotation_animation_data.z.value

	local look = Quaternion.look(normalize)

	ScriptCamera.set_local_rotation(self.camera, look)

	local _camera_position_animation_data = self._camera_position_animation_data
	local _camera_character_position_animation_data = self._camera_character_position_animation_data
	local _camera_gamepad_offset_data = self._camera_gamepad_offset_data

	zero.x = zero.x + _camera_position_animation_data.x.value + _camera_character_position_animation_data.x.value + _camera_gamepad_offset_data[1]
	zero.y = zero.y + _camera_position_animation_data.y.value + _camera_character_position_animation_data.y.value + _camera_gamepad_offset_data[2]
	zero.z = zero.z + _camera_position_animation_data.z.value + _camera_character_position_animation_data.z.value + _camera_gamepad_offset_data[3]

	ScriptCamera.set_local_position(self.camera, zero)

	local get_service = self.input_manager:get_service("hero_view")

	if arg_12_3 or not self.character_unit_visible then
		self:handle_mouse_input(get_service, arg_12_1)
		self:handle_controller_input(get_service, arg_12_1)
	end
end

MenuWorldPreviewer.post_update = function (self, arg_13_1, arg_13_2)
	-- function 13
	self:_handle_unit_spawn_request()
	MenuWorldPreviewer.super.post_update(self, arg_13_1, arg_13_2)
end

MenuWorldPreviewer.force_stream_highest_mip_levels = function (self)
	-- function 14
	self._use_highest_mip_levels = true
end

MenuWorldPreviewer.force_hide_character = function (self)
	-- function 15
	self._force_hide_character = true
end

MenuWorldPreviewer.force_unhide_character = function (self)
	-- function 16
	self._force_hide_character = false
end

MenuWorldPreviewer._update_units_visibility = function (self, arg_17_1)
	-- function 17
	if not self._force_hide_character then
		return
	end

	MenuWorldPreviewer.super._update_units_visibility(self, arg_17_1)
end

MenuWorldPreviewer._set_character_visibility = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	MenuWorldPreviewer.super._set_character_visibility(self, arg_18_1)

	if not arg_18_3 then
		return
	end

	local flag = arg_18_2 or self._camera_move_duration

	if not flag then
		local num = 0
		local num_2 = 0
		local num_3 = 0

		if not arg_18_1 then
			local _current_profile_name = self._current_profile_name

			if not _current_profile_name then
				local _character_camera_positions = self._character_camera_positions
				local var_18_6 = _character_camera_positions[_current_profile_name]

				var_18_6 = var_18_6 or _character_camera_positions.default
				num = var_18_6.x
				num_2 = var_18_6.y
				num_3 = var_18_6.z
			end
		end

		self:set_character_axis_offset("x", num, flag, math.easeOutCubic)
		self:set_character_axis_offset("y", num_2, flag, math.easeOutCubic)
		self:set_character_axis_offset("z", num_3, flag, math.easeOutCubic)
	end
end

MenuWorldPreviewer._update_camera_animation_data = function (arg_19_0, arg_19_1, arg_19_2)
	-- function 19
	for k, v in pairs(arg_19_1) do
		if not v.total_time then
			local time = v.time

			v.time = math.min(time + arg_19_2, v.total_time)

			local min = math.min(1, v.time / v.total_time)
			local func = v.func
			local num = v.to - v.from
			local var_19_4

			if not func then
				var_19_4 = func(min)

				if not var_19_4 then
					-- Nothing
				end
			end

			var_19_4 = min

			::label_19_0::

			v.value = num * var_19_4 + v.from

			if min == 1 then
				v.total_time = nil
			end
		end
	end
end

MenuWorldPreviewer.set_camera_axis_offset = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	local var_20_0 = self._camera_position_animation_data[arg_20_1]
	local _camera_default_position = self._camera_default_position
	local value

	if not arg_20_3 then
		value = var_20_0.value

		if not value then
			-- Nothing
		end
	end

	value = arg_20_2

	::label_20_0::

	var_20_0.from = value

	local num

	if not arg_20_5 then
		num = arg_20_2 + -_camera_default_position[arg_20_1]

		if not num then
			-- Nothing
		end
	end

	num = arg_20_2

	::label_20_1::

	var_20_0.to = num
	var_20_0.total_time = arg_20_3
	var_20_0.time = 0
	var_20_0.func = arg_20_4
	var_20_0.value = var_20_0.from
end

MenuWorldPreviewer.set_camera_gamepad_offset = function (self, arg_21_1)
	-- function 21
	self._camera_gamepad_offset_data = arg_21_1
end

MenuWorldPreviewer.set_camera_rotation_axis_offset = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	-- function 22
	local var_22_0 = self._camera_rotation_animation_data[arg_22_1]
	local value

	if not arg_22_3 then
		value = var_22_0.value

		if not value then
			-- Nothing
		end
	end

	value = arg_22_2

	::label_22_0::

	var_22_0.from = value
	var_22_0.to = arg_22_2
	var_22_0.total_time = arg_22_3
	var_22_0.time = 0
	var_22_0.func = arg_22_4
	var_22_0.value = var_22_0.from
end

MenuWorldPreviewer.set_character_axis_offset = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	-- function 23
	local var_23_0 = self._camera_character_position_animation_data[arg_23_1]
	local value

	if not arg_23_3 then
		value = var_23_0.value

		if not value then
			-- Nothing
		end
	end

	value = arg_23_2

	::label_23_0::

	var_23_0.from = value
	var_23_0.to = arg_23_2
	var_23_0.total_time = arg_23_3
	var_23_0.time = 0
	var_23_0.func = arg_23_4
	var_23_0.value = var_23_0.from
end

local tbl_3 = {}

MenuWorldPreviewer.handle_mouse_input = function (self, arg_24_1, arg_24_2)
	-- function 24
	if self.character_unit == nil then
		return
	end

	if not self.input_manager:is_device_active("mouse") then
		return
	end

	local get = arg_24_1:get("cursor")

	if not get then
		return
	end

	local button_hotspot = self.viewport_widget.content.button_hotspot

	if not (not button_hotspot and button_hotspot.is_hover) then
		if not arg_24_1:get("left_press") then
			self.is_moving_camera = true
			self.last_mouse_position = nil
		elseif not arg_24_1:get("right_press") then
			self.camera_xy_angle_target = degrees_to_radians
		end
	end

	local is_moving_camera = self.is_moving_camera
	local get_2 = arg_24_1:get("left_hold")

	if not is_moving_camera and not get_2 then
		if not self.last_mouse_position then
			self.camera_xy_angle_target = self.camera_xy_angle_target - (get.x - self.last_mouse_position[1]) * 0.01
		end

		tbl_3[1] = get.x
		tbl_3[2] = get.y
		self.last_mouse_position = tbl_3
	elseif not is_moving_camera then
		self.is_moving_camera = false
	end
end

MenuWorldPreviewer.handle_controller_input = function (self, arg_25_1, arg_25_2)
	-- function 25
	if self.character_unit == nil then
		return
	end

	if not self.input_manager:is_device_active("gamepad") then
		return
	end

	local get = arg_25_1:get("gamepad_right_axis")

	if not (not get and not (Vector3.length(get) > 0.01)) then
		self.camera_xy_angle_target = self.camera_xy_angle_target + -get.x * arg_25_2 * 5
	end
end

MenuWorldPreviewer.start_character_rotation = function (self, arg_26_1)
	-- function 26
	if not arg_26_1 then
		self.rotation_direction = arg_26_1
	end
end

MenuWorldPreviewer.end_character_rotation = function (self)
	-- function 27
	print("end_character_rotation", self.rotation_direction)
end

MenuWorldPreviewer.request_spawn_hero_unit = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7, arg_28_8)
	-- function 28
	self:clear_asynchronous_data()

	self._requested_hero_spawn_data = {
		frame_delay = 1,
		profile_name = arg_28_1,
		career_index = arg_28_2,
		state_character = arg_28_3,
		callback = arg_28_4,
		optional_scale = arg_28_5,
		camera_move_duration = arg_28_6,
		optional_skin = arg_28_7
	}

	if not self._delayed_spawn then
		self._delayed_hero_spawn_data = table.clone(self._requested_hero_spawn_data)
	end

	self:clear_units(arg_28_8)

	self._draw_character = true
end

MenuWorldPreviewer.request_spawn_unit = function (self, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	local _requested_unit_spawn_queue = self._requested_unit_spawn_queue

	_requested_unit_spawn_queue[#_requested_unit_spawn_queue + 1] = {
		frame_delay = 1,
		unit_name = arg_29_1,
		unit_type = arg_29_2,
		callback = arg_29_3
	}

	if not self._delayed_spawn then
		self._delayed_unit_spawn_queue = table.clone(_requested_unit_spawn_queue)
	end
end

MenuWorldPreviewer._handle_hero_spawn_request = function (self)
	-- function 30
	if not self._requested_hero_spawn_data then
		local _requested_hero_spawn_data = self._requested_hero_spawn_data
		local frame_delay = _requested_hero_spawn_data.frame_delay

		if frame_delay == 0 then
			local profile_name = _requested_hero_spawn_data.profile_name
			local career_index = _requested_hero_spawn_data.career_index
			local state_character = _requested_hero_spawn_data.state_character
			local callback = _requested_hero_spawn_data.callback
			local optional_scale = _requested_hero_spawn_data.optional_scale
			local camera_move_duration = _requested_hero_spawn_data.camera_move_duration
			local optional_skin = _requested_hero_spawn_data.optional_skin

			self:_load_hero_unit(profile_name, career_index, state_character, callback, optional_scale, camera_move_duration, optional_skin)

			self._requested_hero_spawn_data = nil
		else
			_requested_hero_spawn_data.frame_delay = frame_delay - 1
		end
	end
end

MenuWorldPreviewer._handle_unit_spawn_request = function (self)
	-- function 31
	if #self._requested_unit_spawn_queue < 1 then
		return
	end

	local var_31_0 = self._requested_unit_spawn_queue[1]
	local frame_delay = var_31_0.frame_delay

	if frame_delay == 0 then
		self:_spawn_unit(var_31_0.unit_name, var_31_0)
		table.remove(self._requested_unit_spawn_queue, 1)
	else
		var_31_0.frame_delay = frame_delay - 1
	end
end

MenuWorldPreviewer._load_hero_unit = function (self, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6, arg_32_7)
	-- function 32
	self.camera_xy_angle_target = degrees_to_radians

	if not self._delayed_spawn then
		self:_unload_all_packages()
	end

	arg_32_6 = arg_32_6 or 0.01

	local _character_camera_positions = self._character_camera_positions
	local var_32_1 = _character_camera_positions[arg_32_1]

	var_32_1 = var_32_1 or _character_camera_positions.default

	self:set_character_axis_offset("x", var_32_1.x, arg_32_6, math.easeOutCubic)
	self:set_character_axis_offset("y", var_32_1.y, arg_32_6, math.easeOutCubic)
	self:set_character_axis_offset("z", var_32_1.z, arg_32_6, math.easeOutCubic)

	self._camera_move_duration = arg_32_6
	self._current_profile_name = arg_32_1

	local var_32_2 = FindProfileIndex(arg_32_1)
	local var_32_3 = SPProfiles[var_32_2].careers[arg_32_2]
	local name = var_32_3.name
	local get_loadout_item = BackendUtils.get_loadout_item(name, "slot_skin")
	local flag = not get_loadout_item and get_loadout_item.data

	if not arg_32_7 then
		-- Nothing
	end

	do
		local name_2
	end

	::label_32_0::

	if not flag then
		name_2 = flag.name

		if not name_2 then
			-- Nothing
		end
	end

	name_2 = var_32_3.base_skin

	::label_32_1::

	GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", name == "bw_necromancer")

	if not arg_32_3 then
		name_2 = var_32_3.base_skin
	end

	self._current_career_name = name
	self.character_unit_skin_data = nil

	local retrieve_skin_packages_for_preview = CosmeticsUtils.retrieve_skin_packages_for_preview(name_2)
	local var_32_9 = Cosmetics[name_2]

	self._hero_loading_package_data = {
		num_loaded_packages = 0,
		career_name = name,
		skin_data = var_32_9,
		career_index = arg_32_2,
		optional_scale = arg_32_5,
		package_names = retrieve_skin_packages_for_preview,
		num_packages = #retrieve_skin_packages_for_preview,
		callback = arg_32_4
	}, self:_load_packages(retrieve_skin_packages_for_preview)
end

MenuWorldPreviewer._spawn_hero_unit = function (self, arg_33_1, arg_33_2, arg_33_3)
	-- function 33
	MenuWorldPreviewer.super._spawn_hero_unit(self, arg_33_1, arg_33_2, arg_33_3)

	if self._use_highest_mip_levels or not UISettings.wait_for_mip_streaming_character then
		self:_request_mip_streaming_for_unit(self.character_unit)
	end
end

MenuWorldPreviewer.respawn_hero_unit = function (self, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5)
	-- function 34
	local flag = true

	self:request_spawn_hero_unit(arg_34_1, arg_34_2, arg_34_3, arg_34_4, nil, arg_34_5, nil, flag)
end

MenuWorldPreviewer._spawn_item = function (self, arg_35_1, arg_35_2)
	-- function 35
	if not MenuWorldPreviewer.super._spawn_item(self, arg_35_1, arg_35_2) and self._use_highest_mip_levels and not UISettings.wait_for_mip_streaming_character then
		self:_request_mip_streaming_for_unit(self.character_unit)
	end
end

MenuWorldPreviewer._spawn_item_unit = function (self, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7)
	-- function 36
	MenuWorldPreviewer.super._spawn_item_unit(self, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7)

	if self._use_highest_mip_levels or not UISettings.wait_for_mip_streaming_items then
		self:_request_mip_streaming_for_unit(arg_36_1)
	end
end

MenuWorldPreviewer._spawn_unit = function (self, arg_37_1, arg_37_2)
	-- function 37
	local spawn_unit = World.spawn_unit(self.world, arg_37_1)

	self._units[#self._units + 1] = spawn_unit
	self._hidden_units[spawn_unit] = true

	Unit.set_unit_visibility(spawn_unit, false)

	local callback = arg_37_2.callback

	if not callback then
		callback(spawn_unit)
	end
end

MenuWorldPreviewer.set_unit_location = function (arg_38_0, arg_38_1, arg_38_2)
	-- function 38
	if not arg_38_2 and not arg_38_1 and not Unit.alive(arg_38_1) then
		Unit.set_local_position(arg_38_1, 0, Vector3Aux.unbox(arg_38_2))
	end
end

MenuWorldPreviewer._destroy_item_units_by_slot = function (self, arg_39_1)
	-- function 39
	local world = self.world
	local _hidden_units = self._hidden_units
	local _requested_mip_streaming_units = self._requested_mip_streaming_units
	local spawn_data = self._item_info_by_slot[arg_39_1].spawn_data

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
				local var_39_8 = self._equipment_units[slot_index]

				if var_39_8 ~= nil then
					_hidden_units[var_39_8] = nil
					_requested_mip_streaming_units[var_39_8] = nil

					World.destroy_unit(world, var_39_8)

					self._equipment_units[slot_index] = nil
				end
			end
		end
	end
end

MenuWorldPreviewer._reference_name = function (self)
	-- function 40
	local str = "MenuWorldPreviewer"

	if not self.unique_id then
		str = str .. tostring(self.unique_id)
	end

	return str
end

MenuWorldPreviewer.clear_units = function (self, arg_41_1)
	-- function 41
	MenuWorldPreviewer.super.clear_units(self)

	if not arg_41_1 then
		local _default_animation_data = self._default_animation_data

		self:set_character_axis_offset("x", _default_animation_data.x.value, 0.5, math.easeOutCubic)
		self:set_character_axis_offset("y", _default_animation_data.y.value, 0.5, math.easeOutCubic)
		self:set_character_axis_offset("z", _default_animation_data.z.value, 0.5, math.easeOutCubic)
	end

	local _units = self._units

	if not _units then
		for i = 1, #_units do
			World.destroy_unit(self.world, _units[i])
		end
	end

	self._units = {}
end

MenuWorldPreviewer.hide_character = function (self)
	-- function 42
	self._draw_character = false
end

MenuWorldPreviewer.trigger_unit_flow_event = function (arg_43_0, arg_43_1, arg_43_2)
	-- function 43
	if not arg_43_1 and not Unit.alive(arg_43_1) then
		Unit.flow_event(arg_43_1, arg_43_2)
	end
end

MenuWorldPreviewer.trigger_level_flow_event = function (self, arg_44_1)
	-- function 44
	return Level.trigger_event(self.level, arg_44_1)
end
