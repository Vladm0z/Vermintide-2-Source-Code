-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_bw_unchained.lua

CareerAbilityBWUnchained = class(CareerAbilityBWUnchained)

CareerAbilityBWUnchained.init = function (self, arg_1_1, arg_1_2, arg_1_3)
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
	self._priming_fx_name = "fx/chr_unchained_aoe_decal"
end

CareerAbilityBWUnchained.extensions_ready = function (self, arg_2_1, arg_2_2)
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

CareerAbilityBWUnchained.destroy = function (arg_3_0)
	-- function 3
	return
end

CareerAbilityBWUnchained.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
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

CareerAbilityBWUnchained.stop = function (self, arg_5_1)
	-- function 5
	if arg_5_1 == "pushed" or arg_5_1 == "stunned" or not self._is_priming then
		self:_stop_priming()
	end
end

CareerAbilityBWUnchained._ability_available = function (self)
	-- function 6
	local _career_extension = self._career_extension
	local _status_extension = self._status_extension
	local can_use_activated_ability = _career_extension:can_use_activated_ability()

	can_use_activated_ability = not can_use_activated_ability and not _status_extension:is_disabled()

	return can_use_activated_ability
end

CareerAbilityBWUnchained._start_priming = function (self)
	-- function 7
	if not self._local_player then
		local _world = self._world
		local _priming_fx_name = self._priming_fx_name

		if not ScriptUnit.extension(self._owner_unit, "talent_system"):has_talent("sienna_unchained_activated_ability_power_on_enemies_hit", "bright_wizard", true) then
			_priming_fx_name = "fx/chr_unchained_aoe_decal_large"
		end

		self._priming_fx_id = World.create_particles(_world, _priming_fx_name, Vector3.zero())
	end

	self._is_priming = true
end

CareerAbilityBWUnchained._update_priming = function (self, arg_8_1)
	-- function 8
	local _priming_fx_id = self._priming_fx_id

	if not _priming_fx_id then
		local _world = self._world
		local _owner_unit = self._owner_unit
		local var_8_3 = POSITION_LOOKUP[_owner_unit]

		World.move_particles(_world, _priming_fx_id, var_8_3)
	end
end

CareerAbilityBWUnchained._stop_priming = function (self)
	-- function 9
	local _world = self._world
	local _priming_fx_id = self._priming_fx_id

	if not _priming_fx_id then
		World.destroy_particles(_world, _priming_fx_id)

		self._priming_fx_id = nil
	end

	self._is_priming = false
end

