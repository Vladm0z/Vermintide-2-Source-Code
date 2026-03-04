-- chunkname: @scripts/unit_extensions/weapons/actions/action_ranged_base.lua

ActionRangedBase = class(ActionRangedBase, ActionBase)

local var_0_0 = rawget(_G, "Tobii") and Application.user_setting("tobii_eyetracking")
local var_0_1 = 3
local var_0_2 = ScriptUnit.has_extension
local var_0_3 = Unit.set_flow_variable
local var_0_4 = Unit.flow_event

ActionRangedBase.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionRangedBase.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.buff_extension = var_0_2(arg_1_4, "buff_system")
	arg_1_0.overcharge_extension = var_0_2(arg_1_4, "overcharge_system")
	arg_1_0.hud_extension = var_0_2(arg_1_4, "hud_system")
	arg_1_0.first_person_extension = var_0_2(arg_1_4, "first_person_system")
	arg_1_0.eyetracking_extension = var_0_0 and var_0_2(arg_1_4, "eyetracking_system")
	arg_1_0.targeting_extension = var_0_2(arg_1_4, "smart_targeting_system")
	arg_1_0.input_extension = var_0_2(arg_1_4, "input_system")
	arg_1_0.status_extension = var_0_2(arg_1_4, "status_system")
	arg_1_0.ammo_extension = var_0_2(arg_1_7, "ammo_system")
	arg_1_0.spread_extension = var_0_2(arg_1_7, "spread_system")
	arg_1_0._start_gaze_rotation = QuaternionBox()
	arg_1_0._fire_position = Vector3Box()
	arg_1_0._fire_rotation = QuaternionBox()
	arg_1_0.shield_users_blocking = {}
end

ActionRangedBase.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	ActionRangedBase.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	local var_2_0 = arg_2_0.owner_unit
	local var_2_1 = arg_2_0.buff_extension
	local var_2_2 = arg_2_0.hud_extension

	arg_2_0._state = "waiting_to_shoot"
	arg_2_0._time_to_shoot = arg_2_2 + (arg_2_1.fire_time or 0)
	arg_2_0._active_reload_time = arg_2_1.active_reload_time and arg_2_2 + arg_2_1.active_reload_time
	arg_2_0._power_level = arg_2_4

	if arg_2_1.power_level then
		arg_2_0._power_level = arg_2_1.power_level
	end

	arg_2_0._num_shots_total, arg_2_0._num_projectiles_per_shot = arg_2_0:gen_num_shots()
	arg_2_0._extra_shot_delay = arg_2_1.extra_shot_delay or 0.2
	arg_2_0._burst_shot_delay = arg_2_1.burst_shot_delay or 0.1
	arg_2_0._num_shots_fired = 0
	arg_2_0._num_projectiles_spawned = 0
	arg_2_0._check_buffs = true
	arg_2_0._spread_done = false
	arg_2_0._extra_buff_shot = false
	arg_2_0._infinite_ammo = var_2_1:has_buff_perk("infinite_ammo")
	arg_2_0._continuous_buff_check = arg_2_1.continuous_buff_check or false
	arg_2_0._apply_shot_cost_once = arg_2_1.apply_shot_cost_once or false
	arg_2_0._shot_cost_applied = false
	arg_2_0._roll_crit_once = arg_2_1.roll_crit_once or false
	arg_2_0._crit_applied = false

	if not arg_2_0.is_bot then
		local var_2_3 = arg_2_1.controller_effects and arg_2_1.controller_effects.start

		if var_2_3 then
			Managers.state.controller_features:add_effect(var_2_3.effect_type, var_2_3.params)
		end
	end

	local var_2_4 = arg_2_1.spread_template_override

	if var_2_4 then
		arg_2_0.spread_extension:override_spread_template(var_2_4)
	end

	arg_2_0._unhide_ammo_at_action_end = arg_2_1.unhide_ammo_on_infinite_ammo and arg_2_0._infinite_ammo
end

ActionRangedBase.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if arg_3_0._state == "waiting_to_shoot" then
		arg_3_0:_waiting_to_shoot(arg_3_1, arg_3_2)
	end

	if arg_3_0._state == "start_shooting" then
		arg_3_0:_start_shooting(arg_3_2)
	end

	if arg_3_0._state == "shooting" then
		arg_3_0:_shooting(arg_3_2, false)
	end

	if arg_3_0._state == "finished_shooting" then
		arg_3_0:_finished_shooting(arg_3_2)
	end
end

