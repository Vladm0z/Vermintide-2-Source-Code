-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_bw_adept.lua

CareerAbilityBWAdept = class(CareerAbilityBWAdept)

local num = 0.01
local tbl = {}

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	if Vector3.length(Vector3.flat(arg_1_1 - arg_1_2)) < num then
		return Vector3.zero(), 0, arg_1_1
	end

	local gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration
	local degrees_to_radians = math.degrees_to_radians(45)
	local num_2 = 8
	local zero = Vector3.zero()
	local num_3 = 0.1
	local speed_to_hit_moving_target, var_1_6 = WeaponHelper.speed_to_hit_moving_target(arg_1_1, arg_1_2, degrees_to_radians, zero, gravity_acceleration, num_3)
	local test_angled_trajectory, var_1_8, var_1_9 = WeaponHelper.test_angled_trajectory(arg_1_0, arg_1_1, arg_1_2, -gravity_acceleration, speed_to_hit_moving_target, degrees_to_radians, tbl, num_2, nil, true)

	fassert(test_angled_trajectory, "no landing location for leap")

	return Vector3.normalize(var_1_8), speed_to_hit_moving_target, var_1_6
end

CareerAbilityBWAdept.init = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	self._owner_unit = arg_2_2
	self._world = arg_2_1.world
	self._wwise_world = Managers.world:wwise_world(self._world)

	local player = arg_2_3.player

	self._player = player
	self._is_server = player.is_server
	self._local_player = player.local_player
	self._bot_player = player.bot_player
	self._network_manager = Managers.state.network
	self._input_manager = Managers.input
	self._effect_name = "fx/wpnfx_staff_geiser_charge"
	self._effect_id = nil
	self._double_ability_buff_id = nil
end

CareerAbilityBWAdept.extensions_ready = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._first_person_extension = ScriptUnit.has_extension(arg_3_2, "first_person_system")
	self._status_extension = ScriptUnit.extension(arg_3_2, "status_system")
	self._career_extension = ScriptUnit.extension(arg_3_2, "career_system")
	self._buff_extension = ScriptUnit.extension(arg_3_2, "buff_system")
	self._locomotion_extension = ScriptUnit.extension(arg_3_2, "locomotion_system")
	self._input_extension = ScriptUnit.has_extension(arg_3_2, "input_system")
	self._talent_extension = ScriptUnit.has_extension(arg_3_2, "talent_system")

	if not self._first_person_extension then
		self.first_person_unit = self._first_person_extension:get_first_person_unit()
	end
end

CareerAbilityBWAdept.destroy = function (arg_4_0)
	-- function 4
	return
end

local str = "career_ability_bw_adept"

CareerAbilityBWAdept.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local _input_extension = self._input_extension

	if not _input_extension then
		return
	end

	if not self._is_priming then
		if not self:_ability_available() then
			return
		end

		if not _input_extension:get("action_career") then
			self:_start_priming()
		end
	elseif not self._is_priming then
		local _update_priming = self:_update_priming(arg_5_3, arg_5_5)

		if _input_extension:get("action_two") or _input_extension:get("jump") or not _input_extension:get("jump_only") then
			self:_stop_priming()

			return
		end

		if not _input_extension:get("weapon_reload") then
			self:_stop_priming()

			return
		end

		if not _update_priming then
			if not self._last_valid_landing_position then
				self._last_valid_landing_position:store(_update_priming)
			else
				self._last_valid_landing_position = Vector3Box(_update_priming)
			end
		end

		if not self._last_valid_landing_position then
			self:_stop_priming()

			return
		end

		if not (not self._last_valid_landing_position and _input_extension:get("action_career_hold")) then
			self:_run_ability()
		end
	end
end

CareerAbilityBWAdept.stop = function (self, arg_6_1)
	-- function 6
	if arg_6_1 == "pushed" or arg_6_1 == "stunned" or not self._is_priming then
		self:_stop_priming()
	end
end

CareerAbilityBWAdept._ability_available = function (self)
	-- function 7
	local _career_extension = self._career_extension
	local _status_extension = self._status_extension
	local _locomotion_extension = self._locomotion_extension
	local can_use_activated_ability = _career_extension:can_use_activated_ability()
	local is_disabled = _status_extension:is_disabled()
	local is_overcharge_exploding = _status_extension:is_overcharge_exploding()
	local is_on_ground = _locomotion_extension:is_on_ground()

	return not can_use_activated_ability and not not is_disabled and not not is_overcharge_exploding or is_on_ground
