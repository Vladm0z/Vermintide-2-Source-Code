-- chunkname: @scripts/unit_extensions/default_player_unit/charge/player_unit_overcharge_extension.lua

require("scripts/unit_extensions/default_player_unit/charge/overcharge_data")

PlayerUnitOverchargeExtension = class(PlayerUnitOverchargeExtension)

local var_0_0 = table.enum("none", "low", "medium", "high", "critical", "exploding")

PlayerUnitOverchargeExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_2

	local var_1_0 = arg_1_3.overcharge_data

	arg_1_0.max_value = var_1_0.max_value or 40
	arg_1_0.time_when_overcharge_start_decreasing = 0
	arg_1_0.overcharge_crit_time = 0
	arg_1_0.overcharge_crit_interval = 1
	arg_1_0.venting_overcharge = false
	arg_1_0.vent_damage_pool = 0
	arg_1_0.no_damage = global_is_inside_inn or var_1_0.no_damage
	arg_1_0.lockout = false
	arg_1_0.prev_lockout = false
	arg_1_0.overcharge_threshold = var_1_0.overcharge_threshold or 0
	arg_1_0.overcharge_value_decrease_rate = var_1_0.overcharge_value_decrease_rate or 0
	arg_1_0.time_until_overcharge_decreases = var_1_0.time_until_overcharge_decreases or 0
	arg_1_0.hit_overcharge_threshold_sound = var_1_0.hit_overcharge_threshold_sound or "ui_special_attack_ready"
	arg_1_0.critical_overcharge_margin = var_1_0.critical_overcharge_margin or 1.2
	arg_1_0.overcharge_depleted_func = var_1_0.overcharge_depleted_func
	arg_1_0.screen_space_particle = var_1_0.onscreen_particles_id or "fx/screenspace_overheat_indicator"
	arg_1_0.screen_space_particle_critical = var_1_0.critical_onscreen_particles_id or not var_1_0.no_critical_onscreen_particles and "fx/screenspace_overheat_critical"
	arg_1_0._lerped_overcharge_fraction = 0

	local var_1_1 = Managers.player:local_player()
	local var_1_2 = var_1_1 and Managers.state.side:get_side_from_player_unique_id(var_1_1:unique_id())

	if var_1_2 and var_1_2:name() == "dark_pact" then
		arg_1_0.screen_space_particle = "fx/screenspace_overheat_indicator_warpfire"
		arg_1_0.screen_space_particle_critical = "fx/screenspace_overheat_critical_warpfire"
	end

	arg_1_0._overcharge_states = {
		[var_0_0.none] = {},
		[var_0_0.low] = {
			sound_event = var_1_0.overcharge_warning_low_sound_event,
			controller_effect = {
				rumble_effect = "overcharge_rumble"
			}
		},
		[var_0_0.medium] = {
			dialogue_event = "overcharge",
			sound_event = var_1_0.overcharge_warning_med_sound_event,
			controller_effect = {
				rumble_effect = "overcharge_rumble_overcharged"
			}
		},
		[var_0_0.high] = {
			dialogue_event = "overcharge_high",
			sound_event = var_1_0.overcharge_warning_high_sound_event,
			controller_effect = {
				rumble_effect = "overcharge_rumble_crit"
			}
		},
		[var_0_0.critical] = {
			dialogue_event = "overcharge_critical",
			sound_event = var_1_0.overcharge_warning_critical_sound_event
		},
		[var_0_0.exploding] = {
			dialogue_event = "overcharge_explode"
		}
	}
	arg_1_0.explosion_template = var_1_0.explosion_template or "overcharge_explosion"
	arg_1_0.no_forced_movement = var_1_0.no_forced_movement
	arg_1_0.no_explosion = var_1_0.no_explosion
	arg_1_0.explode_vfx_name = var_1_0.explode_vfx_name
	arg_1_0.overcharge_explosion_time = var_1_0.overcharge_explosion_time
	arg_1_0.percent_health_lost = var_1_0.percent_health_lost
	arg_1_0.lockout_overcharge_decay_rate = var_1_0.lockout_overcharge_decay_rate
	arg_1_0.network_manager = Managers.state.network
	arg_1_0.venting_anim = nil
	arg_1_0.is_exploding = false
	arg_1_0._ignored_overcharge_types = {
		flamethrower = true,
		damage_to_overcharge = true,
		charging = true,
		drakegun_charging = true
	}

	local var_1_3 = Application.user_setting("overcharge_opacity") or 100

	arg_1_0:set_screen_particle_opacity_modifier(var_1_3)
