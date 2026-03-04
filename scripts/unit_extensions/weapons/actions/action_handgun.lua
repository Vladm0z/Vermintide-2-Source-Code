-- chunkname: @scripts/unit_extensions/weapons/actions/action_handgun.lua

ActionHandgun = class(ActionHandgun, ActionBase)

ActionHandgun.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionHandgun.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.trail_end_position_variable = World.find_particles_variable(arg_1_1, "fx/wpnfx_pistol_bullet_trail", "size")
	arg_1_0.career_extension = ScriptUnit.extension(arg_1_0.owner_unit, "career_system")
end

ActionHandgun.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	ActionHandgun.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	local var_2_0 = arg_2_0.weapon_unit
	local var_2_1 = arg_2_0.owner_unit
	local var_2_2 = ActionUtils.is_critical_strike(var_2_1, arg_2_1, arg_2_2)
	local var_2_3 = ScriptUnit.extension(var_2_1, "buff_system")

	arg_2_0.current_action = arg_2_1
	arg_2_0.power_level = arg_2_4

	if arg_2_1.use_beam_consecutive_hits and arg_2_3 and arg_2_3.beam_consecutive_hits then
		arg_2_0.charge_multiplier = 0.3 + 0.7 * math.clamp(arg_2_3.beam_consecutive_hits / 3, 0, 1)
		arg_2_0.power_level = arg_2_0.power_level * arg_2_0.charge_multiplier
	end

	arg_2_0.owner_buff_extension = var_2_3

	if not Managers.player:owner(arg_2_0.owner_unit).bot_player then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "light_swing"
		})
	end

	if ScriptUnit.has_extension(var_2_0, "ammo_system") then
		arg_2_0.ammo_extension = ScriptUnit.extension(var_2_0, "ammo_system")
	end

	if ScriptUnit.has_extension(var_2_0, "spread_system") then
		arg_2_0.spread_extension = ScriptUnit.extension(var_2_0, "spread_system")
	end

	local var_2_4 = arg_2_1.spread_template_override

	if var_2_4 then
		arg_2_0.spread_extension:override_spread_template(var_2_4)
	end

	arg_2_0.overcharge_extension = ScriptUnit.extension(var_2_1, "overcharge_system")
	arg_2_0.state = "waiting_to_shoot"
	arg_2_0.time_to_shoot = arg_2_2 + arg_2_1.fire_time
	arg_2_0.extra_buff_shot = false
	arg_2_0.ammo_usage = arg_2_1.ammo_usage
	arg_2_0.overcharge_type = arg_2_1.overcharge_type
	arg_2_0.uses_ability_cooldown = arg_2_1.use_ability_cooldown
	arg_2_0.used_ammo = false
	arg_2_0.active_reload_time = arg_2_1.active_reload_time and arg_2_2 + arg_2_1.active_reload_time

	local var_2_5 = ScriptUnit.has_extension(var_2_1, "hud_system")

	arg_2_0:_handle_critical_strike(var_2_2, var_2_3, var_2_5, nil, "on_critical_shot", nil)

	arg_2_0._is_critical_strike = var_2_2
end

