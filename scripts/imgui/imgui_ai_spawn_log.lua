-- chunkname: @scripts/imgui/imgui_ai_spawn_log.lua

ImguiAISpawnLog = class(ImguiAISpawnLog)

local flag = false

local function fn(arg_1_0)
	-- function 1
	return string.format("%06.3f", arg_1_0)
end

local num = 1
local num_2 = 2
local num_3 = 3
local num_4 = 6
local num_5 = 7
local num_6 = 8
local num_7 = 9

ImguiAISpawnLog.init = function (self)
	-- function 2
	self._log = {}
	self._player_positions = {}
	self._timeline_slice_size = 1
	self._timeline_slice_end = 1
	self._show_totals = false
	self._visualize_locations = false
	self._sticky_hover = false
	self._keep_on_screen = false
	self._live_log = true
	self._live_log_size = 20
	self._segment_distance_sq = 25
	self._event_type_names = {
		"queued",
		"canceled",
		"spawned"
	}
	self._specials_only = false
	self._drawer = nil
	self._hero_side = nil
	self._totals = {}
	self._hovered_id = -1
	self._hovered_time = -1

	self:register_events()
end

ImguiAISpawnLog.register_events = function (arg_3_0)
	-- function 3
	local event = Managers.state.event

	if not event then
		event:register(arg_3_0, "spawn_log_queue", "log_queue")
		event:register(arg_3_0, "spawn_log_spawn", "log_spawn")
	end
end

ImguiAISpawnLog.unregister_events = function (arg_4_0)
	-- function 4
	local event = Managers.state.event

	if not event then
		event:unregister("spawn_log_queue", arg_4_0)
		event:unregister("spawn_log_spawn", arg_4_0)
	end
end

ImguiAISpawnLog.update = function (self)
	-- function 5
	if not flag then
		self:unregister_events()
		self:init()

		flag = false
	end

	local time = Managers.time:time("game")

	if not time then
		self:_reset()

		return
	end

	if not self._drawer then
		self:_init_session()
	end

	self:_log_player_positions(time)

	if not self._visualize_locations and not self._drawer then
		self:_visualise_player_pos()
	end
end

ImguiAISpawnLog.is_persistent = function (self)
	-- function 6
	return self._keep_on_screen
end

ImguiAISpawnLog.draw = function (self)
	-- function 7
	local time = Managers.time:time("game")

	if not time then
		return
	end

	local begin_window = Imgui.begin_window("AI Spawn Log")

	if not Imgui.button("Export Log") then
		self:_export_log_data()
	end

	self._show_totals = Imgui.checkbox("Show Totals", self._show_totals)
	self._keep_on_screen = Imgui.checkbox("Keep On Screen", self._keep_on_screen)
	self._visualize_locations = Imgui.checkbox("Visualize Locaitons", self._visualize_locations)
	self._sticky_hover = Imgui.checkbox("Sticky Hover", self._sticky_hover)
	self._live_log = Imgui.checkbox("Live Log", self._live_log)
	self._specials_only = Imgui.checkbox("Specials Only", self._specials_only)

	if not self._live_log then
		self._timeline_end = time
	end

	self._timeline_slice_size = Imgui.slider_float("Capture Size", self._timeline_slice_size, 1, 120)
	self._timeline_end = math.max(self._timeline_end, self._timeline_slice_size)
	self._timeline_end = Imgui.slider_float("Capture Location", self._timeline_end, self._timeline_slice_size, time)

	if not self._show_totals then
		Imgui.begin_window("AI Spawn Totals")

		if not Imgui.button("Export") then
			self:_export_recap_data()
		end

		local count = #self._event_type_names
		local str = "Legend -" .. string.rep(" %s,", count)

		Imgui.text(string.format(str, unpack(self._event_type_names)))

		local str_2 = "%32s -" .. string.rep(" %d,", count)

		for k, v in pairs(self._totals) do
			Imgui.text(string.format(str_2, k, unpack(v)))
		end

		Imgui.end_window()
	end

	if not Imgui.button("Clear") then
		self:_clear()
	end

	Imgui.separator()

	local _event_type_names = self._event_type_names
	local _visualize_locations = self._visualize_locations
	local var_7_7 = Color(255, 0, 0)
	local tbl = {
		255,
		255,
		255
	}
	local tbl_2 = {
		255,
		0,
		0
	}
	local _specials_only = self._specials_only
	local num_8 = self._timeline_end - self._timeline_slice_size
	local _timeline_end = self._timeline_end
	local _hovered_id

	if not self._sticky_hover then
		_hovered_id = self._hovered_id

		if not _hovered_id then
			-- Nothing
		end
	end

	_hovered_id = -1

	do
		local _hovered_time
	end

	::label_7_0::

	if not self._sticky_hover then
		_hovered_time = self._hovered_time

		if not _hovered_time then
			-- Nothing
		end
	end

	_hovered_time = -1

	::label_7_1::

	local _hovered_id_2 = self._hovered_id

	for k_2 = 1, #self._log do
		local var_7_16 = self._log[k_2]
		local var_7_17 = var_7_16[num_2]

		if not (not (num_8 <= var_7_17) or not (var_7_17 <= _timeline_end)) then
			local var_7_18 = var_7_16[num_4]

			if not _specials_only and not var_7_18 and not var_7_18.special then
				local var_7_19 = fn(var_7_17)
				local var_7_20 = _event_type_names[var_7_16[num]]
				local str_3 = var_7_19 .. " " .. var_7_20
				local flag = not var_7_18 and var_7_18.name
				local str_4 = str_3 .. " " .. tostring(flag)
				local var_7_24 = var_7_16[num_5]
				local str_5 = str_4 .. " " .. tostring(var_7_24)
				local var_7_26 = var_7_16[num_6]
				local str_6 = str_5 .. " " .. tostring(var_7_26)
				local var_7_28 = var_7_16[num_7]
				local str_7 = str_6 .. " " .. tostring(var_7_28)
				local flag_2 = _hovered_id_2 == var_7_28
				local flag_3 = not flag_2 and tbl_2 and tbl

				Imgui.text_colored(str_7, flag_3[1], flag_3[2], flag_3[3], 255)

				if not Imgui.is_item_hovered() then
					_hovered_id = var_7_28
					_hovered_time = var_7_17
				end

				if not (not _visualize_locations and not self._drawer and _hovered_id_2 == -1 or _hovered_id ~= var_7_28) then
					local var_7_32 = Vector3(var_7_16[num_3], var_7_16[num_3 + 1], var_7_16[num_3 + 2])

					self._drawer:sphere(var_7_32, 1, var_7_7)

					if not flag_2 then
						self._drawer:line(var_7_32, var_7_32 + Vector3(0, 0, 25), var_7_7)
					end
				end
			end
		end
	end

	self._hovered_id = _hovered_id
	self._hovered_time = _hovered_time

	Imgui.end_window("AI Spawn Log")

	return begin_window