end

PlayerUnitOverchargeExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.first_person_extension = ScriptUnit.extension(arg_2_0.unit, "first_person_system")
	arg_2_0._dialogue_input = ScriptUnit.extension_input(arg_2_0.unit, "dialogue_system")
	arg_2_0._buff_extension = ScriptUnit.extension(arg_2_0.unit, "buff_system")
	arg_2_0.overcharge_value = 0
	arg_2_0.original_max_value = arg_2_0.max_value

	arg_2_0:_calculate_and_set_buffed_max_overcharge_values()
end

PlayerUnitOverchargeExtension._calculate_and_set_buffed_max_overcharge_values = function (arg_3_0)
	local var_3_0 = arg_3_0:overcharge_fraction()
	local var_3_1 = arg_3_0._buff_extension:apply_buffs_to_value(arg_3_0.original_max_value, "max_overcharge")

	fassert(var_3_1 >= NetworkConstants.max_overcharge.min and var_3_1 <= NetworkConstants.max_overcharge.max, "Max overcharge outside value bounds allowed by network variable!")

	arg_3_0.overcharge_value = var_3_0 * var_3_1
	arg_3_0.max_value = var_3_1
	arg_3_0.overcharge_limit = var_3_1 * 0.65
	arg_3_0.overcharge_critical_limit = var_3_1 * 0.8
end

PlayerUnitOverchargeExtension.set_screen_particle_opacity_modifier = function (arg_4_0, arg_4_1)
	arg_4_0._screen_particle_opacity_modifier = arg_4_1 / 100
end

PlayerUnitOverchargeExtension.reset = function (arg_5_0)
	arg_5_0:_destroy_all_screen_space_particles()

	local var_5_0 = ScriptUnit.has_extension(arg_5_0.unit, "buff_system")

	if var_5_0 and var_5_0:active_buffs() then
		arg_5_0:_add_overcharge_buff(nil)
	end

	arg_5_0.lockout = false
	arg_5_0.overcharge_value = 0
	arg_5_0.played_hit_overcharge_threshold = false
	arg_5_0.is_exploding = false

	StatusUtils.set_overcharge_exploding(arg_5_0.unit, false)

	local var_5_1 = arg_5_0.world
	local var_5_2 = Managers.world:wwise_world(var_5_1)

	WwiseWorld.set_global_parameter(var_5_2, "overcharge_status", 0)
	arg_5_0:set_animation_variable()
end

PlayerUnitOverchargeExtension._destroy_all_screen_space_particles = function (arg_6_0)
	arg_6_0:_destroy_screen_space_particles(arg_6_0.onscreen_particles_id)

	arg_6_0.onscreen_particles_id = nil

	arg_6_0:_destroy_screen_space_particles(arg_6_0.critical_onscreen_particles_id)

	arg_6_0.critical_onscreen_particles_id = nil
end

PlayerUnitOverchargeExtension._destroy_screen_space_particles = function (arg_7_0, arg_7_1)
	if arg_7_1 then
		World.destroy_particles(arg_7_0.world, arg_7_1)
	end
end

PlayerUnitOverchargeExtension._update_vfx_sfx = function (arg_8_0, arg_8_1)
	if arg_8_1 and not arg_8_1.bot_player then
		arg_8_0:_update_screen_effect()

		local var_8_0 = arg_8_0.world
		local var_8_1 = Managers.world:wwise_world(var_8_0)

		WwiseWorld.set_global_parameter(var_8_1, "overcharge_status", arg_8_0._lerped_overcharge_fraction)
	end
end

PlayerUnitOverchargeExtension.destroy = function (arg_9_0)
	arg_9_0:_destroy_all_screen_space_particles()

	local var_9_0 = ScriptUnit.has_extension(arg_9_0.unit, "buff_system")

	if var_9_0 and var_9_0:active_buffs() then
		arg_9_0:_add_overcharge_buff(nil)
	end
end

PlayerUnitOverchargeExtension.set_animation_variable = function (arg_10_0)
	local var_10_0 = arg_10_0:get_anim_blend_overcharge()

	arg_10_0.first_person_extension:animation_set_variable("overcharge", var_10_0, true)
end

