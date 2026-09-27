-- chunkname: @scripts/unit_extensions/default_player_unit/charge/player_unit_overcharge_extension.lua

require("scripts/unit_extensions/default_player_unit/charge/overcharge_data")

PlayerUnitOverchargeExtension = class(PlayerUnitOverchargeExtension)

local enum = table.enum("none", "low", "medium", "high", "critical", "exploding")

PlayerUnitOverchargeExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.unit = arg_1_2

	local overcharge_data = arg_1_3.overcharge_data
	local max_value = overcharge_data.max_value

	max_value = max_value or 40
	self.max_value = max_value
	self.time_when_overcharge_start_decreasing = 0
	self.overcharge_crit_time = 0
	self.overcharge_crit_interval = 1
	self.venting_overcharge = false
	self.vent_damage_pool = 0

	local global_is_inside_inn = global_is_inside_inn

	global_is_inside_inn = global_is_inside_inn or overcharge_data.no_damage
	self.no_damage = global_is_inside_inn
	self.lockout = false
	self.prev_lockout = false

	local overcharge_threshold = overcharge_data.overcharge_threshold

	overcharge_threshold = overcharge_threshold or 0
	self.overcharge_threshold = overcharge_threshold

	local overcharge_value_decrease_rate = overcharge_data.overcharge_value_decrease_rate

	overcharge_value_decrease_rate = overcharge_value_decrease_rate or 0
	self.overcharge_value_decrease_rate = overcharge_value_decrease_rate

	local time_until_overcharge_decreases = overcharge_data.time_until_overcharge_decreases

	time_until_overcharge_decreases = time_until_overcharge_decreases or 0
	self.time_until_overcharge_decreases = time_until_overcharge_decreases

	local hit_overcharge_threshold_sound = overcharge_data.hit_overcharge_threshold_sound

	hit_overcharge_threshold_sound = hit_overcharge_threshold_sound or "ui_special_attack_ready"
	self.hit_overcharge_threshold_sound = hit_overcharge_threshold_sound

	local critical_overcharge_margin = overcharge_data.critical_overcharge_margin

	critical_overcharge_margin = critical_overcharge_margin or 1.2
	self.critical_overcharge_margin = critical_overcharge_margin
	self.overcharge_depleted_func = overcharge_data.overcharge_depleted_func

	local onscreen_particles_id = overcharge_data.onscreen_particles_id

	onscreen_particles_id = onscreen_particles_id or "fx/screenspace_overheat_indicator"
	self.screen_space_particle = onscreen_particles_id

	local critical_onscreen_particles_id = overcharge_data.critical_onscreen_particles_id

	critical_onscreen_particles_id = critical_onscreen_particles_id or not not overcharge_data.no_critical_onscreen_particles or "fx/screenspace_overheat_critical"
	self.screen_space_particle_critical = critical_onscreen_particles_id
	self._lerped_overcharge_fraction = 0

	local local_player = Managers.player:local_player()
	local flag = not local_player and Managers.state.side:get_side_from_player_unique_id(local_player:unique_id())

	if not (not flag and flag:name() ~= "dark_pact") then
		self.screen_space_particle = "fx/screenspace_overheat_indicator_warpfire"
		self.screen_space_particle_critical = "fx/screenspace_overheat_critical_warpfire"
	end

	self._overcharge_states = {
		[enum.none] = {},
		[enum.low] = {
			sound_event = overcharge_data.overcharge_warning_low_sound_event,
			controller_effect = {
				rumble_effect = "overcharge_rumble"
			}
		},
		[enum.medium] = {
			dialogue_event = "overcharge",
			sound_event = overcharge_data.overcharge_warning_med_sound_event,
			controller_effect = {
				rumble_effect = "overcharge_rumble_overcharged"
			}
		},
		[enum.high] = {
			dialogue_event = "overcharge_high",
			sound_event = overcharge_data.overcharge_warning_high_sound_event,
			controller_effect = {
				rumble_effect = "overcharge_rumble_crit"
			}
		},
		[enum.critical] = {
			dialogue_event = "overcharge_critical",
			sound_event = overcharge_data.overcharge_warning_critical_sound_event
		},
		[enum.exploding] = {
			dialogue_event = "overcharge_explode"
		}
	}

	local explosion_template = overcharge_data.explosion_template

	explosion_template = explosion_template or "overcharge_explosion"
	self.explosion_template = explosion_template
	self.no_forced_movement = overcharge_data.no_forced_movement
	self.no_explosion = overcharge_data.no_explosion
	self.explode_vfx_name = overcharge_data.explode_vfx_name
	self.overcharge_explosion_time = overcharge_data.overcharge_explosion_time
	self.percent_health_lost = overcharge_data.percent_health_lost
	self.lockout_overcharge_decay_rate = overcharge_data.lockout_overcharge_decay_rate
	self.network_manager = Managers.state.network
	self.venting_anim = nil
	self.is_exploding = false
	self._ignored_overcharge_types = {
		flamethrower = true,
		damage_to_overcharge = true,
		charging = true,
		drakegun_charging = true
	}

	local user_setting = Application.user_setting("overcharge_opacity")

	user_setting = user_setting or 100

	self:set_screen_particle_opacity_modifier(user_setting)
