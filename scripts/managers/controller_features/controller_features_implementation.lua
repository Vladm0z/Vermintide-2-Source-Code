-- chunkname: @scripts/managers/controller_features/controller_features_implementation.lua

ControllerFeaturesImplementation = class(ControllerFeaturesImplementation)

ControllerFeaturesImplementation.init = function (arg_1_0, arg_1_1)
	arg_1_0:_reset()

	arg_1_0._is_in_inn = arg_1_1

	if Managers.state.event then
		Managers.state.event:register(arg_1_0, "gm_event_end_conditions_met", "event_end_conditions_met")
	end
end

ControllerFeaturesImplementation._reset = function (arg_2_0)
	arg_2_0._effects = {}
	arg_2_0._current_effect_id = 1
	arg_2_0._game_mode_ended = false
	arg_2_0._state_data = {}
end

ControllerFeaturesImplementation.event_end_conditions_met = function (arg_3_0)
	arg_3_0._game_mode_ended = true
end

local var_0_0 = {}

ControllerFeaturesImplementation.update = function (arg_4_0, arg_4_1, arg_4_2)
	for iter_4_0, iter_4_1 in pairs(arg_4_0._effects) do
		table.clear(var_0_0)

		for iter_4_2, iter_4_3 in pairs(iter_4_1) do
			if arg_4_0._game_mode_ended or iter_4_3.effect.update(iter_4_3.state_data, arg_4_1, arg_4_2) then
				iter_4_3.effect.destroy(iter_4_3.state_data)

				var_0_0[#var_0_0 + 1] = iter_4_2
			end
		end

		for iter_4_4, iter_4_5 in ipairs(var_0_0) do
			iter_4_1[iter_4_5] = nil
		end
	end
end

ControllerFeaturesImplementation.add_effect = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if arg_5_0._game_mode_ended or not Application.user_setting("gamepad_rumble_enabled") or arg_5_1 == "camera_shake" and arg_5_0._is_in_inn or script_data.honduras_demo or not Managers.input:is_device_active("gamepad") then
		return
	end

	local var_5_0 = arg_5_3 or Managers.account:user_id()

	if not var_5_0 then
		return
	end

	local var_5_1 = Managers.account:active_controller(var_5_0)

	if not var_5_1 then
		return
	end

	local var_5_2 = {}

	if ControllerFeaturesSettings[arg_5_1] then
		local var_5_3 = ControllerFeaturesSettings[arg_5_1]

		var_5_2.controller = var_5_1

		var_5_3.init(var_5_2, arg_5_2)

		var_5_2.effect_id = arg_5_0._current_effect_id
		arg_5_0._effects[var_5_0] = arg_5_0._effects[var_5_0] or {}
		arg_5_0._effects[var_5_0][arg_5_0._current_effect_id] = {
			state_data = var_5_2,
			effect = var_5_3
		}
		arg_5_0._current_effect_id = arg_5_0._current_effect_id + 1

		return arg_5_0._current_effect_id - 1
	end
end

ControllerFeaturesImplementation.stop_effect = function (arg_6_0, arg_6_1)
	local var_6_0 = Managers.account:user_id()

	if not var_6_0 then
		return
	end

	local var_6_1 = arg_6_0._effects[var_6_0][arg_6_1]

	if var_6_1 then
		var_6_1.effect.destroy(var_6_1.state_data)

		arg_6_0._effects[var_6_0][arg_6_1] = nil
	end
end

ControllerFeaturesImplementation.destroy = function (arg_7_0)
	for iter_7_0, iter_7_1 in pairs(arg_7_0._effects) do
		for iter_7_2, iter_7_3 in pairs(iter_7_1) do
			iter_7_3.effect.destroy(iter_7_3.state_data)
		end
	end

	arg_7_0:_reset()
end
