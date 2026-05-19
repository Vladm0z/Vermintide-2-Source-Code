-- chunkname: @scripts/unit_extensions/weapons/actions/action_aim.lua

ActionAim = class(ActionAim, ActionBase)

function ActionAim.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionAim.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.ammo_extension = ScriptUnit.has_extension(arg_1_7, "ammo_system")
	arg_1_0.spread_extension = ScriptUnit.has_extension(arg_1_7, "spread_system")
	arg_1_0.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
end

local function var_0_0(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	return arg_2_1 / ActionUtils.get_action_time_scale(arg_2_2, arg_2_0)
end

function ActionAim.client_owner_start_action(arg_3_0, arg_3_1, arg_3_2)
	ActionAim.super.client_owner_start_action(arg_3_0, arg_3_1, arg_3_2)

	local var_3_0 = arg_3_0.owner_unit

	arg_3_0.current_action = arg_3_1
	arg_3_0.zoom_condition_function = arg_3_1.zoom_condition_function
	arg_3_0.played_aim_sound = false
	arg_3_0.heavy_aim_flow_done = false
	arg_3_0.fully_charged_triggered = false

	local var_3_1 = ScriptUnit.extension(var_3_0, "buff_system")

	arg_3_0.buff_extension = var_3_1

	local var_3_2 = var_0_0(arg_3_1, arg_3_1.aim_sound_delay or 0, var_3_0, var_3_1)
	local var_3_3 = var_0_0(arg_3_1, arg_3_1.aim_zoom_delay or 0, var_3_0, var_3_1)
	local var_3_4 = var_0_0(arg_3_1, arg_3_1.heavy_aim_flow_delay or 0, var_3_0, var_3_1)
	local var_3_5 = var_0_0(arg_3_1, arg_3_1.charge_time or 0, var_3_0, var_3_1)

	arg_3_0.aim_sound_time = arg_3_2 + var_3_2
	arg_3_0.aim_zoom_time = arg_3_2 + var_3_3
	arg_3_0.heavy_aim_flow_time = arg_3_2 + var_3_4
	arg_3_0.charge_time_trigger = arg_3_2 + var_3_5

	local var_3_6 = ScriptUnit.extension(var_3_0, "first_person_system")

	var_3_6:disable_rig_movement()
	var_3_6:enable_rig_offset()

	local var_3_7 = arg_3_1.spread_template_override

	if var_3_7 then
		arg_3_0.spread_extension:override_spread_template(var_3_7)
	end

	local var_3_8 = arg_3_1.loaded_projectile_settings

	if var_3_8 then
		ScriptUnit.extension(var_3_0, "inventory_system"):set_loaded_projectile_override(var_3_8)
	end

	arg_3_0.charge_ready_sound_event = arg_3_0.current_action.charge_ready_sound_event

	arg_3_0:_start_charge_sound()
end

function ActionAim._start_charge_sound(arg_4_0)
	local var_4_0 = arg_4_0.current_action
	local var_4_1 = arg_4_0.owner_unit
	local var_4_2 = arg_4_0.owner_player
	local var_4_3 = var_4_2 and var_4_2.bot_player
	local var_4_4 = var_4_2 and not var_4_2.remote
	local var_4_5 = arg_4_0.wwise_world

	if var_4_4 and not var_4_3 then
		local var_4_6, var_4_7 = ActionUtils.start_charge_sound(var_4_5, arg_4_0.weapon_unit, var_4_1, var_4_0)

		arg_4_0.charging_sound_id = var_4_6
		arg_4_0.wwise_source_id = var_4_7
	end

	ActionUtils.play_husk_sound_event(var_4_5, var_4_0.charge_sound_husk_name, var_4_1, var_4_3)
end

function ActionAim._stop_charge_sound(arg_5_0)
	local var_5_0 = arg_5_0.current_action
	local var_5_1 = arg_5_0.owner_unit
	local var_5_2 = arg_5_0.owner_player
	local var_5_3 = var_5_2 and var_5_2.bot_player
	local var_5_4 = var_5_2 and not var_5_2.remote
	local var_5_5 = arg_5_0.wwise_world

	if var_5_4 and not var_5_3 then
		ActionUtils.stop_charge_sound(var_5_5, arg_5_0.charging_sound_id, arg_5_0.wwise_source_id, var_5_0)

		arg_5_0.charging_sound_id = nil
		arg_5_0.wwise_source_id = nil
	end

	ActionUtils.play_husk_sound_event(var_5_5, var_5_0.charge_sound_husk_stop_event, var_5_1, var_5_3)
end

function ActionAim.client_owner_post_update(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = arg_6_0.current_action
	local var_6_1 = arg_6_0.owner_unit

	if Application.user_setting("tobii_eyetracking") and ScriptUnit.has_extension(var_6_1, "eyetracking_system") then
		local var_6_2 = ScriptUnit.extension(var_6_1, "eyetracking_system")

		if var_6_2:get_is_feature_enabled("tobii_aim_at_gaze") and not var_6_2:get_aim_at_gaze_cancelled() then
			local var_6_3 = ScriptUnit.extension(var_6_1, "input_system")
			local var_6_4 = var_6_3:get("look_raw") or Vector3(0, 0, 0)
			local var_6_5 = var_6_3:get("look_raw_controller") or Vector3(0, 0, 0)

			if Vector3.length(var_6_4) > 0.01 or Vector3.length(var_6_5) > 0.01 then
				ScriptUnit.extension(var_6_1, "first_person_system"):stop_force_look_rotation()
				var_6_2:set_aim_at_gaze_cancelled(true)
			end
		end
	end

	if not arg_6_0.zoom_condition_function or arg_6_0.zoom_condition_function() then
		local var_6_6 = ScriptUnit.extension(var_6_1, "status_system")
		local var_6_7 = ScriptUnit.extension(var_6_1, "input_system")
		local var_6_8 = ScriptUnit.extension(var_6_1, "buff_system")

		if not var_6_6:is_zooming() and arg_6_2 >= arg_6_0.aim_zoom_time then
			var_6_6:set_zooming(true, var_6_0.default_zoom)
		end

		if var_6_8:has_buff_perk("increased_zoom") and var_6_6:is_zooming() and var_6_7:get("action_three") then
			var_6_6:switch_variable_zoom(var_6_0.buffed_zoom_thresholds)
		end
	end

	if not arg_6_0.played_aim_sound and arg_6_2 >= arg_6_0.aim_sound_time and not Managers.player:owner(arg_6_0.owner_unit).bot_player then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "aim_start"
		})

		local var_6_9 = var_6_0.aim_sound_event

		if var_6_9 then
			if var_6_0.looping_aim_sound then
				local var_6_10 = var_6_0.aim_sound_event
				local var_6_11 = var_6_0.unaim_sound_event

				arg_6_0.weapon_extension:add_looping_audio("aim", var_6_10, var_6_11, nil, nil, true)
			else
				local var_6_12 = arg_6_0.wwise_world

				WwiseWorld.trigger_event(var_6_12, var_6_9)
			end
		end

		arg_6_0.played_aim_sound = true
	end

	if not arg_6_0.heavy_aim_flow_done and arg_6_2 >= arg_6_0.heavy_aim_flow_time and not Managers.player:owner(arg_6_0.owner_unit).bot_player then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "aim_start"
		})

		local var_6_13 = var_6_0.heavy_aim_flow_event

		if var_6_13 then
			Unit.flow_event(arg_6_0.first_person_unit, var_6_13)
		end

		local var_6_14 = var_6_0.heavy_aim_sound_event

		if var_6_14 then
			local var_6_15 = arg_6_0.wwise_world

			WwiseWorld.trigger_event(var_6_15, var_6_14)
		end

		arg_6_0.heavy_aim_flow_done = true
	end

	if arg_6_2 > arg_6_0.charge_time_trigger and not arg_6_0.fully_charged_triggered then
		arg_6_0.fully_charged_triggered = true

		arg_6_0.buff_extension:trigger_procs("on_full_charge")
	end
