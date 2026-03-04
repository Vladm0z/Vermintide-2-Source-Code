-- chunkname: @scripts/managers/backend_playfab/backend_interface_deus_playfab.lua

require("scripts/managers/backend_playfab/backend_interface_deus_base")

BackendInterfaceDeusPlayFab = class(BackendInterfaceDeusPlayFab, BackendInterfaceDeusBase)

function BackendInterfaceDeusPlayFab.init(arg_1_0, arg_1_1)
	arg_1_0._backend_mirror = arg_1_1
	arg_1_0._belakor_data = {}

	arg_1_0.super.init(arg_1_0)
end

function BackendInterfaceDeusPlayFab.get_journey_cycle(arg_2_0)
	local var_2_0 = Managers.time:time("main")
	local var_2_1 = arg_2_0._backend_mirror:get_deus_journey_cycle_data()
	local var_2_2 = var_2_0 - var_2_1.time_of_update
	local var_2_3 = var_2_1.remaining_time - var_2_2
	local var_2_4

	if var_2_3 < 0 then
		local var_2_5 = -var_2_3
		local var_2_6 = var_2_1.span
		local var_2_7 = math.ceil(var_2_5 / var_2_6)

		var_2_4 = var_2_1.cycle_count + var_2_7
		var_2_3 = var_2_6 - var_2_5 % var_2_6
	else
		var_2_4 = var_2_1.cycle_count
	end

	return arg_2_0:_generate_journey_cycle(var_2_0, var_2_3, var_2_4)
end

function BackendInterfaceDeusPlayFab.has_loaded_belakor_data(arg_3_0)
	return arg_3_0._backend_mirror:has_loaded_belakor_data()
end

function BackendInterfaceDeusPlayFab.set_has_loaded_belakor_data(arg_4_0, arg_4_1)
	arg_4_0._backend_mirror:set_has_loaded_belakor_data(arg_4_1)
end

function BackendInterfaceDeusPlayFab.deus_journey_with_belakor(arg_5_0, arg_5_1)
	if not arg_5_1 then
		return false
	end

	if not arg_5_0._belakor_data or table.is_empty(arg_5_0._belakor_data) then
		arg_5_0:get_belakor_cycle()
	end

	return arg_5_0._belakor_data.journey_name == arg_5_1 and true or false
end

function BackendInterfaceDeusPlayFab.get_belakor_cycle(arg_6_0)
	local var_6_0 = Managers.time:time("main")
	local var_6_1 = arg_6_0._backend_mirror:get_deus_belakor_curse_data()
	local var_6_2 = var_6_0 - var_6_1.time_of_update
	local var_6_3 = var_6_1.remaining_time - var_6_2
	local var_6_4

	if var_6_3 < 0 then
		local var_6_5 = -var_6_3
		local var_6_6 = var_6_1.span
		local var_6_7 = math.ceil(var_6_5 / var_6_6)

		var_6_4 = var_6_1.cycle_count + var_6_7
		var_6_3 = var_6_6 - var_6_5 % var_6_6
	else
		var_6_4 = var_6_1.cycle_count
	end

	return arg_6_0:_generate_belakor_curse_cycle(var_6_0, var_6_3, var_6_4)
end

function BackendInterfaceDeusPlayFab._generate_belakor_curse_cycle(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_3 % #AvailableJourneyOrder + 1
	local var_7_1 = AvailableJourneyOrder[var_7_0]
	local var_7_2 = {
		remaining_time = arg_7_2,
		time_of_update = arg_7_1,
		journey_name = var_7_1
	}

	arg_7_0._belakor_data = var_7_2

	return var_7_2
end

function BackendInterfaceDeusPlayFab.refresh_belakor_cycle(arg_8_0)
	arg_8_0._backend_mirror:deus_refresh_belakor_data()
end

function BackendInterfaceDeusPlayFab.get_rolled_over_soft_currency(arg_9_0)
	return arg_9_0._backend_mirror:get_deus_rolled_over_soft_currency()
end

function BackendInterfaceDeusPlayFab.deus_run_started(arg_10_0)
	local var_10_0 = {
		FunctionName = "deusRunStarted",
		FunctionParameter = {}
	}
	local var_10_1 = arg_10_0._backend_mirror

	var_10_1:predict_deus_run_started()

	local function var_10_2(arg_11_0)
		var_10_1:handle_deus_result(arg_11_0)
	end

	var_10_1:request_queue():enqueue(var_10_0, var_10_2)
end

function BackendInterfaceDeusPlayFab.write_player_event(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = {
		EventName = arg_12_1,
		Body = arg_12_2
	}
	local var_12_1 = arg_12_0._backend_mirror:request_queue()

	local function var_12_2(arg_13_0)
		return
	end

	var_12_1:enqueue_api_request("WritePlayerEvent", var_12_0, var_12_2)
end
