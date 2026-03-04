-- chunkname: @scripts/unit_extensions/weapons/actions/action_minigun_spin.lua

ActionMinigunSpin = class(ActionMinigunSpin, ActionBase)

ActionMinigunSpin.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	ActionMinigunSpin.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	arg_1_0.first_person_extension = ScriptUnit.has_extension(arg_1_4, "first_person_system")
end

ActionMinigunSpin.client_owner_start_action = function (arg_2_0, arg_2_1, arg_2_2)
	ActionMinigunSpin.super.client_owner_start_action(arg_2_0, arg_2_1, arg_2_2)

	arg_2_0._initial_windup = arg_2_1.initial_windup
	arg_2_0._windup_max = arg_2_1.windup_max
	arg_2_0._windup_speed = arg_2_1.windup_speed

	if arg_2_1.windup_start_on_zero then
		arg_2_0._current_windup = 0
	else
		arg_2_0._current_windup = arg_2_0.weapon_extension:get_custom_data("windup")
	end

	arg_2_0._last_update_t = arg_2_2
	arg_2_0._audio_loop_id = arg_2_1.audio_loop_id
	arg_2_0._fp_speed_anim_variable = arg_2_1.fp_speed_anim_variable

	arg_2_0:start_audio_loop()
end

ActionMinigunSpin.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_0.weapon_extension
	local var_3_1 = arg_3_0._current_windup
	local var_3_2 = math.clamp(var_3_1 + arg_3_0._windup_speed * arg_3_1, arg_3_0._initial_windup, 1)

	var_3_0:set_custom_data("windup", var_3_2)

	arg_3_0._current_windup = var_3_2
	arg_3_0._last_update_t = arg_3_2

	arg_3_0:_update_animation_speed(var_3_2)
end

ActionMinigunSpin.start_audio_loop = function (arg_4_0)
	local var_4_0 = arg_4_0._audio_loop_id

	if not var_4_0 then
		return
	end

	local var_4_1 = arg_4_0.current_action
	local var_4_2 = var_4_1.charge_sound_name
	local var_4_3 = var_4_1.charge_sound_stop_event

	if not var_4_2 or not var_4_3 then
		return
	end

	local var_4_4 = arg_4_0.weapon_extension
	local var_4_5 = var_4_1.charge_sound_husk_name
	local var_4_6 = var_4_1.charge_sound_husk_stop_event

	var_4_4:add_looping_audio(var_4_0, var_4_2, var_4_3, var_4_5, var_4_6)
	var_4_4:start_looping_audio(var_4_0)
end

ActionMinigunSpin._update_animation_speed = function (arg_5_0, arg_5_1)
	if arg_5_0._fp_speed_anim_variable then
		local var_5_0 = arg_5_1 / 3 + 0.67
		local var_5_1 = math.clamp(var_5_0, NetworkConstants.animation_variable_float.min, NetworkConstants.animation_variable_float.max)

		arg_5_0.first_person_extension:animation_set_variable(arg_5_0._fp_speed_anim_variable, var_5_1)
	end
end

ActionMinigunSpin.finish = function (arg_6_0, ...)
	ActionMinigunSpin.super.finish(arg_6_0, ...)
end
