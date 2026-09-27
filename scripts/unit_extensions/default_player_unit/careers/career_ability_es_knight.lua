-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_es_knight.lua

CareerAbilityESKnight = class(CareerAbilityESKnight)

CareerAbilityESKnight.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._owner_unit = arg_1_2
	self._world = arg_1_1.world
	self._wwise_world = Managers.world:wwise_world(self._world)

	local player = arg_1_3.player

	self._player = player
	self._is_server = player.is_server
	self._local_player = player.local_player
	self._bot_player = player.bot_player
	self._network_manager = Managers.state.network
	self._input_manager = Managers.input
	self._decal_unit = nil
	self._decal_unit_name = "units/decals/decal_arrow"
	self._fov_lerp_time = 0
	self._lunge_events = {
		start = function (self)
			-- function 2
			local first_person_extension = self.first_person_extension
			local unit = self.unit

			first_person_extension:play_hud_sound_event("Play_career_ability_kruber_charge_enter")
			first_person_extension:play_hud_sound_event("Play_career_ability_kruber_charge_forward")
			first_person_extension:play_remote_unit_sound_event("Play_career_ability_kruber_charge_enter", unit, 0)
			first_person_extension:play_remote_unit_sound_event("Play_career_ability_kruber_charge_forward", unit, 0)
		end,
		impact = function (self)
			-- function 3
			local first_person_extension = self.first_person_extension
			local _first_person_unit = self._first_person_unit
			local unit = self.unit
			local wwise_world = self.wwise_world
			local _num_impacts = self._num_impacts

			Unit.flow_event(_first_person_unit, "lua_es_knight_activated_impact")
			WwiseWorld.set_global_parameter(wwise_world, "knight_charge_num_impacts", _num_impacts)
			first_person_extension:play_hud_sound_event("Play_career_ability_kruber_charge_hit_player")
			first_person_extension:play_remote_unit_sound_event("Play_career_ability_kruber_charge_hit_player", unit, 0)
		end,
		finished = function (self)
			-- function 4
			local first_person_extension = self.first_person_extension
			local unit = self.unit

			first_person_extension:play_hud_sound_event("Stop_career_ability_kruber_charge_forward")
			first_person_extension:play_remote_unit_sound_event("Stop_career_ability_kruber_charge_forward", unit, 0)
		end
	}
end

CareerAbilityESKnight.extensions_ready = function (self, arg_5_1, arg_5_2)
	-- function 5
	self._first_person_extension = ScriptUnit.has_extension(arg_5_2, "first_person_system")
	self._status_extension = ScriptUnit.extension(arg_5_2, "status_system")
	self._career_extension = ScriptUnit.extension(arg_5_2, "career_system")
	self._buff_extension = ScriptUnit.extension(arg_5_2, "buff_system")
	self._input_extension = ScriptUnit.has_extension(arg_5_2, "input_system")

	if not self._first_person_extension then
		self._first_person_unit = self._first_person_extension:get_first_person_unit()
	end
end

CareerAbilityESKnight.destroy = function (arg_6_0)
	-- function 6
	return
end

CareerAbilityESKnight.update = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	if not self:_ability_available() then
		return
	end

	local _input_extension = self._input_extension

	if not _input_extension then
		return
	end

	if not self._is_priming then
		if not _input_extension:get("action_career") then
			self:_start_priming()
		end
	elseif not self._is_priming then
		self:_update_priming(arg_7_3)

		if not _input_extension:get("action_two") then
			self:_stop_priming()

			return
		end

		if not _input_extension:get("weapon_reload") then
			self:_stop_priming()

			return
		end

		if not _input_extension:get("toggle_menu") then
			self:_stop_priming()

			return
		end

		if not _input_extension:get("action_career_hold") then
			self:_run_ability()
		end
	end
end

CareerAbilityESKnight.stop = function (self, arg_8_1)
	-- function 8
	if arg_8_1 == "pushed" or arg_8_1 == "stunned" or not self._is_priming then
		self:_stop_priming()
	end
end

