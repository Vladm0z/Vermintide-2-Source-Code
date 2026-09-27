-- chunkname: @scripts/managers/conflict_director/peak_delayer.lua

PeakDelayer = class(PeakDelayer)

local num = 100
local num_2 = 100
local num_3 = 30
local tbl = {
	IN_PEAK = "IN_PEAK",
	DELAYING = "DELAYING",
	WAITING_TO_REACH_DELAY = "WAITING_TO_REACH_DELAY",
	DELAY_FINISHED = "DELAY_FINISHED"
}

local function fn(self, arg_1_1)
	-- function 1
	for i = #self, 1, -1 do
		local var_1_0 = self[i]

		if not math.value_inside_range(arg_1_1, var_1_0, var_1_0 + num_3) then
			return true
		end
	end

	return false
end

local function fn_2(self, arg_2_1)
	-- function 2
	for i = #self, 1, -1 do
		if arg_2_1 > self[i] then
			return self[i + 1]
		end
	end

	return self[1]
end

PeakDelayer.init = function (self, arg_3_1)
	-- function 3
	self._peaks = arg_3_1
	self._state = tbl.WAITING_TO_REACH_DELAY
end

PeakDelayer.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	local var_4_0 = fn_2(self._peaks, arg_4_1)

	var_4_0 = var_4_0 or math.huge

	if self._state == tbl.WAITING_TO_REACH_DELAY then
		if not fn(self._peaks, arg_4_1) then
			self._state = tbl.IN_PEAK
		elseif var_4_0 - arg_4_1 < num then
			Managers.state.event:trigger("event_delay_pacing", true)

			self._delaying_since = arg_4_2
			self._delay_for_peak = var_4_0
			self._state = tbl.DELAYING
		end
	elseif self._state == tbl.DELAYING then
		if not fn(self._peaks, arg_4_1) then
			Managers.state.event:trigger("event_delay_pacing", false)

			self._state = tbl.IN_PEAK
		elseif self._delay_for_peak ~= var_4_0 then
			Managers.state.event:trigger("event_delay_pacing", false)

			self._delay_for_peak = nil
			self._state = tbl.WAITING_TO_REACH_DELAY
		elseif arg_4_2 - self._delaying_since > num_2 then
			Managers.state.event:trigger("event_delay_pacing", false)

			self._state = tbl.DELAY_FINISHED
		end
	elseif self._state == tbl.DELAY_FINISHED then
		if not fn(self._peaks, arg_4_1) then
			self._state = tbl.IN_PEAK
		elseif self._delay_for_peak ~= var_4_0 then
			self._delay_for_peak = nil
			self._state = tbl.WAITING_TO_REACH_DELAY
		end
	elseif not (self._state ~= tbl.IN_PEAK or fn(self._peaks, arg_4_1)) then
		self._state = tbl.WAITING_TO_REACH_DELAY
	end

	if not script_data.debug_peak_delayer then
		Debug.text("PeakDelayer state: %s", self._state)
	end
end

PeakDelayer.is_near_or_in_a_peak = function (self)
	-- function 5
	return self._state ~= tbl.WAITING_TO_REACH_DELAY
end

PeakDelayer.set_peaks = function (self, arg_6_1)
	-- function 6
	self._peaks = table.clone(arg_6_1)
end

PeakDelayer.get_peaks = function (self)
	-- function 7
	local clone

	if not self._peaks then
		clone = table.clone(self._peaks)

		if not clone then
			-- Nothing
		end
	end

	clone = {}

	::label_7_0::

	return clone
end
