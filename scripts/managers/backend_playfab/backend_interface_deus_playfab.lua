-- chunkname: @scripts/managers/backend_playfab/backend_interface_deus_playfab.lua

require("scripts/managers/backend_playfab/backend_interface_deus_base")

BackendInterfaceDeusPlayFab = class(BackendInterfaceDeusPlayFab, BackendInterfaceDeusBase)

BackendInterfaceDeusPlayFab.init = function (self, arg_1_1)
	-- function 1
	self._backend_mirror = arg_1_1
	self._belakor_data = {}

	self.super.init(self)
end

BackendInterfaceDeusPlayFab.get_journey_cycle = function (self)
	-- function 2
	local time = Managers.time:time("main")
	local get_deus_journey_cycle_data = self._backend_mirror:get_deus_journey_cycle_data()
	local num = time - get_deus_journey_cycle_data.time_of_update
	local num_2 = get_deus_journey_cycle_data.remaining_time - num
	local var_2_4

	if num_2 < 0 then
		local num_3 = -num_2
		local span = get_deus_journey_cycle_data.span
		local ceil = math.ceil(num_3 / span)

		var_2_4 = get_deus_journey_cycle_data.cycle_count + ceil
		num_2 = span - num_3 % span
	else
		var_2_4 = get_deus_journey_cycle_data.cycle_count
	end

	return self:_generate_journey_cycle(time, num_2, var_2_4)
end

BackendInterfaceDeusPlayFab.has_loaded_belakor_data = function (self)
	-- function 3
	return self._backend_mirror:has_loaded_belakor_data()
end

BackendInterfaceDeusPlayFab.set_has_loaded_belakor_data = function (self, arg_4_1)
	-- function 4
	self._backend_mirror:set_has_loaded_belakor_data(arg_4_1)
end

BackendInterfaceDeusPlayFab.deus_journey_with_belakor = function (self, arg_5_1)
	-- function 5
	if not arg_5_1 then
		return false
	end

	if not self._belakor_data and not table.is_empty(self._belakor_data) then
		self:get_belakor_cycle()
	end

	local flag

	flag = self._belakor_data.journey_name ~= arg_5_1 or not true or false

	return flag
end

BackendInterfaceDeusPlayFab.get_belakor_cycle = function (self)
	-- function 6
	local time = Managers.time:time("main")
	local get_deus_belakor_curse_data = self._backend_mirror:get_deus_belakor_curse_data()
	local num = time - get_deus_belakor_curse_data.time_of_update
	local num_2 = get_deus_belakor_curse_data.remaining_time - num
	local var_6_4

	if num_2 < 0 then
		local num_3 = -num_2
		local span = get_deus_belakor_curse_data.span
		local ceil = math.ceil(num_3 / span)

		var_6_4 = get_deus_belakor_curse_data.cycle_count + ceil
		num_2 = span - num_3 % span
	else
		var_6_4 = get_deus_belakor_curse_data.cycle_count
	end

	return self:_generate_belakor_curse_cycle(time, num_2, var_6_4)
end

BackendInterfaceDeusPlayFab._generate_belakor_curse_cycle = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local num = arg_7_3 % #AvailableJourneyOrder + 1
	local var_7_1 = AvailableJourneyOrder[num]
	local tbl = {
		remaining_time = arg_7_2,
		time_of_update = arg_7_1,
		journey_name = var_7_1
	}

	self._belakor_data = tbl

	return tbl
end

BackendInterfaceDeusPlayFab.refresh_belakor_cycle = function (self)
	-- function 8
	self._backend_mirror:deus_refresh_belakor_data()
end

BackendInterfaceDeusPlayFab.get_rolled_over_soft_currency = function (self)
	-- function 9
	return self._backend_mirror:get_deus_rolled_over_soft_currency()
end

BackendInterfaceDeusPlayFab.deus_run_started = function (self)
	-- function 10
	local tbl = {
		FunctionName = "deusRunStarted",
		FunctionParameter = {}
	}
	local _backend_mirror = self._backend_mirror

	_backend_mirror:predict_deus_run_started()

	local function fn(arg_11_0)
		-- function 11
		_backend_mirror:handle_deus_result(arg_11_0)
	end

	_backend_mirror:request_queue():enqueue(tbl, fn)
end

BackendInterfaceDeusPlayFab.write_player_event = function (self, arg_12_1, arg_12_2)
	-- function 12
	local tbl = {
		EventName = arg_12_1,
		Body = arg_12_2
	}
	local request_queue = self._backend_mirror:request_queue()

	local function fn(arg_13_0)
		-- function 13
		return
	end

	request_queue:enqueue_api_request("WritePlayerEvent", tbl, fn)
end
