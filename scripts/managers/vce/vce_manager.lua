-- chunkname: @scripts/managers/vce/vce_manager.lua

VCEManager = class(VCEManager)

VCEManager.init = function (arg_1_0)
	arg_1_0._vce_by_unit = {}
	arg_1_0._vce_free_list = {}
end

VCEManager.trigger_vce = function (arg_2_0, arg_2_1, arg_2_2, ...)
	if Managers.state.entity:system("dialogue_system"):is_unit_playing_dialogue(arg_2_1) then
		return
	end

	local var_2_0 = WwiseWorld.trigger_event(arg_2_2, ...)

	arg_2_0:_register_vce(arg_2_1, arg_2_2, var_2_0)
end

VCEManager.trigger_vce_unit = function (arg_3_0, arg_3_1, ...)
	if Managers.state.entity:system("dialogue_system"):is_unit_playing_dialogue(arg_3_1) then
		return
	end

	local var_3_0, var_3_1, var_3_2 = WwiseUtils.trigger_unit_event(...)

	arg_3_0:_register_vce(arg_3_1, var_3_2, var_3_0)
end

VCEManager._register_vce = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_0:_rent_vce_data()

	var_4_0.vce_id = arg_4_3
	var_4_0.wwise_world = arg_4_2

	local var_4_1 = arg_4_0._vce_by_unit[arg_4_1] or {}

	arg_4_0._vce_by_unit[arg_4_1] = var_4_1
	var_4_1[#var_4_1 + 1] = var_4_0
end

VCEManager.interrupt_vce = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._vce_by_unit[arg_5_1]

	if not var_5_0 then
		return
	end

	for iter_5_0 = 1, #var_5_0 do
		local var_5_1 = var_5_0[iter_5_0]
		local var_5_2 = var_5_1.vce_id
		local var_5_3 = var_5_1.wwise_world

		if WwiseWorld.is_playing(var_5_3, var_5_2) then
			WwiseWorld.stop_event(var_5_3, var_5_2)
		end

		arg_5_0:_return_vce_data(var_5_1)

		var_5_0[iter_5_0] = nil
	end
end

VCEManager._rent_vce_data = function (arg_6_0)
	local var_6_0 = arg_6_0._vce_free_list
	local var_6_1 = #var_6_0
	local var_6_2 = var_6_0[var_6_1] or {}

	var_6_0[var_6_1] = nil

	return var_6_2
end

VCEManager._return_vce_data = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._vce_free_list

	var_7_0[#var_7_0] = arg_7_1
end
