-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_we_maiden_guard.lua

CareerAbilityWEMaidenGuard = class(CareerAbilityWEMaidenGuard)

CareerAbilityWEMaidenGuard.init = function (self, arg_1_1, arg_1_2, arg_1_3)
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
	self._decal_unit_name = "units/decals/decal_arrow_kerillian"
end

CareerAbilityWEMaidenGuard.extensions_ready = function (self, arg_2_1, arg_2_2)
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

CareerAbilityWEMaidenGuard.destroy = function (arg_3_0)
	-- function 3
	return
end

CareerAbilityWEMaidenGuard.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
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

CareerAbilityWEMaidenGuard.stop = function (self, arg_5_1)
	-- function 5
	if arg_5_1 == "pushed" or arg_5_1 == "stunned" or not self._is_priming then
		self:_stop_priming()
	end
end

CareerAbilityWEMaidenGuard._ability_available = function (self)
	-- function 6
	local _career_extension = self._career_extension
	local _status_extension = self._status_extension
	local can_use_activated_ability = _career_extension:can_use_activated_ability()

	can_use_activated_ability = not can_use_activated_ability and not _status_extension:is_disabled()

	return can_use_activated_ability
end

CareerAbilityWEMaidenGuard._start_priming = function (self)
	-- function 7
	if not self._local_player then
		local _decal_unit_name = self._decal_unit_name

		self._decal_unit = Managers.state.unit_spawner:spawn_local_unit(_decal_unit_name)
	end

	self._is_priming = true
end

CareerAbilityWEMaidenGuard._update_priming = function (self)
	-- function 8
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

CareerAbilityWEMaidenGuard._stop_priming = function (self)
	-- function 9
	if not self._decal_unit then
		Managers.state.unit_spawner:mark_for_deletion(self._decal_unit)
	end

	self._is_priming = false
end

CareerAbilityWEMaidenGuard._run_ability = function (self)
	-- function 10
	self:_stop_priming()

	local _owner_unit = self._owner_unit
	local _is_server = self._is_server
	local _local_player = self._local_player
	local _bot_player = self._bot_player
	local _network_manager = self._network_manager
	local network_transmit = _network_manager.network_transmit
	local _status_extension = self._status_extension
	local _career_extension = self._career_extension
	local _buff_extension = self._buff_extension
	local extension = ScriptUnit.extension(_owner_unit, "talent_system")

	_buff_extension:add_buff("kerillian_maidenguard_activated_ability")

	if not extension:has_talent("kerillian_maidenguard_activated_ability_invis_duration") then
		_buff_extension:add_buff("kerillian_maidenguard_activated_ability_invis_duration")
	end

	if not _is_server and _bot_player and not _local_player then
		local _first_person_extension = self._first_person_extension

		_first_person_extension:animation_event("shade_stealth_ability")
		_first_person_extension:play_remote_unit_sound_event("Play_career_ability_maiden_guard_charge", _owner_unit, 0)
		_career_extension:set_state("kerillian_activate_maiden_guard")

		if not _local_player then
			_first_person_extension:play_hud_sound_event("Play_career_ability_maiden_guard_charge")
		end
	end

	if not _network_manager:game() then
		_status_extension:set_is_dodging(true)

		local unit_game_object_id = _network_manager:unit_game_object_id(_owner_unit)

		network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, true, unit_game_object_id, 0)
	end

	local str = "maidenguard_dash_ability"
	local has_talent = extension:has_talent("kerillian_maidenguard_activated_ability_damage")

	if not has_talent then
		str = "maidenguard_dash_ability_bleed"
	end

	local tbl = {
		animation_end_event = "maiden_guard_active_ability_charge_hit",
		allow_rotation = false,
		first_person_animation_end_event = "dodge_bwd",
		first_person_hit_animation_event = "charge_react",
		falloff_to_speed = 5,
		dodge = true,
		first_person_animation_event = "shade_stealth_ability",
		first_person_animation_end_event_hit = "dodge_bwd",
		duration = 0.65,
		initial_speed = 25,
		animation_event = "maiden_guard_active_ability_charge_start"
	}
	local tbl_2 = {
		depth_padding = 0.4,
		height = 1.8,
		collision_filter = "filter_explosion_overlap_no_player",
		hit_zone_hit_name = "full",
		ignore_shield = true,
		interrupt_on_max_hit_mass = false,
		interrupt_on_first_hit = false,
		width = 1.5,
		allow_backstab = true,
		damage_profile = str
	}
	local flag

	flag = not has_talent and 1 and 0
	tbl_2.power_level_multiplier = flag
	tbl_2.stagger_angles = {
		max = 90,
		min = 90
	}
	tbl.damage = tbl_2
	_status_extension.do_lunge = tbl

	_career_extension:start_activated_ability_cooldown()
	self:_play_vo()
end

CareerAbilityWEMaidenGuard._play_vo = function (self)
	-- function 11
	local _owner_unit = self._owner_unit
	local extension_input = ScriptUnit.extension_input(_owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end