CareerAbilityESKnight._ability_available = function (self)
	-- function 9
	local _career_extension = self._career_extension
	local _status_extension = self._status_extension
	local can_use_activated_ability = _career_extension:can_use_activated_ability()

	can_use_activated_ability = not can_use_activated_ability and not _status_extension:is_disabled()

	return can_use_activated_ability
end

CareerAbilityESKnight._start_priming = function (self)
	-- function 10
	if not self._local_player then
		local _decal_unit_name = self._decal_unit_name

		self._decal_unit = Managers.state.unit_spawner:spawn_local_unit(_decal_unit_name)

		local str = "lua_es_knight_activated_start_priming"

		Unit.flow_event(self._owner_unit, str)
		Unit.flow_event(self._first_person_unit, str)
	end

	local _buff_extension = self._buff_extension
	local str_2 = "planted_decrease_movement"
	local tbl = {
		external_optional_multiplier = 0.3
	}

	self._buff_id = _buff_extension:add_buff(str_2, tbl)
	self._is_priming = true
end

CareerAbilityESKnight._update_priming = function (self, arg_11_1)
	-- function 11
	if not self._decal_unit then
		local _first_person_extension = self._first_person_extension
		local local_position = Unit.local_position(self._owner_unit, 0)
		local current_rotation = _first_person_extension:current_rotation()
		local flat = Vector3.flat(Vector3.normalize(Quaternion.forward(current_rotation)))
		local look = Quaternion.look(flat, Vector3.up())

		Unit.set_local_position(self._decal_unit, 0, local_position)
		Unit.set_local_rotation(self._decal_unit, 0, look)
	end

	if not self._local_player then
		local num = 2.5
		local num_2 = self._fov_lerp_time / num
		local lerp = math.lerp(1, 0.95, num_2)

		self._fov_lerp_time = math.min(self._fov_lerp_time + arg_11_1, num)

		Managers.state.camera:set_additional_fov_multiplier(lerp)
	end
end

CareerAbilityESKnight._stop_priming = function (self)
	-- function 12
	if not self._decal_unit then
		Managers.state.unit_spawner:mark_for_deletion(self._decal_unit)
	end

	if not self._buff_id then
		self._buff_extension:remove_buff(self._buff_id)

		self._buff_id = nil
	end

	if not self._local_player then
		local str = "lua_es_knight_activated_stop_priming"

		Unit.flow_event(self._owner_unit, str)
		Unit.flow_event(self._first_person_unit, str)

		self._fov_lerp_time = 0

		Managers.state.camera:set_additional_fov_multiplier(1)
	end

	self._is_priming = false
end

