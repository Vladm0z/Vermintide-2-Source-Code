-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_dr_ironbreaker.lua

CareerAbilityDRIronbreaker = class(CareerAbilityDRIronbreaker)

CareerAbilityDRIronbreaker.init = function (self, arg_1_1, arg_1_2, arg_1_3)
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
	self._priming_fx_id = nil
	self._priming_fx_name = "fx/chr_ironbreaker_aoe_decal"
end

CareerAbilityDRIronbreaker.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._first_person_extension = ScriptUnit.has_extension(arg_2_2, "first_person_system")
	self._status_extension = ScriptUnit.extension(arg_2_2, "status_system")
	self._career_extension = ScriptUnit.extension(arg_2_2, "career_system")
	self._buff_extension = ScriptUnit.extension(arg_2_2, "buff_system")
	self._input_extension = ScriptUnit.has_extension(arg_2_2, "input_system")

	if not self._first_person_extension then
		self._first_person_unit = self._first_person_extension:get_first_person_unit()
	end
end

CareerAbilityDRIronbreaker.destroy = function (arg_3_0)
	-- function 3
	return
end

CareerAbilityDRIronbreaker.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
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
		self:_update_priming(arg_4_3)

		if not _input_extension:get("action_two") then
			self:_stop_priming()

			return
		end

		if not _input_extension:get("weapon_reload") then
			self:_stop_priming()

			return
		end

		if not _input_extension:get("action_career_hold") then
			self:_run_ability()
		end
	end
end

CareerAbilityDRIronbreaker.stop = function (self, arg_5_1)
	-- function 5
	if arg_5_1 == "pushed" or arg_5_1 == "stunned" or not self._is_priming then
		self:_stop_priming()
	end
end

CareerAbilityDRIronbreaker._ability_available = function (self)
	-- function 6
	local _career_extension = self._career_extension
	local _status_extension = self._status_extension
	local can_use_activated_ability = _career_extension:can_use_activated_ability()

	can_use_activated_ability = not can_use_activated_ability and not _status_extension:is_disabled()

	return can_use_activated_ability
end

CareerAbilityDRIronbreaker._start_priming = function (self)
	-- function 7
	if not self._local_player then
		local _world = self._world
		local _priming_fx_name = self._priming_fx_name

		self._priming_fx_id = World.create_particles(_world, _priming_fx_name, Vector3.zero())
	end

	self._is_priming = true
end

CareerAbilityDRIronbreaker._update_priming = function (self, arg_8_1)
	-- function 8
	local _priming_fx_id = self._priming_fx_id

	if not _priming_fx_id then
		local _world = self._world
		local _owner_unit = self._owner_unit
		local var_8_3 = POSITION_LOOKUP[_owner_unit]

		World.move_particles(_world, _priming_fx_id, var_8_3)
	end
end

CareerAbilityDRIronbreaker._stop_priming = function (self)
	-- function 9
	local _priming_fx_id = self._priming_fx_id

	if not _priming_fx_id then
		local _world = self._world

		World.destroy_particles(_world, _priming_fx_id)

		self._priming_fx_id = nil
	end

	self._is_priming = false
end