end

CareerAbilityBWAdept._start_priming = function (self)
	-- function 8
	if not self._local_player then
		local _world = self._world
		local _effect_name = self._effect_name

		self._effect_id = World.create_particles(_world, _effect_name, Vector3.zero())
	end

	self._last_valid_landing_position = nil
	self._is_priming = true
end

CareerAbilityBWAdept._update_priming = function (self, arg_9_1, arg_9_2)
	-- function 9
	local _effect_id = self._effect_id
	local _world = self._world
	local get_data = World.get_data(_world, "physics_world")
	local _first_person_extension = self._first_person_extension
	local current_position = _first_person_extension:current_position()
	local current_rotation = _first_person_extension:current_rotation()
	local str = "filter_adept_teleport"
	local degrees_to_radians = math.degrees_to_radians(45)
	local degrees_to_radians_2 = math.degrees_to_radians(12.5)
	local yaw = Quaternion.yaw(current_rotation)
	local clamp = math.clamp(Quaternion.pitch(current_rotation), -degrees_to_radians, degrees_to_radians_2)
	local var_9_11 = Quaternion(Vector3.up(), yaw)
	local var_9_12 = Quaternion(Vector3.right(), clamp)
	local multiply = Quaternion.multiply(var_9_11, var_9_12)
	local forward = Quaternion.forward(multiply)
	local has_extension = ScriptUnit.has_extension(self._owner_unit, "talent_system")
	local num = 11

	if not has_extension:has_talent("sienna_adept_activated_ability_distance") then
		num = 17
	end

	local num_2 = forward * num
	local var_9_18 = Vector3(0, 0, -11)
	local ground_target, var_9_20 = WeaponHelper:ground_target(get_data, self._owner_unit, current_position, num_2, var_9_18, str)

	if not ground_target then
		var_9_20 = nil
	end

	if not _effect_id and not var_9_20 then
		World.move_particles(_world, _effect_id, var_9_20)
	end

	return var_9_20
end

CareerAbilityBWAdept._stop_priming = function (self)
	-- function 10
	if not self._effect_id then
		World.destroy_particles(self._world, self._effect_id)

		self._effect_id = nil
	end

	self._is_priming = false
	self._last_valid_landing_position = nil
end

