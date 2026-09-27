-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_wh_zealot.lua

CareerAbilityWHZealot = class(CareerAbilityWHZealot)

CareerAbilityWHZealot.init = function (self, arg_1_1, arg_1_2, arg_1_3)
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
	self._decal_unit_name = "units/decals/decal_arrow_saltzpyre"
	self._fov_lerp_time = 0
end

CareerAbilityWHZealot.extensions_ready = function (self, arg_2_1, arg_2_2)
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

CareerAbilityWHZealot.destroy = function (arg_3_0)
	-- function 3
	return
end

CareerAbilityWHZealot.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
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

CareerAbilityWHZealot.stop = function (self, arg_5_1)
	-- function 5
	if arg_5_1 == "pushed" or arg_5_1 == "stunned" or not self._is_priming then
		self:_stop_priming()
	end
end

CareerAbilityWHZealot._ability_available = function (self)
	-- function 6
	local _career_extension = self._career_extension
	local _status_extension = self._status_extension
	local can_use_activated_ability = _career_extension:can_use_activated_ability()

	can_use_activated_ability = not can_use_activated_ability and not _status_extension:is_disabled()

	return can_use_activated_ability
end

CareerAbilityWHZealot._start_priming = function (self)
	-- function 7
	if not self._local_player then
		local _decal_unit_name = self._decal_unit_name

		self._decal_unit = Managers.state.unit_spawner:spawn_local_unit(_decal_unit_name)
	end

	local _buff_extension = self._buff_extension
	local str = "planted_decrease_movement"
	local tbl = {
		external_optional_multiplier = 0.3
	}

	self._buff_id = _buff_extension:add_buff(str, tbl)
	self._is_priming = true
end

CareerAbilityWHZealot._update_priming = function (self, arg_8_1)
	-- function 8
	if not self._local_player then
		local _first_person_extension = self._first_person_extension
		local local_position = Unit.local_position(self._owner_unit, 0)
		local current_rotation = _first_person_extension:current_rotation()
		local flat = Vector3.flat(Vector3.normalize(Quaternion.forward(current_rotation)))
		local look = Quaternion.look(flat, Vector3.up())

		Unit.set_local_position(self._decal_unit, 0, local_position)
		Unit.set_local_rotation(self._decal_unit, 0, look)

		local num = 1.9
		local num_2 = self._fov_lerp_time / num
		local lerp = math.lerp(1, 1.07, num_2)

		self._fov_lerp_time = math.min(self._fov_lerp_time + arg_8_1, num)

		Managers.state.camera:set_additional_fov_multiplier(lerp)
	end
end

CareerAbilityWHZealot._stop_priming = function (self)
	-- function 9
	if not self._decal_unit then
		Managers.state.unit_spawner:mark_for_deletion(self._decal_unit)
	end

	if not self._buff_id then
		self._buff_extension:remove_buff(self._buff_id)

		self._buff_id = nil
	end

	if not self._local_player then
		self._fov_lerp_time = 0

		Managers.state.camera:set_additional_fov_multiplier(1)
	end

	self._is_priming = false
end

CareerAbilityWHZealot._run_ability = function (self)
	-- function 10
	self:_stop_priming()

	local _owner_unit = self._owner_unit
	local _is_server = self._is_server
	local _local_player = self._local_player
	local _network_manager = self._network_manager
	local network_transmit = _network_manager.network_transmit
	local _status_extension = self._status_extension
	local _career_extension = self._career_extension
	local _buff_extension = self._buff_extension
	local tbl = {
		"victor_zealot_activated_ability"
	}
	local extension = ScriptUnit.extension(_owner_unit, "talent_system")

	if not extension:has_talent("victor_zealot_activated_ability_power_on_hit", "witch_hunter", true) then
		tbl[#tbl + 1] = "victor_zealot_activated_ability_power_on_hit"
	end

	if not extension:has_talent("victor_zealot_activated_ability_ignore_death", "witch_hunter", true) then
		tbl[#tbl + 1] = "victor_zealot_activated_ability_ignore_death"
	end

	if not extension:has_talent("victor_zealot_activated_ability_cooldown_stack_on_hit", "witch_hunter", true) then
		_buff_extension:add_buff("victor_zealot_activated_ability_cooldown_stack_on_hit", {
			attacker_unit = _owner_unit
		})
	end

	for i = 1, #tbl do
		local var_10_10 = tbl[i]
		local unit_game_object_id = _network_manager:unit_game_object_id(_owner_unit)
		local var_10_12 = NetworkLookup.buff_templates[var_10_10]

		if not _is_server then
			_buff_extension:add_buff(var_10_10, {
				attacker_unit = _owner_unit
			})
			network_transmit:send_rpc_clients("rpc_add_buff", unit_game_object_id, var_10_12, unit_game_object_id, 0, false)
		else
			network_transmit:send_rpc_server("rpc_add_buff", unit_game_object_id, var_10_12, unit_game_object_id, 0, true)
		end
	end

	if _local_player or not _is_server or not self._bot_player then
		local _first_person_extension = self._first_person_extension

		_first_person_extension:play_hud_sound_event("Play_career_ability_victor_zealot_enter")
		_first_person_extension:play_remote_unit_sound_event("Play_career_ability_victor_zealot_enter", _owner_unit, 0)
		_first_person_extension:play_hud_sound_event("Play_career_ability_victor_zealot_loop")

		if not _local_player then
			_first_person_extension:animation_event("shade_stealth_ability")
			_first_person_extension:play_hud_sound_event("Play_career_ability_zealot_charge")
			_first_person_extension:play_remote_unit_sound_event("Play_career_ability_zealot_charge", _owner_unit, 0)
			_career_extension:set_state("victor_activate_zealot")
			Managers.state.camera:set_mood("skill_zealot", "skill_zealot", true)
		end
	end

	_status_extension:set_noclip(true, "skill_zealot")

	_status_extension.do_lunge = {
		animation_end_event = "zealot_active_ability_charge_hit",
		allow_rotation = false,
		first_person_animation_end_event = "dodge_bwd",
		first_person_hit_animation_event = "charge_react",
		falloff_to_speed = 8,
		dodge = true,
		first_person_animation_event = "shade_stealth_ability",
		first_person_animation_end_event_hit = "dodge_bwd",
		duration = 0.75,
		initial_speed = 25,
		animation_event = "zealot_active_ability_charge_start",
		damage = {
			depth_padding = 0.4,
			height = 1.8,
			collision_filter = "filter_explosion_overlap_no_player",
			hit_zone_hit_name = "full",
			ignore_shield = true,
			interrupt_on_max_hit_mass = true,
			power_level_multiplier = 0.8,
			interrupt_on_first_hit = false,
			damage_profile = "heavy_slashing_linesman",
			width = 1.5,
			allow_backstab = true,
			stagger_angles = {
				max = 90,
				min = 45
			},
			on_interrupt_blast = {
				allow_backstab = false,
				radius = 3,
				power_level_multiplier = 1,
				hit_zone_hit_name = "full",
				damage_profile = "heavy_slashing_linesman",
				ignore_shield = false,
				collision_filter = "filter_explosion_overlap_no_player"
			}
		}
	}

	_career_extension:start_activated_ability_cooldown()
	self:_play_vo()
end

CareerAbilityWHZealot._play_vo = function (self)
	-- function 11
	local _owner_unit = self._owner_unit
	local extension_input = ScriptUnit.extension_input(_owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end