CareerAbilityDRIronbreaker._run_ability = function (self)
	-- function 10
	self:_stop_priming()

	local _owner_unit = self._owner_unit
	local _is_server = self._is_server
	local _local_player = self._local_player
	local _bot_player = self._bot_player
	local _network_manager = self._network_manager
	local network_transmit = _network_manager.network_transmit
	local unit_game_object_id = _network_manager:unit_game_object_id(_owner_unit)
	local _career_extension = self._career_extension
	local extension = ScriptUnit.extension(_owner_unit, "talent_system")

	CharacterStateHelper.play_animation_event(_owner_unit, "iron_breaker_active_ability")

	local tbl = {
		"bardin_ironbreaker_activated_ability",
		"bardin_ironbreaker_activated_ability_block_cost",
		"bardin_ironbreaker_activated_ability_attack_intensity_decay_increase"
	}

	if not extension:has_talent("bardin_ironbreaker_activated_ability_taunt_range_and_duration") then
		table.clear(tbl)

		tbl = {
			"bardin_ironbreaker_activated_ability_taunt_range_and_duration",
			"bardin_ironbreaker_activated_ability_taunt_range_and_duration_block_cost",
			"bardin_ironbreaker_activated_ability_taunt_range_and_duration_attack_intensity_decay_increase"
		}
	end

	local alloc_table = FrameTable.alloc_table()

	alloc_table[1] = _owner_unit

	local num = 10
	local num_2 = 10

	if not extension:has_talent("bardin_ironbreaker_activated_ability_taunt_range_and_duration") then
		num_2 = 15
		num = 15
	end

	if not extension:has_talent("bardin_ironbreaker_activated_ability_power_buff_allies") then
		local PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[_owner_unit].PLAYER_AND_BOT_UNITS
		local count = #PLAYER_AND_BOT_UNITS

		for i = 1, count do
			local var_10_15 = PLAYER_AND_BOT_UNITS[i]
			local var_10_16 = POSITION_LOOKUP[var_10_15]
			local var_10_17 = POSITION_LOOKUP[_owner_unit]

			if Vector3.distance_squared(var_10_17, var_10_16) < num * num then
				local str = "bardin_ironbreaker_activated_ability_power_buff"
				local unit_game_object_id_2 = _network_manager:unit_game_object_id(var_10_15)
				local extension_2 = ScriptUnit.extension(var_10_15, "buff_system")
				local var_10_21 = NetworkLookup.buff_templates[str]

				if not _is_server then
					extension_2:add_buff(str)
					network_transmit:send_rpc_clients("rpc_add_buff", unit_game_object_id_2, var_10_21, unit_game_object_id, 0, false)
				else
					network_transmit:send_rpc_server("rpc_add_buff", unit_game_object_id_2, var_10_21, unit_game_object_id, 0, true)
				end
			end
		end
	end

	local flag = true
	local has_talent = extension:has_talent("bardin_ironbreaker_activated_ability_taunt_bosses")

	if not _is_server then
		ScriptUnit.extension(_owner_unit, "target_override_system"):taunt(num, num_2, flag, has_talent)
	else
		network_transmit:send_rpc_server("rpc_taunt", unit_game_object_id, num, num_2, flag, has_talent)
	end

	local count_2 = #alloc_table

	for j = 1, count_2 do
		local var_10_25 = alloc_table[j]
		local unit_game_object_id_3 = _network_manager:unit_game_object_id(var_10_25)
		local extension_3 = ScriptUnit.extension(var_10_25, "buff_system")

		for i_2, v in ipairs(tbl) do
			local var_10_28 = NetworkLookup.buff_templates[v]

			if not _is_server then
				extension_3:add_buff(v, {
					attacker_unit = _owner_unit
				})
				network_transmit:send_rpc_clients("rpc_add_buff", unit_game_object_id_3, var_10_28, unit_game_object_id, 0, false)
			else
				network_transmit:send_rpc_server("rpc_add_buff", unit_game_object_id_3, var_10_28, unit_game_object_id, 0, true)
			end
		end
	end

	if not _is_server and _bot_player and not _local_player then
		local _first_person_extension = self._first_person_extension

		_first_person_extension:animation_event("ability_shout")
		_first_person_extension:play_hud_sound_event("Play_career_ability_bardin_ironbreaker_enter")
		_first_person_extension:play_remote_unit_sound_event("Play_career_ability_bardin_ironbreaker_enter", _owner_unit, 0)
	end

	self:_play_vfx()
	self:_play_vo()
	_career_extension:start_activated_ability_cooldown()
end

CareerAbilityDRIronbreaker._play_vo = function (self)
	-- function 11
	local _owner_unit = self._owner_unit
	local extension_input = ScriptUnit.extension_input(_owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end

CareerAbilityDRIronbreaker._play_vfx = function (self)
	-- function 12
	local _owner_unit = self._owner_unit
	local _network_manager = self._network_manager
	local network_transmit = _network_manager.network_transmit
	local unit_game_object_id = _network_manager:unit_game_object_id(_owner_unit)
	local str = "fx/chr_iron_breaker_ability_taunt"
	local var_12_5 = NetworkLookup.effects[str]
	local var_12_6 = unit_game_object_id
	local num = 0
	local var_12_8 = Vector3(0, 0, 0)
	local identity = Quaternion.identity()
	local flag = false

	Managers.state.event:trigger("event_play_particle_effect", str, _owner_unit, num, var_12_8, identity, flag)

	if not Managers.player.is_server then
		network_transmit:send_rpc_clients("rpc_play_particle_effect", var_12_5, var_12_6, num, var_12_8, identity, flag)
	else
		network_transmit:send_rpc_server("rpc_play_particle_effect", var_12_5, var_12_6, num, var_12_8, identity, flag)
	end
end
