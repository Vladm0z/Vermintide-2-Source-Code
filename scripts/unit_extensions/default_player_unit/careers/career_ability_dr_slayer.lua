-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_dr_slayer.lua

CareerAbilityDRSlayer = class(CareerAbilityDRSlayer)

local num = 2
local tbl = {}

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local num = -PlayerUnitMovementSettings.gravity_acceleration
	local degrees_to_radians = math.degrees_to_radians(45)
	local num_2 = 8
	local zero = Vector3.zero()
	local num_3 = 0.1
	local speed_to_hit_moving_target, var_1_6 = WeaponHelper.speed_to_hit_moving_target(arg_1_1, arg_1_2, degrees_to_radians, zero, num, num_3)
	local test_angled_trajectory, var_1_8, var_1_9 = WeaponHelper.test_angled_trajectory(arg_1_0, arg_1_1, arg_1_2, -num, speed_to_hit_moving_target, degrees_to_radians, tbl, num_2, nil, true)

	fassert(test_angled_trajectory, "no landing location for leap")

	return Vector3.normalize(var_1_8), speed_to_hit_moving_target, var_1_6
end

CareerAbilityDRSlayer.init = function (self, arg_2_1, arg_2_2, arg_2_3)
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
	self._effect_name = "fx/chr_slayer_jump"
	self._effect_id = nil
	self._is_priming = false
	self._last_valid_landing_position = nil
end

CareerAbilityDRSlayer.extensions_ready = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._first_person_extension = ScriptUnit.has_extension(arg_3_2, "first_person_system")
	self._status_extension = ScriptUnit.extension(arg_3_2, "status_system")
	self._career_extension = ScriptUnit.extension(arg_3_2, "career_system")
	self._buff_extension = ScriptUnit.extension(arg_3_2, "buff_system")
	self._locomotion_extension = ScriptUnit.extension(arg_3_2, "locomotion_system")
	self._input_extension = ScriptUnit.has_extension(arg_3_2, "input_system")
	self._talent_extension = ScriptUnit.has_extension(arg_3_2, "talent_system")

	if not self._first_person_extension then
		self._first_person_unit = self._first_person_extension:get_first_person_unit()
	end
end

CareerAbilityDRSlayer.destroy = function (arg_4_0)
	-- function 4
	return
end

CareerAbilityDRSlayer.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
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
		local _update_priming, var_5_2, var_5_3 = self:_update_priming()

		if _input_extension:get("action_two") or _input_extension:get("jump") or not _input_extension:get("jump_only") then
			self:_stop_priming()

			return
		end

		if not _input_extension:get("weapon_reload") then
			self:_stop_priming()

			return
		end

		if not _update_priming and not var_5_2 then
			if not self._last_valid_landing_position then
				self._last_valid_landing_position:store(var_5_2)
			else
				self._last_valid_landing_position = Vector3Box(var_5_2)
			end
		end

		if not self._last_valid_landing_position then
			self:_stop_priming()

			return
		end

		if not not _input_extension:get("action_career_hold") then
			if not _update_priming and not self._last_valid_landing_position then
				if var_5_3 <= num then
					self:_do_stomp(arg_5_5)
				else
					self:_do_leap()
				end
			else
				self:_stop_priming()
			end
		end
	end
end

CareerAbilityDRSlayer.stop = function (self, arg_6_1)
	-- function 6
	if arg_6_1 == "pushed" or arg_6_1 == "stunned" or not self._is_priming then
		self:_stop_priming()
	end
end

CareerAbilityDRSlayer._ability_available = function (self)
	-- function 7
	local _career_extension = self._career_extension
	local _status_extension = self._status_extension
	local _locomotion_extension = self._locomotion_extension
	local can_use_activated_ability = _career_extension:can_use_activated_ability()

	can_use_activated_ability = not can_use_activated_ability and not not _status_extension:is_disabled() or _locomotion_extension:is_on_ground()

	return can_use_activated_ability
end

CareerAbilityDRSlayer._start_priming = function (self)
	-- function 8
	if not self._local_player then
		local _world = self._world
		local _effect_name = self._effect_name

		self._effect_id = World.create_particles(_world, _effect_name, Vector3.zero())
	end

	self._last_valid_landing_position = nil
	self._is_priming = true
end

