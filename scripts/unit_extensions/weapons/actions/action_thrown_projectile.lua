-- chunkname: @scripts/unit_extensions/weapons/actions/action_thrown_projectile.lua

ActionThrownProjectile = class(ActionThrownProjectile, ActionBase)

ActionThrownProjectile.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionThrownProjectile.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		arg_1_0._ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	arg_1_0._spread_extension = ScriptUnit.extension(arg_1_7, "spread_system")
end

ActionThrownProjectile.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	ActionThrownProjectile.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	local var_2_0 = arg_2_0.owner_unit
	local var_2_1 = ActionUtils.is_critical_strike(var_2_0, arg_2_1, arg_2_2)

	arg_2_0._status_extension = ScriptUnit.extension(var_2_0, "status_system")
	arg_2_0._first_person_extension = ScriptUnit.extension(var_2_0, "first_person_system")

	local var_2_2 = ScriptUnit.has_extension(var_2_0, "hud_system")
	local var_2_3 = ScriptUnit.extension(var_2_0, "buff_system")

	arg_2_0._hud_extension = var_2_2
	arg_2_0._owner_buff_extension = var_2_3
	arg_2_0._current_action = arg_2_1
	arg_2_0._power_level = arg_2_4

	ScriptUnit.extension(var_2_0, "input_system"):reset_input_buffer()

	arg_2_0.state = "waiting_to_shoot"

	local var_2_4 = ActionUtils.get_action_time_scale(var_2_0, arg_2_1)

	arg_2_0._time_to_shoot = arg_2_2 + (arg_2_1.fire_time or 0) * (1 / var_2_4)
	arg_2_0._time_to_unzoom = arg_2_1.unzoom_time and arg_2_2 + arg_2_1.unzoom_time or nil
	arg_2_0._extra_buff_shot = false

	arg_2_0:_handle_critical_strike(var_2_1, var_2_3, var_2_2, nil, "on_critical_shot", nil)

	arg_2_0._is_critical_strike = var_2_1
end

ActionThrownProjectile._use_ammo = function (arg_3_0)
	local var_3_0 = arg_3_0._ammo_extension

	if var_3_0 and not arg_3_0._extra_buff_shot then
		local var_3_1 = arg_3_0._current_action.ammo_usage

		var_3_0:use_ammo(var_3_1)
	end
end

ActionThrownProjectile._reload = function (arg_4_0)
	local var_4_0 = arg_4_0._ammo_extension

	if var_4_0:can_reload() then
		local var_4_1 = arg_4_0._current_action
		local var_4_2 = var_4_1.play_reload_animation
		local var_4_3 = var_4_1.override_reload_time

		var_4_0:start_reload(var_4_2, var_4_3)
	end
end

ActionThrownProjectile.client_owner_post_update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_0._current_action

	if arg_5_0._time_to_unzoom and arg_5_2 >= arg_5_0._time_to_unzoom then
		arg_5_0._status_extension:set_zooming(false)
	end

	if arg_5_0.state == "waiting_to_shoot" and arg_5_2 >= arg_5_0._time_to_shoot then
		arg_5_0.state = "shooting"
	end

	if arg_5_0.state == "shooting" then
		local var_5_1 = arg_5_0:_update_extra_shots(arg_5_0._owner_buff_extension, 1)
		local var_5_2 = not arg_5_0._extra_buff_shot

		if not Managers.player:owner(arg_5_0.owner_unit).bot_player then
			Managers.state.controller_features:add_effect("rumble", {
				rumble_effect = "bow_fire"
			})
		end

		arg_5_0:_fire(var_5_2)

		if arg_5_0._ammo_extension and not arg_5_0._extra_buff_shot then
			arg_5_0:_use_ammo()

			if var_5_0.reload_event_delay_time then
				arg_5_0.time_to_reload = arg_5_2 + var_5_0.reload_event_delay_time
			else
				arg_5_0:_reload()
			end
		end

		if var_5_1 then
			arg_5_0.state = "waiting_to_shoot"
			arg_5_0._time_to_shoot = arg_5_2 + 0.1
			arg_5_0._extra_buff_shot = true
		else
			arg_5_0.state = "shot"
		end

		local var_5_3 = arg_5_0._first_person_extension

		if arg_5_0._current_action.reset_aim_on_attack then
			var_5_3:reset_aim_assist_multiplier()
		end

		local var_5_4 = arg_5_0._current_action.fire_sound_event

		if var_5_4 then
			var_5_3:play_hud_sound_event(var_5_4)
		end
	end

	if arg_5_0.time_to_reload and arg_5_2 > arg_5_0.time_to_reload then
		arg_5_0:_reload()

		arg_5_0.time_to_reload = nil
	end
end

ActionThrownProjectile.finish = function (arg_6_0, arg_6_1, arg_6_2)
	if arg_6_0.state == "waiting_to_shoot" then
		arg_6_0:_fire()
		arg_6_0:_use_ammo()
		arg_6_0:_reload()

		arg_6_0.state = "shot"
	end

	if not arg_6_2 or arg_6_2.new_action ~= "action_two" or arg_6_2.new_sub_action ~= "default" then
		arg_6_0._status_extension:set_zooming(false)
	end

	local var_6_0 = arg_6_0._hud_extension

	if var_6_0 then
		var_6_0.show_critical_indication = false
	end
end

ActionThrownProjectile._fire = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._current_action
	local var_7_1 = arg_7_0.owner_unit
	local var_7_2 = arg_7_0._first_person_extension
	local var_7_3 = var_7_0.speed
	local var_7_4, var_7_5 = var_7_2:get_projectile_start_position_rotation()
	local var_7_6 = arg_7_0._spread_extension

	if var_7_6 then
		var_7_5 = var_7_6:get_randomised_spread(var_7_5)

		if arg_7_1 then
			var_7_6:set_shooting()
		end
	end

	local var_7_7 = ActionUtils.pitch_from_rotation(var_7_5)
	local var_7_8 = Vector3.normalize(Vector3.flat(Quaternion.forward(var_7_5)))
	local var_7_9 = var_7_0.lookup_data

	ActionUtils.spawn_player_projectile(var_7_1, var_7_4, var_7_5, 0, var_7_7, var_7_8, var_7_3, arg_7_0.item_name, var_7_9.item_template_name, var_7_9.action_name, var_7_9.sub_action_name, arg_7_0._is_critical_strike, arg_7_0._power_level)

	if var_7_0.alert_sound_range_fire then
		Managers.state.entity:system("ai_system"):alert_enemies_within_range(var_7_1, POSITION_LOOKUP[var_7_1], var_7_0.alert_sound_range_fire)
	end
end
