-- chunkname: @scripts/settings/dlcs/shovel/action_damage_target.lua

ActionDamageTarget = class(ActionDamageTarget, ActionBase)

ActionDamageTarget.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionDamageTarget.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.owner_unit = arg_1_4
	arg_1_0.ammo_extension = ScriptUnit.has_extension(arg_1_7, "ammo_system")
	arg_1_0.inventory_extension = ScriptUnit.extension(arg_1_4, "inventory_system")
	arg_1_0.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	arg_1_0.first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
	arg_1_0.owner_buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	arg_1_0.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	arg_1_0.status_extension = ScriptUnit.extension(arg_1_4, "status_system")
	arg_1_0.hud_extension = ScriptUnit.has_extension(arg_1_4, "hud_system")

	if arg_1_0.first_person_extension then
		arg_1_0.first_person_unit = arg_1_0.first_person_extension:get_first_person_unit()
	end

	arg_1_0._rumble_effect_id = false
	arg_1_0.unit_id = arg_1_0.network_manager.unit_storage:go_id(arg_1_4)
end

ActionDamageTarget.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	ActionDamageTarget.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	if not arg_2_3 or not arg_2_3.target then
		arg_2_0._done = true

		arg_2_0.weapon_extension:stop_action("action_complete")

		return
	end

	arg_2_0._power_level = arg_2_4
	arg_2_0._target_unit = arg_2_3.target
	arg_2_0._damage_steps = arg_2_1.damage_steps
	arg_2_0._step_idx = 1
	arg_2_0._num_repeats = 0
	arg_2_0._anim_time_scale = ActionUtils.get_action_time_scale(arg_2_0.owner_unit, arg_2_1)
	arg_2_0._next_update_t = arg_2_2 + arg_2_1.damage_steps[1].start_delay / arg_2_0._anim_time_scale
	arg_2_0._done = false

	local var_2_0 = arg_2_0._target_unit
	local var_2_1 = Unit.has_node(var_2_0, "j_spine") and Unit.node(var_2_0, "j_spine") or 0

	arg_2_0._target_node_id = var_2_1
	arg_2_0._target_hit_zone = arg_2_1.target_node
	arg_2_0._target_hit_zone_id = NetworkLookup.hit_zones[arg_2_1.target_node]

	local var_2_2 = Managers.state.network

	arg_2_0._attacker_unit_id = var_2_2:unit_game_object_id(arg_2_0.owner_unit)
	arg_2_0._hit_unit_id = var_2_2:unit_game_object_id(arg_2_3.target)

	AiUtils.alert_unit(arg_2_0.owner_unit, arg_2_0._target_unit)
	arg_2_0.weapon_system:start_soul_rip(arg_2_0.owner_unit, arg_2_3.target, var_2_1, math.random(0, 65535), true)

	if not arg_2_0.is_bot then
		local var_2_3, var_2_4 = ActionUtils.start_charge_sound(arg_2_0.wwise_world, arg_2_0.weapon_unit, arg_2_0.owner_unit, arg_2_1)

		arg_2_0.charging_sound_id = var_2_3
		arg_2_0.wwise_source_id = var_2_4
	end
end

ActionDamageTarget._apply_damage_step = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_3.damage_profile
	local var_3_1 = arg_3_3.overcharge_amount
	local var_3_2 = Unit.get_data(arg_3_1, "breed")

	if var_3_2 then
		var_3_1 = var_3_2.is_player and arg_3_3.overcharge_amount_player_target or var_3_1

		if arg_3_3.can_crit then
			arg_3_0._is_critical_strike = ActionUtils.is_critical_strike(arg_3_0.owner_unit, arg_3_0.current_action, arg_3_4)

			arg_3_0:_handle_critical_strike(arg_3_0._is_critical_strike, arg_3_0.buff_extension, arg_3_0.hud_extension, arg_3_0.first_person_extension, "on_critical_shot", nil)
		else
			arg_3_0._is_critical_strike = false
		end

		if arg_3_3.proc_buffs then
			local var_3_3 = 1
			local var_3_4 = true
			local var_3_5 = DamageProfileTemplates[var_3_0].charge_value or "instant_projectile"
			local var_3_6 = DamageUtils.get_item_buff_type(arg_3_0.item_name)

			DamageUtils.buff_on_attack(arg_3_0.owner_unit, arg_3_1, var_3_5, arg_3_0._is_critical_strike, arg_3_0._target_hit_zone, var_3_3, var_3_4, var_3_6, nil, arg_3_0.item_name)
		end
	end

	local var_3_7, var_3_8 = ActionUtils.get_ranged_boost(arg_3_0.owner_unit)
	local var_3_9 = arg_3_0.item_name
	local var_3_10 = NetworkLookup.damage_sources[var_3_9]
	local var_3_11 = arg_3_0._attacker_unit_id
	local var_3_12 = arg_3_0._hit_unit_id
	local var_3_13 = arg_3_0._target_hit_zone_id
	local var_3_14 = Unit.world_position(arg_3_1, arg_3_0._target_node_id)
	local var_3_15 = arg_3_0.first_person_extension:current_position()
	local var_3_16 = Vector3.normalize(var_3_14 - var_3_15)
	local var_3_17 = NetworkLookup.damage_profiles[var_3_0]

	arg_3_0.weapon_system:send_rpc_attack_hit(var_3_10, var_3_11, var_3_12, var_3_13, var_3_14, var_3_16, var_3_17, "power_level", arg_3_2, "hit_target_index", 1, "blocking", false, "shield_break_procced", false, "boost_curve_multiplier", var_3_8, "is_critical_strike", arg_3_0._is_critical_strike, "can_damage", true, "can_stagger", true, "first_hit", true)

	if var_3_1 then
		local var_3_18 = arg_3_0.owner_buff_extension

		if arg_3_0._is_critical_strike and var_3_18:has_buff_perk("no_overcharge_crit") then
			var_3_1 = 0
		end

		arg_3_0.overcharge_extension:add_charge(var_3_1)
	end