ActionHandgun.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_0.weapon_unit
	local var_3_1 = arg_3_0.owner_unit
	local var_3_2 = arg_3_0.current_action

	if arg_3_0.state == "waiting_to_shoot" and arg_3_2 >= arg_3_0.time_to_shoot then
		arg_3_0.state = "shooting"

		if arg_3_0.ammo_extension and not arg_3_0.extra_buff_shot and arg_3_0.ammo_usage then
			local var_3_3 = arg_3_0.ammo_usage

			arg_3_0.ammo_extension:use_ammo(var_3_3)
		end

		local var_3_4 = arg_3_0.overcharge_type

		if var_3_4 then
			local var_3_5 = PlayerUnitStatusSettings.overcharge_values[var_3_4] * (arg_3_0.charge_multiplier or 1)
			local var_3_6 = ScriptUnit.extension(var_3_1, "buff_system")

			if arg_3_0._is_critical_strike and var_3_6:has_buff_perk("no_overcharge_crit") then
				var_3_5 = 0
			end

			arg_3_0.overcharge_extension:add_charge(var_3_5)
		end

		if arg_3_0.uses_ability_cooldown then
			arg_3_0.career_extension:reduce_activated_ability_cooldown(-arg_3_0.ammo_usage)
		end
	end

	if arg_3_0.state == "shooting" then
		local var_3_7 = not arg_3_0.extra_buff_shot

		if arg_3_0:_update_extra_shots(arg_3_0.owner_buff_extension, 1) then
			arg_3_0.state = "waiting_to_shoot"
			arg_3_0.time_to_shoot = arg_3_2 + 0.1
			arg_3_0.extra_buff_shot = true
		else
			arg_3_0.state = "shot"
		end

		if not Managers.player:owner(arg_3_0.owner_unit).bot_player then
			Managers.state.controller_features:add_effect("rumble", {
				rumble_effect = "handgun_fire"
			})
		end

		local var_3_8 = ScriptUnit.extension(var_3_1, "first_person_system")
		local var_3_9, var_3_10 = var_3_8:get_projectile_start_position_rotation()

		if var_3_2.fire_at_gaze_setting and ScriptUnit.has_extension(var_3_1, "eyetracking_system") then
			local var_3_11 = ScriptUnit.extension(var_3_1, "eyetracking_system")

			if var_3_11:get_is_feature_enabled("tobii_fire_at_gaze") then
				var_3_10 = var_3_11:gaze_rotation()
			end
		end

		local var_3_12 = arg_3_0.spread_extension

		if var_3_12 then
			var_3_10 = var_3_12:get_randomised_spread(var_3_10)

			if var_3_7 then
				var_3_12:set_shooting()
			end
		end

		local var_3_13 = World.get_data(arg_3_3, "physics_world")
		local var_3_14 = var_3_2.aim_assist_auto_hit_chance or 0
		local var_3_15

		if var_3_14 >= math.random() and Managers.input:is_device_active("gamepad") and ScriptUnit.has_extension(var_3_1, "smart_targeting_system") then
			local var_3_16 = ScriptUnit.extension(var_3_1, "smart_targeting_system"):get_targeting_data().target_position

			if var_3_16 then
				var_3_15 = Vector3.normalize(var_3_16 - var_3_9)
			end
		end

		var_3_15 = var_3_15 or Quaternion.forward(var_3_10)

		local var_3_17

		if var_3_2.projectile_info then
			local var_3_18 = ActionUtils.pitch_from_rotation(var_3_10)
			local var_3_19 = var_3_2.speed
			local var_3_20 = Vector3.normalize(Vector3.flat(Quaternion.forward(var_3_10)))
			local var_3_21 = var_3_2.lookup_data

			ActionUtils.spawn_player_projectile(var_3_1, var_3_9, var_3_10, 0, var_3_18, var_3_20, var_3_19, arg_3_0.item_name, var_3_21.item_template_name, var_3_21.action_name, var_3_21.sub_action_name, arg_3_0._is_critical_strike, arg_3_0.power_level)
		else
			if var_3_2.ray_against_large_hitbox then
				var_3_17 = PhysicsWorld.immediate_raycast_actors(var_3_13, var_3_9, var_3_15, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only", "dynamic_collision_filter", "filter_enemy_trigger")
			else
				var_3_17 = PhysicsWorld.immediate_raycast_actors(var_3_13, var_3_9, var_3_15, "static_collision_filter", "filter_player_ray_projectile_static_only", "dynamic_collision_filter", "filter_player_ray_projectile_ai_only", "dynamic_collision_filter", "filter_player_ray_projectile_hitbox_only")
			end

			local var_3_22 = arg_3_0.is_server

			if var_3_17 then
				DamageUtils.process_projectile_hit(arg_3_3, arg_3_0.item_name, var_3_1, var_3_22, var_3_17, var_3_2, var_3_15, true, nil, nil, arg_3_0._is_critical_strike, arg_3_0.power_level)
			end
		end

		if arg_3_0.current_action.reset_aim_on_attack then
			var_3_8:reset_aim_assist_multiplier()
		end

		local var_3_23 = arg_3_0.current_action.fire_sound_event

		if var_3_23 then
			var_3_8:play_hud_sound_event(var_3_23)
		end

		if var_3_2.alert_sound_range_fire then
			Managers.state.entity:system("ai_system"):alert_enemies_within_range(var_3_1, POSITION_LOOKUP[var_3_1], var_3_2.alert_sound_range_fire)
		end

		local var_3_24 = var_3_17 and var_3_17[#var_3_17][1] or var_3_9 + var_3_15 * 100

		Unit.set_flow_variable(var_3_0, "hit_position", var_3_24)
		Unit.set_flow_variable(var_3_0, "trail_life", Vector3.length(var_3_24 - var_3_9) * 0.1)
		Unit.flow_event(var_3_0, "lua_bullet_trail")
		Unit.flow_event(var_3_0, "lua_bullet_trail_set")
	end

	if arg_3_0.state == "shot" and arg_3_0.active_reload_time then
		local var_3_25 = ScriptUnit.extension(var_3_1, "input_system")

		if arg_3_2 > arg_3_0.active_reload_time then
			local var_3_26 = arg_3_0.ammo_extension

			if (var_3_25:get("weapon_reload") or var_3_25:get_buffer("weapon_reload")) and var_3_26:can_reload() then
				ScriptUnit.extension(var_3_1, "status_system"):set_zooming(false)
				ScriptUnit.extension(var_3_0, "weapon_system"):stop_action("reload")
			end
		elseif var_3_25:get("weapon_reload") then
			var_3_25:add_buffer("weapon_reload", 0)
		end
	end
end

ActionHandgun.finish = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.ammo_extension
	local var_4_1 = arg_4_0.current_action
	local var_4_2 = arg_4_0.owner_unit

	if arg_4_1 ~= "new_interupting_action" then
		ScriptUnit.extension(var_4_2, "status_system"):set_zooming(false)

		local var_4_3 = var_4_1.reload_when_out_of_ammo_condition_func
		local var_4_4 = not var_4_3 and true or var_4_3(var_4_2, arg_4_1)

		if var_4_0 and var_4_1.reload_when_out_of_ammo and var_4_4 and var_4_0:ammo_count() == 0 and var_4_0:can_reload() then
			var_4_0:start_reload(true)
		end
	end

	if var_4_1.keep_block then
		if not LEVEL_EDITOR_TEST then
			local var_4_5 = Managers.state.unit_storage:go_id(var_4_2)

			if arg_4_0.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", var_4_5, false)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", var_4_5, false)
			end
		end

		ScriptUnit.extension(var_4_2, "status_system"):set_blocking(false)
	end

	arg_4_0.charge_multiplier = nil

	local var_4_6 = ScriptUnit.has_extension(var_4_2, "hud_system")

	if var_4_6 then
		var_4_6.show_critical_indication = false
	end

	if arg_4_0.spread_extension then
		arg_4_0.spread_extension:reset_spread_template()
	end
end