PlayerUnitOverchargeExtension._update_game_object = function (arg_11_0)
	local var_11_0 = arg_11_0.network_manager
	local var_11_1 = arg_11_0.unit
	local var_11_2 = var_11_0:game()
	local var_11_3 = Managers.state.unit_storage:go_id(var_11_1)

	if var_11_2 and var_11_3 then
		local var_11_4 = arg_11_0:overcharge_fraction()
		local var_11_5 = arg_11_0:threshold_fraction()
		local var_11_6 = arg_11_0:get_max_value()

		GameSession.set_game_object_field(var_11_2, var_11_3, "overcharge_percentage", var_11_4)
		GameSession.set_game_object_field(var_11_2, var_11_3, "overcharge_threshold_percentage", var_11_5)
		GameSession.set_game_object_field(var_11_2, var_11_3, "overcharge_max_value", var_11_6)
	end
end

PlayerUnitOverchargeExtension.update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	arg_12_0:_calculate_and_set_buffed_max_overcharge_values()
	arg_12_0:_update_game_object()

	local var_12_0 = arg_12_0.overcharge_value

	if not arg_12_0.is_exploding and arg_12_0.venting_overcharge and arg_12_0.overcharge_value >= 0 then
		local var_12_1 = arg_12_0._buff_extension
		local var_12_2 = arg_12_0.unit
		local var_12_3 = var_12_1:apply_buffs_to_value(arg_12_3, "vent_speed")
		local var_12_4 = arg_12_0.overcharge_value * (arg_12_0.original_max_value / 80) * var_12_3
		local var_12_5 = arg_12_0.overcharge_value
		local var_12_6 = var_12_5 - var_12_4

		arg_12_0:_update_overcharge_buff_state(var_12_5, var_12_6)

		arg_12_0.overcharge_value = var_12_6
		arg_12_0.vent_damage_pool = arg_12_0.vent_damage_pool + var_12_4 * 2

		if arg_12_0.vent_damage_pool >= 20 and not arg_12_0.no_damage and arg_12_0.overcharge_value > arg_12_0.overcharge_threshold then
			local var_12_7, var_12_8 = var_12_1:apply_buffs_to_value(0, "overcharge_damage_immunity")

			if not var_12_8 then
				local var_12_9 = 2 + arg_12_0.overcharge_value / 12
				local var_12_10 = var_12_1:apply_buffs_to_value(var_12_9, "vent_damage")

				DamageUtils.add_damage_network(var_12_2, var_12_2, var_12_10, "torso", "overcharge", nil, Vector3(0, 1, 0), "overcharge", nil, nil, nil, nil, false, false, false, 0, 1, nil, 1)
			end

			arg_12_0.vent_damage_pool = 0
		end
	else
		arg_12_0.venting_overcharge = false
	end

	local var_12_11 = arg_12_0.first_person_extension
	local var_12_12 = arg_12_0.unit

	if var_12_11 then
		if arg_12_0.venting_anim then
			var_12_11:animation_event(arg_12_0.venting_anim)

			arg_12_0.venting_anim = nil
		end

		local var_12_13 = arg_12_0.lockout

		if arg_12_0.prev_lockout ~= var_12_13 then
			arg_12_0.prev_lockout = var_12_13

			local var_12_14 = var_12_13 and 1 or 0

			var_12_11:animation_set_variable("overcharge_locked_out", var_12_14, true)

			if not var_12_13 then
				var_12_11:animation_event("overcharge_end")
				Managers.state.network:anim_event(var_12_12, "overcharge_end")
			end
		end
	end

	local var_12_15 = arg_12_0._buff_extension
	local var_12_16 = Managers.player:owner(arg_12_0.unit)

	if arg_12_0.overcharge_value > 0 or var_12_15:has_buff_type("sienna_unchained_activated_ability") then
		arg_12_0._had_overcharge = true

		if not arg_12_0.is_exploding and arg_12_5 > arg_12_0.time_when_overcharge_start_decreasing or arg_12_0.lockout == true then
			local var_12_17 = 1

			if arg_12_0.overcharge_value >= arg_12_0.overcharge_threshold then
				var_12_17 = var_12_17 * 0.6
			elseif arg_12_0.lockout == true then
				arg_12_0.lockout = false
				arg_12_0.is_exploding = false

				arg_12_0:_trigger_hud_sound("weapon_life_staff_lockout_end", arg_12_0.first_person_extension)
				arg_12_0:_trigger_dialogue("overcharge_lockout_end")
			end

			if arg_12_0.lockout then
				var_12_17 = var_12_17 * arg_12_0.lockout_overcharge_decay_rate
			end

			local var_12_18 = var_12_17 * arg_12_0.overcharge_value_decrease_rate * arg_12_3
			local var_12_19 = arg_12_0.overcharge_value - var_12_15:apply_buffs_to_value(var_12_18, "overcharge_regen")

			if var_12_15:has_buff_type("sienna_unchained_activated_ability") and var_12_19 >= arg_12_0.max_value then
				arg_12_0:add_charge(1)
			end

			local var_12_20 = arg_12_0.overcharge_value
			local var_12_21 = math.min(math.max(0, var_12_19), arg_12_0.max_value)

			arg_12_0.overcharge_value = var_12_21

			arg_12_0:_update_overcharge_buff_state(var_12_20, var_12_21)
		end
	elseif arg_12_0._had_overcharge then
		arg_12_0._had_overcharge = false

		arg_12_0:_update_overcharge_buff(var_0_0.none)
		arg_12_0:_trigger_controller_effect(nil)
	end

	if arg_12_0:_update_lerped_overcharge(arg_12_3) then
		arg_12_0:_update_vfx_sfx(var_12_16)
		arg_12_0:set_animation_variable()
	end

	local var_12_22 = arg_12_0.overcharge_value

	if var_12_22 < var_12_0 then
		arg_12_0._buff_extension:trigger_procs("on_overcharge_lost", var_12_0 - var_12_22, arg_12_0.max_value)
	end

	if arg_12_0.overcharge_value <= 0 and var_12_0 ~= 0 and arg_12_0.overcharge_depleted_func then
		arg_12_0.overcharge_depleted_func(arg_12_0.world, arg_12_0.unit, arg_12_0.first_person_extension)
	end