end

PlayerUnitOverchargeExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self.first_person_extension = ScriptUnit.extension(self.unit, "first_person_system")
	self._dialogue_input = ScriptUnit.extension_input(self.unit, "dialogue_system")
	self._buff_extension = ScriptUnit.extension(self.unit, "buff_system")
	self.overcharge_value = 0
	self.original_max_value = self.max_value

	self:_calculate_and_set_buffed_max_overcharge_values()
end

PlayerUnitOverchargeExtension._calculate_and_set_buffed_max_overcharge_values = function (self)
	-- function 3
	local overcharge_fraction = self:overcharge_fraction()
	local apply_buffs_to_value = self._buff_extension:apply_buffs_to_value(self.original_max_value, "max_overcharge")

	fassert(not (apply_buffs_to_value >= NetworkConstants.max_overcharge.min) or apply_buffs_to_value <= NetworkConstants.max_overcharge.max, "Max overcharge outside value bounds allowed by network variable!")

	self.overcharge_value = overcharge_fraction * apply_buffs_to_value
	self.max_value = apply_buffs_to_value
	self.overcharge_limit = apply_buffs_to_value * 0.65
	self.overcharge_critical_limit = apply_buffs_to_value * 0.8
end

PlayerUnitOverchargeExtension.set_screen_particle_opacity_modifier = function (self, arg_4_1)
	-- function 4
	self._screen_particle_opacity_modifier = arg_4_1 / 100
end

PlayerUnitOverchargeExtension.reset = function (self)
	-- function 5
	self:_destroy_all_screen_space_particles()

	local has_extension = ScriptUnit.has_extension(self.unit, "buff_system")

	if not has_extension and not has_extension:active_buffs() then
		self:_add_overcharge_buff(nil)
	end

	self.lockout = false
	self.overcharge_value = 0
	self.played_hit_overcharge_threshold = false
	self.is_exploding = false

	StatusUtils.set_overcharge_exploding(self.unit, false)

	local world = self.world
	local wwise_world = Managers.world:wwise_world(world)

	WwiseWorld.set_global_parameter(wwise_world, "overcharge_status", 0)
	self:set_animation_variable()
end

PlayerUnitOverchargeExtension._destroy_all_screen_space_particles = function (self)
	-- function 6
	self:_destroy_screen_space_particles(self.onscreen_particles_id)

	self.onscreen_particles_id = nil

	self:_destroy_screen_space_particles(self.critical_onscreen_particles_id)

	self.critical_onscreen_particles_id = nil
end

PlayerUnitOverchargeExtension._destroy_screen_space_particles = function (self, arg_7_1)
	-- function 7
	if not arg_7_1 then
		World.destroy_particles(self.world, arg_7_1)
	end
end

PlayerUnitOverchargeExtension._update_vfx_sfx = function (self, arg_8_1)
	-- function 8
	if not (not arg_8_1 and arg_8_1.bot_player) then
		self:_update_screen_effect()

		local world = self.world
		local wwise_world = Managers.world:wwise_world(world)

		WwiseWorld.set_global_parameter(wwise_world, "overcharge_status", self._lerped_overcharge_fraction)
	end