CareerAbilityBWUnchained._run_ability = function (self, arg_10_1)
	-- function 10
	self:_stop_priming()

	local _owner_unit = self._owner_unit
	local _is_server = self._is_server
	local _local_player = self._local_player
	local _bot_player = self._bot_player
	local var_10_4 = POSITION_LOOKUP[_owner_unit]
	local _network_manager = self._network_manager
	local network_transmit = _network_manager.network_transmit
	local _career_extension = self._career_extension
	local _buff_extension = self._buff_extension
	local extension = ScriptUnit.extension(_owner_unit, "talent_system")
	local str = "sienna_unchained_activated_ability"

	_buff_extension:add_buff(str, {
		attacker_unit = _owner_unit
	})

	if not _is_server and _bot_player and not _local_player then
		ScriptUnit.extension(_owner_unit, "overcharge_system"):reset()
		_career_extension:set_state("sienna_activate_unchained")
	end

	local local_rotation = Unit.local_rotation(_owner_unit, 0)
	local str_2 = "explosion_bw_unchained_ability"
	local num = 1

	if not extension:has_talent("sienna_unchained_activated_ability_fire_aura") then
		str_2 = "explosion_bw_unchained_ability_increased_radius"
	end

	local get_career_power_level = _career_extension:get_career_power_level()

	if not extension:has_talent("sienna_unchained_activated_ability_temp_health") then
		local num_2 = 10
		local alloc_table = FrameTable.alloc_table()
		local player_units_broadphase = Managers.state.entity:system("proximity_system").player_units_broadphase

		Broadphase.query(player_units_broadphase, POSITION_LOOKUP[_owner_unit], num_2, alloc_table)

		local side = Managers.state.side
		local get_talent_attribute = TalentUtils.get_talent_attribute("sienna_unchained_activated_ability_temp_health", "heal_amount")
		local career_skill = NetworkLookup.heal_types.career_skill

		for k, v in pairs(alloc_table) do
			if not side:is_enemy(self._owner_unit, v) then
				local unit_game_object_id = _network_manager:unit_game_object_id(v)

				if not unit_game_object_id then
					network_transmit:send_rpc_server("rpc_request_heal", unit_game_object_id, get_talent_attribute, career_skill)
				end
			end
		end
	end

	local get_template = ExplosionUtils.get_template(str_2)
	local unit_game_object_id_2 = _network_manager:unit_game_object_id(_owner_unit)
	local str_3 = "career_ability"
	local var_10_25 = NetworkLookup.explosion_templates[str_2]
	local var_10_26 = NetworkLookup.damage_sources[str_3]
	local flag = false

	if not _is_server then
		network_transmit:send_rpc_clients("rpc_create_explosion", unit_game_object_id_2, false, var_10_4, local_rotation, var_10_25, num, var_10_26, get_career_power_level, false, unit_game_object_id_2)
	else
		network_transmit:send_rpc_server("rpc_create_explosion", unit_game_object_id_2, false, var_10_4, local_rotation, var_10_25, num, var_10_26, get_career_power_level, false, unit_game_object_id_2)
	end

	DamageUtils.create_explosion(self._world, _owner_unit, var_10_4, local_rotation, get_template, num, str_3, _is_server, flag, _owner_unit, get_career_power_level, false, _owner_unit)
	_career_extension:start_activated_ability_cooldown()

	if not extension:has_talent("sienna_unchained_activated_ability_fire_aura") then
		local tbl = {
			"sienna_unchained_activated_ability_pulse"
		}
		local unit_game_object_id_3 = _network_manager:unit_game_object_id(_owner_unit)

		if not _is_server then
			local _buff_extension_2 = self._buff_extension

			for k_2 = 1, #tbl do
				local var_10_31 = tbl[k_2]
				local var_10_32 = NetworkLookup.buff_templates[var_10_31]

				_buff_extension_2:add_buff(var_10_31, {
					attacker_unit = _owner_unit
				})
				network_transmit:send_rpc_clients("rpc_add_buff", unit_game_object_id_3, var_10_32, unit_game_object_id_3, 0, false)
			end
		else
			for l = 1, #tbl do
				local var_10_33 = tbl[l]
				local var_10_34 = NetworkLookup.buff_templates[var_10_33]

				network_transmit:send_rpc_server("rpc_add_buff", unit_game_object_id_3, var_10_34, unit_game_object_id_3, 0, true)
			end
		end
	end

	if not extension:has_talent("sienna_unchained_activated_ability_power_on_enemies_hit") then
		local ability = NetworkLookup.buff_attack_types.ability
		local unit_game_object_id_4 = _network_manager:unit_game_object_id(_owner_unit)
		local var_10_37 = NetworkLookup.buff_weapon_types["n/a"]
		local torso = NetworkLookup.hit_zones.torso
		local num_3 = 10
		local alloc_table_2 = FrameTable.alloc_table()
		local enemy_broadphase = Managers.state.entity:system("proximity_system").enemy_broadphase

		Broadphase.query(enemy_broadphase, var_10_4, num_3, alloc_table_2)

		local num_4 = 1
		local side_2 = Managers.state.side

		for k_3, v_2 in pairs(alloc_table_2) do
			if not Unit.alive(v_2) then
				local unit_game_object_id_5 = _network_manager:unit_game_object_id(v_2)

				if not side_2:is_enemy(_owner_unit, v_2) then
					if not _is_server then
						network_transmit:send_rpc_server("rpc_buff_on_attack", unit_game_object_id_4, unit_game_object_id_5, ability, false, torso, num_4, var_10_37, var_10_26)
					else
						network_transmit:send_rpc_server("rpc_buff_on_attack", unit_game_object_id_4, unit_game_object_id_5, ability, false, torso, num_4, var_10_37, var_10_26)
					end
				end
			end
		end
	end

	local get_all_weapon_unit, var_10_46 = ScriptUnit.has_extension(_owner_unit, "inventory_system"):get_all_weapon_unit()
	local flag_2 = not get_all_weapon_unit and ScriptUnit.has_extension(get_all_weapon_unit, "weapon_system")
	local flag_3 = not var_10_46 and ScriptUnit.has_extension(var_10_46, "weapon_system")
	local flag_4 = not flag_2 and flag_2:has_current_action()

	flag_4 = flag_4 or not flag_3 or flag_3:has_current_action()

	if not flag_4 then
		CharacterStateHelper.play_animation_event(_owner_unit, "unchained_ability_explosion")
	end

	if not _is_server and _bot_player and not _local_player then
		local _first_person_extension = self._first_person_extension

		if not flag_4 then
			_first_person_extension:animation_event("unchained_ability_explosion")
		end

		_first_person_extension:play_hud_sound_event("Play_career_ability_unchained_fire")
		_first_person_extension:play_remote_unit_sound_event("Play_career_ability_unchained_fire", _owner_unit, 0)
	end

	self:_play_vo()
end

CareerAbilityBWUnchained._play_vo = function (self)
	-- function 11
	local _owner_unit = self._owner_unit
	local extension_input = ScriptUnit.extension_input(_owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end