end

PlayerUnitOverchargeExtension.add_charge = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = arg_13_0._buff_extension
	local var_13_1 = arg_13_0.max_value
	local var_13_2 = arg_13_0.overcharge_value
	local var_13_3

	if arg_13_2 then
		arg_13_1 = 0.4 * arg_13_1 + 0.6 * arg_13_1 * arg_13_2
	end

	arg_13_1 = arg_13_0._buff_extension:apply_buffs_to_value(arg_13_1, "reduced_overcharge")

	if var_13_0 and not arg_13_0._ignored_overcharge_types[arg_13_3] then
		arg_13_1 = arg_13_1 * var_13_0:apply_buffs_to_value(1, "ammo_used_multiplier")

		var_13_0:trigger_procs("on_ammo_used", arg_13_0, 0)
		var_13_0:trigger_procs("on_overcharge_used", arg_13_1)
		Managers.state.achievement:trigger_event("ammo_used", arg_13_0.owner_unit)

		if not LEVEL_EDITOR_TEST and not arg_13_0._is_server then
			local var_13_4 = Managers.player
			local var_13_5 = Managers.player:owner(arg_13_0.unit)
			local var_13_6 = var_13_5:network_id()
			local var_13_7 = var_13_5:local_player_id()
			local var_13_8 = NetworkLookup.proc_events.on_ammo_used

			Managers.state.network.network_transmit:send_rpc_server("rpc_proc_event", var_13_6, var_13_7, var_13_8)
		end
	end

	if var_13_0:has_buff_perk("no_overcharge") then
		return
	end

	if var_13_0:has_buff_type("twitch_no_overcharge_no_ammo_reloads") then
		return
	end

	if var_13_2 <= var_13_1 - arg_13_0.critical_overcharge_margin and var_13_1 <= var_13_2 + arg_13_1 then
		local var_13_9 = arg_13_0._overcharge_states[var_0_0.critical]

		arg_13_0:_trigger_hud_sound(var_13_9.sound_event, arg_13_0.first_person_extension)
		arg_13_0:_trigger_dialogue(var_13_9.dialogue_event)

		var_13_3 = var_13_1 - 0.1
	else
		var_13_3 = math.min(var_13_2 + arg_13_1, var_13_1)
	end

	arg_13_0:_check_overcharge_level_thresholds(var_13_3)

	local var_13_10 = var_13_3 - var_13_2
	local var_13_11 = var_13_10 / arg_13_0:get_max_value()

	Managers.state.achievement:trigger_event("overcharge_gained", var_13_10, var_13_11, arg_13_0.unit)

	arg_13_0.time_when_overcharge_start_decreasing = Managers.time:time("game") + arg_13_0.time_until_overcharge_decreases
	arg_13_0.overcharge_value = var_13_3
