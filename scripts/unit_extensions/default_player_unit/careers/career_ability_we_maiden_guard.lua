-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_we_maiden_guard.lua

CareerAbilityWEMaidenGuard = class(CareerAbilityWEMaidenGuard)

CareerAbilityWEMaidenGuard.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	self._owner_unit = unit
	self._world = extension_init_context.world
	self._wwise_world = Managers.world:wwise_world(self._world)

	local player = extension_init_data.player

	self._player = player
	self._is_server = player.is_server
	self._local_player = player.local_player
	self._bot_player = player.bot_player
	self._network_manager = Managers.state.network
	self._input_manager = Managers.input
	self._decal_unit = nil
	self._decal_unit_name = "units/decals/decal_arrow_kerillian"
end

CareerAbilityWEMaidenGuard.extensions_ready = function (self, world, unit)
	-- function 2
	self._first_person_extension = ScriptUnit.has_extension(unit, "first_person_system")
	self._status_extension = ScriptUnit.extension(unit, "status_system")
	self._career_extension = ScriptUnit.extension(unit, "career_system")
	self._buff_extension = ScriptUnit.extension(unit, "buff_system")
	self._input_extension = ScriptUnit.has_extension(unit, "input_system")

	if self._first_person_extension then
		self._first_person_unit = self._first_person_extension:get_first_person_unit()
	end
end

CareerAbilityWEMaidenGuard.destroy = function (self)
	-- function 3
	return
end

CareerAbilityWEMaidenGuard.update = function (self, unit, input, dt, context, t)
	-- function 4
	if not self:_ability_available() then
		return
	end

	local input_extension = self._input_extension

	if not input_extension then
		return
	end

	if not self._is_priming then
		if input_extension:get("action_career") then
			self:_start_priming()
		end
	elseif self._is_priming then
		self:_update_priming()

		if input_extension:get("action_two") then
			self:_stop_priming()

			return
		end

		if input_extension:get("weapon_reload") then
			self:_stop_priming()

			return
		end

		if not input_extension:get("action_career_hold") then
			self:_run_ability()
		end
	end
end

CareerAbilityWEMaidenGuard.stop = function (self, reason)
	-- function 5
	if reason ~= "pushed" and reason ~= "stunned" and self._is_priming then
		self:_stop_priming()
	end
end

CareerAbilityWEMaidenGuard._ability_available = function (self)
	-- function 6
	local career_extension = self._career_extension
	local status_extension = self._status_extension
	local can_use_activated_ability = career_extension:can_use_activated_ability()

	can_use_activated_ability = not not can_use_activated_ability and not not not status_extension:is_disabled()

	return can_use_activated_ability
end

CareerAbilityWEMaidenGuard._start_priming = function (self)
	-- function 7
	if self._local_player then
		local decal_unit_name = self._decal_unit_name
		local unit_spawner = Managers.state.unit_spawner

		self._decal_unit = unit_spawner:spawn_local_unit(decal_unit_name)
	end

	self._is_priming = true
end

CareerAbilityWEMaidenGuard._update_priming = function (self)
	-- function 8
	if self._decal_unit then
		local first_person_extension = self._first_person_extension
		local player_position = Unit.local_position(self._owner_unit, 0)
		local player_rotation = first_person_extension:current_rotation()
		local player_direction_flat = Vector3.flat(Vector3.normalize(Quaternion.forward(player_rotation)))
		local player_rotation_flat = Quaternion.look(player_direction_flat, Vector3.up())

		Unit.set_local_position(self._decal_unit, 0, player_position)
		Unit.set_local_rotation(self._decal_unit, 0, player_rotation_flat)
	end
end

CareerAbilityWEMaidenGuard._stop_priming = function (self)
	-- function 9
	if self._decal_unit then
		local unit_spawner = Managers.state.unit_spawner

		unit_spawner:mark_for_deletion(self._decal_unit)
	end

	self._is_priming = false
end

CareerAbilityWEMaidenGuard._run_ability = function (self)
	-- function 10
	self:_stop_priming()

	local owner_unit = self._owner_unit
	local is_server = self._is_server
	local local_player = self._local_player
	local bot_player = self._bot_player
	local network_manager = self._network_manager
	local network_transmit = network_manager.network_transmit
	local status_extension = self._status_extension
	local career_extension = self._career_extension
	local buff_extension = self._buff_extension
	local talent_extension = ScriptUnit.extension(owner_unit, "talent_system")

	buff_extension:add_buff("kerillian_maidenguard_activated_ability")

	if talent_extension:has_talent("kerillian_maidenguard_activated_ability_invis_duration") then
		buff_extension:add_buff("kerillian_maidenguard_activated_ability_invis_duration")
	end

	if (not is_server or not bot_player) and local_player then
		local first_person_extension = self._first_person_extension

		first_person_extension:animation_event("shade_stealth_ability")
		first_person_extension:play_remote_unit_sound_event("Play_career_ability_maiden_guard_charge", owner_unit, 0)
		career_extension:set_state("kerillian_activate_maiden_guard")

		if local_player then
			first_person_extension:play_hud_sound_event("Play_career_ability_maiden_guard_charge")
		end
	end

	if network_manager:game() then
		status_extension:set_is_dodging(true)

		local unit_id = network_manager:unit_game_object_id(owner_unit)

		network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, true, unit_id, 0)
	end

	local damage_profile = "maidenguard_dash_ability"
	local bleed = talent_extension:has_talent("kerillian_maidenguard_activated_ability_damage")

	if bleed then
		damage_profile = "maidenguard_dash_ability_bleed"
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
		damage_profile = damage_profile
	}
	local flag

	flag = (not bleed or not 1) and not not 0
	tbl_2.power_level_multiplier = flag
	tbl_2.stagger_angles = {
		max = 90,
		min = 90
	}
	tbl.damage = tbl_2
	status_extension.do_lunge = tbl

	career_extension:start_activated_ability_cooldown()
	self:_play_vo()
end

CareerAbilityWEMaidenGuard._play_vo = function (self)
	-- function 11
	local owner_unit = self._owner_unit
	local dialogue_input = ScriptUnit.extension_input(owner_unit, "dialogue_system")
	local event_data = FrameTable.alloc_table()

	dialogue_input:trigger_networked_dialogue_event("activate_ability", event_data)
end
