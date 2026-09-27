-- chunkname: @scripts/unit_extensions/default_player_unit/player_unit_first_person.lua

local testify = script_data.testify

testify = not testify and require("scripts/unit_extensions/default_player_unit/player_unit_first_person_testify")
PlayerUnitFirstPerson = class(PlayerUnitFirstPerson)

local script_data = script_data
local disable_aim_lead_rig_motion = script_data.disable_aim_lead_rig_motion

if not disable_aim_lead_rig_motion then
	disable_aim_lead_rig_motion = Development.parameter("disable_aim_lead_rig_motion")
	disable_aim_lead_rig_motion = disable_aim_lead_rig_motion or true
end

script_data.disable_aim_lead_rig_motion = disable_aim_lead_rig_motion

local alive = Unit.alive
local animation_find_variable = Unit.animation_find_variable
local animation_set_variable = Unit.animation_set_variable
local num = 0.001
local tbl = {
	recentering_lerp_speed = 2,
	camera_look_sensitivity = 1,
	sway_range = 1,
	look_sensitivity = 0.6,
	lerp_speed = math.huge
}

PlayerUnitFirstPerson.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.unit = arg_1_2
	self._nav_world = Managers.state.entity:system("ai_system"):nav_world()

	local profile = arg_1_3.profile
	local skin_name = arg_1_3.skin_name
	local get = Managers.backend:get_interface("hero_attributes"):get(profile.display_name, "career")

	get = get or 1

	local first_person_attachment = Cosmetics[skin_name].first_person_attachment

	first_person_attachment = first_person_attachment or profile.first_person_attachment

	local first_person = Cosmetics[skin_name].first_person

	first_person = first_person or profile.base_units.first_person

	local unit = first_person_attachment.unit
	local attachment_node_linking = first_person_attachment.attachment_node_linking
	local unit_spawner = Managers.state.unit_spawner
	local spawn_local_unit = unit_spawner:spawn_local_unit(first_person)
	local var_1_9 = profile.careers[get]
	local default_state_machine = profile.default_state_machine

	if not default_state_machine then
		Unit.set_animation_state_machine(spawn_local_unit, default_state_machine)
	end

	self.profile = profile
	self.first_person_unit = spawn_local_unit

	Unit.set_flow_variable(spawn_local_unit, "character_vo", profile.character_vo)
	Unit.set_flow_variable(spawn_local_unit, "sound_character", var_1_9.sound_character)
	Unit.flow_event(spawn_local_unit, "character_vo_set")

	self.first_person_attachment_unit = unit_spawner:spawn_local_unit(unit)

	Unit.set_flow_variable(spawn_local_unit, "lua_first_person_mesh_unit", self.first_person_attachment_unit)
	AttachmentUtils.link(arg_1_1.world, self.first_person_unit, self.first_person_attachment_unit, attachment_node_linking)

	self.first_person_mode = true
	self._show_first_person_units = true
	self._anim_var_id_lookup = {}
	self._anim_var_values = {}
	self.look_position = Vector3Box(Unit.local_position(arg_1_2, 0))
	self.look_rotation = QuaternionBox(Unit.local_rotation(arg_1_2, 0))
	self.forced_look_rotation = nil
	self.forced_lerp_time = nil

	Unit.set_local_position(spawn_local_unit, 0, Unit.local_position(arg_1_2, 0))
	Unit.set_local_rotation(spawn_local_unit, 0, Unit.local_rotation(arg_1_2, 0))

	self.has_look_delta = false
	self.look_delta = Vector3Box()
	self.player_height_wanted = self:_player_height_from_name("stand")
	self.player_height_current = self.player_height_wanted
	self.player_height_previous = self.player_height_wanted
	self.player_height_time_to_change = 0.001
	self.player_height_change_start_time = 0
	self.hide_weapon_reasons = {}
	self.hide_weapon_lights_reasons = {}

	local num = math.pi / 15

	self.MAX_MIN_PITCH = math.pi / 2 - num
	self.drawer = Managers.state.debug:drawer({
		mode = "immediate",
		name = "PlayerUnitFirstPerson"
	})
	self._head_bob = true
	self._game_options_dirty = true
	self.aim_assist_multiplier = 1
	self.aim_assist_ramp_multiplier = 0
	self.aim_assist_ramp_multiplier_timer = 0

	if not Unit.animation_has_constraint_target(spawn_local_unit, "aim_target") then
		self._aim_target_index = Unit.animation_find_constraint_target(spawn_local_unit, "aim_target")
	end

	if not script_data.disable_aim_lead_rig_motion then
		self:disable_rig_movement()
	else
		self:enable_rig_movement()
	end

	self._rig_update_timestep = 0.016666666666666666
	self._show_selected_jump = Managers.state.game_mode:setting("show_selected_jump")
	self._current_jump_id = nil
	self._move_y = 0
	self._move_x = 0
	self._move_z = 0
	self._look_delta_y = 0
	self._look_delta_x = 0
	self._look_target_y = 0
	self._look_target_x = 0
	self._look_sensitivity = 1

	Managers.state.event:register(self, "on_game_options_changed", "_set_game_options_dirty")
	self:update_game_options()
	self:animation_set_variable("career_index", get)
	self:animation_set_variable("profile_index", profile.index)

	local animation_variables = var_1_9.animation_variables

	if not animation_variables then
		for k, v in pairs(animation_variables) do
			self:animation_set_variable(k, v)
		end
	end

	local career_name = ScriptUnit.extension(arg_1_2, "career_system"):career_name()

	Wwise.set_state("current_career", career_name)
end

PlayerUnitFirstPerson.reset = function (arg_2_0)
	-- function 2
	return
end

PlayerUnitFirstPerson.extensions_ready = function (self)
	-- function 3
	local unit = self.unit

	self.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	self.inventory_extension = ScriptUnit.extension(unit, "inventory_system")
	self.attachment_extension = ScriptUnit.extension(unit, "attachment_system")
	self.smart_targeting_extension = ScriptUnit.extension(unit, "smart_targeting_system")
	self.input_extension = ScriptUnit.extension(unit, "input_system")
	self.cosmetic_extension = ScriptUnit.extension(unit, "cosmetic_system")

	local career_name = ScriptUnit.extension(unit, "career_system"):career_name()

	Unit.set_flow_variable(self.first_person_unit, "lua_career_name", career_name)

	if not script_data.debug_third_person then
		self:set_first_person_mode(false)
	else
		self.cosmetic_extension:show_third_person_mesh(false)
	end
end

PlayerUnitFirstPerson.destroy = function (self)
	-- function 4
	AttachmentUtils.unlink(self.world, self.first_person_attachment_unit)

	local unit_spawner = Managers.state.unit_spawner

	unit_spawner:mark_for_deletion(self.first_person_unit)
	unit_spawner:mark_for_deletion(self.first_person_attachment_unit)
	Managers.state.event:unregister("on_game_options_changed", self)
end

PlayerUnitFirstPerson.set_state_machine = function (self, arg_5_1)
	-- function 5
	if arg_5_1 == self._current_state_machine then
		return
	end

	local first_person_unit = self.first_person_unit

	Unit.set_animation_state_machine_blend_base_layer(first_person_unit, arg_5_1)

	if not self.profile.supports_motion_sickness_modes then
		local animation_event = Unit.animation_event
		local var_5_2 = first_person_unit
		local flag

		flag = not self._head_bob and "enable_headbob" and "disable_headbob"

		animation_event(var_5_2, flag)
		Unit.animation_event(first_person_unit, "motion_sickness_hit_" .. self._motion_sickness_hit)
		Unit.animation_event(first_person_unit, "motion_sickness_swing_" .. self._motion_sickness_swing)
		Unit.animation_event(first_person_unit, "motion_sickness_misc_" .. self._motion_sickness_misc_cam)

		if not (self._motion_sickness_swing ~= "off" or self._motion_sickness_hit ~= "off") then
			Unit.animation_event(first_person_unit, "motion_sickness_both_muted")
		end
	end

	table.clear(self._anim_var_id_lookup)

	for k, v in pairs(self._anim_var_values) do
		self:animation_set_variable(k, v)
	end

	self._current_state_machine = arg_5_1