CareerAbilityESKnight._run_ability = function (self)
	-- function 13
	self:_stop_priming()

	local _owner_unit = self._owner_unit
	local _is_server = self._is_server
	local _status_extension = self._status_extension
	local _career_extension = self._career_extension
	local _buff_extension = self._buff_extension
	local extension = ScriptUnit.extension(_owner_unit, "talent_system")
	local _network_manager = self._network_manager
	local network_transmit = _network_manager.network_transmit
	local unit_game_object_id = _network_manager:unit_game_object_id(_owner_unit)
	local str = "markus_knight_activated_ability"

	_buff_extension:add_buff(str, {
		attacker_unit = _owner_unit
	})

	if not extension:has_talent("markus_knight_ability_invulnerability", "empire_soldier", true) then
		local str_2 = "markus_knight_ability_invulnerability_buff"

		_buff_extension:add_buff(str_2, {
			attacker_unit = _owner_unit
		})

		local var_13_11 = NetworkLookup.buff_templates[str_2]

		if not _is_server then
			network_transmit:send_rpc_clients("rpc_add_buff", unit_game_object_id, var_13_11, unit_game_object_id, 0, false)
		else
			network_transmit:send_rpc_server("rpc_add_buff", unit_game_object_id, var_13_11, unit_game_object_id, 0, false)
		end
	end

	_status_extension:set_noclip(true, "skill_knight")

	local num = 0.03
	local num_2 = 0.15

	_status_extension.do_lunge = {
		animation_end_event = "foot_knight_ability_charge_hit",
		allow_rotation = false,
		falloff_to_speed = 5,
		ledge_falloff_immunity = 0.5,
		dodge = true,
		first_person_animation_event = "foot_knight_ability_charge_start",
		first_person_animation_end_event = "foot_knight_ability_charge_hit",
		first_person_hit_animation_event = "charge_react",
		damage_start_time = 0.3,
		duration = 1.5,
		initial_speed = 20,
		animation_event = "foot_knight_ability_charge_start",
		lunge_events = self._lunge_events,
		speed_function = function (arg_14_0, arg_14_1)
			-- function 14
			local num_3 = 0.25
			local num_4 = arg_14_0 - num - num_2
			local num_5 = arg_14_1 - num - num_2 - num_3
			local num_6 = 0
			local num_7 = -3
			local num_8 = 20
			local num_9 = 15
			local num_10 = 2

			if not (not (num_4 <= 0) or not (num > 0)) then
				local num_11 = -num_4 / (num + num_2)

				return math.lerp(0, -1, num_11)
			elseif num_4 < num_2 then
				local num_12 = num_4 / num_2
				local cos = math.cos((num_12 + 1) * math.pi * 0.5)

				return math.min(math.lerp(num_7, num_6, cos), num_9)
			elseif num_4 < num_5 then
				local num_13 = num_4 / num_5
				local min = math.min(num_4 / (num_5 / 3), 1)
				local cos_2 = math.cos(num_13 * math.pi * 0.5)
				local var_14_14
				local num_14 = 0.25

				if num_4 > 8 * num_14 then
					var_14_14 = 0
				elseif num_4 > 7 * num_14 then
					var_14_14 = (num_4 - 1.4) / num_14
				elseif num_4 > 6 * num_14 then
					var_14_14 = (num_4 - 6 * num_14) / num_14
				elseif num_4 > 5 * num_14 then
					var_14_14 = (num_4 - 5 * num_14) / num_14
				elseif num_4 > 4 * num_14 then
					var_14_14 = (num_4 - 4 * num_14) / num_14
				elseif num_4 > 3 * num_14 then
					var_14_14 = (num_4 - 3 * num_14) / num_14
				elseif num_4 > 2 * num_14 then
					var_14_14 = (num_4 - 2 * num_14) / num_14
				elseif num_14 < num_4 then
					var_14_14 = (num_4 - num_14) / num_14
				else
					var_14_14 = num_4 / num_14
				end

				return (1 - var_14_14 * 0.4) * (min * min) * math.lerp(num_8, num_9, cos_2)
			else
				local num_15 = (num_4 - num_5) / num_3
				local num_16 = 1 + math.cos((num_15 + 1) * math.pi * 0.5)

				return math.lerp(num_10, num_8, num_16)
			end
		end,
		damage = {
			offset_forward = 2.4,
			height = 1.8,
			depth_padding = 0.6,
			hit_zone_hit_name = "full",
			ignore_shield = false,
			collision_filter = "filter_explosion_overlap_no_player",
			interrupt_on_max_hit_mass = true,
			power_level_multiplier = 1,
			interrupt_on_first_hit = false,
			damage_profile = "markus_knight_charge",
			width = 2,
			allow_backstab = false,
			stagger_angles = {
				max = 80,
				min = 25
			},
			on_interrupt_blast = {
				allow_backstab = false,
				radius = 3,
				power_level_multiplier = 1,
				hit_zone_hit_name = "full",
				damage_profile = "markus_knight_charge_blast",
				ignore_shield = false,
				collision_filter = "filter_explosion_overlap_no_player"
			}
		}
	}

	if not extension:has_talent("markus_knight_wide_charge", "empire_soldier", true) then
		_status_extension.do_lunge.damage.width = 5
		_status_extension.do_lunge.damage.interrupt_on_max_hit_mass = false
	end

	_career_extension:start_activated_ability_cooldown()
	self:_play_vo()
end

CareerAbilityESKnight._play_vo = function (self)
	-- function 15
	local _owner_unit = self._owner_unit
	local extension_input = ScriptUnit.extension_input(_owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end
