-- chunkname: @scripts/unit_extensions/default_player_unit/third_person_idle_fullbody_animation_control.lua

ThirdPersonIdleFullbodyAnimationControl = class(ThirdPersonIdleFullbodyAnimationControl)

local var_0_0 = 0.12
local var_0_1 = 0.25
local var_0_2 = 0.25
local var_0_3 = 1
local var_0_4 = 0

function ThirdPersonIdleFullbodyAnimationControl.init(arg_1_0, arg_1_1)
	arg_1_0._unit = arg_1_1
	arg_1_0._idle_fullbody_variable = Unit.animation_find_variable(arg_1_1, "idle_fullbody")
	arg_1_0._progress = 1
	arg_1_0._is_moving = false
	arg_1_0._is_crouching = false
	arg_1_0._is_moving_transition_start_t = 0
	arg_1_0._crouch_t = 0
end

function ThirdPersonIdleFullbodyAnimationControl.extensions_ready(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._locomotion_extension = ScriptUnit.extension(arg_2_2, "locomotion_system")
	arg_2_0._status_extension = ScriptUnit.extension(arg_2_2, "status_system")
end

function ThirdPersonIdleFullbodyAnimationControl._total_time(arg_3_0, arg_3_1)
	return arg_3_1 and var_0_0 or var_0_1
end

function ThirdPersonIdleFullbodyAnimationControl._calculate_start_time(arg_4_0, arg_4_1, arg_4_2)
	return arg_4_2 - arg_4_0:_total_time(arg_4_1) * (1 - arg_4_0._progress)
end

function ThirdPersonIdleFullbodyAnimationControl._wanted_fullbody_value(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_0:_total_time(arg_5_2)
	local var_5_1 = math.clamp01(arg_5_1 / var_5_0)
	local var_5_2 = var_5_1

	if not arg_5_2 then
		var_5_1 = 1 - var_5_1
	end

	local var_5_3 = math.lerp(var_0_3, var_0_4, var_5_1)
	local var_5_4 = arg_5_3 and 1 or 0
	local var_5_5 = 1 - var_5_4

	return var_5_3 * math.clamp01(math.inv_lerp(var_5_4, var_5_5, arg_5_4 / var_0_2)), var_5_2
end

function ThirdPersonIdleFullbodyAnimationControl._percentage_done(arg_6_0, arg_6_1)
	return 0
end

function ThirdPersonIdleFullbodyAnimationControl.update(arg_7_0, arg_7_1)
	if not arg_7_0._idle_fullbody_variable then
		return
	end

	local var_7_0 = arg_7_0._unit
	local var_7_1 = arg_7_0._status_extension:is_crouching()
	local var_7_2 = Vector3.length_squared(arg_7_0._locomotion_extension:current_velocity())

	if var_7_2 < NetworkConstants.VELOCITY_EPSILON * NetworkConstants.VELOCITY_EPSILON then
		var_7_2 = 0
	end

	local var_7_3 = arg_7_0._is_moving

	if not var_7_3 and var_7_2 > 0 then
		arg_7_0._is_moving = true
		arg_7_0._is_moving_transition_start_t = arg_7_0:_calculate_start_time(arg_7_0._is_moving, arg_7_1)
	elseif var_7_3 and var_7_2 == 0 then
		arg_7_0._is_moving = false
		arg_7_0._is_moving_transition_start_t = arg_7_0:_calculate_start_time(arg_7_0._is_moving, arg_7_1)
	end

	local var_7_4 = arg_7_0._is_moving

	if var_7_1 ~= arg_7_0._is_crouching then
		arg_7_0._crouch_t = arg_7_1
		arg_7_0._is_crouching = var_7_1
	end

	local var_7_5 = arg_7_1 - arg_7_0._is_moving_transition_start_t
	local var_7_6, var_7_7 = arg_7_0:_wanted_fullbody_value(var_7_5, var_7_4, var_7_1, arg_7_1 - arg_7_0._crouch_t)

	Unit.animation_set_variable(var_7_0, arg_7_0._idle_fullbody_variable, var_7_6)

	arg_7_0._idle_fullbody_value = var_7_6
	arg_7_0._progress = var_7_7
end
