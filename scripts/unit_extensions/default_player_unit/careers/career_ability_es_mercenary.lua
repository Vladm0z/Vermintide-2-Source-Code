-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_es_mercenary.lua

CareerAbilityESMercenary = class(CareerAbilityESMercenary)

CareerAbilityESMercenary.init = function (self, arg_1_1, arg_1_2, arg_1_3)
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

CareerAbilityESMercenary.extensions_ready = function (self, arg_2_1, arg_2_2)
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

CareerAbilityESMercenary.destroy = function (arg_3_0)
	-- function 3
	return
end

CareerAbilityESMercenary.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
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

CareerAbilityESMercenary.stop = function (self, arg_5_1)
	-- function 5
	if arg_5_1 == "pushed" or arg_5_1 == "stunned" or not self._is_priming then
		self:_stop_priming()
	end
end

CareerAbilityESMercenary._ability_available = function (self)
	-- function 6
	local _career_extension = self._career_extension
	local _status_extension = self._status_extension
	local can_use_activated_ability = _career_extension:can_use_activated_ability()

	can_use_activated_ability = not can_use_activated_ability and not _status_extension:is_disabled()

	return can_use_activated_ability
end

CareerAbilityESMercenary._start_priming = function (self)
	-- function 7
	if not self._local_player then
		local _world = self._world
		local _priming_fx_name = self._priming_fx_name

		self._priming_fx_id = World.create_particles(_world, _priming_fx_name, Vector3.zero())
	end

	self._is_priming = true
end

CareerAbilityESMercenary._update_priming = function (self, arg_8_1)
	-- function 8
	local _priming_fx_id = self._priming_fx_id

	if not _priming_fx_id then
		local _world = self._world
		local _owner_unit = self._owner_unit
		local var_8_3 = POSITION_LOOKUP[_owner_unit]

		World.move_particles(_world, _priming_fx_id, var_8_3)
	end
end

CareerAbilityESMercenary._stop_priming = function (self)
	-- function 9
	local _priming_fx_id = self._priming_fx_id

	if not _priming_fx_id then
		local _world = self._world

		World.destroy_particles(_world, _priming_fx_id)

		self._priming_fx_id = nil
	end

	self._is_priming = false
end

CareerAbilityESMercenary._run_ability = function (self, arg_10_1)
	-- function 10
	self:_stop_priming()

	local _world = self._world
	local _owner_unit = self._owner_unit
	local _is_server = self._is_server
	local _local_player = self._local_player
	local _bot_player = self._bot_player
	local _network_manager = self._network_manager
	local network_transmit = _network_manager.network_transmit
	local _career_extension = self._career_extension
	local extension = ScriptUnit.extension(_owner_unit, "talent_system")

	CharacterStateHelper.play_animation_event(_owner_unit, "mercenary_active_ability")

	local num = 15
	local alloc_table = FrameTable.alloc_table()
	local player_units_broadphase = Managers.state.entity:system("proximity_system").player_units_broadphase

	Broadphase.query(player_units_broadphase, POSITION_LOOKUP[_owner_unit], num, alloc_table)

	local side = Managers.state.side
	local alloc_table_2 = FrameTable.alloc_table()

	for k, v in pairs(alloc_table) do
		if side:is_enemy(self._owner_unit, v) or not ScriptUnit.extension(v, "status_system"):is_available_for_career_revive() then
			alloc_table_2[#alloc_table_2 + 1] = v
		end
	end

	local unit_game_object_id = _network_manager:unit_game_object_id(_owner_unit)

	if not extension:has_talent("markus_mercenary_activated_ability_revive") then
		for k_2, v_2 in pairs(alloc_table_2) do
			local unit_game_object_id_2 = _network_manager:unit_game_object_id(v_2)

			network_transmit:send_rpc_server("rpc_request_revive", unit_game_object_id_2, unit_game_object_id)
			CharacterStateHelper.play_animation_event(v_2, "revive_complete")
		end
	end

	local heal_amount = CareerUtils.get_ability_data(_career_extension:profile_index(), _career_extension:career_index(), 1).heal_amount
	local career_skill = NetworkLookup.heal_types.career_skill

	for k_3, v_3 in pairs(alloc_table) do
		if not side:is_enemy(self._owner_unit, v_3) then
			local unit_game_object_id_3 = _network_manager:unit_game_object_id(v_3)

			if not unit_game_object_id_3 then
				if not extension:has_talent("markus_mercenary_activated_ability_damage_reduction") then
					Managers.state.entity:system("buff_system"):add_buff(v_3, "markus_mercenary_activated_ability_damage_reduction", self._owner_unit, false)
				end

				network_transmit:send_rpc_server("rpc_request_heal", unit_game_object_id_3, heal_amount, career_skill)
			end
		end
	end

	if not _is_server and _bot_player and not _local_player then
		local _first_person_extension = self._first_person_extension

		_first_person_extension:animation_event("ability_shout")
		_first_person_extension:play_hud_sound_event("Play_career_ability_mercenary_shout_out")
		_first_person_extension:play_remote_unit_sound_event("Play_career_ability_mercenary_shout_out", _owner_unit, 0)
	end

	local str = "kruber_mercenary_activated_ability_stagger"
	local get_template = ExplosionUtils.get_template(str)
	local num_2 = 1
	local str_2 = "career_ability"
	local flag = false
	local identity = Quaternion.identity()
	local get_career_power_level = _career_extension:get_career_power_level()
	local PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[_owner_unit].PLAYER_AND_BOT_UNITS
	local count = #PLAYER_AND_BOT_UNITS

	for i6 = 1, count do
		local var_10_29 = PLAYER_AND_BOT_UNITS[i6]
		local has_extension = ScriptUnit.has_extension(var_10_29, "attack_intensity_system")

		if not has_extension then
			has_extension:add_attack_intensity("normal", 20, 20)
		end
	end

	self:_play_vo()
	self:_play_vfx()
	_career_extension:start_activated_ability_cooldown()

	local var_10_31 = POSITION_LOOKUP[_owner_unit]
	local var_10_32 = NetworkLookup.explosion_templates[str]
	local var_10_33 = NetworkLookup.damage_sources[str_2]

	if not _is_server then
		network_transmit:send_rpc_clients("rpc_create_explosion", unit_game_object_id, false, var_10_31, identity, var_10_32, num_2, var_10_33, get_career_power_level, false, unit_game_object_id)
	else
		network_transmit:send_rpc_server("rpc_create_explosion", unit_game_object_id, false, var_10_31, identity, var_10_32, num_2, var_10_33, get_career_power_level, false, unit_game_object_id)
	end

	DamageUtils.create_explosion(_world, _owner_unit, var_10_31, identity, get_template, num_2, str_2, _is_server, flag, _owner_unit, get_career_power_level, false, _owner_unit)
end

CareerAbilityESMercenary._play_vo = function (self)
	-- function 11
	local _owner_unit = self._owner_unit
	local extension_input = ScriptUnit.extension_input(_owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end

CareerAbilityESMercenary._play_vfx = function (self)
	-- function 12
	local _owner_unit = self._owner_unit
	local _network_manager = self._network_manager
	local network_transmit = _network_manager.network_transmit
	local unit_game_object_id = _network_manager:unit_game_object_id(_owner_unit)
	local str = "fx/chr_kruber_shockwave"
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