end

PlayerUnitOverchargeExtension.destroy = function (self)
	-- function 9
	self:_destroy_all_screen_space_particles()

	local has_extension = ScriptUnit.has_extension(self.unit, "buff_system")

	if not has_extension and not has_extension:active_buffs() then
		self:_add_overcharge_buff(nil)
	end
end

PlayerUnitOverchargeExtension.set_animation_variable = function (self)
	-- function 10
	local get_anim_blend_overcharge = self:get_anim_blend_overcharge()

	self.first_person_extension:animation_set_variable("overcharge", get_anim_blend_overcharge, true)
end

PlayerUnitOverchargeExtension._update_game_object = function (self)
	-- function 11
	local network_manager = self.network_manager
	local unit = self.unit
	local game = network_manager:game()
	local go_id = Managers.state.unit_storage:go_id(unit)

	if not game and not go_id then
		local overcharge_fraction = self:overcharge_fraction()
		local threshold_fraction = self:threshold_fraction()
		local get_max_value = self:get_max_value()

		GameSession.set_game_object_field(game, go_id, "overcharge_percentage", overcharge_fraction)
		GameSession.set_game_object_field(game, go_id, "overcharge_threshold_percentage", threshold_fraction)
		GameSession.set_game_object_field(game, go_id, "overcharge_max_value", get_max_value)
	end
end

PlayerUnitOverchargeExtension.update = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	-- function 12
	self:_calculate_and_set_buffed_max_overcharge_values()
	self:_update_game_object()

	local overcharge_value = self.overcharge_value

	if not ((self.is_exploding or not self.venting_overcharge) and not (self.overcharge_value >= 0)) then
		local _buff_extension = self._buff_extension
		local unit = self.unit
		local apply_buffs_to_value = _buff_extension:apply_buffs_to_value(arg_12_3, "vent_speed")
		local num = self.overcharge_value * (self.original_max_value / 80) * apply_buffs_to_value
		local overcharge_value_2 = self.overcharge_value
		local num_2 = overcharge_value_2 - num

		self:_update_overcharge_buff_state(overcharge_value_2, num_2)

		self.overcharge_value = num_2
		self.vent_damage_pool = self.vent_damage_pool + num * 2

		if not (not (self.vent_damage_pool >= 20) or self.no_damage or not (self.overcharge_value > self.overcharge_threshold)) then
			local apply_buffs_to_value_2, var_12_8 = _buff_extension:apply_buffs_to_value(0, "overcharge_damage_immunity")

			if not var_12_8 then
				local num_3 = 2 + self.overcharge_value / 12
				local apply_buffs_to_value_3 = _buff_extension:apply_buffs_to_value(num_3, "vent_damage")

				DamageUtils.add_damage_network(unit, unit, apply_buffs_to_value_3, "torso", "overcharge", nil, Vector3(0, 1, 0), "overcharge", nil, nil, nil, nil, false, false, false, 0, 1, nil, 1)
			end

			self.vent_damage_pool = 0
		end
	else
		self.venting_overcharge = false
	end

	local first_person_extension = self.first_person_extension
	local unit_2 = self.unit

	if not first_person_extension then
		if not self.venting_anim then
			first_person_extension:animation_event(self.venting_anim)

			self.venting_anim = nil
		end

		local lockout = self.lockout

		if self.prev_lockout ~= lockout then
			self.prev_lockout = lockout

			local flag

			flag = not lockout and 1 and 0

			first_person_extension:animation_set_variable("overcharge_locked_out", flag, true)

			if not lockout then
				first_person_extension:animation_event("overcharge_end")
				Managers.state.network:anim_event(unit_2, "overcharge_end")
			end
		end
	end

	local _buff_extension_2 = self._buff_extension
	local owner = Managers.player:owner(self.unit)

	if self.overcharge_value > 0 or not _buff_extension_2:has_buff_type("sienna_unchained_activated_ability") then
		self._had_overcharge = true

		if not (self.is_exploding or not (arg_12_5 > self.time_when_overcharge_start_decreasing) or self.lockout ~= true) then
			local num_4 = 1

			if self.overcharge_value >= self.overcharge_threshold then
				num_4 = num_4 * 0.6
			elseif self.lockout == true then
				self.lockout = false
				self.is_exploding = false

				self:_trigger_hud_sound("weapon_life_staff_lockout_end", self.first_person_extension)
				self:_trigger_dialogue("overcharge_lockout_end")
			end

			if not self.lockout then
				num_4 = num_4 * self.lockout_overcharge_decay_rate
			end

			local num_5 = num_4 * self.overcharge_value_decrease_rate * arg_12_3
			local num_6 = self.overcharge_value - _buff_extension_2:apply_buffs_to_value(num_5, "overcharge_regen")

			if not (not _buff_extension_2:has_buff_type("sienna_unchained_activated_ability") and not (num_6 >= self.max_value)) then
				self:add_charge(1)
			end

			local overcharge_value_3 = self.overcharge_value
			local min = math.min(math.max(0, num_6), self.max_value)

			self.overcharge_value = min

			self:_update_overcharge_buff_state(overcharge_value_3, min)
		end
	elseif not self._had_overcharge then
		self._had_overcharge = false

		self:_update_overcharge_buff(enum.none)
		self:_trigger_controller_effect(nil)
	end

	if not self:_update_lerped_overcharge(arg_12_3) then
		self:_update_vfx_sfx(owner)
		self:set_animation_variable()
	end

	local overcharge_value_4 = self.overcharge_value

	if overcharge_value_4 < overcharge_value then
		self._buff_extension:trigger_procs("on_overcharge_lost", overcharge_value - overcharge_value_4, self.max_value)
	end

	if not (self.overcharge_value <= 0) or overcharge_value == 0 or not self.overcharge_depleted_func then
		self.overcharge_depleted_func(self.world, self.unit, self.first_person_extension)
	end