end

ImguiAISpawnLog.log_queue = function (self, ...)
	-- function 8
	self:_log_event(1, ...)
end

ImguiAISpawnLog.log_queue_cancel = function (self, ...)
	-- function 9
	self:_log_event(2, ...)
end

ImguiAISpawnLog.log_spawn = function (self, ...)
	-- function 10
	self:_log_event(3, ...)
end

ImguiAISpawnLog._log_event = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
	-- function 11
	local flag = not arg_11_2 and arg_11_2:unbox()
	local time = Managers.time:time("game")
	local tbl = {
		arg_11_1,
		time
	}
	local x

	if not flag then
		x = flag.x

		if not x then
			-- Nothing
		end
	end

	x = 0

	::label_11_0::

	tbl[3] = x

	local y

	if not flag then
		y = flag.y

		if not y then
			-- Nothing
		end
	end

	y = 0

	::label_11_1::

	tbl[4] = y

	local z

	if not flag then
		z = flag.z

		if not z then
			-- Nothing
		end
	end

	z = 0

	::label_11_2::

	tbl[5] = z
	tbl[6] = arg_11_3
	tbl[7] = arg_11_4
	tbl[8] = arg_11_5
	tbl[9] = arg_11_6

	if not arg_11_3 then
		if not self._totals[arg_11_3.name] then
			self._totals[arg_11_3.name] = {}

			for i = 1, #self._event_type_names do
				self._totals[arg_11_3.name][i] = 0
			end
		end

		self._totals[arg_11_3.name][arg_11_1] = self._totals[arg_11_3.name][arg_11_1] + 1
	end

	table.insert(self._log, 1, tbl)
end

ImguiAISpawnLog._clear = function (self)
	-- function 12
	self._log = {}
	self._player_positions = {}
	self._totals = {}
end

ImguiAISpawnLog._reset = function (self)
	-- function 13
	self._drawer = nil
	self._hero_side = nil

	self:_clear()
end

ImguiAISpawnLog._init_session = function (self)
	-- function 14
	local state = Managers.state

	if not state then
		self:register_events()

		self._drawer = state.debug:drawer({
			mode = "immediate",
			name = "ImguiAISpawnLog"
		})
		self._hero_side = state.side:get_side_from_name("heroes")
	end
end