end

PlayerUnitFirstPerson._set_game_options_dirty = function (self)
	-- function 6
	self._game_options_dirty = true
end

PlayerUnitFirstPerson.update_game_options = function (self)
	-- function 7
	if not self._game_options_dirty then
		return
	end

	local user_setting = Application.user_setting("head_bob")

	if self._head_bob ~= user_setting then
		local animation_event = Unit.animation_event
		local first_person_unit = self.first_person_unit
		local flag

		flag = not user_setting and "enable_headbob" and "disable_headbob"

		animation_event(first_person_unit, flag)

		self._head_bob = user_setting
	end

	if not self.profile.supports_motion_sickness_modes then
		local user_setting_2 = Application.user_setting("motion_sickness_hit")

		if self._motion_sickness_hit ~= user_setting_2 then
			local str = "motion_sickness_hit_" .. user_setting_2

			Unit.animation_event(self.first_person_unit, str)

			self._motion_sickness_hit = user_setting_2
		end

		local user_setting_3 = Application.user_setting("motion_sickness_swing")

		if self._motion_sickness_swing ~= user_setting_3 then
			local str_2 = "motion_sickness_swing_" .. user_setting_3

			Unit.animation_event(self.first_person_unit, str_2)

			self._motion_sickness_swing = user_setting_3
		end

		if not (user_setting_3 ~= "off" or user_setting_2 ~= "off") then
			Unit.animation_event(self.first_person_unit, "motion_sickness_both_muted")
		end

		local user_setting_4 = Application.user_setting("motion_sickness_misc_cam")

		if self._motion_sickness_misc_cam ~= user_setting_4 then
			local str_3 = "motion_sickness_misc_" .. user_setting_4

			Unit.animation_event(self.first_person_unit, str_3)

			self._motion_sickness_misc_cam = user_setting_4
		end
	end

	self._gamepad_auto_aim_enabled = Application.user_setting("gamepad_auto_aim_enabled")

	local var_7_10

	if not Application.user_setting("tobii_eyetracking") then
		var_7_10 = ScriptUnit.has_extension(self.unit, "eyetracking_system")
	end

	self._eyetracking_extension = var_7_10

	local user_setting_5 = Application.user_setting("weapon_trails")

	Unit.set_data(self.first_person_unit, "trails_enabled", user_setting_5 ~= "none")

	self._game_options_dirty = false
end

local tbl_2 = {}

PlayerUnitFirstPerson.check_for_jumps = function (self, arg_8_1, arg_8_2)
	-- function 8
	local var_8_0 = POSITION_LOOKUP[arg_8_1]
	local system = Managers.state.entity:system("nav_graph_system")
	local jumps_broadphase_max_dist = system.jumps_broadphase_max_dist
	local jumps_broadphase = system.jumps_broadphase
	local query = Broadphase.query(jumps_broadphase, var_8_0, jumps_broadphase_max_dist, tbl_2)

	if query <= 0 then
		return
	end

	local world = self.world
	local level_jumps = system.level_jumps
	local viewport_name = Managers.player:owner(self.unit).viewport_name
	local viewport = ScriptWorld.viewport(self.world, viewport_name)
	local camera = ScriptViewport.camera(viewport)
	local position = ScriptCamera.position(camera)
	local rotation = ScriptCamera.rotation(camera)
	local forward = Quaternion.forward(rotation)
	local var_8_13
	local var_8_14
	local num = 0

	for i = 1, query do
		local var_8_16 = tbl_2[i]
		local var_8_17 = level_jumps[var_8_16]
		local jump_object_data = var_8_17.jump_object_data
		local pos1

		if not var_8_17.swap_entrance_exit then
			pos1 = jump_object_data.pos1

			if not pos1 then
				-- Nothing
			end
		end

		pos1 = jump_object_data.pos2

		::label_8_0::

		local var_8_20 = Vector3(pos1[1], pos1[2], pos1[3])
		local normalize = Vector3.normalize(Vector3.flat(var_8_20 - position))
		local dot = Vector3.dot(normalize, forward)
		local flag = dot > 0.25
		local distance = Vector3.distance(var_8_20, var_8_0)

		if not (flag or not (distance < 0.25)) then
			local clamp = math.clamp(distance, 1, 5)
			local num_2 = dot + 1.15 / (clamp * clamp)

			if not (not (num < num_2) or not (distance < 2)) then
				num = num_2

				local var_8_27 = var_8_20

				var_8_13 = var_8_16
			end
		end
	end

	if not var_8_13 then
		if var_8_13 ~= self._current_jump_id then
			self._current_jump_id = var_8_13

			local var_8_28 = level_jumps[var_8_13]

			if not var_8_28 then
				local jump_object_data_2 = var_8_28.jump_object_data
				local unbox = Vector3Aux.unbox(jump_object_data_2.pos1)
				local unbox_2 = Vector3Aux.unbox(jump_object_data_2.pos2)

				self._valid_jump_id = var_8_13
				self._valid_jump_data = var_8_28

				local num_3

				if not var_8_28.swap_entrance_exit then
					num_3 = unbox_2 - unbox

					if not num_3 then
						-- Nothing
					end
				end

				num_3 = unbox - unbox_2

				::label_8_1::

				local flat = Vector3.flat(num_3)
				local look = Quaternion.look(flat)

				if not self._indicator_unit then
					Unit.flow_event(self._indicator_unit, "disable_glow")
				end

				if not self._show_selected_jump then
					self._indicator_unit = var_8_28.unit
				end

				if not self._show_selected_jump and not self._indicator_unit then
					Unit.flow_event(self._indicator_unit, "enable_glow")
				end
			end
		end
	else
		self:_reset_jump_indicator()
	end
end

PlayerUnitFirstPerson._reset_jump_indicator = function (self)
	-- function 9
	self._valid_jump_id = nil
	self._valid_jump_data = nil

	if not self._indicator_unit and not alive(self._indicator_unit) then
		Unit.flow_event(self._indicator_unit, "disable_glow")

		self._indicator_unit = nil
	end

	self._current_jump_id = nil
end

local tbl_3 = {}