end

PlayerUnitOverchargeExtension.remove_charge = function (arg_14_0, arg_14_1)
	if arg_14_0.is_exploding then
		return
	end

	local var_14_0 = arg_14_0.overcharge_value
	local var_14_1 = math.max(var_14_0 - arg_14_1, 0)

	arg_14_0:_check_overcharge_level_thresholds(var_14_1)

	local var_14_2 = math.max(var_14_0 - var_14_1, 0)

	arg_14_0._buff_extension:trigger_procs("on_overcharge_lost", var_14_2, arg_14_0.max_value)

	arg_14_0.overcharge_value = var_14_1

	return var_14_0 - var_14_1
end

PlayerUnitOverchargeExtension.remove_charge_fraction = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0:get_max_value()
	local var_15_1 = var_15_0 * arg_15_1
	local var_15_2 = arg_15_0:remove_charge(var_15_1) or 0

	return var_15_2, var_15_2 / var_15_0
end

PlayerUnitOverchargeExtension._check_overcharge_level_thresholds = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._buff_extension
	local var_16_1 = arg_16_0.max_value

	if var_16_1 <= arg_16_1 then
		if var_16_0:has_buff_perk("no_overcharge_explosion") then
			local var_16_2 = arg_16_0.unit
			local var_16_3 = arg_16_1 - var_16_1 + 1
			local var_16_4 = 2 + var_16_1 / 12
			local var_16_5 = var_16_0:apply_buffs_to_value(var_16_4, "vent_damage")

			arg_16_0:remove_charge(var_16_3)
		else
			local var_16_6 = arg_16_0.unit

			StatusUtils.set_overcharge_exploding(var_16_6, true)

			arg_16_0.is_exploding = true

			arg_16_0:_add_overcharge_buff(nil)

			local var_16_7 = arg_16_0._overcharge_states[var_0_0.exploding]

			arg_16_0:_trigger_hud_sound(var_16_7.sound_event, arg_16_0.first_person_extension)
			arg_16_0:_trigger_dialogue(var_16_7.dialogue_event)
			arg_16_0:_trigger_controller_effect("rumble", var_16_7.controller_effect)
		end
	else
		local var_16_8 = arg_16_1 / var_16_1
		local var_16_9 = arg_16_0.overcharge_threshold
		local var_16_10 = arg_16_0:_overcharge_value_state(arg_16_0.overcharge_value)
		local var_16_11 = arg_16_0:_overcharge_value_state(arg_16_1)
		local var_16_12 = var_16_10 ~= var_16_11
		local var_16_13 = arg_16_0._overcharge_states[var_16_11]

		if var_16_13 then
			if var_16_12 then
				if var_16_11 == var_0_0.low then
					local var_16_14 = Managers.world:wwise_world(arg_16_0.world)

					WwiseWorld.trigger_event(var_16_14, arg_16_0.hit_overcharge_threshold_sound)
				end

				arg_16_0:_trigger_hud_sound(var_16_13.sound_event, arg_16_0.first_person_extension)
				arg_16_0:_update_overcharge_buff(var_16_11)
			end

			arg_16_0:_trigger_dialogue(var_16_13.dialogue_event)
			arg_16_0:_trigger_controller_effect("rumble", var_16_13.controller_effect)
		end
	end
end

PlayerUnitOverchargeExtension.set_lockout = function (arg_17_0, arg_17_1)
	arg_17_0.lockout = arg_17_1
end

PlayerUnitOverchargeExtension.get_overcharge_value = function (arg_18_0)
	return arg_18_0.overcharge_value
end

PlayerUnitOverchargeExtension.is_above_critical_limit = function (arg_19_0)
	return arg_19_0.overcharge_value >= arg_19_0.overcharge_critical_limit
end

PlayerUnitOverchargeExtension.get_original_max_value = function (arg_20_0)
	return arg_20_0.original_max_value
end

PlayerUnitOverchargeExtension.get_max_value = function (arg_21_0)
	return arg_21_0.max_value
end

PlayerUnitOverchargeExtension.get_overcharge_threshold = function (arg_22_0)
	return arg_22_0.overcharge_threshold
end

PlayerUnitOverchargeExtension.above_overcharge_threshold = function (arg_23_0)
	return arg_23_0.overcharge_value >= arg_23_0.overcharge_threshold
