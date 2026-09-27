-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_we_shade_dash.lua

CareerAbilityWEShadeDash = class(CareerAbilityWEShadeDash)

CareerAbilityWEShadeDash.init = function (self, arg_1_1, arg_1_2, arg_1_3)
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
	self._lunge_events = {
		start = function (arg_2_0)
			-- function 2
			local _owner_unit = self._owner_unit
			local _local_player = self._local_player
			local _bot_player = self._bot_player
			local _is_server = self._is_server
			local _network_manager = self._network_manager
			local network_transmit = _network_manager.network_transmit
			local _career_extension = self._career_extension
			local _status_extension = self._status_extension
			local _buff_extension = self._buff_extension
			local str = "kerillian_shade_activated_ability"

			if not ScriptUnit.extension(self._owner_unit, "talent_system"):has_talent("kerillian_shade_activated_ability_quick_cooldown", "wood_elf", true) then
				str = "kerillian_shade_activated_ability_quick_cooldown"
			end

			local var_2_10 = NetworkLookup.buff_templates[str]
			local unit_game_object_id = _network_manager:unit_game_object_id(_owner_unit)

			if not _is_server then
				_buff_extension:add_buff(str, {
					attacker_unit = _owner_unit
				})
				network_transmit:send_rpc_clients("rpc_add_buff", unit_game_object_id, var_2_10, unit_game_object_id, 0, false)
			else
				network_transmit:send_rpc_server("rpc_add_buff", unit_game_object_id, var_2_10, unit_game_object_id, 0, true)
			end

			if _local_player or not _is_server or not _bot_player then
				local set_invisible = _status_extension:set_invisible(true, nil, "skill_shade")

				_status_extension:set_noclip(true, "skill_shade")

				local tbl = {
					"Play_career_ability_kerillian_shade_enter",
					"Play_career_ability_kerillian_shade_loop_husk"
				}
				local unit_game_object_id_2 = _network_manager:unit_game_object_id(_owner_unit)
				local num = 0

				for i, v in ipairs(tbl) do
					local var_2_16 = NetworkLookup.sound_events[v]

					if not _is_server then
						network_transmit:send_rpc_clients("rpc_play_husk_unit_sound_event", unit_game_object_id_2, num, var_2_16)
					else
						network_transmit:send_rpc_server("rpc_play_husk_unit_sound_event", unit_game_object_id_2, num, var_2_16)
					end
				end

				if not _bot_player then
					local _first_person_extension = self._first_person_extension

					if not set_invisible then
						_first_person_extension:play_hud_sound_event("Play_career_ability_kerillian_shade_loop")
					end

					_first_person_extension:play_hud_sound_event("Play_career_ability_kerillian_shade_enter")
					_first_person_extension:animation_event("shade_stealth_ability")
					_career_extension:set_state("kerillian_activate_shade")
				end
			end
		end,
		impact = function (arg_3_0)
			-- function 3
			return
		end,
		finished = function (arg_4_0)
			-- function 4
			return
		end
	}
	self._decal_unit = nil
	self._decal_unit_name = "units/decals/decal_arrow_kerillian"
end

CareerAbilityWEShadeDash.extensions_ready = function (self, arg_5_1, arg_5_2)
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

CareerAbilityWEShadeDash.destroy = function (arg_6_0)
	-- function 6
	return
end

CareerAbilityWEShadeDash.update = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
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
		self:_update_priming()

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

CareerAbilityWEShadeDash.stop = function (self, arg_8_1)
	-- function 8
	if arg_8_1 == "pushed" or arg_8_1 == "stunned" or not self._is_priming then
		self:_stop_priming()
	end
end

CareerAbilityWEShadeDash._ability_available = function (self)
	-- function 9
	local _career_extension = self._career_extension
	local _status_extension = self._status_extension
	local extension = ScriptUnit.extension(self._owner_unit, "talent_system")
	local flag = false

	if not flag then
		-- Nothing
	end

	::label_9_0::

	local can_use_activated_ability = _career_extension:can_use_activated_ability()

	can_use_activated_ability = not can_use_activated_ability and not _status_extension:is_disabled()

	::label_9_1::

	return can_use_activated_ability
end

CareerAbilityWEShadeDash._start_priming = function (self)
	-- function 10
	if not self._local_player then
		local _decal_unit_name = self._decal_unit_name

		self._decal_unit = Managers.state.unit_spawner:spawn_local_unit(_decal_unit_name)
	end

	self._is_priming = true
end

CareerAbilityWEShadeDash._update_priming = function (self)
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
end

CareerAbilityWEShadeDash._stop_priming = function (self)
	-- function 12
	if not self._decal_unit then
		Managers.state.unit_spawner:mark_for_deletion(self._decal_unit)
	end

	self._is_priming = false
end

CareerAbilityWEShadeDash._run_ability = function (self)
	-- function 13
	self:_stop_priming()

	local _owner_unit = self._owner_unit
	local _is_server = self._is_server
	local _local_player = self._local_player
	local _bot_player = self._bot_player
	local _network_manager = self._network_manager
	local network_transmit = _network_manager.network_transmit
	local _status_extension = self._status_extension
	local _career_extension = self._career_extension

	if not _is_server and _bot_player and not _local_player then
		local _first_person_extension = self._first_person_extension

		_first_person_extension:animation_event("shade_stealth_ability")
		_first_person_extension:play_hud_sound_event("Play_career_ability_shade_shadowstep_charge")
		_first_person_extension:play_remote_unit_sound_event("Play_career_ability_shade_shadowstep_charge", _owner_unit, 0)
		_career_extension:set_state("kerillian_activate_maiden_guard")
	end

	_status_extension:set_noclip(true, "skill_shade")

	if not _network_manager:game() then
		_status_extension:set_is_dodging(true)

		local unit_game_object_id = _network_manager:unit_game_object_id(_owner_unit)

		network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, true, unit_game_object_id, 0)
	end

	_status_extension.do_lunge = {
		animation_end_event = "maiden_guard_active_ability_charge_hit",
		allow_rotation = false,
		falloff_to_speed = 5,
		first_person_animation_end_event = "dodge_bwd",
		first_person_hit_animation_event = "charge_react",
		dodge = true,
		first_person_animation_event = "shade_stealth_ability",
		first_person_animation_end_event_hit = "dodge_bwd",
		duration = 0.65,
		initial_speed = 25,
		animation_event = "maiden_guard_active_ability_charge_start",
		lunge_events = self._lunge_events
	}

	_career_extension:start_activated_ability_cooldown()
	self:_play_vo()
end

CareerAbilityWEShadeDash._play_vo = function (self)
	-- function 14
	local _owner_unit = self._owner_unit
	local extension_input = ScriptUnit.extension_input(_owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end
