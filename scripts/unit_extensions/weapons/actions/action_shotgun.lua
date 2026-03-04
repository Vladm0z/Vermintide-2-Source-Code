-- chunkname: @scripts/unit_extensions/weapons/actions/action_shotgun.lua

ActionShotgun = class(ActionShotgun, ActionBase)

local var_0_0 = Unit.set_flow_variable
local var_0_1 = Unit.flow_event
local var_0_2 = 3

ActionShotgun.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionShotgun.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		arg_1_0.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	arg_1_0.spread_extension = ScriptUnit.extension(arg_1_7, "spread_system")
	arg_1_0.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	arg_1_0.start_gaze_rotation = QuaternionBox()
	arg_1_0._fire_position = Vector3Box()
	arg_1_0._fire_rotation = QuaternionBox()
end

ActionShotgun.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	ActionShotgun.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	arg_2_0.current_action = arg_2_1
	arg_2_0.state = "waiting_to_shoot"
	arg_2_0.time_to_shoot = arg_2_2 + arg_2_1.fire_time
	arg_2_0.active_reload_time = arg_2_1.active_reload_time and arg_2_2 + arg_2_1.active_reload_time

	local var_2_0 = arg_2_0.owner_unit
	local var_2_1 = ActionUtils.is_critical_strike(var_2_0, arg_2_1, arg_2_2)
	local var_2_2 = ScriptUnit.extension(var_2_0, "buff_system")

	arg_2_0.infinite_ammo = var_2_2:has_buff_perk("infinite_ammo")
	arg_2_0.power_level = arg_2_4
	arg_2_0.owner_buff_extension = var_2_2

	local var_2_3 = ScriptUnit.has_extension(var_2_0, "hud_system")

	arg_2_0:_handle_critical_strike(var_2_1, var_2_2, var_2_3, nil, "on_critical_shot", nil)

	arg_2_0._is_critical_strike = var_2_1

	local var_2_4 = arg_2_1.spread_template_override

	if var_2_4 then
		arg_2_0.spread_extension:override_spread_template(var_2_4)
	end

	arg_2_0._shots_fired = 0
	arg_2_0._check_buffs = true
	arg_2_0._spread_done = false
	arg_2_0.extra_buff_shot = false
	arg_2_0.shield_users_blocking = {}

	if rawget(_G, "Tobii") and Application.user_setting("tobii_eyetracking") and arg_2_1.fire_at_gaze_setting and Application.user_setting("tobii_fire_at_gaze") then
		local var_2_5 = ScriptUnit.has_extension(var_2_0, "eyetracking_system")

		if var_2_5 then
			arg_2_0.start_gaze_rotation:store(var_2_5:gaze_rotation())
		end
	end
end

ActionShotgun._use_ammo = function (arg_3_0)
	local var_3_0 = arg_3_0.current_action
	local var_3_1 = arg_3_0.ammo_extension
	local var_3_2 = var_3_0.ammo_usage
	local var_3_3 = var_3_0.shot_count or 1

	if var_3_0.special_ammo_thing then
		var_3_2 = var_3_1:current_ammo()
		var_3_3 = var_3_2
	end

	if var_3_1 then
		var_3_1:use_ammo(var_3_2)
	end

	arg_3_0._num_shots_total = var_3_3
end

ActionShotgun._add_overcharge = function (arg_4_0)
	local var_4_0 = arg_4_0.current_action.overcharge_type

	if var_4_0 then
		local var_4_1 = PlayerUnitStatusSettings.overcharge_values[var_4_0]
		local var_4_2 = arg_4_0.owner_unit
		local var_4_3 = ScriptUnit.extension(var_4_2, "buff_system")

		if arg_4_0._is_critical_strike and var_4_3:has_buff_perk("no_overcharge_crit") then
			var_4_1 = 0
		end

		arg_4_0.overcharge_extension:add_charge(var_4_1)
	end
end

ActionShotgun._start_shooting = function (arg_5_0)
	local var_5_0 = arg_5_0.owner_unit
	local var_5_1 = arg_5_0.current_action
	local var_5_2 = ScriptUnit.extension(var_5_0, "first_person_system")
	local var_5_3, var_5_4 = var_5_2:get_projectile_start_position_rotation()

	if var_5_1.fire_at_gaze_setting and ScriptUnit.has_extension(var_5_0, "eyetracking_system") and ScriptUnit.extension(var_5_0, "eyetracking_system"):get_is_feature_enabled("tobii_fire_at_gaze") then
		var_5_4 = arg_5_0.start_gaze_rotation:unbox()
	end

	arg_5_0._fire_position:store(var_5_3)
	arg_5_0._fire_rotation:store(var_5_4)

	if not Managers.player:owner(arg_5_0.owner_unit).bot_player then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "handgun_fire"
		})
	end

	if not arg_5_0.extra_buff_shot then
		arg_5_0:_use_ammo()
		arg_5_0:_add_overcharge()
	end

	if var_5_1.alert_sound_range_fire then
		Managers.state.entity:system("ai_system"):alert_enemies_within_range(var_5_0, POSITION_LOOKUP[var_5_0], var_5_1.alert_sound_range_fire)
	end

	local var_5_5 = arg_5_0.current_action.fire_sound_event

	if var_5_5 then
		var_5_2:play_hud_sound_event(var_5_5)
	end

	arg_5_0.state = "shooting"
end