end

ActionDamageTarget.client_owner_post_update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_0._target_unit

	if var_4_0 and not HEALTH_ALIVE[var_4_0] then
		arg_4_0._done = true
		arg_4_0._target_unit = nil

		if ALIVE[var_4_0] then
			local var_4_1 = arg_4_0.current_action

			arg_4_0.weapon_system:soul_rip_burst(arg_4_0.owner_unit, var_4_0, arg_4_0._target_node_id, var_4_1.last_damage_step_fx_name, math.random(0, 65535), true)
		end

		arg_4_0:_start_forced_action(arg_4_2)
	end

	if not arg_4_0._done and arg_4_2 >= arg_4_0._next_update_t then
		local var_4_2 = arg_4_0._damage_steps[arg_4_0._step_idx]

		arg_4_0:_apply_damage_step(var_4_0, arg_4_0._power_level, var_4_2, arg_4_2)

		arg_4_0._num_repeats = arg_4_0._num_repeats + 1

		if arg_4_0._num_repeats < var_4_2.repeat_count then
			arg_4_0._next_update_t = arg_4_2 + var_4_2.repeat_delay / arg_4_0._anim_time_scale
		else
			arg_4_0._step_idx = arg_4_0._step_idx + 1

			local var_4_3 = arg_4_0._damage_steps[arg_4_0._step_idx]

			if var_4_3 then
				arg_4_0._next_update_t = arg_4_2 + var_4_3.start_delay / arg_4_0._anim_time_scale
				arg_4_0._num_repeats = 0
			else
				arg_4_0._done = true

				arg_4_0:_proc_spell_used(arg_4_0.owner_buff_extension)
				arg_4_0:_start_forced_action(arg_4_2)
			end
		end
	end

	if ALIVE[var_4_0] then
		local var_4_4 = Unit.world_position(var_4_0, arg_4_0._target_node_id)
		local var_4_5, var_4_6 = Vector3.direction_length(var_4_4 - arg_4_0.first_person_extension:current_position())
		local var_4_7 = Quaternion.forward(arg_4_0.first_person_extension:current_rotation())
		local var_4_8 = math.cos(math.degrees_to_radians(45))
		local var_4_9 = Vector3.dot(var_4_7, var_4_5)

		if var_4_9 < var_4_8 then
			local var_4_10 = 5

			if var_4_9 < math.cos(math.atan2(var_4_10, var_4_6)) then
				arg_4_0._done = true
				arg_4_0._target_unit = nil

				arg_4_0.weapon_extension:stop_action("action_complete")
			end
		end

		if not arg_4_0._damage_steps[arg_4_0._step_idx] then
			local var_4_11 = arg_4_0.current_action

			arg_4_0.weapon_system:soul_rip_burst(arg_4_0.owner_unit, var_4_0, arg_4_0._target_node_id, var_4_11.last_damage_step_fx_name, math.random(0, 65535), true)

			local var_4_12 = var_4_11.last_damage_step_sound_event

			if var_4_12 then
				Managers.state.entity:system("audio_system"):play_audio_position_event(var_4_12, var_4_4)
			end
		end
	end
end

ActionDamageTarget._start_forced_action = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.current_action.force_action_on_complete

	if not var_5_0 then
		return
	end

	local var_5_1 = var_5_0.action_name
	local var_5_2 = var_5_0.sub_action_name
	local var_5_3 = arg_5_0._power_level
	local var_5_4 = arg_5_0.weapon_extension
	local var_5_5 = arg_5_0.current_action.lookup_data.item_template_name
	local var_5_6 = WeaponUtils.get_weapon_template(var_5_5).actions

	var_5_4:start_action(var_5_1, var_5_2, var_5_6, arg_5_1, var_5_3)
end

ActionDamageTarget.finish = function (arg_6_0, arg_6_1)
	ActionDamageTarget.super.finish(arg_6_0, arg_6_1)

	if not arg_6_0.is_bot then
		ActionUtils.stop_charge_sound(arg_6_0.wwise_world, arg_6_0.charging_sound_id, arg_6_0.wwise_source_id, arg_6_0.current_action)

		arg_6_0.charging_sound_id = nil
		arg_6_0.wwise_source_id = nil
	end

	arg_6_0.weapon_system:stop_soul_rip(arg_6_0.owner_unit, true)
end

ActionDamageTarget.destroy = function (arg_7_0)
	return
end