end

PlayerUnitOverchargeExtension.are_you_exploding = function (arg_24_0)
	return arg_24_0.is_exploding
end

PlayerUnitOverchargeExtension.are_you_locked_out = function (arg_25_0)
	return arg_25_0.lockout
end

PlayerUnitOverchargeExtension.overcharge_fraction = function (arg_26_0)
	return math.clamp(arg_26_0.overcharge_value / arg_26_0.max_value, 0, 1)
end

PlayerUnitOverchargeExtension.lerped_overcharge_fraction = function (arg_27_0)
	return arg_27_0._lerped_overcharge_fraction
end

PlayerUnitOverchargeExtension.threshold_fraction = function (arg_28_0)
	return arg_28_0.overcharge_threshold / arg_28_0.max_value
end

PlayerUnitOverchargeExtension.current_overcharge_status = function (arg_29_0)
	local var_29_0 = arg_29_0:get_overcharge_value()
	local var_29_1 = arg_29_0:get_overcharge_threshold()
	local var_29_2 = arg_29_0:get_max_value()

	return var_29_0, var_29_1, var_29_2
end

PlayerUnitOverchargeExtension.vent_overcharge = function (arg_30_0)
	arg_30_0.venting_overcharge = true

	if arg_30_0.overcharge_value > 0 then
		arg_30_0.vent_damage_pool = 20
	else
		arg_30_0.vent_damage_pool = 0
	end

	arg_30_0.venting_anim = "cooldown_start"
end

PlayerUnitOverchargeExtension.vent_overcharge_done = function (arg_31_0)
	arg_31_0.venting_overcharge = false
	arg_31_0.venting_anim = "cooldown_end"
end

PlayerUnitOverchargeExtension.get_anim_blend_overcharge = function (arg_32_0)
	local var_32_0 = arg_32_0._lerped_overcharge_fraction * arg_32_0:get_max_value()
	local var_32_1 = arg_32_0.overcharge_threshold
	local var_32_2 = arg_32_0.max_value

	return (math.clamp((var_32_0 - var_32_1) / (var_32_2 - var_32_1), 0, 1))
end

PlayerUnitOverchargeExtension._trigger_hud_sound = function (arg_33_0, arg_33_1, arg_33_2)
	if not arg_33_1 or not arg_33_2 then
		return
	end

	arg_33_2:play_hud_sound_event(arg_33_1)
end

PlayerUnitOverchargeExtension._trigger_dialogue = function (arg_34_0, arg_34_1)
	if not arg_34_1 then
		return
	end

	local var_34_0 = arg_34_0._dialogue_input
	local var_34_1 = FrameTable.alloc_table()

	var_34_0:trigger_networked_dialogue_event(arg_34_1, var_34_1)
end