end

PlayerUnitOverchargeExtension.add_charge = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local _buff_extension = self._buff_extension
	local max_value = self.max_value
	local overcharge_value = self.overcharge_value
	local var_13_3

	if not arg_13_2 then
		arg_13_1 = 0.4 * arg_13_1 + 0.6 * arg_13_1 * arg_13_2
	end

	arg_13_1 = self._buff_extension:apply_buffs_to_value(arg_13_1, "reduced_overcharge")

	if not (not _buff_extension and self._ignored_overcharge_types[arg_13_3]) then
		arg_13_1 = arg_13_1 * _buff_extension:apply_buffs_to_value(1, "ammo_used_multiplier")

		_buff_extension:trigger_procs("on_ammo_used", self, 0)
		_buff_extension:trigger_procs("on_overcharge_used", arg_13_1)
		Managers.state.achievement:trigger_event("ammo_used", self.owner_unit)

		if not (LEVEL_EDITOR_TEST or self._is_server) then
			local player = Managers.player
			local owner = Managers.player:owner(self.unit)
			local network_id = owner:network_id()
			local local_player_id = owner:local_player_id()
			local on_ammo_used = NetworkLookup.proc_events.on_ammo_used

			Managers.state.network.network_transmit:send_rpc_server("rpc_proc_event", network_id, local_player_id, on_ammo_used)
		end
	end

	if not _buff_extension:has_buff_perk("no_overcharge") then
		return
	end

	if not _buff_extension:has_buff_type("twitch_no_overcharge_no_ammo_reloads") then
		return
	end

	if not (not (overcharge_value <= max_value - self.critical_overcharge_margin) or not (max_value <= overcharge_value + arg_13_1)) then
		local var_13_9 = self._overcharge_states[enum.critical]

		self:_trigger_hud_sound(var_13_9.sound_event, self.first_person_extension)
		self:_trigger_dialogue(var_13_9.dialogue_event)

		var_13_3 = max_value - 0.1
	else
		var_13_3 = math.min(overcharge_value + arg_13_1, max_value)
	end

	self:_check_overcharge_level_thresholds(var_13_3)

	local num = var_13_3 - overcharge_value
	local num_2 = num / self:get_max_value()

	Managers.state.achievement:trigger_event("overcharge_gained", num, num_2, self.unit)

	self.time_when_overcharge_start_decreasing = Managers.time:time("game") + self.time_until_overcharge_decreases
	self.overcharge_value = var_13_3
