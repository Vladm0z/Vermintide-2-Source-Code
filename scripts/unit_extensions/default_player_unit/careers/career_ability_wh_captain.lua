-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_wh_captain.lua

CareerAbilityWHCaptain = class(CareerAbilityWHCaptain)

CareerAbilityWHCaptain.init = function (self, arg_1_1, arg_1_2, arg_1_3)
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

CareerAbilityWHCaptain.extensions_ready = function (self, arg_2_1, arg_2_2)
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

CareerAbilityWHCaptain.destroy = function (arg_3_0)
	-- function 3
	return
end

CareerAbilityWHCaptain.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
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

CareerAbilityWHCaptain.stop = function (self, arg_5_1)
	-- function 5
	if arg_5_1 == "pushed" or arg_5_1 == "stunned" or not self._is_priming then
		self:_stop_priming()
	end
end

CareerAbilityWHCaptain._ability_available = function (self)
	-- function 6
	local _career_extension = self._career_extension
	local _status_extension = self._status_extension
	local can_use_activated_ability = _career_extension:can_use_activated_ability()

	can_use_activated_ability = not can_use_activated_ability and not _status_extension:is_disabled()

	return can_use_activated_ability
end

CareerAbilityWHCaptain._start_priming = function (self)
	-- function 7
	if not self._local_player then
		local _world = self._world
		local _priming_fx_name = self._priming_fx_name

		self._priming_fx_id = World.create_particles(_world, _priming_fx_name, Vector3.zero())
	end

	self._is_priming = true
end

CareerAbilityWHCaptain._update_priming = function (self, arg_8_1)
	-- function 8
	local _priming_fx_id = self._priming_fx_id

	if not _priming_fx_id then
		local _world = self._world
		local _owner_unit = self._owner_unit
		local var_8_3 = POSITION_LOOKUP[_owner_unit]

		World.move_particles(_world, _priming_fx_id, var_8_3)
	end
end

CareerAbilityWHCaptain._stop_priming = function (self)
	-- function 9
	local _priming_fx_id = self._priming_fx_id

	if not _priming_fx_id then
		local _world = self._world

		World.destroy_particles(_world, _priming_fx_id)

		self._priming_fx_id = nil
	end

	self._is_priming = false
end

CareerAbilityWHCaptain._run_ability = function (self, arg_10_1)
	-- function 10
	self:_stop_priming()

	local _career_extension = self._career_extension

	_career_extension:start_activated_ability_cooldown()

	local _world = self._world
	local _owner_unit = self._owner_unit
	local _is_server = self._is_server
	local _local_player = self._local_player
	local _bot_player = self._bot_player
	local extension = ScriptUnit.extension(_owner_unit, "talent_system")
	local system = Managers.state.entity:system("buff_system")
	local str = "victor_witchhunter_activated_ability_crit_buff"
	local _network_manager = self._network_manager
	local network_transmit = _network_manager.network_transmit

	CharacterStateHelper.play_animation_event(_owner_unit, "witch_hunter_active_ability")

	local num = 10
	local var_10_12 = POSITION_LOOKUP[_owner_unit]

	if not extension:has_talent("victor_witchhunter_activated_ability_guaranteed_crit_self_buff") then
		local alloc_table = FrameTable.alloc_table()
		local player_units_broadphase = Managers.state.entity:system("proximity_system").player_units_broadphase

		Broadphase.query(player_units_broadphase, var_10_12, num, alloc_table)

		local side = Managers.state.side

		for k, v in pairs(alloc_table) do
			if not (not Unit.alive(v) and side:is_enemy(_owner_unit, v)) then
				system:add_buff(v, str, _owner_unit)
			end
		end
	else
		local str_2 = "victor_witchhunter_activated_ability_guaranteed_crit_self_buff"

		system:add_buff(_owner_unit, str_2, _owner_unit)
	end

	local str_3 = "victor_captain_activated_ability_stagger"
	local get_template = ExplosionUtils.get_template(str_3)

	if not extension:has_talent("victor_captain_activated_ability_stagger_ping_debuff", "witch_hunter", true) then
		if not extension:has_talent("victor_witchhunter_improved_damage_taken_ping", "witch_hunter", true) then
			str_3 = "victor_captain_activated_ability_stagger_ping_debuff_improved"
			get_template = ExplosionUtils.get_template(str_3)
		else
			str_3 = "victor_captain_activated_ability_stagger_ping_debuff"
			get_template = ExplosionUtils.get_template(str_3)
		end
	end

	local num_2 = 1
	local str_4 = "career_ability"
	local flag = false
	local identity = Quaternion.identity()
	local get_career_power_level = _career_extension:get_career_power_level()

	DamageUtils.create_explosion(_world, _owner_unit, var_10_12, identity, get_template, num_2, str_4, _is_server, flag, _owner_unit, get_career_power_level, false, _owner_unit)

	local unit_game_object_id = _network_manager:unit_game_object_id(_owner_unit)
	local var_10_25 = NetworkLookup.explosion_templates[str_3]
	local var_10_26 = NetworkLookup.damage_sources[str_4]

	if not _is_server then
		network_transmit:send_rpc_clients("rpc_create_explosion", unit_game_object_id, false, var_10_12, identity, var_10_25, num_2, var_10_26, get_career_power_level, false, unit_game_object_id)
	else
		network_transmit:send_rpc_server("rpc_create_explosion", unit_game_object_id, false, var_10_12, identity, var_10_25, num_2, var_10_26, get_career_power_level, false, unit_game_object_id)
	end

	if not extension:has_talent("victor_witchhunter_activated_ability_refund_cooldown_on_enemies_hit") then
		local alloc_table_2 = FrameTable.alloc_table()
		local enemy_broadphase = Managers.state.entity:system("proximity_system").enemy_broadphase

		Broadphase.query(enemy_broadphase, var_10_12, num, alloc_table_2)

		local num_3 = 1
		local side_2 = Managers.state.side

		for k_2, v_2 in pairs(alloc_table_2) do
			if not Unit.alive(v_2) and not side_2:is_enemy(_owner_unit, v_2) then
				DamageUtils.buff_on_attack(_owner_unit, v_2, "ability", false, "torso", num_3, false, "n/a", nil, str_4)

				num_3 = num_3 + 1
			end
		end
	end

	if not _is_server and _bot_player and not _local_player then
		local _first_person_extension = self._first_person_extension

		_first_person_extension:animation_event("ability_shout")
		_first_person_extension:play_hud_sound_event("Play_career_ability_captain_shout_out")
		_first_person_extension:play_remote_unit_sound_event("Play_career_ability_captain_shout_out", _owner_unit, 0)
	end

	self:_play_vo()
	self:_play_vfx()
end

CareerAbilityWHCaptain._play_vo = function (self)
	-- function 11
	local _owner_unit = self._owner_unit
	local extension_input = ScriptUnit.extension_input(_owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end

CareerAbilityWHCaptain._play_vfx = function (self)
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