ActionRangedBase.finish = function (arg_4_0, arg_4_1)
	ActionRangedBase.super.finish(arg_4_0, arg_4_1)

	if arg_4_0._state == "start_shooting" then
		arg_4_0:_start_shooting()
	end

	if arg_4_0._state == "shooting" then
		local var_4_0 = Managers.time:time("game")

		arg_4_0:_shooting(var_4_0, true)
	end

	if arg_4_0.spread_extension then
		arg_4_0.spread_extension:reset_spread_template()
	end

	local var_4_1 = arg_4_0.hud_extension

	if var_4_1 then
		var_4_1.show_critical_indication = false
	end

	if arg_4_1 ~= "new_interupting_action" then
		arg_4_0.status_extension:set_zooming(false)
		arg_4_0:reload()
	end

	if arg_4_0._unhide_ammo_at_action_end then
		Unit.flow_event(arg_4_0.first_person_unit, "anim_cb_unhide_ammo")
	end
end

ActionRangedBase._waiting_to_shoot = function (arg_5_0, arg_5_1, arg_5_2)
	if arg_5_2 >= arg_5_0._time_to_shoot then
		arg_5_0._state = "start_shooting"
	end
end

ActionRangedBase._start_shooting = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.owner_unit
	local var_6_1 = arg_6_0.current_action
	local var_6_2 = arg_6_0.first_person_extension
	local var_6_3
	local var_6_4

	if arg_6_0.get_projectile_start_position_rotation then
		var_6_3, var_6_4 = arg_6_0:get_projectile_start_position_rotation()
	else
		var_6_3, var_6_4 = var_6_2:get_projectile_start_position_rotation()
	end

	local var_6_5 = arg_6_0.eyetracking_extension

	if var_6_1.fire_at_gaze_setting and var_6_5 and var_6_5:get_is_feature_enabled("tobii_fire_at_gaze") then
		var_6_4 = arg_6_0._start_gaze_rotation:unbox()
	end

	if not arg_6_0._crit_applied or not arg_6_0._roll_crit_once then
		local var_6_6 = ActionUtils.is_critical_strike(var_6_0, var_6_1, arg_6_1)

		arg_6_0:_handle_critical_strike(var_6_6, arg_6_0.buff_extension, arg_6_0.hud_extension, nil, "on_critical_shot", nil)

		arg_6_0._is_critical_strike = var_6_6
		arg_6_0._crit_applied = true
	end

	table.clear(arg_6_0.shield_users_blocking)
	arg_6_0._fire_position:store(var_6_3)
	arg_6_0._fire_rotation:store(var_6_4)

	if not arg_6_0.is_bot then
		local var_6_7 = var_6_1.controller_effects and var_6_1.controller_effects.fire

		if var_6_7 then
			Managers.state.controller_features:add_effect(var_6_7.effect_type, var_6_7.params)
		end
	end

	if not arg_6_0._shot_cost_applied or not arg_6_0._apply_shot_cost_once then
		arg_6_0:apply_shot_cost(arg_6_1)

		arg_6_0._shot_cost_applied = true
	end

	arg_6_0._num_projectiles_spawned = 0

	if var_6_1.alert_sound_range_fire then
		Managers.state.entity:system("ai_system"):alert_enemies_within_range(var_6_0, POSITION_LOOKUP[var_6_0], var_6_1.alert_sound_range_fire)
	end

	local var_6_8 = arg_6_0.current_action.fire_sound_event

	if var_6_8 then
		var_6_2:play_hud_sound_event(var_6_8)
	end

	if not arg_6_0.is_bot then
		Unit.flow_event(arg_6_0.weapon_unit, "lua_start_shooting")
	end

	arg_6_0._state = "shooting"
end

ActionRangedBase._shooting = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._num_projectiles_per_shot
	local var_7_1 = arg_7_0._num_projectiles_spawned
	local var_7_2 = var_7_0 - var_7_1

	if not arg_7_2 then
		var_7_2 = math.min(var_7_2, var_0_1)
	end

	arg_7_0:_update_extra_shots(arg_7_0.buff_extension)

	arg_7_0._num_projectiles_spawned = arg_7_0:shoot(var_7_2, var_7_1, var_7_0)

	if var_7_0 - arg_7_0._num_projectiles_spawned <= 0 then
		arg_7_0._num_shots_fired = arg_7_0._num_shots_fired + 1

		if arg_7_0._num_shots_fired < arg_7_0._num_shots_total then
			arg_7_0._state = "waiting_to_shoot"
			arg_7_0._time_to_shoot = arg_7_1 + arg_7_0._burst_shot_delay
		elseif arg_7_0:_update_extra_shots(arg_7_0.buff_extension, 1) then
			arg_7_0._state = "waiting_to_shoot"
			arg_7_0._time_to_shoot = arg_7_1 + arg_7_0._extra_shot_delay
			arg_7_0._extra_buff_shot = true
		else
			arg_7_0._state = "finished_shooting"
		end
	end