CareerAbilityDRSlayer._update_priming = function (self)
	-- function 9
	local _effect_id = self._effect_id
	local _world = self._world
	local get_data = World.get_data(_world, "physics_world")
	local _first_person_extension = self._first_person_extension
	local _talent_extension = self._talent_extension
	local current_position = _first_person_extension:current_position()
	local current_rotation = _first_person_extension:current_rotation()
	local str = "filter_slayer_leap"
	local degrees_to_radians = math.degrees_to_radians(45)
	local degrees_to_radians_2 = math.degrees_to_radians(12.5)
	local yaw = Quaternion.yaw(current_rotation)
	local clamp = math.clamp(Quaternion.pitch(current_rotation), -degrees_to_radians, degrees_to_radians_2)
	local var_9_12 = Quaternion(Vector3.up(), yaw)
	local var_9_13 = Quaternion(Vector3.right(), clamp)
	local multiply = Quaternion.multiply(var_9_12, var_9_13)
	local forward = Quaternion.forward(multiply)
	local num = 11

	if not _talent_extension:has_talent("bardin_slayer_activated_ability_leap_range") then
		num = 17
	end

	local num_2 = forward * num
	local var_9_18 = Vector3(0, 0, -11)
	local ground_target, var_9_20 = WeaponHelper:ground_target(get_data, self._owner_unit, current_position, num_2, var_9_18, str)
	local var_9_21

	if not ground_target then
		var_9_21 = Vector3.length(var_9_20 - current_position)

		if not _effect_id and not var_9_20 then
			World.move_particles(_world, _effect_id, var_9_20)
		end
	else
		var_9_20 = nil
	end

	return ground_target, var_9_20, var_9_21
end

CareerAbilityDRSlayer._stop_priming = function (self)
	-- function 10
	if not self._effect_id then
		World.destroy_particles(self._world, self._effect_id)

		self._effect_id = nil
	end

	self._is_priming = false
	self._last_valid_landing_position = nil
end