ActionShotgun._shooting = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._num_shots_total
	local var_6_1 = var_6_0 - arg_6_0._shots_fired

	if not arg_6_2 then
		var_6_1 = math.min(var_6_1, var_0_2)
	end

	local var_6_2 = arg_6_0:_update_extra_shots(arg_6_0.owner_buff_extension)

	arg_6_0:_shoot(var_6_0, var_6_1)

	if arg_6_0._num_shots_total - arg_6_0._shots_fired <= 0 then
		if var_6_2 then
			arg_6_0._num_shots_total = var_6_0 + var_6_2

			arg_6_0:_update_extra_shots(arg_6_0.owner_buff_extension, var_6_2)

			arg_6_0.state = "waiting_to_shoot"
			arg_6_0.time_to_shoot = arg_6_1 + 0.15
			arg_6_0.extra_buff_shot = true
		else
			arg_6_0.state = "shot"
		end
	end
end

ActionShotgun._shoot = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0.current_action
	local var_7_1 = arg_7_0._fire_position:unbox()
	local var_7_2 = arg_7_0._fire_rotation:unbox()
	local var_7_3 = arg_7_0.world
	local var_7_4 = arg_7_0.physics_world
	local var_7_5 = arg_7_0._check_buffs
	local var_7_6 = var_7_0.num_layers_spread or 1
	local var_7_7 = var_7_0.bullseye or false
	local var_7_8 = var_7_0.spread_pitch or 0.8
	local var_7_9 = arg_7_0.weapon_unit
	local var_7_10 = arg_7_0.item_name
	local var_7_11 = arg_7_0.owner_unit
	local var_7_12 = arg_7_0.is_server

	for iter_7_0 = 1, arg_7_2 do
		arg_7_0._shots_fired = arg_7_0._shots_fired + 1

		local var_7_13 = arg_7_0:_get_spread_rotation(arg_7_1, var_7_2, var_7_6, var_7_7, var_7_8)
		local var_7_14 = Quaternion.forward(var_7_13)
		local var_7_15 = PhysicsWorld.immediate_raycast_actors(var_7_4, var_7_1, var_7_14, var_7_0.range, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")

		if var_7_15 then
			local var_7_16 = DamageUtils.process_projectile_hit(var_7_3, var_7_10, var_7_11, var_7_12, var_7_15, var_7_0, var_7_14, var_7_5, nil, arg_7_0.shield_users_blocking, arg_7_0._is_critical_strike, arg_7_0.power_level)

			if var_7_16.buffs_checked then
				var_7_5 = var_7_5 and false
			end

			if var_7_16.blocked_by_unit then
				arg_7_0.shield_users_blocking[var_7_16.blocked_by_unit] = true
			end
		end

		local var_7_17 = var_7_15 and var_7_15[#var_7_15][1] or var_7_1 + var_7_14 * var_7_0.range

		var_0_0(var_7_9, "hit_position", var_7_17)
		var_0_0(var_7_9, "trail_life", Vector3.length(var_7_17 - var_7_1) * 0.1)
		var_0_1(var_7_9, "lua_bullet_trail")
		var_0_1(var_7_9, "lua_bullet_trail_set")
	end

	arg_7_0._check_buffs = var_7_5
end

ActionShotgun.client_owner_post_update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = arg_8_0.owner_unit

	if arg_8_0.state == "waiting_to_shoot" and arg_8_2 >= arg_8_0.time_to_shoot then
		arg_8_0.state = "start_shooting"
	end

	if arg_8_0.state == "start_shooting" then
		arg_8_0:_start_shooting()
	end

	if arg_8_0.state == "shooting" then
		arg_8_0:_shooting(arg_8_2, false)
	end

	if arg_8_0.state == "shot" and arg_8_0.active_reload_time then
		local var_8_1 = not arg_8_0.extra_buff_shot

		if arg_8_0.spread_extension and var_8_1 and not arg_8_0._spread_done then
			arg_8_0.spread_extension:set_shooting()

			arg_8_0._spread_done = true
		end

		local var_8_2 = ScriptUnit.extension(var_8_0, "input_system")

		if arg_8_2 > arg_8_0.active_reload_time then
			local var_8_3 = arg_8_0.ammo_extension

			if (var_8_2:get("weapon_reload") or var_8_2:get_buffer("weapon_reload")) and var_8_3:can_reload() then
				ScriptUnit.extension(arg_8_0.weapon_unit, "weapon_system"):stop_action("reload")
			end
		elseif var_8_2:get("weapon_reload") then
			var_8_2:add_buffer("weapon_reload", 0)
		end
	end
end

ActionShotgun.reload = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.ammo_extension

	if not var_9_0 then
		return
	end

	local var_9_1 = arg_9_1.reload_when_out_of_ammo_condition_func
	local var_9_2 = not var_9_1 and true or var_9_1(arg_9_0.owner_unit)

	if var_9_0:can_reload() and arg_9_1.reload_when_out_of_ammo and var_9_2 and var_9_0:ammo_count() == 0 then
		local var_9_3 = arg_9_1.play_reload_animation

		var_9_0:start_reload(var_9_3, arg_9_1.override_reload_time)
	end
end

ActionShotgun.finish = function (arg_10_0, arg_10_1)
	if arg_10_0.state == "start_shooting" then
		arg_10_0:_start_shooting()
	end

	if arg_10_0.state == "shooting" then
		local var_10_0 = Managers.time:time("game")

		arg_10_0:_shooting(var_10_0, true)
	end

	if arg_10_0.state == "shot" and arg_10_1 == "charged" then
		arg_10_0:reload(arg_10_0.current_action)
	end

	if arg_10_0.spread_extension then
		arg_10_0.spread_extension:reset_spread_template()
	end

	local var_10_1 = ScriptUnit.has_extension(arg_10_0.owner_unit, "hud_system")

	if var_10_1 then
		var_10_1.show_critical_indication = false
	end
end

ActionShotgun._get_spread_rotation = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	local var_11_0 = arg_11_0.spread_extension

	if var_11_0 then
		return var_11_0:get_target_style_spread(arg_11_0._shots_fired, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	else
		return arg_11_2
	end
end