PlayerUnitOverchargeExtension._trigger_controller_effect = function (arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = Managers.state.controller_features
	local var_35_1 = arg_35_0._rumble_effect_id

	if var_35_1 then
		var_35_0:stop_effect(var_35_1)

		arg_35_0._rumble_effect_id = nil
	end

	if arg_35_1 and arg_35_2 then
		arg_35_0._rumble_effect_id = var_35_0:add_effect(arg_35_1, arg_35_2)
	end
end

PlayerUnitOverchargeExtension._add_overcharge_buff = function (arg_36_0, arg_36_1)
	local var_36_0 = arg_36_0._buff_extension
	local var_36_1 = arg_36_0._overcharged_buff_id

	if var_36_1 then
		var_36_0:remove_buff(var_36_1)

		arg_36_0.overcharged_buff_id = nil
	end

	if arg_36_1 then
		arg_36_0._overcharged_buff_id = var_36_0:add_buff(arg_36_1)
	end
end

PlayerUnitOverchargeExtension._update_overcharge_buff = function (arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0._buff_extension

	if arg_37_1 == var_0_0.high then
		if var_37_0:has_buff_type("sienna_unchained_passive") or var_37_0:has_buff_perk("overcharge_no_slow") then
			arg_37_0:_add_overcharge_buff("overcharged_critical_no_attack_penalty")
		else
			arg_37_0:_add_overcharge_buff("overcharged_critical")
		end
	elseif arg_37_1 == var_0_0.medium then
		if var_37_0:has_buff_type("sienna_unchained_passive") or var_37_0:has_buff_perk("overcharge_no_slow") then
			arg_37_0:_add_overcharge_buff("overcharged_no_attack_penalty")
		else
			arg_37_0:_add_overcharge_buff("overcharged")
		end
	else
		arg_37_0:_add_overcharge_buff(nil)
	end
end

PlayerUnitOverchargeExtension._update_lerped_overcharge = function (arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0:overcharge_fraction()
	local var_38_1 = arg_38_0._lerped_overcharge_fraction

	if var_38_0 == var_38_1 then
		return false
	end

	local var_38_2 = 0.1
	local var_38_3 = 0.2
	local var_38_4 = 10
	local var_38_5 = 0.3
	local var_38_6 = math.abs(var_38_1 - var_38_0)

	if var_38_3 < var_38_6 then
		var_38_5 = var_38_5 * var_38_4
	elseif var_38_2 < var_38_6 then
		var_38_5 = var_38_5 * math.remap(var_38_2, var_38_3, 1, var_38_4, var_38_6)
	end

	local var_38_7 = math.min(var_38_1, var_38_0)
	local var_38_8 = math.max(var_38_1, var_38_0)
	local var_38_9 = var_38_1 + math.sign(var_38_0 - var_38_1) * var_38_5 * arg_38_1

	arg_38_0._lerped_overcharge_fraction = math.clamp(var_38_9, var_38_7, var_38_8)

	return true
end

PlayerUnitOverchargeExtension._update_screen_effect = function (arg_39_0)
	if Development.parameter("screen_space_player_camera_reactions") == false then
		arg_39_0:_destroy_all_screen_space_particles()

		return
	end

	local var_39_0 = arg_39_0.world
	local var_39_1 = arg_39_0.first_person_extension
	local var_39_2 = "overlay"
	local var_39_3 = "intensity"
	local var_39_4 = arg_39_0._screen_particle_opacity_modifier
	local var_39_5 = arg_39_0:lerped_overcharge_fraction()

	if var_39_5 > 0 then
		if not arg_39_0.onscreen_particles_id then
			arg_39_0.onscreen_particles_id = var_39_1:create_screen_particles(arg_39_0.screen_space_particle)
		end

		World.set_particles_material_scalar(var_39_0, arg_39_0.onscreen_particles_id, var_39_2, var_39_3, var_39_5 * var_39_4)
	elseif arg_39_0.onscreen_particles_id then
		arg_39_0:_destroy_screen_space_particles(arg_39_0.onscreen_particles_id)

		arg_39_0.onscreen_particles_id = nil
	end

	if arg_39_0.screen_space_particle_critical then
		if arg_39_0:is_above_critical_limit() then
			if not arg_39_0.critical_onscreen_particles_id then
				arg_39_0.critical_onscreen_particles_id = var_39_1:create_screen_particles(arg_39_0.screen_space_particle_critical)
			end

			local var_39_6 = math.min(1, (arg_39_0.overcharge_value - arg_39_0.overcharge_critical_limit) / (arg_39_0.max_value - arg_39_0.overcharge_critical_limit) * 2)

			World.set_particles_material_scalar(var_39_0, arg_39_0.critical_onscreen_particles_id, var_39_2, var_39_3, var_39_6 * var_39_4)
		elseif arg_39_0.critical_onscreen_particles_id then
			arg_39_0:_destroy_screen_space_particles(arg_39_0.critical_onscreen_particles_id)

			arg_39_0.critical_onscreen_particles_id = nil
		end
	end
end

PlayerUnitOverchargeExtension._update_overcharge_buff_state = function (arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = arg_40_0:_overcharge_value_state(arg_40_1)
	local var_40_1 = arg_40_0:_overcharge_value_state(arg_40_2)

	if var_40_0 ~= var_40_1 then
		arg_40_0:_update_overcharge_buff(var_40_1)

		local var_40_2 = arg_40_0._overcharge_states[var_40_1]

		if var_40_2 then
			arg_40_0:_trigger_controller_effect("rumble", var_40_2.controller_effect)
		end
	end
end

PlayerUnitOverchargeExtension._overcharge_value_state = function (arg_41_0, arg_41_1)
	if arg_41_1 >= arg_41_0.overcharge_critical_limit then
		return var_0_0.high
	elseif arg_41_1 >= arg_41_0.overcharge_limit then
		return var_0_0.medium
	elseif arg_41_1 >= arg_41_0.overcharge_threshold then
		return var_0_0.low
	else
		return var_0_0.none
	end
end