CareerAbilityDRSlayer._do_common_stuff = function (self)
	-- function 11
	local _owner_unit = self._owner_unit
	local _is_server = self._is_server
	local _local_player = self._local_player
	local _bot_player = self._bot_player
	local _network_manager = self._network_manager
	local network_transmit = _network_manager.network_transmit
	local _career_extension = self._career_extension
	local _talent_extension = self._talent_extension
	local tbl = {
		"bardin_slayer_activated_ability"
	}

	if not _talent_extension:has_talent("bardin_slayer_activated_ability_movement") then
		tbl[#tbl + 1] = "bardin_slayer_activated_ability_movement"
	end

	local unit_game_object_id = _network_manager:unit_game_object_id(_owner_unit)

	if not _is_server then
		local _buff_extension = self._buff_extension

		for i = 1, #tbl do
			local var_11_11 = tbl[i]
			local var_11_12 = NetworkLookup.buff_templates[var_11_11]

			_buff_extension:add_buff(var_11_11, {
				attacker_unit = _owner_unit
			})
			network_transmit:send_rpc_clients("rpc_add_buff", unit_game_object_id, var_11_12, unit_game_object_id, 0, false)
		end
	else
		for j = 1, #tbl do
			local var_11_13 = tbl[j]
			local var_11_14 = NetworkLookup.buff_templates[var_11_13]

			network_transmit:send_rpc_server("rpc_add_buff", unit_game_object_id, var_11_14, unit_game_object_id, 0, true)
		end
	end

	if not _is_server and _bot_player and not _local_player then
		local _first_person_extension = self._first_person_extension

		_first_person_extension:play_hud_sound_event("Play_career_ability_bardin_slayer_enter")
		_first_person_extension:play_remote_unit_sound_event("Play_career_ability_bardin_slayer_enter", _owner_unit, 0)
		_first_person_extension:play_hud_sound_event("Play_career_ability_bardin_slayer_loop")

		if not _local_player then
			_career_extension:set_state("bardin_activate_slayer")
			Managers.state.camera:set_mood("skill_slayer", "skill_slayer", true)
		end
	end

	_career_extension:start_activated_ability_cooldown()
	self:_play_vo()
end

CareerAbilityDRSlayer._do_stomp = function (self, arg_12_1)
	-- function 12
	self:_stop_priming()

	if not self._locomotion_extension:is_on_ground() then
		return
	end

	self:_do_common_stuff()

	local _owner_unit = self._owner_unit
	local _local_player = self._local_player
	local _career_extension = self._career_extension
	local has_talent = self._talent_extension:has_talent("bardin_slayer_activated_ability_impact_damage")
	local var_12_4 = POSITION_LOOKUP[_owner_unit]
	local identity = Quaternion.identity()
	local flag

	flag = not has_talent and "bardin_slayer_activated_ability_landing_stagger_impact" and "bardin_slayer_activated_ability_landing_stagger"

	local num = 1
	local get_career_power_level = _career_extension:get_career_power_level()
	local flag_2

	flag_2 = not has_talent and 2 and 1

	local num_2 = get_career_power_level * flag_2

	Managers.state.entity:system("area_damage_system"):create_explosion(_owner_unit, var_12_4, identity, flag, num, "career_ability", num_2, false)

	if not _local_player then
		local _first_person_extension = self._first_person_extension

		_first_person_extension:play_unit_sound_event("Play_career_ability_bardin_slayer_impact", _owner_unit, 0, true)
		_first_person_extension:play_camera_effect_sequence("leap_stomp", arg_12_1)
	end
end

CareerAbilityDRSlayer._do_leap = function (self)
	-- function 13
	local unbox = self._last_valid_landing_position:unbox()

	self:_stop_priming()

	if not self._locomotion_extension:is_on_ground() then
		return
	end

	self:_do_common_stuff()

	local _world = self._world
	local _owner_unit = self._owner_unit
	local _local_player = self._local_player
	local _network_manager = self._network_manager
	local network_transmit = _network_manager.network_transmit
	local _status_extension = self._status_extension
	local _career_extension = self._career_extension
	local _talent_extension = self._talent_extension

	self._locomotion_extension:set_external_velocity_enabled(false)
	_status_extension:reset_move_speed_multiplier()
	_status_extension:set_noclip(true, "skill_slayer")

	if not Managers.state.network:game() then
		_status_extension:set_is_dodging(true)

		local unit_game_object_id = _network_manager:unit_game_object_id(_owner_unit)

		network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, true, unit_game_object_id, 0)
	end

	local get_data = World.get_data(_world, "physics_world")
	local var_13_11, var_13_12, var_13_13 = fn(get_data, POSITION_LOOKUP[_owner_unit], unbox)
	local distance = Vector3.distance(POSITION_LOOKUP[_owner_unit], unbox)
	local clamp = math.clamp(distance / 10, 0, 1)
	local has_talent = _talent_extension:has_talent("bardin_slayer_activated_ability_impact_damage")

	_status_extension.do_leap = {
		camera_effect_sequence_start = "jump",
		anim_start_event_3p = "jump_fwd",
		camera_effect_sequence_land = "landed_leap",
		anim_start_event_1p = "slayer_jump_ability",
		move_function = "leap",
		direction = Vector3Box(var_13_11),
		speed = var_13_12,
		initial_vertical_speed = PlayerUnitMovementSettings.leap.jump_speed * clamp,
		projected_hit_pos = Vector3Box(var_13_13),
		sfx_event_jump = not _local_player and "Play_career_ability_bardin_slayer_jump",
		sfx_event_land = not _local_player and "Play_career_ability_bardin_slayer_impact",
		leap_events = {
			start = function (self)
				-- function 14
				local unit = self.unit
				local has_extension = ScriptUnit.has_extension(unit, "buff_system")

				self._uninterruptible_buff_id = has_extension:add_buff("bardin_slayer_passive_uninterruptible_leap")
			end,
			finished = function (self, arg_15_1, arg_15_2)
				-- function 15
				local unit = self.unit
				local player = self.player

				if not arg_15_1 then
					local identity = Quaternion.identity()
					local flag

					flag = not has_talent and "bardin_slayer_activated_ability_landing_stagger_impact" and "bardin_slayer_activated_ability_landing_stagger"

					local num = 1
					local get_career_power_level = _career_extension:get_career_power_level()
					local flag_2

					flag_2 = not has_talent and 2 and 1

					local num_2 = get_career_power_level * flag_2

					Managers.state.entity:system("area_damage_system"):create_explosion(unit, arg_15_2, identity, flag, num, "career_ability", num_2, false)
				end

				ScriptUnit.extension(unit, "status_system"):set_noclip(false, "skill_slayer")

				local game = Managers.state.network:game()

				if not player and player.remote or not game then
					ScriptUnit.extension(unit, "status_system"):set_is_dodging(false)

					local unit_game_object_id = _network_manager:unit_game_object_id(unit)

					network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, false, unit_game_object_id, 0)
				end

				local has_extension = ScriptUnit.has_extension(unit, "buff_system")

				if not self._uninterruptible_buff_id then
					has_extension:remove_buff(self._uninterruptible_buff_id)

					self._uninterruptible_buff_id = nil
				end
			end
		}
	}
end

CareerAbilityDRSlayer._play_vo = function (self)
	-- function 16
	local _owner_unit = self._owner_unit
	local extension_input = ScriptUnit.extension_input(_owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end
