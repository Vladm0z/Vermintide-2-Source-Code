-- chunkname: @scripts/unit_extensions/weapons/actions/action_magma_projectile.lua

ActionMagmaProjectile = class(ActionMagmaProjectile, ActionShotgun)

ActionMagmaProjectile.client_owner_start_action = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	ActionMagmaProjectile.super.client_owner_start_action(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)

	local var_1_0 = arg_1_1.is_spell
	local var_1_1 = arg_1_0.owner_buff_extension

	if arg_1_0.charge_level and arg_1_0.charge_level >= 1 and var_1_0 then
		var_1_1:trigger_procs("on_full_charge_action", arg_1_1, arg_1_2, arg_1_3)
	end
end

ActionMagmaProjectile._start_shooting = function (arg_2_0)
	local var_2_0 = arg_2_0.owner_unit
	local var_2_1 = arg_2_0.current_action
	local var_2_2 = ScriptUnit.extension(var_2_0, "first_person_system")
	local var_2_3, var_2_4 = var_2_2:get_projectile_start_position_rotation()

	if var_2_1.fire_at_gaze_setting and ScriptUnit.has_extension(var_2_0, "eyetracking_system") and ScriptUnit.extension(var_2_0, "eyetracking_system"):get_is_feature_enabled("tobii_fire_at_gaze") then
		var_2_4 = arg_2_0.start_gaze_rotation:unbox()
	end

	arg_2_0._fire_position:store(var_2_3)
	arg_2_0._fire_rotation:store(var_2_4)

	if not Managers.player:owner(arg_2_0.owner_unit).bot_player then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "handgun_fire"
		})
	end

	arg_2_0:_use_ammo()
	arg_2_0:_add_overcharge()
	arg_2_0:_proc_spell_used(arg_2_0.owner_buff_extension)

	if var_2_1.alert_sound_range_fire then
		Managers.state.entity:system("ai_system"):alert_enemies_within_range(var_2_0, POSITION_LOOKUP[var_2_0], var_2_1.alert_sound_range_fire)
	end

	local var_2_5 = arg_2_0.current_action.fire_sound_event

	if var_2_5 then
		local var_2_6 = arg_2_0.current_action.fire_sound_on_husk

		var_2_2:play_hud_sound_event(var_2_5, nil, var_2_6)
	end

	arg_2_0.state = "shooting"
end
