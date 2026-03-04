-- chunkname: @scripts/unit_extensions/weapons/actions/action_bow.lua

ActionBow = class(ActionBow, ActionBase)

function ActionBow.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionBow.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		arg_1_0.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	arg_1_0.spread_extension = ScriptUnit.extension(arg_1_7, "spread_system")
end

function ActionBow.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	ActionBow.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	local var_2_0 = arg_2_0.owner_unit
	local var_2_1 = ActionUtils.is_critical_strike(var_2_0, arg_2_1, arg_2_2)
	local var_2_2 = ScriptUnit.extension(var_2_0, "buff_system")

	arg_2_0.owner_buff_extension = var_2_2
	arg_2_0.current_action = arg_2_1
	arg_2_0.power_level = arg_2_4

	ScriptUnit.extension(var_2_0, "input_system"):reset_input_buffer()

	arg_2_0.state = "waiting_to_shoot"
	arg_2_0.time_to_shoot = arg_2_2 + (arg_2_1.fire_time or 0)
	arg_2_0.time_to_unzoom = arg_2_1.unzoom_time and arg_2_2 + arg_2_1.unzoom_time or nil
	arg_2_0.extra_buff_shot = false

	local var_2_3 = ScriptUnit.has_extension(var_2_0, "hud_system")

	arg_2_0:_handle_critical_strike(var_2_1, var_2_2, var_2_3, nil, "on_critical_shot", nil)

	arg_2_0._is_critical_strike = var_2_1
end

function ActionBow.reload(arg_3_0, arg_3_1)
	if arg_3_0.ammo_extension:can_reload() then
		local var_3_0 = arg_3_1.play_reload_animation

		arg_3_0.ammo_extension:start_reload(var_3_0, arg_3_1.override_reload_time)

		arg_3_0.time_to_reload = nil
	end
end

function ActionBow.client_owner_post_update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_0.current_action

	if arg_4_0.time_to_unzoom and arg_4_2 >= arg_4_0.time_to_unzoom then
		local var_4_1 = arg_4_0.owner_unit

		ScriptUnit.extension(var_4_1, "status_system"):set_zooming(false)
	end

	if arg_4_0.state == "waiting_to_shoot" and arg_4_2 >= arg_4_0.time_to_shoot then
		arg_4_0.state = "shooting"
	end

	if arg_4_0.state == "shooting" then
		local var_4_2 = not arg_4_0.extra_buff_shot

		if not Managers.player:owner(arg_4_0.owner_unit).bot_player then
			Managers.state.controller_features:add_effect("rumble", {
				rumble_effect = "bow_fire"
			})
		end

		local var_4_3 = not var_4_0.career_skill and arg_4_0:_update_extra_shots(arg_4_0.owner_buff_extension, 1)

		arg_4_0:fire(var_4_0, var_4_2)

		if arg_4_0.ammo_extension and not arg_4_0.extra_buff_shot then
			local var_4_4 = arg_4_0.current_action.ammo_usage

			arg_4_0.ammo_extension:use_ammo(var_4_4)

			if var_4_0.reload_event_delay_time then
				arg_4_0.time_to_reload = arg_4_2 + var_4_0.reload_event_delay_time
			else
				arg_4_0:reload(var_4_0)
			end
		end

		if var_4_3 then
			arg_4_0.state = "waiting_to_shoot"
			arg_4_0.time_to_shoot = arg_4_2 + 0.1
			arg_4_0.extra_buff_shot = true
		else
			arg_4_0.state = "shot"
		end

		local var_4_5 = ScriptUnit.extension(arg_4_0.owner_unit, "first_person_system")

		if arg_4_0.current_action.reset_aim_on_attack then
			var_4_5:reset_aim_assist_multiplier()
		end

		local var_4_6 = arg_4_0.current_action.fire_sound_event

		if var_4_6 then
			var_4_5:play_hud_sound_event(var_4_6)
		end
	end

	if arg_4_0.time_to_reload and arg_4_2 > arg_4_0.time_to_reload then
		arg_4_0:reload(var_4_0)

		arg_4_0.time_to_reload = nil
	end
end

function ActionBow.finish(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.current_action
	local var_5_1 = arg_5_0.owner_unit

	if arg_5_0.state == "waiting_to_shoot" then
		arg_5_0:fire(var_5_0)

		arg_5_0.state = "shot"

		if arg_5_0.ammo_extension and not arg_5_0.extra_buff_shot then
			local var_5_2 = var_5_0.ammo_usage

			arg_5_0.ammo_extension:use_ammo(var_5_2)
		end

		arg_5_0:reload(var_5_0)
	end

	if arg_5_0.time_to_reload then
		arg_5_0:reload(var_5_0)
	end

	if not arg_5_2 or arg_5_2.new_action ~= "action_two" or arg_5_2.new_sub_action ~= "default" then
		ScriptUnit.extension(var_5_1, "status_system"):set_zooming(false)
	end

	local var_5_3 = ScriptUnit.has_extension(var_5_1, "hud_system")

	if var_5_3 then
		var_5_3.show_critical_indication = false
	end
end

function ActionBow.fire(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0.owner_unit
	local var_6_1 = ScriptUnit.extension(var_6_0, "first_person_system")
	local var_6_2 = arg_6_1.speed
	local var_6_3, var_6_4 = var_6_1:get_projectile_start_position_rotation()
	local var_6_5 = arg_6_0.spread_extension

	if var_6_5 then
		var_6_4 = var_6_5:get_randomised_spread(var_6_4)

		if arg_6_2 then
			var_6_5:set_shooting()
		end
	end

	local var_6_6 = ActionUtils.pitch_from_rotation(var_6_4)
	local var_6_7 = Vector3.normalize(Vector3.flat(Quaternion.forward(var_6_4)))
	local var_6_8 = arg_6_1.lookup_data

	ActionUtils.spawn_player_projectile(var_6_0, var_6_3, var_6_4, 0, var_6_6, var_6_7, var_6_2, arg_6_0.item_name, var_6_8.item_template_name, var_6_8.action_name, var_6_8.sub_action_name, arg_6_0._is_critical_strike, arg_6_0.power_level)

	if arg_6_1.alert_sound_range_fire then
		Managers.state.entity:system("ai_system"):alert_enemies_within_range(var_6_0, POSITION_LOOKUP[var_6_0], arg_6_1.alert_sound_range_fire)
	end
end