CareerAbilityBWAdept._run_ability = function (self)
	-- function 11
	local unbox = self._last_valid_landing_position:unbox()

	self:_stop_priming()

	if not self._locomotion_extension:is_on_ground() then
		return
	end

	local _world = self._world
	local _owner_unit = self._owner_unit
	local _is_server = self._is_server
	local _local_player = self._local_player
	local _bot_player = self._bot_player
	local network_transmit = self._network_manager.network_transmit
	local _career_extension = self._career_extension
	local _status_extension = self._status_extension
	local _talent_extension = self._talent_extension
	local _locomotion_extension = self._locomotion_extension
	local get_data = World.get_data(_world, "physics_world")
	local var_11_12, var_11_13, var_11_14 = fn(get_data, POSITION_LOOKUP[_owner_unit], unbox)

	if not ((_local_player or not _is_server or not _bot_player) and _talent_extension:has_talent("sienna_adept_activated_ability_explosion")) then
		local nav_world = Managers.state.entity:system("ai_system"):nav_world()
		local var_11_16 = POSITION_LOOKUP[_owner_unit]
		local num = 2
		local num_2 = 30
		local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, var_11_16, num, num_2)

		pos_on_mesh = pos_on_mesh or GwNavQueries.inside_position_from_outside_position(nav_world, var_11_16, num, num_2, 2, 0.5)

		if not pos_on_mesh then
			local str = "sienna_adept_ability_trail"
			local var_11_21 = NetworkLookup.damage_wave_templates[str]
			local _network_manager = self._network_manager
			local unit_game_object_id = _network_manager:unit_game_object_id(_owner_unit)

			_network_manager.network_transmit:send_rpc_server("rpc_create_damage_wave", unit_game_object_id, pos_on_mesh, var_11_14, var_11_21)
		end
	end

	if not _local_player then
		self._first_person_extension:animation_event("battle_wizard_active_ability_blink")
		_career_extension:set_state("sienna_activate_adept")
	end

	_locomotion_extension:set_external_velocity_enabled(false)
	_status_extension:reset_move_speed_multiplier()
	_status_extension:set_noclip(true, self)

	if not Managers.state.network:game() then
		_status_extension:set_is_dodging(true)

		local unit_game_object_id_2 = Managers.state.network:unit_game_object_id(_owner_unit)

		network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, true, unit_game_object_id_2, 0)
	end

	_status_extension.do_leap = {
		move_function = "teleleap",
		direction = Vector3Box(var_11_12),
		speed = var_11_13,
		initial_vertical_speed = PlayerUnitMovementSettings.teleleap.jump_speed,
		projected_hit_pos = Vector3Box(var_11_14),
		sfx_event_jump = not _local_player and "Play_career_ability_bardin_slayer_jump",
		sfx_event_land = not _local_player and "Play_career_ability_bardin_slayer_impact",
		leap_events = {
			{
				distance_percentage = 0.1,
				event_function = function (self)
					-- function 12
					local unit = self.unit

					ScriptUnit.extension(unit, "status_system"):set_invisible(true, nil, self)
				end
			},
			{
				distance_percentage = 0.2,
				event_function = function (self)
					-- function 13
					local unit = self.unit
					local extension = ScriptUnit.extension(unit, "career_system")
					local var_13_2 = POSITION_LOOKUP[unit]

					var_13_2 = var_13_2 or Unit.world_position(unit, 0)

					local local_rotation = Unit.local_rotation(unit, 0)
					local str = "sienna_adept_activated_ability_step_stagger"
					local num = 1
					local get_career_power_level = extension:get_career_power_level()

					Managers.state.entity:system("area_damage_system"):create_explosion(unit, var_13_2, local_rotation, str, num, "career_ability", get_career_power_level, false)
				end
			},
			start = function (self)
				-- function 14
				local unit = self.unit
				local extension = ScriptUnit.extension(unit, "career_system")
				local var_14_2 = POSITION_LOOKUP[unit]

				var_14_2 = var_14_2 or Unit.world_position(unit, 0)

				local local_rotation = Unit.local_rotation(unit, 0)
				local str = "sienna_adept_activated_ability_start_stagger"
				local num = 1
				local get_career_power_level = extension:get_career_power_level()

				Managers.state.entity:system("area_damage_system"):create_explosion(unit, var_14_2, local_rotation, str, num, "career_ability", get_career_power_level, false)
			end,
			finished = function (self, arg_15_1, arg_15_2)
				-- function 15
				local unit = self.unit
				local extension = ScriptUnit.extension(unit, "status_system")
				local extension_2 = ScriptUnit.extension(unit, "talent_system")
				local extension_3 = ScriptUnit.extension(unit, "career_system")

				if not arg_15_1 then
					local local_rotation = Unit.local_rotation(unit, 0)
					local str = "sienna_adept_activated_ability_end_stagger"

					if not extension_2:has_talent("sienna_adept_activated_ability_explosion") then
						str = "sienna_adept_activated_ability_end_stagger_improved"
					end

					local num = 1
					local get_career_power_level = extension_3:get_career_power_level()

					Managers.state.entity:system("area_damage_system"):create_explosion(unit, arg_15_2, local_rotation, str, num, "career_ability", get_career_power_level, false)
				end

				extension:set_invisible(false, nil, self)
				extension:set_noclip(false, self)

				if not Managers.state.network:game() then
					extension:set_is_dodging(false)

					local unit_game_object_id = Managers.state.network:unit_game_object_id(unit)

					network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, false, unit_game_object_id, 0)
				end
			end
		}
	}

	if _local_player or not _is_server or not _bot_player then
		local _buff_extension = self._buff_extension
		local get_buff_type = _buff_extension:get_buff_type("sienna_adept_ability_trail_double")
		local has_talent = _talent_extension:has_talent("sienna_adept_ability_trail_double")

		if not (get_buff_type or not has_talent) then
			if not get_buff_type then
				get_buff_type.aborted = true

				_buff_extension:remove_buff(get_buff_type.id)
			end

			_career_extension:start_activated_ability_cooldown()
			_career_extension:set_abilities_always_usable(false, "sienna_adept_ability_trail_double")
		else
			_buff_extension:add_buff("sienna_adept_ability_trail_double")
			_career_extension:set_abilities_always_usable(true, "sienna_adept_ability_trail_double")
			_career_extension:start_activated_ability_cooldown()
		end
	else
		_career_extension:start_activated_ability_cooldown()
	end

	self:_play_vo()
end

CareerAbilityBWAdept._play_vo = function (self)
	-- function 16
	local _owner_unit = self._owner_unit
	local extension_input = ScriptUnit.extension_input(_owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end
