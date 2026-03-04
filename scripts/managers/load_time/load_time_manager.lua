-- chunkname: @scripts/managers/load_time/load_time_manager.lua

LoadTimeManager = class(LoadTimeManager)

LoadTimeManager.init = function (arg_1_0)
	arg_1_0._previous_level_key = "none"
	arg_1_0._members_joined = {}
	arg_1_0._members_left = {}
	arg_1_0._members = {}
	arg_1_0._lobby_failed = false
	arg_1_0._current_lobby = nil
end

LoadTimeManager.start_timer = function (arg_2_0, arg_2_1, arg_2_2)
	if Managers.time:has_timer("loading_timer") then
		Managers.time:unregister_timer("loading_timer")
	end

	Managers.time:register_timer("loading_timer", "main", 0)

	arg_2_0._current_lobby = nil
	arg_2_0._lobby_failed = false
	arg_2_0._time_spent_in_level = arg_2_1 or -1
	arg_2_0._end_reason = arg_2_2 or "unknown"

	table.clear(arg_2_0._members_joined)
	table.clear(arg_2_0._members_left)
	table.clear(arg_2_0._members)
end

LoadTimeManager.set_lobby = function (arg_3_0, arg_3_1)
	arg_3_0._current_lobby = arg_3_1

	local var_3_0 = arg_3_0._current_lobby:members():get_members()

	for iter_3_0, iter_3_1 in ipairs(var_3_0) do
		arg_3_0._members[iter_3_1] = true
	end
end

LoadTimeManager.has_lobby = function (arg_4_0)
	if arg_4_0._lobby_failed then
		return false
	end

	return arg_4_0._current_lobby ~= nil
end

LoadTimeManager.update = function (arg_5_0, arg_5_1)
	if not arg_5_0._current_lobby then
		return
	end

	if arg_5_0._current_lobby:failed() then
		arg_5_0._current_lobby = nil
		arg_5_0._lobby_failed = true

		return
	end

	local var_5_0 = false
	local var_5_1 = arg_5_0._current_lobby:members()

	if not var_5_1 then
		return
	end

	local var_5_2 = var_5_1:get_members()

	for iter_5_0, iter_5_1 in ipairs(var_5_2) do
		if not arg_5_0._members[iter_5_1] then
			arg_5_0._members_joined[#arg_5_0._members_joined + 1] = iter_5_1

			print("[LoadTimeManager] Member Joined")

			var_5_0 = true
		end
	end

	for iter_5_2, iter_5_3 in pairs(arg_5_0._members) do
		if not table.find(var_5_2, iter_5_2) then
			arg_5_0._members_left[#arg_5_0._members_left + 1] = iter_5_2

			print("[LoadTimeManager] Member left")

			var_5_0 = true
		end
	end

	if var_5_0 then
		table.clear(arg_5_0._members)

		for iter_5_4, iter_5_5 in ipairs(var_5_2) do
			arg_5_0._members[iter_5_5] = true
		end
	end
end

local var_0_0 = {}

LoadTimeManager.end_timer = function (arg_6_0)
	table.clear(var_0_0)

	local var_6_0 = "unknown"

	if Managers.state.game_mode then
		var_6_0 = Managers.state.game_mode:level_key()
	end

	local var_6_1 = Managers.player:local_player()
	local var_6_2 = var_6_1 and var_6_1.is_server or "unknown"
	local var_6_3 = arg_6_0._previous_level_key
	local var_6_4 = Managers.time:time("loading_timer") or 0
	local var_6_5 = math.floor(var_6_4 % 60 + 0.5)
	local var_6_6 = math.floor(var_6_4 / 60)
	local var_6_7 = math.floor(var_6_6 / 60)
	local var_6_8 = string.format("%02d:%02d:%02d", var_6_7, var_6_6, var_6_5)

	print("#################################################################################################################")
	print(string.format("[Loading Time]: %s [Transition]: %s-%s  [Members joined]: %s [Members Left]: %s [Is Server]: %s", var_6_8, var_6_3, var_6_0, tostring(#arg_6_0._members_joined), tostring(#arg_6_0._members_left), tostring(var_6_2)))
	print("#################################################################################################################")

	var_0_0.identifier = "load-level"
	var_0_0.duration = tonumber(string.format("%.2f", var_6_4))
	var_0_0.parameters = {
		from_level = var_6_3,
		to_level = var_6_0,
		end_reason = arg_6_0._end_reason,
		time_spent_in_level = arg_6_0._time_spent_in_level,
		members_joined = #arg_6_0._members_joined,
		members_left = #arg_6_0._members_left,
		lobby_failed = arg_6_0._lobby_failed,
		is_server = var_6_2
	}

	BackendUtils.commit_load_time_data(var_0_0)

	arg_6_0._previous_level_key = var_6_0
	arg_6_0._current_lobby = nil
	arg_6_0._lobby_failed = false
end

LoadTimeManager.destroy = function (arg_7_0)
	if Managers.time and Managers.time:has_timer("loading_timer") then
		Managers.time:unregister_timer("loading_timer")
	end

	arg_7_0._current_lobby = nil
	arg_7_0._lobby_failed = false

	table.clear(arg_7_0._members_joined)
	table.clear(arg_7_0._members_left)
	table.clear(arg_7_0._members)
end
