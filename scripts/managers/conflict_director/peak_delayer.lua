-- chunkname: @scripts/managers/conflict_director/peak_delayer.lua

PeakDelayer = class(PeakDelayer)

local var_0_0 = 100
local var_0_1 = 100
local var_0_2 = 30
local var_0_3 = {
	IN_PEAK = "IN_PEAK",
	DELAYING = "DELAYING",
	WAITING_TO_REACH_DELAY = "WAITING_TO_REACH_DELAY",
	DELAY_FINISHED = "DELAY_FINISHED"
}

local function var_0_4(arg_1_0, arg_1_1)
	for iter_1_0 = #arg_1_0, 1, -1 do
		local var_1_0 = arg_1_0[iter_1_0]

		if math.value_inside_range(arg_1_1, var_1_0, var_1_0 + var_0_2) then
			return true
		end
	end

	return false
end

local function var_0_5(arg_2_0, arg_2_1)
	for iter_2_0 = #arg_2_0, 1, -1 do
		if arg_2_1 > arg_2_0[iter_2_0] then
			return arg_2_0[iter_2_0 + 1]
		end
	end

	return arg_2_0[1]
end

function PeakDelayer.init(arg_3_0, arg_3_1)
	arg_3_0._peaks = arg_3_1
	arg_3_0._state = var_0_3.WAITING_TO_REACH_DELAY
end

function PeakDelayer.update(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = var_0_5(arg_4_0._peaks, arg_4_1) or math.huge

	if arg_4_0._state == var_0_3.WAITING_TO_REACH_DELAY then
		if var_0_4(arg_4_0._peaks, arg_4_1) then
			arg_4_0._state = var_0_3.IN_PEAK
		elseif var_4_0 - arg_4_1 < var_0_0 then
			Managers.state.event:trigger("event_delay_pacing", true)

			arg_4_0._delaying_since = arg_4_2
			arg_4_0._delay_for_peak = var_4_0
			arg_4_0._state = var_0_3.DELAYING
		end
	elseif arg_4_0._state == var_0_3.DELAYING then
		if var_0_4(arg_4_0._peaks, arg_4_1) then
			Managers.state.event:trigger("event_delay_pacing", false)

			arg_4_0._state = var_0_3.IN_PEAK
		elseif arg_4_0._delay_for_peak ~= var_4_0 then
			Managers.state.event:trigger("event_delay_pacing", false)

			arg_4_0._delay_for_peak = nil
			arg_4_0._state = var_0_3.WAITING_TO_REACH_DELAY
		elseif arg_4_2 - arg_4_0._delaying_since > var_0_1 then
			Managers.state.event:trigger("event_delay_pacing", false)

			arg_4_0._state = var_0_3.DELAY_FINISHED
		end
	elseif arg_4_0._state == var_0_3.DELAY_FINISHED then
		if var_0_4(arg_4_0._peaks, arg_4_1) then
			arg_4_0._state = var_0_3.IN_PEAK
		elseif arg_4_0._delay_for_peak ~= var_4_0 then
			arg_4_0._delay_for_peak = nil
			arg_4_0._state = var_0_3.WAITING_TO_REACH_DELAY
		end
	elseif arg_4_0._state == var_0_3.IN_PEAK and not var_0_4(arg_4_0._peaks, arg_4_1) then
		arg_4_0._state = var_0_3.WAITING_TO_REACH_DELAY
	end

	if script_data.debug_peak_delayer then
		Debug.text("PeakDelayer state: %s", arg_4_0._state)
	end
end

function PeakDelayer.is_near_or_in_a_peak(arg_5_0)
	return arg_5_0._state ~= var_0_3.WAITING_TO_REACH_DELAY
end

function PeakDelayer.set_peaks(arg_6_0, arg_6_1)
	arg_6_0._peaks = table.clone(arg_6_1)
end

function PeakDelayer.get_peaks(arg_7_0)
	return arg_7_0._peaks and table.clone(arg_7_0._peaks) or {}
end