end

ActionRangedBase._finished_shooting = function (arg_8_0, arg_8_1)
	if arg_8_0._active_reload_time then
		local var_8_0 = not arg_8_0._extra_buff_shot

		if arg_8_0.spread_extension and var_8_0 and not arg_8_0._spread_done then
			arg_8_0.spread_extension:set_shooting()

			arg_8_0._spread_done = true
		end

		local var_8_1 = arg_8_0.input_extension

		if arg_8_1 > arg_8_0._active_reload_time then
			local var_8_2 = arg_8_0.ammo_extension

			if (var_8_1:get("weapon_reload") or var_8_1:get_buffer("weapon_reload")) and var_8_2:can_reload() then
				arg_8_0.status_extension:set_zooming(false)
				ScriptUnit.extension(arg_8_0.weapon_unit, "weapon_system"):stop_action("reload")
			end
		elseif var_8_1:get("weapon_reload") then
			var_8_1:add_buffer("weapon_reload", 0)
		end
	end

	Unit.flow_event(arg_8_0.weapon_unit, "lua_finish_shooting")
end

ActionRangedBase.shoot = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_0.spread_extension
	local var_9_1 = arg_9_0.current_action
	local var_9_2 = arg_9_0._fire_position:unbox()
	local var_9_3 = arg_9_0._fire_rotation:unbox()
	local var_9_4 = var_9_1.num_layers_spread or 1
	local var_9_5 = var_9_1.bullseye or false
	local var_9_6 = var_9_1.spread_pitch or 0.8

	for iter_9_0 = 1, arg_9_1 do
		arg_9_2 = arg_9_2 + 1

		local var_9_7 = var_9_3

		if var_9_0 then
			var_9_7 = var_9_0:get_target_style_spread(arg_9_2, arg_9_3, var_9_3, var_9_4, var_9_5, var_9_6)
		end

		arg_9_0:spawn_projectile(var_9_2, var_9_7)
	end

	return arg_9_2
end

ActionRangedBase.reload = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.ammo_extension

	if not var_10_0 then
		return
	end

	local var_10_1 = arg_10_0.current_action

	if var_10_1.reload_when_out_of_ammo and var_10_0:ammo_count() == 0 and var_10_0:can_reload() then
		local var_10_2 = arg_10_0.owner_unit
		local var_10_3 = var_10_1.reload_when_out_of_ammo_condition_func

		if not var_10_3 or var_10_3(var_10_2, arg_10_1) then
			var_10_0:start_reload(var_10_1.play_reload_animation)
		end
	end
end

ActionRangedBase.spawn_projectile = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0.current_action

	if var_11_0.projectile_info then
		arg_11_0:fire_projectile(arg_11_1, arg_11_2)
	elseif var_11_0.lightweight_projectile_info then
		arg_11_0:fire_lightweight_projectile(arg_11_1, arg_11_2)
	else
		local var_11_1 = Quaternion.forward(arg_11_2)
		local var_11_2 = arg_11_0:fire_hitscan(arg_11_1, var_11_1, var_11_0.range or 30)

		if var_11_2 then
			local var_11_3 = arg_11_0.world
			local var_11_4 = arg_11_0.item_name
			local var_11_5 = arg_11_0.owner_unit
			local var_11_6 = arg_11_0.is_server
			local var_11_7 = arg_11_0._check_buffs
			local var_11_8 = arg_11_0._continuous_buff_check
			local var_11_9 = DamageUtils.process_projectile_hit(var_11_3, var_11_4, var_11_5, var_11_6, var_11_2, var_11_0, var_11_1, var_11_7, nil, arg_11_0.shield_users_blocking, arg_11_0._is_critical_strike, arg_11_0._power_level)

			if var_11_9.buffs_checked and var_11_7 and not var_11_8 then
				arg_11_0._check_buffs = false
			end

			if var_11_9.blocked_by_unit then
				arg_11_0.shield_users_blocking[var_11_9.blocked_by_unit] = true
			end
		end
	end
end

ActionRangedBase.fire_projectile = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0.owner_unit
	local var_12_1 = arg_12_0.current_action
	local var_12_2 = ActionUtils.pitch_from_rotation(arg_12_2)
	local var_12_3 = var_12_1.speed
	local var_12_4 = Vector3.normalize(Vector3.flat(Quaternion.forward(arg_12_2)))
	local var_12_5 = var_12_1.lookup_data

	ActionUtils.spawn_player_projectile(var_12_0, arg_12_1, arg_12_2, 0, var_12_2, var_12_4, var_12_3, arg_12_0.item_name, var_12_5.item_template_name, var_12_5.action_name, var_12_5.sub_action_name, arg_12_0._is_critical_strike, arg_12_0._power_level)