PlayerUnitFirstPerson._draw_smart_objects = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	if not arg_10_1 then
		return
	end

	local jump_object_data = arg_10_1.jump_object_data
	local smart_object_type = jump_object_data.smart_object_type

	tbl_3[1] = Vector3Aux.unbox(jump_object_data.pos1)
	tbl_3[2] = Vector3Aux.unbox(jump_object_data.pos2)

	local clamp = math.clamp(1 - arg_10_3 / arg_10_4, 0, 1)
	local clamp_2 = math.clamp(255 * clamp, 1, 255)
	local drawer = Managers.state.debug:drawer({
		mode = "immediate",
		name = "DarkPactPlayerJumpDrawer"
	})
	local var_10_5 = Color(clamp_2, 127, 255, 212)

	if not (smart_object_type == "ledges" or smart_object_type ~= "ledges_with_fence") then
		if not jump_object_data.data.ledge_position1 then
			drawer:line(tbl_3[1], Vector3Aux.unbox(jump_object_data.data.ledge_position1), var_10_5)
			drawer:line(Vector3Aux.unbox(jump_object_data.data.ledge_position1), Vector3Aux.unbox(jump_object_data.data.ledge_position2), var_10_5)
			drawer:line(tbl_3[2], Vector3Aux.unbox(jump_object_data.data.ledge_position2), var_10_5)
		else
			drawer:line(tbl_3[1], Vector3Aux.unbox(jump_object_data.data.ledge_position), var_10_5)
			drawer:line(tbl_3[2], Vector3Aux.unbox(jump_object_data.data.ledge_position), var_10_5)
		end

		if not jump_object_data.data.is_bidirectional then
			drawer:vector(tbl_3[1], Vector3.up(), var_10_5)
		end
	elseif smart_object_type == "jumps" then
		drawer:line(tbl_3[1], tbl_3[2], var_10_5)
	else
		drawer:line(tbl_3[1], tbl_3[2], var_10_5)
	end

	local _nav_world = self._nav_world

	if not GwNavQueries.triangle_from_position(_nav_world, tbl_3[1]) then
		drawer:sphere(tbl_3[1], 0.02, var_10_5)
	end

	if not GwNavQueries.triangle_from_position(_nav_world, tbl_3[2]) then
		drawer:sphere(tbl_3[2], 0.02, var_10_5)
	end
end

PlayerUnitFirstPerson.get_valid_jump_id = function (self)
	-- function 11
	return self._valid_jump_id, self._valid_jump_data
end

PlayerUnitFirstPerson.update = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	-- function 12
	if not Managers.input:is_device_active("gamepad") then
		self:update_aim_assist_multiplier(arg_12_3)
	end

	self:update_game_options(arg_12_3, arg_12_5)
	self:update_player_height(arg_12_5)
	self:update_rotation(arg_12_5, arg_12_3)
	self:update_position()

	local owner = Managers.player:owner(arg_12_1)

	if not (not self.toggle_visibility_timer and not (arg_12_5 >= self.toggle_visibility_timer)) then
		self.toggle_visibility_timer = nil

		self:set_first_person_mode(not self.first_person_mode)
	end

	if not (not self._first_person_units_visibility_timer and not (arg_12_5 >= self._first_person_units_visibility_timer)) then
		self:toggle_first_person_units_visibility(self._first_person_units_visibility_reason)
	end

	if self._want_to_show_first_person_ammo ~= nil then
		local _show_first_person_units = self._show_first_person_units
		local _want_to_show_first_person_ammo = self._want_to_show_first_person_ammo

		if not _show_first_person_units and not _want_to_show_first_person_ammo then
			self.inventory_extension:show_first_person_inventory(true)

			self._want_to_show_first_person_ammo = nil
		elseif not (not _show_first_person_units and _want_to_show_first_person_ammo) then
			self.inventory_extension:show_first_person_inventory(false)

			self._want_to_show_first_person_ammo = nil
		elseif _show_first_person_units or not _want_to_show_first_person_ammo then
			-- Nothing
		elseif not (_show_first_person_units or _want_to_show_first_person_ammo) then
			self.inventory_extension:show_first_person_inventory(false)

			self._want_to_show_first_person_ammo = nil
		end
	end

	if not script_data.attract_mode_spectate and not self.first_person_mode then
		CharacterStateHelper.change_camera_state(Managers.player:local_player(), "attract")
		self:set_first_person_mode(false, true)
	end

	if not self.first_person_unit then
		self:_update_state_machine_variables(arg_12_3, arg_12_5)
	end

	if not self._check_for_jumps then
		self:check_for_jumps(arg_12_1, arg_12_5)
	end

	if not script_data.testify then
		Testify:poll_requests_through_handler(testify, self)
	end
end

PlayerUnitFirstPerson.update_aim_assist_multiplier = function (self, arg_13_1)
	-- function 13
	if not self._gamepad_auto_aim_enabled then
		local inventory_extension = self.inventory_extension
		local var_13_1
		local equipment = inventory_extension:equipment()
		local right_hand_wielded_unit = equipment.right_hand_wielded_unit

		right_hand_wielded_unit = right_hand_wielded_unit or equipment.left_hand_wielded_unit

		if not Unit.alive(right_hand_wielded_unit) then
			local extension = ScriptUnit.extension(right_hand_wielded_unit, "weapon_system")

			if not extension:has_current_action() then
				var_13_1 = extension:get_current_action_settings()
			end
		end

		local get_wielded_slot_item_template = inventory_extension:get_wielded_slot_item_template()
		local var_13_6

		if not var_13_1 and not var_13_1.aim_assist_settings then
			var_13_6 = var_13_1.aim_assist_settings
		else
			var_13_6 = not get_wielded_slot_item_template and get_wielded_slot_item_template.aim_assist_settings
		end

		local base_multiplier

		if not var_13_6 then
			base_multiplier = var_13_6.base_multiplier

			if not base_multiplier then
				-- Nothing
			end
		end

		base_multiplier = 0

		do
			local no_aim_input_multiplier
		end

		::label_13_0::

		if not var_13_6 then
			no_aim_input_multiplier = var_13_6.no_aim_input_multiplier

			if not no_aim_input_multiplier then
				-- Nothing
			end
		end

		no_aim_input_multiplier = base_multiplier * 0.5

		::label_13_1::

		local input_extension = self.input_extension
		local get = input_extension:get("look_raw_controller")
		local get_2 = input_extension:get("move_controller")
		local flag = true

		if not (not var_13_6 and var_13_6.always_auto_aim and not (Vector3.length(get) < 0.01)) then
			base_multiplier = no_aim_input_multiplier

			if Vector3.length(get_2) < 0.01 then
				flag = false
			end
		end

		local max = math.max(self.aim_assist_ramp_multiplier_timer - arg_13_1, 0)
		local var_13_14

		if max > 0 then
			var_13_14 = self.aim_assist_ramp_multiplier
		else
			var_13_14 = math.max(self.aim_assist_ramp_multiplier - arg_13_1, 0)
		end

		local min

		if not flag then
			min = math.min(base_multiplier + var_13_14, 1)

			if not min then
				-- Nothing
			end
		end

		min = 0

		::label_13_2::

		self.aim_assist_multiplier = min
		self.aim_assist_ramp_multiplier = var_13_14
		self.aim_assist_ramp_multiplier_timer = max
	else
		self.aim_assist_multiplier = 0
		self.aim_assist_ramp_multiplier = 0
		self.aim_assist_ramp_multiplier_timer = 0
	end
end

PlayerUnitFirstPerson.increase_aim_assist_multiplier = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	self.aim_assist_ramp_multiplier_timer, self.aim_assist_ramp_multiplier = arg_14_3 or 2, math.min(self.aim_assist_ramp_multiplier + arg_14_1, arg_14_2)
end

PlayerUnitFirstPerson.reset_aim_assist_multiplier = function (self)
	-- function 15
	self.aim_assist_ramp_multiplier = 0
	self.aim_assist_ramp_multiplier_timer = 0
end

