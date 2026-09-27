-- chunkname: @scripts/managers/load_time/load_time_manager.lua

LoadTimeManager = class(LoadTimeManager)

LoadTimeManager.init = function (self)
	-- function 1
	self._previous_level_key = "none"
	self._members_joined = {}
	self._members_left = {}
	self._members = {}
	self._lobby_failed = false
	self._current_lobby = nil
end

LoadTimeManager.start_timer = function (self, arg_2_1, arg_2_2)
	-- function 2
	if not Managers.time:has_timer("loading_timer") then
		Managers.time:unregister_timer("loading_timer")
	end

	Managers.time:register_timer("loading_timer", "main", 0)

	self._current_lobby = nil
	self._lobby_failed = false
	self._time_spent_in_level = arg_2_1 or -1
	self._end_reason = arg_2_2 or "unknown"

	table.clear(self._members_joined)
	table.clear(self._members_left)
	table.clear(self._members)
end

LoadTimeManager.set_lobby = function (self, arg_3_1)
	-- function 3
	self._current_lobby = arg_3_1

	local get_members = self._current_lobby:members():get_members()

	for i, v in ipairs(get_members) do
		self._members[v] = true
	end
end

LoadTimeManager.has_lobby = function (self)
	-- function 4
	if not self._lobby_failed then
		return false
	end

	return self._current_lobby ~= nil
end

LoadTimeManager.update = function (self, arg_5_1)
	-- function 5
	if not self._current_lobby then
		return
	end

	if not self._current_lobby:failed() then
		self._current_lobby = nil
		self._lobby_failed = true

		return
	end

	local flag = false
	local members = self._current_lobby:members()

	if not members then
		return
	end

	local get_members = members:get_members()

	for i, v in ipairs(get_members) do
		if not self._members[v] then
			self._members_joined[#self._members_joined + 1] = v

			print("[LoadTimeManager] Member Joined")

			flag = true
		end
	end

	for k, v_2 in pairs(self._members) do
		if not table.find(get_members, k) then
			self._members_left[#self._members_left + 1] = k

			print("[LoadTimeManager] Member left")

			flag = true
		end
	end

	if not flag then
		table.clear(self._members)

		for i_2, v_3 in ipairs(get_members) do
			self._members[v_3] = true
		end
	end
end

local tbl = {}

LoadTimeManager.end_timer = function (self)
	-- function 6
	table.clear(tbl)

	local str = "unknown"

	if not Managers.state.game_mode then
		str = Managers.state.game_mode:level_key()
	end

	local local_player = Managers.player:local_player()
	local is_server

	if not local_player then
		is_server = local_player.is_server

		if not is_server then
			-- Nothing
		end
	end

	is_server = "unknown"

	::label_6_0::

	local _previous_level_key = self._previous_level_key
	local time = Managers.time:time("loading_timer")

	time = time or 0

	local floor = math.floor(time % 60 + 0.5)
	local floor_2 = math.floor(time / 60)
	local floor_3 = math.floor(floor_2 / 60)
	local format = string.format("%02d:%02d:%02d", floor_3, floor_2, floor)

	print("#################################################################################################################")
	print(string.format("[Loading Time]: %s [Transition]: %s-%s  [Members joined]: %s [Members Left]: %s [Is Server]: %s", format, _previous_level_key, str, tostring(#self._members_joined), tostring(#self._members_left), tostring(is_server)))
	print("#################################################################################################################")

	tbl.identifier = "load-level"
	tbl.duration = tonumber(string.format("%.2f", time))
	tbl.parameters = {
		from_level = _previous_level_key,
		to_level = str,
		end_reason = self._end_reason,
		time_spent_in_level = self._time_spent_in_level,
		members_joined = #self._members_joined,
		members_left = #self._members_left,
		lobby_failed = self._lobby_failed,
		is_server = is_server
	}

	BackendUtils.commit_load_time_data(tbl)

	self._previous_level_key = str
	self._current_lobby = nil
	self._lobby_failed = false
end

LoadTimeManager.destroy = function (self)
	-- function 7
	if not Managers.time and not Managers.time:has_timer("loading_timer") then
		Managers.time:unregister_timer("loading_timer")
	end

	self._current_lobby = nil
	self._lobby_failed = false

	table.clear(self._members_joined)
	table.clear(self._members_left)
	table.clear(self._members)
end