end

PlayerUnitOverchargeExtension.remove_charge = function (self, arg_14_1)
	-- function 14
	if not self.is_exploding then
		return
	end

	local overcharge_value = self.overcharge_value
	local max = math.max(overcharge_value - arg_14_1, 0)

	self:_check_overcharge_level_thresholds(max)

	local max_2 = math.max(overcharge_value - max, 0)

	self._buff_extension:trigger_procs("on_overcharge_lost", max_2, self.max_value)

	self.overcharge_value = max

	return overcharge_value - max
end

PlayerUnitOverchargeExtension.remove_charge_fraction = function (self, arg_15_1)
	-- function 15
	local get_max_value = self:get_max_value()
	local num = get_max_value * arg_15_1
	local remove_charge = self:remove_charge(num)

	remove_charge = remove_charge or 0

	return remove_charge, remove_charge / get_max_value
end

PlayerUnitOverchargeExtension._check_overcharge_level_thresholds = function (self, arg_16_1)
	-- function 16
	local _buff_extension = self._buff_extension
	local max_value = self.max_value

	if max_value <= arg_16_1 then
		if not _buff_extension:has_buff_perk("no_overcharge_explosion") then
			local unit = self.unit
			local num = arg_16_1 - max_value + 1
			local num_2 = 2 + max_value / 12
			local apply_buffs_to_value = _buff_extension:apply_buffs_to_value(num_2, "vent_damage")

			self:remove_charge(num)
		else
			local unit_2 = self.unit

			StatusUtils.set_overcharge_exploding(unit_2, true)

			self.is_exploding = true

			self:_add_overcharge_buff(nil)

			local var_16_7 = self._overcharge_states[enum.exploding]

			self:_trigger_hud_sound(var_16_7.sound_event, self.first_person_extension)
			self:_trigger_dialogue(var_16_7.dialogue_event)
			self:_trigger_controller_effect("rumble", var_16_7.controller_effect)
		end
	else
		local num_3 = arg_16_1 / max_value
		local overcharge_threshold = self.overcharge_threshold
		local _overcharge_value_state = self:_overcharge_value_state(self.overcharge_value)
		local _overcharge_value_state_2 = self:_overcharge_value_state(arg_16_1)
		local flag = _overcharge_value_state ~= _overcharge_value_state_2
		local var_16_13 = self._overcharge_states[_overcharge_value_state_2]

		if not var_16_13 then
			if not flag then
				if _overcharge_value_state_2 == enum.low then
					local wwise_world = Managers.world:wwise_world(self.world)

					WwiseWorld.trigger_event(wwise_world, self.hit_overcharge_threshold_sound)
				end

				self:_trigger_hud_sound(var_16_13.sound_event, self.first_person_extension)
				self:_update_overcharge_buff(_overcharge_value_state_2)
			end

			self:_trigger_dialogue(var_16_13.dialogue_event)
			self:_trigger_controller_effect("rumble", var_16_13.controller_effect)
		end
	end
end

PlayerUnitOverchargeExtension.set_lockout = function (self, arg_17_1)
	-- function 17
	self.lockout = arg_17_1
end

PlayerUnitOverchargeExtension.get_overcharge_value = function (self)
	-- function 18
	return self.overcharge_value
end

PlayerUnitOverchargeExtension.is_above_critical_limit = function (self)
	-- function 19
	return self.overcharge_value >= self.overcharge_critical_limit
end

PlayerUnitOverchargeExtension.get_original_max_value = function (self)
	-- function 20
	return self.original_max_value
end

PlayerUnitOverchargeExtension.get_max_value = function (self)
	-- function 21
	return self.max_value
end

PlayerUnitOverchargeExtension.get_overcharge_threshold = function (self)
	-- function 22
	return self.overcharge_threshold
end

PlayerUnitOverchargeExtension.above_overcharge_threshold = function (self)
	-- function 23
	return self.overcharge_value >= self.overcharge_threshold
end

PlayerUnitOverchargeExtension.are_you_exploding = function (self)
	-- function 24
	return self.is_exploding