end

ActionRangedBase.fire_lightweight_projectile = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0.owner_unit
	local var_13_1 = arg_13_0.current_action.lightweight_projectile_info
	local var_13_2 = Network.peer_id()
	local var_13_3 = var_13_1.template_name
	local var_13_4 = LightWeightProjectiles[var_13_3]
	local var_13_5 = var_13_1.collision_filter
	local var_13_6 = Quaternion.forward(arg_13_2)
	local var_13_7 = Vector3.normalize(var_13_6)
	local var_13_8 = math.random() * var_13_4.spread
	local var_13_9 = Quaternion.look(var_13_7, Vector3.up())
	local var_13_10 = Quaternion(Vector3.right(), var_13_8)
	local var_13_11 = Quaternion(Vector3.forward(), math.random() * math.tau)
	local var_13_12 = Quaternion.multiply(Quaternion.multiply(var_13_9, var_13_11), var_13_10)
	local var_13_13 = Quaternion.forward(var_13_12)
	local var_13_14 = {
		power_level = arg_13_0._power_level,
		damage_profile = var_13_4.damage_profile,
		hit_effect = var_13_4.hit_effect,
		player_push_velocity = Vector3Box(var_13_7 * var_13_4.impact_push_speed),
		projectile_linker = var_13_4.projectile_linker,
		first_person_hit_flow_events = var_13_4.first_person_hit_flow_events
	}

	Managers.state.entity:system("projectile_system"):create_light_weight_projectile(arg_13_0.item_name, var_13_0, arg_13_1, var_13_13, var_13_4.projectile_speed, nil, nil, var_13_4.projectile_max_range, var_13_5, var_13_14, var_13_4.light_weight_projectile_effect, var_13_2)
end

ActionRangedBase.fire_hitscan = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0

	if arg_14_0.current_action.ray_against_large_hitbox then
		var_14_0 = PhysicsWorld.immediate_raycast_actors(arg_14_0.physics_world, arg_14_1, arg_14_2, arg_14_3, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only", "dynamic_collision_filter", "filter_enemy_trigger")
	else
		var_14_0 = PhysicsWorld.immediate_raycast_actors(arg_14_0.physics_world, arg_14_1, arg_14_2, arg_14_3, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")
	end

	return var_14_0
end

ActionRangedBase.proc_extra_shot = function (arg_15_0, arg_15_1)
	if not arg_15_0._extra_buff_shot then
		local var_15_0, var_15_1 = arg_15_0.buff_extension:apply_buffs_to_value(0, "extra_shot")

		if var_15_1 then
			return true
		end
	end

	return false
end

ActionRangedBase.gen_num_shots = function (arg_16_0)
	local var_16_0 = arg_16_0.current_action
	local var_16_1 = arg_16_0.ammo_extension
	local var_16_2 = var_16_0.ammo_usage or 1
	local var_16_3 = var_16_0.num_shots or 1
	local var_16_4 = var_16_1 and math.floor(var_16_1:current_ammo() / var_16_2) or var_16_3
	local var_16_5 = var_16_0.num_projectiles_per_shot or 1

	if var_16_1 and var_16_0.fire_all_ammo then
		var_16_5 = var_16_5 * var_16_4
		var_16_3 = 1
	else
		var_16_3 = math.min(var_16_3, var_16_4)
	end

	return var_16_3, var_16_5
end

ActionRangedBase.apply_shot_cost = function (arg_17_0, arg_17_1)
	arg_17_0:_use_ammo()
	arg_17_0:_add_overcharge()
end

ActionRangedBase._use_ammo = function (arg_18_0)
	local var_18_0 = arg_18_0.ammo_extension

	if var_18_0 and not arg_18_0._extra_buff_shot then
		var_18_0:use_ammo(arg_18_0.current_action.ammo_usage)
	end
end

ActionRangedBase._add_overcharge = function (arg_19_0)
	local var_19_0 = arg_19_0.current_action.overcharge_type

	if var_19_0 then
		local var_19_1 = PlayerUnitStatusSettings.overcharge_values[var_19_0]

		if arg_19_0._is_critical_strike and arg_19_0.buff_extension and arg_19_0.buff_extension:has_buff_perk("no_overcharge_crit") then
			var_19_1 = 0
		end

		arg_19_0.overcharge_extension:add_charge(var_19_1)
	end
end