ImguiAISpawnLog._log_player_positions = function (self, arg_15_1)
	-- function 15
	local _hero_side = self._hero_side

	if not _hero_side then
		local PLAYER_AND_BOT_UNITS = _hero_side.PLAYER_AND_BOT_UNITS
		local PLAYER_AND_BOT_POSITIONS = _hero_side.PLAYER_AND_BOT_POSITIONS
		local _segment_distance_sq = self._segment_distance_sq

		for i = 1, #PLAYER_AND_BOT_UNITS do
			local var_15_4 = PLAYER_AND_BOT_UNITS[i]
			local var_15_5 = PLAYER_AND_BOT_POSITIONS[i]

			if not self._player_positions[var_15_4] then
				self._player_positions[var_15_4] = {
					arg_15_1,
					var_15_5.x,
					var_15_5.y,
					var_15_5.z
				}
			else
				local var_15_6 = self._player_positions[var_15_4]
				local count = #var_15_6
				local var_15_8 = var_15_6[count - 2]
				local var_15_9 = var_15_6[count - 1]
				local var_15_10 = var_15_6[count]

				if _segment_distance_sq <= Vector3.distance_squared(var_15_5, Vector3(var_15_8, var_15_9, var_15_10)) then
					var_15_6[count + 1] = arg_15_1
					var_15_6[count + 2] = var_15_5.x
					var_15_6[count + 3] = var_15_5.y
					var_15_6[count + 4] = var_15_5.z
				end
			end
		end
	end
end

ImguiAISpawnLog._visualise_player_pos = function (self)
	-- function 16
	local num = self._timeline_end - self._timeline_slice_size
	local _timeline_end = self._timeline_end
	local var_16_2 = Color(0, 255, 0)
	local var_16_3 = Color(255, 255, 0)
	local _hovered_time = self._hovered_time

	for k, v in pairs(self._player_positions) do
		local num_2 = 1
		local num_3 = 1

		for k_2 = 1, #v, 4 do
			local var_16_7 = v[k_2]

			if var_16_7 < num then
				num_2 = k_2
				num_3 = k_2
			elseif _timeline_end < var_16_7 then
				num_3 = k_2

				break
			else
				num_3 = k_2
			end
		end

		for l = num_2, num_3, 4 do
			local var_16_8 = Vector3(v[l + 1], v[l + 2], v[l + 3])

			self._drawer:sphere(var_16_8, 1, var_16_2)

			if num_3 >= l + 4 then
				local var_16_9 = Vector3(v[l + 5], v[l + 6], v[l + 7])

				self._drawer:arrow_2d(var_16_8, var_16_9, var_16_2)

				if not (not (_hovered_time >= v[l]) or not (_hovered_time <= v[l + 4])) then
					local num_4 = (_hovered_time - v[l]) / (v[l + 4] - v[l])
					local lerp = Vector3.lerp(var_16_8, var_16_9, num_4)

					self._drawer:sphere(lerp, 1, var_16_3)
					self._drawer:line(lerp, lerp + Vector3(0, 0, 25), var_16_3)
				end
			end
		end
	end
end

ImguiAISpawnLog._export_recap_data = function (self)
	-- function 17
	local str = "Breed,Faction,Count"

	for k, v in pairs(self._totals) do
		local var_17_1 = Breeds[k]
		local race

		if not var_17_1 then
			race = var_17_1.race

			if not race then
				-- Nothing
			end
		end

		race = "unknown"

		::label_17_0::

		str = str .. "\n"
		str = str .. k .. ","
		str = str .. race .. ","
		str = str .. tostring(v[3])
	end

	Clipboard.put(str)
end

ImguiAISpawnLog._export_log_data = function (self)
	-- function 18
	local _event_type_names = self._event_type_names
	local str = "Breed,Faction,Spawn Category,Spawn Type"

	for i = 1, #self._log do
		local var_18_2 = self._log[i]

		if _event_type_names[var_18_2[num]] == "spawned" then
			str = str .. "\n"

			local var_18_3 = var_18_2[num_4]
			local name

			if not var_18_3 then
				name = var_18_3.name

				if not name then
					-- Nothing
				end
			end

			name = "unknown"

			do
				local race
			end

			::label_18_0::

			if not var_18_3 then
				race = var_18_3.race

				if not race then
					-- Nothing
				end
			end

			race = "unknown"

			::label_18_1::

			str = str .. name .. ","
			str = str .. race .. ","

			local var_18_6 = var_18_2[num_5]

			str = str .. tostring(var_18_6) .. ","

			local var_18_7 = var_18_2[num_6]

			str = str .. tostring(var_18_7)
		end
	end

	Clipboard.put(str)
end