end

function ActionAim.finish(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.current_action
	local var_7_1 = arg_7_0.ammo_extension
	local var_7_2 = arg_7_0.owner_unit
	local var_7_3 = var_7_0.unzoom_condition_function

	if not var_7_3 or var_7_3(arg_7_1) then
		ScriptUnit.extension(var_7_2, "status_system"):set_zooming(false)
	end

	local var_7_4 = ScriptUnit.extension(var_7_2, "first_person_system")

	var_7_4:enable_rig_movement()
	var_7_4:disable_rig_offset()
	var_7_4:stop_force_look_rotation()

	local var_7_5 = var_7_0.reload_when_out_of_ammo_condition_func
	local var_7_6 = not var_7_5 and true or var_7_5(var_7_2, arg_7_1)

	if var_7_1 and var_7_1:can_reload() and var_7_1:ammo_count() == 0 and var_7_0.reload_when_out_of_ammo and var_7_6 then
		local var_7_7 = true

		var_7_1:start_reload(var_7_7)
	end

	if arg_7_0.spread_extension then
		arg_7_0.spread_extension:reset_spread_template()
	end

	local var_7_8 = var_7_0.unaim_sound_event

	if var_7_8 then
		local var_7_9 = arg_7_0.wwise_world

		WwiseWorld.trigger_event(var_7_9, var_7_8)
	end

	if not Managers.player:owner(var_7_2).bot_player then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "full_stop"
		})
	end

	if var_7_0.reset_aim_assist_on_exit then
		var_7_4:reset_aim_assist_multiplier()
	end

	ScriptUnit.extension(var_7_2, "inventory_system"):set_loaded_projectile_override(nil)
	arg_7_0.buff_extension:trigger_procs("on_charge_finished")

	if not var_7_0.looping_aim_sound then
		arg_7_0:_stop_charge_sound()
	end
end