end

PlayerUnitOverchargeExtension.are_you_locked_out = function (self)
	-- function 25
	return self.lockout
end

PlayerUnitOverchargeExtension.overcharge_fraction = function (self)
	-- function 26
	return math.clamp(self.overcharge_value / self.max_value, 0, 1)
end

PlayerUnitOverchargeExtension.lerped_overcharge_fraction = function (self)
	-- function 27
	return self._lerped_overcharge_fraction
end

PlayerUnitOverchargeExtension.threshold_fraction = function (self)
	-- function 28
	return self.overcharge_threshold / self.max_value
end

PlayerUnitOverchargeExtension.current_overcharge_status = function (self)
	-- function 29
	local get_overcharge_value = self:get_overcharge_value()
	local get_overcharge_threshold = self:get_overcharge_threshold()
	local get_max_value = self:get_max_value()

	return get_overcharge_value, get_overcharge_threshold, get_max_value
end

PlayerUnitOverchargeExtension.vent_overcharge = function (self)
	-- function 30
	self.venting_overcharge = true

	if self.overcharge_value > 0 then
		self.vent_damage_pool = 20
	else
		self.vent_damage_pool = 0
	end

	self.venting_anim = "cooldown_start"
end

PlayerUnitOverchargeExtension.vent_overcharge_done = function (self)
	-- function 31
	self.venting_overcharge = false
	self.venting_anim = "cooldown_end"
end

PlayerUnitOverchargeExtension.get_anim_blend_overcharge = function (self)
	-- function 32
	local num = self._lerped_overcharge_fraction * self:get_max_value()
	local overcharge_threshold = self.overcharge_threshold
	local max_value = self.max_value

	return (math.clamp((num - overcharge_threshold) / (max_value - overcharge_threshold), 0, 1))
end

PlayerUnitOverchargeExtension._trigger_hud_sound = function (arg_33_0, arg_33_1, arg_33_2)
	-- function 33
	if not (not arg_33_1 and arg_33_2) then
		return
	end

	arg_33_2:play_hud_sound_event(arg_33_1)
end

PlayerUnitOverchargeExtension._trigger_dialogue = function (self, arg_34_1)
	-- function 34
	if not arg_34_1 then
		return
	end

	local _dialogue_input = self._dialogue_input
	local alloc_table = FrameTable.alloc_table()

	_dialogue_input:trigger_networked_dialogue_event(arg_34_1, alloc_table)
end

PlayerUnitOverchargeExtension._trigger_controller_effect = function (self, arg_35_1, arg_35_2)
	-- function 35
	local controller_features = Managers.state.controller_features
	local _rumble_effect_id = self._rumble_effect_id

	if not _rumble_effect_id then
		controller_features:stop_effect(_rumble_effect_id)

		self._rumble_effect_id = nil
	end

	if not arg_35_1 and not arg_35_2 then
		self._rumble_effect_id = controller_features:add_effect(arg_35_1, arg_35_2)
	end
end

PlayerUnitOverchargeExtension._add_overcharge_buff = function (self, arg_36_1)
	-- function 36
	local _buff_extension = self._buff_extension
	local _overcharged_buff_id = self._overcharged_buff_id

	if not _overcharged_buff_id then
		_buff_extension:remove_buff(_overcharged_buff_id)

		self.overcharged_buff_id = nil
	end

	if not arg_36_1 then
		self._overcharged_buff_id = _buff_extension:add_buff(arg_36_1)
	end
end

PlayerUnitOverchargeExtension._update_overcharge_buff = function (self, arg_37_1)
	-- function 37
	local _buff_extension = self._buff_extension

	if arg_37_1 == enum.high then
		if _buff_extension:has_buff_type("sienna_unchained_passive") or not _buff_extension:has_buff_perk("overcharge_no_slow") then
			self:_add_overcharge_buff("overcharged_critical_no_attack_penalty")
		else
			self:_add_overcharge_buff("overcharged_critical")
		end
	elseif arg_37_1 == enum.medium then
		if _buff_extension:has_buff_type("sienna_unchained_passive") or not _buff_extension:has_buff_perk("overcharge_no_slow") then
			self:_add_overcharge_buff("overcharged_no_attack_penalty")
		else
			self:_add_overcharge_buff("overcharged")
		end
	else
		self:_add_overcharge_buff(nil)
	end