local function fn(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	arg_16_0 = arg_16_0 / arg_16_3

	return -arg_16_2 * arg_16_0 * (arg_16_0 - 2) + arg_16_1
end

PlayerUnitFirstPerson.update_player_height = function (self, arg_17_1)
	-- function 17
	local num = arg_17_1 - self.player_height_change_start_time

	if num < self.player_height_time_to_change then
		self.player_height_current = fn(num, self.player_height_previous, self.player_height_wanted - self.player_height_previous, self.player_height_time_to_change)
	else
		self.player_height_current = self.player_height_wanted
	end
end

PlayerUnitFirstPerson.set_rotation = function (self, arg_18_1)
	-- function 18
	Unit.set_local_rotation(self.first_person_unit, 0, arg_18_1)
	Unit.set_local_rotation(self.unit, 0, arg_18_1)
	self.look_rotation:store(arg_18_1)
end

PlayerUnitFirstPerson.force_look_rotation = function (self, arg_19_1, arg_19_2)
	-- function 19
	self.forced_look_rotation = QuaternionBox(arg_19_1)
	self.forced_lerp_timer = 0
	self.forced_total_lerp_time = arg_19_2
end

PlayerUnitFirstPerson.stop_force_look_rotation = function (self)
	-- function 20
	self.forced_look_rotation = nil
	self.forced_lerp_timer = 0
	self.forced_lerp_time = nil
end

PlayerUnitFirstPerson.update_rotation = function (self, arg_21_1, arg_21_2)
	-- function 21
	local first_person_unit = self.first_person_unit
	local get_targeting_data = self.smart_targeting_extension:get_targeting_data()

	if self.forced_look_rotation ~= nil then
		local forced_total_lerp_time = self.forced_total_lerp_time

		forced_total_lerp_time = forced_total_lerp_time or 0.3
		self.forced_lerp_timer = self.forced_lerp_timer + arg_21_2

		local num = 1 - self.forced_lerp_timer / forced_total_lerp_time
		local num_2 = 1 - num * num
		local lerp = Quaternion.lerp(self.look_rotation:unbox(), self.forced_look_rotation:unbox(), num_2)
		local yaw = Quaternion.yaw(lerp)
		local clamp = math.clamp(Quaternion.pitch(lerp), -self.MAX_MIN_PITCH, self.MAX_MIN_PITCH)
		local roll = Quaternion.roll(lerp)
		local var_21_9 = Quaternion(Vector3.up(), yaw)
		local var_21_10 = Quaternion(Vector3.right(), clamp)
		local var_21_11 = Quaternion(Vector3.forward(), roll)
		local multiply = Quaternion.multiply(var_21_9, var_21_10)
		local multiply_2 = Quaternion.multiply(multiply, var_21_11)

		self.look_rotation:store(multiply_2)

		local first_person_unit_2 = self.first_person_unit

		Unit.set_local_rotation(first_person_unit_2, 0, multiply_2)

		if forced_total_lerp_time <= self.forced_lerp_timer then
			self.has_look_delta = false
			self.forced_look_rotation = nil
			self.forced_lerp_time = nil
		end
	elseif not self.has_look_delta then
		local unit = get_targeting_data.unit
		local unbox = self.look_rotation:unbox()
		local unbox_2 = self.look_delta:unbox()

		self.has_look_delta = false

		local _weapon_sway_settings = self._weapon_sway_settings

		_weapon_sway_settings = _weapon_sway_settings or tbl

		local camera_look_sensitivity = _weapon_sway_settings.camera_look_sensitivity

		camera_look_sensitivity = camera_look_sensitivity or 1

		local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(self.unit)
		local look_input_limit = get_movement_settings_table.look_input_limit

		if look_input_limit ~= -1 then
			local num_3 = look_input_limit * get_movement_settings_table.look_input_limit_multiplier * arg_21_2
			local length = Vector3.length(unbox_2)

			if num_3 < length then
				unbox_2 = unbox_2 * (num_3 / length)
			end
		end

		local calculate_look_rotation = self:calculate_look_rotation(unbox, unbox_2 * camera_look_sensitivity, arg_21_2)

		if not unit and not Managers.input:is_device_active("gamepad") then
			calculate_look_rotation = self:calculate_aim_assisted_rotation(calculate_look_rotation, get_targeting_data, unbox_2, arg_21_2)
		end

		if not MotionControlSettings.use_motion_controls and not self.input_extension:get("reset_view") then
			local forward, var_21_26 = Quaternion.forward(calculate_look_rotation)
			local normalize = Vector3.normalize(Vector3.flat(forward))

			calculate_look_rotation = Quaternion.look(normalize, Vector3.up())
		end

		self.look_rotation:store(calculate_look_rotation)

		local first_person_unit_3 = self.first_person_unit
		local is_recoiling, var_21_30 = Managers.state.camera:is_recoiling()

		if not is_recoiling and not var_21_30 then
			calculate_look_rotation = Quaternion.multiply(calculate_look_rotation, var_21_30:unbox())
		end

		Unit.set_local_rotation(first_person_unit_3, 0, calculate_look_rotation)
		self:update_rig_movement(unbox_2)
	end
end

PlayerUnitFirstPerson.tutorial_restrict_camera_rotation = function (self, arg_22_1, arg_22_2)
	-- function 22
	if not arg_22_1 then
		self.restrict_rotation_angle = math.degrees_to_radians(arg_22_2)
	else
		self.restrict_rotation_angle = nil
	end
end

PlayerUnitFirstPerson.calculate_look_rotation = function (self, arg_23_1, arg_23_2)
	-- function 23
	local num = Quaternion.yaw(arg_23_1) - arg_23_2.x

	if not self.restrict_rotation_angle then
		num = math.clamp(num, -self.restrict_rotation_angle, self.restrict_rotation_angle)
	end

	local clamp = math.clamp(Quaternion.pitch(arg_23_1) + arg_23_2.y, -self.MAX_MIN_PITCH, self.MAX_MIN_PITCH)
	local var_23_2 = Quaternion(Vector3.up(), num)
	local var_23_3 = Quaternion(Vector3.right(), clamp)

	return (Quaternion.multiply(var_23_2, var_23_3))
end

PlayerUnitFirstPerson.calculate_aim_assisted_rotation = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	-- function 24
	local unit = arg_24_2.unit
	local num = arg_24_2.target_position - self:current_position()
	local look = Quaternion.look(num, Vector3.up())
	local aim_score = arg_24_2.aim_score
	local aim_assist_multiplier = self.aim_assist_multiplier
	local flag = not arg_24_2.vertical_only and arg_24_1 and Quaternion.lerp(arg_24_1, look, arg_24_4 * 33 * aim_score * aim_assist_multiplier)
	local lerp = Quaternion.lerp(arg_24_1, look, aim_assist_multiplier * 0.5 * arg_24_4 * 33 * aim_score * aim_assist_multiplier)
	local yaw = Quaternion.yaw(flag)
	local pitch = Quaternion.pitch(lerp)
	local var_24_9 = Quaternion(Vector3.up(), yaw)
	local var_24_10 = Quaternion(Vector3.right(), pitch)

	return (Quaternion.multiply(var_24_9, var_24_10))
end

PlayerUnitFirstPerson.update_position = function (self)
	-- function 25
	local num = Unit.local_position(self.unit, 0) + Vector3(0, 0, self.player_height_current)

	Unit.set_local_position(self.first_person_unit, 0, num)
end

PlayerUnitFirstPerson.is_in_view = function (self, arg_26_1)
	-- function 26
	local viewport_name = Managers.player:owner(self.unit).viewport_name

	Managers.state.camera:is_in_view(viewport_name, arg_26_1)
end

PlayerUnitFirstPerson.is_infront = function (self, arg_27_1, arg_27_2)
	-- function 27
	local viewport_name = Managers.player:owner(self.unit).viewport_name
	local viewport = ScriptWorld.viewport(self.world, viewport_name)
	local camera = ScriptViewport.camera(viewport)
	local position = ScriptCamera.position(camera)
	local rotation = ScriptCamera.rotation(camera)
	local normalize = Vector3.normalize(Quaternion.forward(rotation))
	local normalize_2 = Vector3.normalize(arg_27_1 - position)

	return Vector3.dot(normalize_2, normalize) > (arg_27_2 or 0)
end

PlayerUnitFirstPerson.is_within_custom_view = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	-- function 28
	return math.point_is_inside_view(arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
end

PlayerUnitFirstPerson.is_within_default_view = function (self, arg_29_1)
	-- function 29
	local camera_position_rotation, var_29_1 = self:camera_position_rotation()
	local num = CameraSettings.first_person._node.vertical_fov * math.pi / 180
	local num_2 = num * 1.7777777777777777

	return math.point_is_inside_view(arg_29_1, camera_position_rotation, var_29_1, num, num_2)
end

PlayerUnitFirstPerson.apply_recoil = function (self, arg_30_1)
	-- function 30
	local viewport_name = Managers.player:owner(self.unit).viewport_name
	local viewport = ScriptWorld.viewport(self.world, viewport_name)
	local camera = ScriptViewport.camera(viewport)
	local rotation = ScriptCamera.rotation(camera)
	local unbox = self.look_rotation:unbox()
	local is_recoiling, var_30_6 = Managers.state.camera:is_recoiling()

	if not is_recoiling and not var_30_6 then
		rotation = Quaternion.multiply(unbox, var_30_6:unbox())
	end

	local _eyetracking_extension = self._eyetracking_extension

	if not self._eyetracking_extension and not _eyetracking_extension:get_is_feature_enabled("tobii_extended_view") then
		rotation = _eyetracking_extension:get_direction_without_extended_view(rotation)
	end

	local lerp = Quaternion.lerp(unbox, rotation, arg_30_1 or 1)

	Unit.set_local_rotation(self.first_person_unit, 0, lerp)
	self.look_rotation:store(lerp)
end

PlayerUnitFirstPerson.get_first_person_unit = function (self)
	-- function 31
	return self.first_person_unit
end

PlayerUnitFirstPerson.get_first_person_mesh_unit = function (self)
	-- function 32
	return self.first_person_attachment_unit
end

PlayerUnitFirstPerson.set_look_delta = function (self, arg_33_1)
	-- function 33
	if not Vector3.is_valid(arg_33_1) then
		print("HON-18240; set_look_delta called after PlayerUnitFirstPerson update")
		print(Script.callstack())
	end

	Vector3Box.store(self.look_delta, arg_33_1)

	self.has_look_delta = true
end

PlayerUnitFirstPerson.set_weapon_sway_settings = function (self, arg_34_1)
	-- function 34
	self._weapon_sway_settings = arg_34_1
end

PlayerUnitFirstPerson.play_animation_event = function (self, arg_35_1)
	-- function 35
	Unit.animation_event(self.first_person_unit, arg_35_1)
end

PlayerUnitFirstPerson.set_aim_constraint_target = function (self, arg_36_1, arg_36_2)
	-- function 36
	local animation_find_constraint_target = Unit.animation_find_constraint_target(self.first_person_unit, arg_36_1)

	Unit.animation_set_constraint_target(self.first_person_unit, animation_find_constraint_target, arg_36_2)
end

PlayerUnitFirstPerson.current_rotation = function (self)
	-- function 37
	return Unit.local_rotation(self.first_person_unit, 0)
end

PlayerUnitFirstPerson.current_position = function (self)
	-- function 38
	return Unit.local_position(self.first_person_unit, 0)
end

PlayerUnitFirstPerson.camera_position_rotation = function (self)
	-- function 39
	local viewport_name = Managers.player:owner(self.unit).viewport_name
	local viewport = ScriptWorld.viewport(self.world, viewport_name)
	local camera = ScriptViewport.camera(viewport)
	local position = ScriptCamera.position(camera)
	local rotation = ScriptCamera.rotation(camera)

	return position, rotation
end

PlayerUnitFirstPerson.camera = function (self)
	-- function 40
	local viewport_name = Managers.player:owner(self.unit).viewport_name
	local viewport = ScriptWorld.viewport(self.world, viewport_name)

	return ScriptViewport.camera(viewport)
end

PlayerUnitFirstPerson.get_projectile_start_position_rotation = function (self)
	-- function 41
	local var_41_0

	if not self:first_person_mode_active() then
		local viewport_name = Managers.player:owner(self.unit).viewport_name
		local viewport = ScriptWorld.viewport(self.world, viewport_name)
		local camera = ScriptViewport.camera(viewport)

		var_41_0 = ScriptCamera.position(camera)
	else
		var_41_0 = self:current_position()
	end

	local current_rotation = self:current_rotation()

	return var_41_0, current_rotation
end

PlayerUnitFirstPerson.set_wanted_player_height = function (self, arg_42_1, arg_42_2, arg_42_3)
	-- function 42
	local _player_height_from_name = self:_player_height_from_name(arg_42_1)
	local num = 3

	self.player_height_wanted = _player_height_from_name
	self.player_height_previous = self.player_height_current

	if arg_42_3 == nil then
		arg_42_3 = math.abs(_player_height_from_name - self.player_height_previous) / num
		arg_42_3 = math.clamp(arg_42_3, 0.001, 1000)
	end

	self.player_height_time_to_change = arg_42_3
	self.player_height_change_start_time = arg_42_2
end

PlayerUnitFirstPerson._player_height_from_name = function (self, arg_43_1)
	-- function 43
	return self.profile.first_person_heights[arg_43_1]
end

PlayerUnitFirstPerson.toggle_visibility = function (self, arg_44_1)
	-- function 44
	local time = Managers.time:time("game")

	if not self.toggle_visibility_timer then
		self:set_first_person_mode(not self.first_person_mode)
	end

	if not arg_44_1 then
		self.toggle_visibility_timer = time + arg_44_1
	else
		self:set_first_person_mode(not self.first_person_mode)
	end
end

PlayerUnitFirstPerson.set_first_person_mode = function (self, arg_45_1, arg_45_2, arg_45_3)
	-- function 45
	if not ((self.debug_first_person_mode or arg_45_2 or not Development.parameter("third_person_mode")) and Development.parameter("attract_mode")) then
		if self.first_person_mode ~= arg_45_1 then
			self.cosmetic_extension:show_third_person_mesh(not arg_45_1)

			if not self.tutorial_first_person then
				Unit.set_unit_visibility(self.first_person_attachment_unit, arg_45_1)
			end
		end

		if not arg_45_1 then
			self:unhide_weapons("third_person_mode")

			if self.first_person_mode ~= arg_45_1 then
				Unit.flow_event(self.first_person_unit, "lua_exit_third_person_camera")
			end
		else
			self:hide_weapons("third_person_mode", true)

			if self.first_person_mode ~= arg_45_1 then
				Unit.flow_event(self.first_person_unit, "lua_enter_third_person_camera")
			end
		end

		self.inventory_extension:show_third_person_inventory(not not arg_45_1 or not arg_45_3)
		self.attachment_extension:show_attachments(not arg_45_1)
	end

	self:abort_toggle_visibility_timer()
	self:abort_first_person_units_visibility_timer()

	self.first_person_mode = arg_45_1
	self._show_first_person_units = arg_45_1
end

PlayerUnitFirstPerson.show_third_person_units = function (self, arg_46_1)
	-- function 46
	self.inventory_extension:show_third_person_inventory(arg_46_1)
	self.attachment_extension:show_attachments(arg_46_1)
	self.cosmetic_extension:show_third_person_mesh(arg_46_1)
end

PlayerUnitFirstPerson.first_person_mode_active = function (self)
	-- function 47
	return self.first_person_mode
end

PlayerUnitFirstPerson.abort_toggle_visibility_timer = function (self)
	-- function 48
	self.toggle_visibility_timer = nil
end

PlayerUnitFirstPerson.first_person_units_visible = function (self)
	-- function 49
	return self._show_first_person_units
end

PlayerUnitFirstPerson.abort_first_person_units_visibility_timer = function (self)
	-- function 50
	self._first_person_units_visibility_timer = nil
	self._first_person_units_visibility_reason = nil
end

PlayerUnitFirstPerson.toggle_first_person_units_visibility = function (self, arg_51_1, arg_51_2)
	-- function 51
	if not arg_51_2 then
		self._first_person_units_visibility_timer = Managers.time:time("game") + arg_51_2
		self._first_person_units_visibility_reason = arg_51_1
	else
		local flag = not self._show_first_person_units

		self._first_person_units_visibility_timer = nil
		self._first_person_units_visibility_reason = nil
		self._show_first_person_units = flag

		Unit.set_unit_visibility(self.first_person_attachment_unit, flag)

		if not flag then
			self:unhide_weapons(arg_51_1)
		else
			self:hide_weapons(arg_51_1, flag)
		end
	end
end

PlayerUnitFirstPerson.tutorial_show_first_person_units = function (self, arg_52_1)
	-- function 52
	Unit.set_unit_visibility(self.first_person_attachment_unit, arg_52_1)

	self.tutorial_first_person = not arg_52_1

	if not arg_52_1 then
		self:unhide_weapons("tutorial")
	else
		self:hide_weapons("tutorial", arg_52_1)
	end
end

PlayerUnitFirstPerson.debug_set_first_person_mode = function (self, arg_53_1, arg_53_2)
	-- function 53
	local first_person_mode = self.first_person_mode

	if not arg_53_1 then
		self.debug_first_person_mode = false

		self:set_first_person_mode(arg_53_2)

		self.first_person_mode = first_person_mode
		self.debug_first_person_mode = true
	else
		self.debug_first_person_mode = false

		self:set_first_person_mode(first_person_mode)
	end
end

PlayerUnitFirstPerson.hide_weapons = function (self, arg_54_1, arg_54_2)
	-- function 54
	self.hide_weapon_reasons[arg_54_1] = true

	if not table.is_empty(self.hide_weapon_reasons) then
		self.inventory_extension:show_first_person_inventory(false)
	end

	if not arg_54_2 then
		self.hide_weapon_lights_reasons[arg_54_1] = true

		if not table.is_empty(self.hide_weapon_lights_reasons) then
			self.inventory_extension:show_first_person_inventory_lights(false)
		end
	end
end

PlayerUnitFirstPerson.unhide_weapons = function (self, arg_55_1)
	-- function 55
	self.hide_weapon_reasons[arg_55_1] = nil
	self.hide_weapon_lights_reasons[arg_55_1] = nil

	if not table.is_empty(self.hide_weapon_reasons) then
		self.inventory_extension:show_first_person_inventory(true)
	end

	if not table.is_empty(self.hide_weapon_lights_reasons) then
		self.inventory_extension:show_first_person_inventory_lights(true)
	end
end

PlayerUnitFirstPerson.show_first_person_ammo = function (self, arg_56_1)
	-- function 56
	if not self._show_first_person_units then
		self.inventory_extension:show_first_person_ammo(arg_56_1)
	else
		self._want_to_show_first_person_ammo = arg_56_1
	end
end

PlayerUnitFirstPerson.animation_set_variable = function (self, arg_57_1, arg_57_2, arg_57_3)
	-- function 57
	local first_person_unit = self.first_person_unit
	local var_57_1 = self._anim_var_id_lookup[arg_57_1]

	if var_57_1 == nil then
		var_57_1 = animation_find_variable(first_person_unit, arg_57_1) or false
		self._anim_var_id_lookup[arg_57_1] = var_57_1
	end

	if not var_57_1 then
		animation_set_variable(first_person_unit, var_57_1, arg_57_2)

		self._anim_var_values[arg_57_1] = arg_57_2
	end
end

PlayerUnitFirstPerson.animation_event = function (self, arg_58_1)
	-- function 58
	Unit.animation_event(self.first_person_unit, arg_58_1)
end

PlayerUnitFirstPerson.create_screen_particles = function (self, arg_59_1, arg_59_2, ...)
	-- function 59
	if Development.parameter("screen_space_player_camera_reactions") == false then
		return
	end

	return World.create_particles(self.world, arg_59_1, arg_59_2 or Vector3.zero(), ...)
end

PlayerUnitFirstPerson.stop_spawning_screen_particles = function (self, arg_60_1)
	-- function 60
	if Development.parameter("screen_space_player_camera_reactions") == false then
		return
	end

	World.stop_spawning_particles(self.world, arg_60_1)
end

PlayerUnitFirstPerson.destroy_screen_particles = function (self, arg_61_1)
	-- function 61
	if Development.parameter("screen_space_player_camera_reactions") == false then
		return
	end

	World.destroy_particles(self.world, arg_61_1)
end

PlayerUnitFirstPerson.play_hud_sound_event = function (self, arg_62_1, arg_62_2, arg_62_3)
	-- function 62
	if not arg_62_3 then
		self:play_remote_hud_sound_event(arg_62_1)
	end

	local wwise_world = Managers.world:wwise_world(self.world)

	if not arg_62_2 then
		local trigger_event, var_62_2 = WwiseWorld.trigger_event(wwise_world, arg_62_1, arg_62_2)

		return trigger_event, var_62_2
	else
		local trigger_event_2, var_62_4 = WwiseWorld.trigger_event(wwise_world, arg_62_1)

		return trigger_event_2, var_62_4
	end
end

PlayerUnitFirstPerson.play_remote_hud_sound_event = function (self, arg_63_1)
	-- function 63
	if not LEVEL_EDITOR_TEST then
		local network = Managers.state.network
		local network_transmit = network.network_transmit
		local is_server = Managers.player.is_server
		local unit_game_object_id = network:unit_game_object_id(self.unit)
		local var_63_4 = NetworkLookup.sound_events[arg_63_1]

		if not is_server then
			network_transmit:send_rpc_clients("rpc_play_husk_sound_event", unit_game_object_id, var_63_4)
		else
			network_transmit:send_rpc_server("rpc_play_husk_sound_event", unit_game_object_id, var_63_4)
		end
	end
end

PlayerUnitFirstPerson.play_sound_event = function (self, arg_64_1, arg_64_2)
	-- function 64
	local flag = arg_64_2 or self:current_position()
	local make_position_auto_source, var_64_2 = WwiseUtils.make_position_auto_source(self.world, flag)

	WwiseWorld.set_switch(var_64_2, "husk", "false", make_position_auto_source)
	WwiseWorld.trigger_event(var_64_2, arg_64_1, make_position_auto_source)
end

PlayerUnitFirstPerson.play_unit_sound_event = function (self, arg_65_1, arg_65_2, arg_65_3, arg_65_4)
	-- function 65
	if not arg_65_4 then
		self:play_remote_unit_sound_event(arg_65_1, arg_65_2, arg_65_3)
	end

	local make_unit_auto_source, var_65_1 = WwiseUtils.make_unit_auto_source(self.world, arg_65_2, arg_65_3)

	WwiseWorld.set_switch(var_65_1, "husk", "false", make_unit_auto_source)
	WwiseWorld.trigger_event(var_65_1, arg_65_1, make_unit_auto_source)
end

PlayerUnitFirstPerson.play_remote_unit_sound_event = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3)
	-- function 66
	local var_66_0 = NetworkLookup.sound_events[arg_66_1]
	local network = Managers.state.network

	if not (not network:game() and LEVEL_EDITOR_TEST) then
		local network_transmit = network.network_transmit
		local is_server = Managers.player.is_server
		local unit_game_object_id = network:unit_game_object_id(arg_66_2)

		if not is_server then
			network_transmit:send_rpc_clients("rpc_play_husk_unit_sound_event", unit_game_object_id, arg_66_3, var_66_0)
		else
			network_transmit:send_rpc_server("rpc_play_husk_unit_sound_event", unit_game_object_id, arg_66_3, var_66_0)
		end
	end
end

PlayerUnitFirstPerson.play_camera_effect_sequence = function (arg_67_0, arg_67_1, arg_67_2)
	-- function 67
	Managers.state.camera:camera_effect_sequence_event(arg_67_1, arg_67_2)
end

PlayerUnitFirstPerson.set_aim_assist = function (self, arg_68_1)
	-- function 68
	if arg_68_1 == "" then
		self.aim_assist_type = arg_68_1
	end
end

PlayerUnitFirstPerson.enable_rig_movement = function (self)
	-- function 69
	if not script_data.disable_aim_lead_rig_motion then
		self:disable_rig_movement()

		return
	end

	if not self._rig_movement_enabled then
		self._rig_movement_enabled = true

		Unit.animation_event(self.first_person_unit, "activate_aim")
	end
end

PlayerUnitFirstPerson.disable_rig_movement = function (self)
	-- function 70
	if not self._rig_movement_enabled then
		self._rig_movement_enabled = false

		Unit.animation_event(self.first_person_unit, "deactivate_aim")
	end
end

PlayerUnitFirstPerson.enable_rig_offset = function (self)
	-- function 71
	if not script_data.disable_aim_lead_rig_motion then
		self:disable_rig_offset()

		return
	end

	if not self._rig_offset_enabled then
		self._rig_offset_enabled = true
	end
end

PlayerUnitFirstPerson.disable_rig_offset = function (self)
	-- function 72
	if not self._rig_offset_enabled then
		self._rig_offset_enabled = false
	end
end

PlayerUnitFirstPerson.update_rig_movement = function (self, arg_73_1)
	-- function 73
	if not script_data.disable_aim_lead_rig_motion then
		return
	end

	if not self._aim_target_index then
		return
	end

	local _rig_update_timestep = self._rig_update_timestep
	local get_wielded_slot_name = self.inventory_extension:get_wielded_slot_name()
	local flag = get_wielded_slot_name == "slot_ranged"
	local flag_2 = not flag
	local get_item_data = self.inventory_extension:get_item_data(get_wielded_slot_name)
	local flag_3 = not get_item_data and get_item_data.template
	local get_weapon_template = WeaponUtils.get_weapon_template(flag_3)
	local local_position = Unit.local_position(self.first_person_unit, 0)
	local local_rotation = Unit.local_rotation(self.first_person_unit, 0)
	local forward = Quaternion.forward(local_rotation)
	local right = Quaternion.right(local_rotation)
	local up = Quaternion.up(local_rotation)
	local rig_movement = PlayerUnitMovementSettings.rig_movement
	local mass = rig_movement.mass
	local tension = rig_movement.tension
	local damping = rig_movement.damping
	local motion_offset = rig_movement.motion_offset
	local horizontal_motion_damping = rig_movement.horizontal_motion_damping
	local vertical_motion_damping = rig_movement.vertical_motion_damping
	local vertical_look_multiplier_ranged

	if not flag then
		vertical_look_multiplier_ranged = rig_movement.vertical_look_multiplier_ranged

		if not vertical_look_multiplier_ranged then
			-- Nothing
		end
	end

	vertical_look_multiplier_ranged = rig_movement.vertical_look_multiplier_melee

	::label_73_0::

	local var_73_20 = Vector3(10, 10, 0)
	local num = 10
	local var_73_22 = Vector2(0.1, 0.1)

	if not flag then
		var_73_20 = Vector3(5, 5, 0)
		num = 4
		var_73_22 = Vector2(0.5, 0.5)
	end

	local rig_motion_multiplier

	if not get_weapon_template then
		rig_motion_multiplier = get_weapon_template.rig_motion_multiplier

		if not rig_motion_multiplier then
			-- Nothing
		end
	end

	rig_motion_multiplier = 1

	::label_73_1::

	local num_2 = var_73_20 * rig_motion_multiplier
	local rig_motion_multiplier_2

	if not get_weapon_template then
		rig_motion_multiplier_2 = get_weapon_template.rig_motion_multiplier

		if not rig_motion_multiplier_2 then
			-- Nothing
		end
	end

	rig_motion_multiplier_2 = 1

	::label_73_2::

	local num_3 = num * rig_motion_multiplier_2
	local rig_motion_multiplier_3

	if not get_weapon_template then
		rig_motion_multiplier_3 = get_weapon_template.rig_motion_multiplier

		if not rig_motion_multiplier_3 then
			-- Nothing
		end
	end

	rig_motion_multiplier_3 = 1

	::label_73_3::

	local num_4 = var_73_22 * rig_motion_multiplier_3
	local num_5 = 1 / mass
	local spring_velocity = self.spring_velocity

	spring_velocity = spring_velocity or Vector3Box(0, 0, 0)
	self.spring_velocity = spring_velocity

	local spring_position = self.spring_position

	spring_position = spring_position or Vector3Box(local_position)
	self.spring_position = spring_position

	local lead_offset = self.lead_offset

	lead_offset = lead_offset or Vector3Box(0, 0, 0)
	self.lead_offset = lead_offset

	local unbox = self.spring_velocity:unbox()
	local unbox_2 = self.spring_position:unbox()
	local unbox_3 = self.lead_offset:unbox()

	if not arg_73_1 then
		unbox_3 = Vector3.lerp(unbox_3, Vector3.multiply_elements(arg_73_1, num_2), _rig_update_timestep)
	end

	local max = Vector3.max(Vector3.min(num_4, unbox_3), -num_4)
	local lerp = Vector3.lerp(max, Vector3.zero(), math.min(_rig_update_timestep * num_3, 1))
	local num_6 = unbox_2 + unbox * _rig_update_timestep
	local num_7 = num_6 - local_position
	local num_8 = unbox - num_5 * tension * num_7 * _rig_update_timestep

	if not (not (Vector3.length(num_7) >= 0.5) or self._state ~= "falling") then
		damping = damping / 10
	end

	local num_9 = 0.5 * mass * Vector3.length_squared(num_8) * damping
	local sqrt = math.sqrt(num_9 / (0.5 * mass))
	local num_10 = num_8 - Vector3.normalize(num_8) * sqrt * _rig_update_timestep

	if not flag_2 then
		num_6 = num_6 - right * lerp.x + up * lerp.y
	end

	local var_73_44 = num_6
	local num_11 = var_73_44 - right * Vector3.dot(right, var_73_44 - local_position) * horizontal_motion_damping
	local num_12 = num_11 - up * Vector3.dot(up, num_11 - local_position) * vertical_motion_damping
	local dot = Vector3.dot(forward, Vector3.up())
	local num_13 = num_12 + forward * motion_offset - up * dot * vertical_look_multiplier_ranged

	if not flag_2 then
		num_13 = num_13 + right * lerp.x + up * lerp.y
	end

	self.spring_position:store(num_6)
	self.spring_velocity:store(num_10)
	self.lead_offset:store(lerp)

	if not script_data.debug_rig_motion then
		local world_position = Unit.world_position(self.first_person_unit, Unit.node(self.first_person_unit, "j_aim_target"))

		QuickDrawer:sphere(world_position - forward * 3, 0.1, Color(255, 255, 255))
		QuickDrawer:sphere(num_6 + forward * Vector3.length(num_6 - (world_position - forward * 3)), 0.1, Color(255, 0, 0))
		QuickDrawer:sphere(num_13 + forward * Vector3.length(num_13 - (world_position - forward * 3)), 0.1, Color(0, 255, 0))
	end

	if not self._rig_offset_enabled then
		Managers.state.camera:set_offset(lerp.x, 0, 0)
	end

	Unit.animation_set_constraint_target(self.first_person_unit, self._aim_target_index, num_13)
end

PlayerUnitFirstPerson.change_state = function (self, arg_74_1)
	-- function 74
	self._state = arg_74_1
end

PlayerUnitFirstPerson.play_camera_recoil = function (self, arg_75_1, arg_75_2)
	-- function 75
	if not self._current_recoil_data then
		Managers.state.camera:stop_weapon_recoil(self._current_recoil_data)

		self._current_recoil_data = nil
	end

	local tbl = {
		vertical_climb = arg_75_1.vertical_climb,
		horizontal_climb = arg_75_1.horizontal_climb,
		climb_start_time = arg_75_2,
		climb_end_time = arg_75_2 + arg_75_1.climb_duration,
		restore_start_time = arg_75_2 + arg_75_1.climb_duration,
		restore_end_time = arg_75_2 + arg_75_1.climb_duration + arg_75_1.restore_duration,
		climb_function = arg_75_1.climb_function,
		restore_function = arg_75_1.restore_function
	}

	self._current_recoil_data = Managers.state.camera:weapon_recoil(tbl)
end

local tbl_4 = {
	vs_packmaster = {
		5,
		5,
		5
	},
	vs_gutter_runner = {
		5,
		5,
		5
	},
	vs_poison_wind_globadier = {
		5,
		5,
		5
	},
	vs_warpfire_thrower = {
		5,
		5,
		5
	},
	vs_ratling_gunner = {
		5,
		5,
		5
	},
	vs_chaos_troll = {
		5,
		5,
		5
	},
	vs_rat_ogre = {
		5,
		5,
		5
	}
}
local min = math.min
local max = math.max
local lerp = math.lerp
local clamp = math.clamp

function bi_clamp(arg_76_0, arg_76_1, arg_76_2)
	-- function 76
	if arg_76_2 < arg_76_1 then
		return max(arg_76_2, min(arg_76_1, arg_76_0))
	else
		return max(arg_76_1, min(arg_76_2, arg_76_0))
	end
end

PlayerUnitFirstPerson._update_state_machine_variables = function (self, arg_77_1, arg_77_2)
	-- function 77
	local _weapon_sway_settings = self._weapon_sway_settings

	_weapon_sway_settings = _weapon_sway_settings or tbl

	local input_extension = self.input_extension
	local get = input_extension:get("look_raw_controller")

	get = get or Vector3(0, 0, 0)

	local get_2 = input_extension:get("look_raw")

	get_2 = get_2 or Vector3(0, 0, 0)

	local num_2 = Vector3(get_2.x * num, -get_2.y * num, 0) + get * arg_77_1
	local num_3 = self._look_target_x + num_2.x * _weapon_sway_settings.look_sensitivity
	local num_4 = self._look_target_y + num_2.y * _weapon_sway_settings.look_sensitivity
	local var_77_7 = min(_weapon_sway_settings.lerp_speed * arg_77_1, 1)
	local var_77_8 = lerp(self._look_delta_x, num_3, var_77_7)
	local var_77_9 = lerp(self._look_delta_y, num_4, var_77_7)
	local sway_range = _weapon_sway_settings.sway_range
	local var_77_11 = clamp(var_77_8, -sway_range, sway_range)
	local var_77_12 = clamp(var_77_9, -sway_range, sway_range)

	self._look_delta_x = var_77_11
	self._look_delta_y = var_77_12

	self:animation_set_variable("look_delta_x", var_77_11)
	self:animation_set_variable("look_delta_y", var_77_12)

	local unbox = self.look_rotation:unbox()
	local clamp_2 = math.clamp(Quaternion.pitch(unbox) / self.MAX_MIN_PITCH, -1, 1)

	self:animation_set_variable("world_look_delta_y", clamp_2)

	if not _weapon_sway_settings.recenter_acc then
		local recenter_acc = _weapon_sway_settings.recenter_acc
		local recetner_dampening = _weapon_sway_settings.recetner_dampening

		recetner_dampening = recetner_dampening or 1

		local recenter_max_vel = _weapon_sway_settings.recenter_max_vel

		recenter_max_vel = recenter_max_vel or 10

		local _look_target_recentering_vel_x = self._look_target_recentering_vel_x

		_look_target_recentering_vel_x = _look_target_recentering_vel_x or 0

		local _look_target_recentering_vel_y = self._look_target_recentering_vel_y

		_look_target_recentering_vel_y = _look_target_recentering_vel_y or 0

		local num_5 = _look_target_recentering_vel_x - bi_clamp(_look_target_recentering_vel_x * recetner_dampening * arg_77_1, -_look_target_recentering_vel_x, _look_target_recentering_vel_x)
		local num_6 = _look_target_recentering_vel_y - bi_clamp(_look_target_recentering_vel_y * recetner_dampening * arg_77_1, -_look_target_recentering_vel_y, _look_target_recentering_vel_y)
		local num_7 = num_5 + num_2.x * _weapon_sway_settings.look_sensitivity
		local num_8 = num_6 + num_2.y * _weapon_sway_settings.look_sensitivity
		local var_77_24 = clamp(num_7 - num_3 * recenter_acc * arg_77_1, -recenter_max_vel, recenter_max_vel)
		local var_77_25 = clamp(num_8 - num_4 * recenter_acc * arg_77_1, -recenter_max_vel, recenter_max_vel)

		self._look_target_recentering_vel_x = var_77_24
		self._look_target_recentering_vel_y = var_77_25
		self._look_target_x = clamp(num_3 + var_77_24 * arg_77_1, -sway_range, sway_range)
		self._look_target_y = clamp(num_4 + var_77_25 * arg_77_1, -sway_range, sway_range)
	else
		local var_77_26 = min
		local recentering_lerp_speed = _weapon_sway_settings.recentering_lerp_speed

		recentering_lerp_speed = recentering_lerp_speed or 2

		local var_77_28 = var_77_26(recentering_lerp_speed * arg_77_1, 1)

		self._look_target_x = clamp(lerp(num_3, 0, var_77_28), -sway_range, sway_range)
		self._look_target_y = clamp(lerp(num_4, 0, var_77_28), -sway_range, sway_range)
	end

	local normalize = Vector3.normalize(get_2 + get)
	local num_9 = math.round(2 * normalize.x) * 0.5
	local num_10 = math.round(2 * normalize.y) * 0.5
	local z = self.locomotion_extension:current_velocity().z
	local display_name = self.profile.display_name
	local num_11 = 5
	local num_12 = 5
	local num_13 = 5
	local var_77_37 = tbl_4[display_name]

	if not var_77_37 then
		num_11 = var_77_37[1]
		num_12 = var_77_37[2]
		num_13 = var_77_37[3]
	end

	if num_9 <= 0.3 then
		num_11 = 7.5
	end

	if num_10 <= 0.3 then
		num_12 = 7.5
	end

	if z <= 0.3 then
		num_13 = 7.5
	end

	local clamp_3 = math.clamp(math.lerp(self._move_x, num_9, num_11 * arg_77_1), -1, 1)
	local clamp_4 = math.clamp(math.lerp(self._move_y, clamp_3, num_12 * arg_77_1), -1, 1)
	local clamp_5 = math.clamp(math.lerp(self._move_z, z, num_13 * arg_77_1), -1, 1)

	self._move_y = clamp_3
	self._move_x = clamp_4
	self._move_z = clamp_5

	self:animation_set_variable("move_x", clamp_4)
	self:animation_set_variable("move_y", clamp_3)
	self:animation_set_variable("move_z", clamp_5)
end