end

PlayerUnitOverchargeExtension._update_lerped_overcharge = function (self, arg_38_1)
	-- function 38
	local overcharge_fraction = self:overcharge_fraction()
	local _lerped_overcharge_fraction = self._lerped_overcharge_fraction

	if overcharge_fraction == _lerped_overcharge_fraction then
		return false
	end

	local num = 0.1
	local num_2 = 0.2
	local num_3 = 10
	local num_4 = 0.3
	local abs = math.abs(_lerped_overcharge_fraction - overcharge_fraction)

	if num_2 < abs then
		num_4 = num_4 * num_3
	elseif num < abs then
		num_4 = num_4 * math.remap(num, num_2, 1, num_3, abs)
	end

	local min = math.min(_lerped_overcharge_fraction, overcharge_fraction)
	local max = math.max(_lerped_overcharge_fraction, overcharge_fraction)
	local num_5 = _lerped_overcharge_fraction + math.sign(overcharge_fraction - _lerped_overcharge_fraction) * num_4 * arg_38_1

	self._lerped_overcharge_fraction = math.clamp(num_5, min, max)

	return true
end

PlayerUnitOverchargeExtension._update_screen_effect = function (self)
	-- function 39
	if Development.parameter("screen_space_player_camera_reactions") == false then
		self:_destroy_all_screen_space_particles()

		return
	end

	local world = self.world
	local first_person_extension = self.first_person_extension
	local str = "overlay"
	local str_2 = "intensity"
	local _screen_particle_opacity_modifier = self._screen_particle_opacity_modifier
	local lerped_overcharge_fraction = self:lerped_overcharge_fraction()

	if lerped_overcharge_fraction > 0 then
		if not self.onscreen_particles_id then
			self.onscreen_particles_id = first_person_extension:create_screen_particles(self.screen_space_particle)
		end

		World.set_particles_material_scalar(world, self.onscreen_particles_id, str, str_2, lerped_overcharge_fraction * _screen_particle_opacity_modifier)
	elseif not self.onscreen_particles_id then
		self:_destroy_screen_space_particles(self.onscreen_particles_id)

		self.onscreen_particles_id = nil
	end

	if not self.screen_space_particle_critical then
		if not self:is_above_critical_limit() then
			if not self.critical_onscreen_particles_id then
				self.critical_onscreen_particles_id = first_person_extension:create_screen_particles(self.screen_space_particle_critical)
			end

			local min = math.min(1, (self.overcharge_value - self.overcharge_critical_limit) / (self.max_value - self.overcharge_critical_limit) * 2)

			World.set_particles_material_scalar(world, self.critical_onscreen_particles_id, str, str_2, min * _screen_particle_opacity_modifier)
		elseif not self.critical_onscreen_particles_id then
			self:_destroy_screen_space_particles(self.critical_onscreen_particles_id)

			self.critical_onscreen_particles_id = nil
		end
	end
end

PlayerUnitOverchargeExtension._update_overcharge_buff_state = function (self, arg_40_1, arg_40_2)
	-- function 40
	local _overcharge_value_state = self:_overcharge_value_state(arg_40_1)
	local _overcharge_value_state_2 = self:_overcharge_value_state(arg_40_2)

	if not (_overcharge_value_state ~= _overcharge_value_state_2) then
		self:_update_overcharge_buff(_overcharge_value_state_2)

		local var_40_2 = self._overcharge_states[_overcharge_value_state_2]

		if not var_40_2 then
			self:_trigger_controller_effect("rumble", var_40_2.controller_effect)
		end
	end
end

PlayerUnitOverchargeExtension._overcharge_value_state = function (self, arg_41_1)
	-- function 41
	if arg_41_1 >= self.overcharge_critical_limit then
		return enum.high
	elseif arg_41_1 >= self.overcharge_limit then
		return enum.medium
	elseif arg_41_1 >= self.overcharge_threshold then
		return enum.low
	else
		return enum.none
	end
end
