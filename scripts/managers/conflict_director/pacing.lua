-- chunkname: @scripts/managers/conflict_director/pacing.lua

Pacing = class(Pacing)

local script_data = script_data
local debug_ai_pacing = script_data.debug_ai_pacing

debug_ai_pacing = debug_ai_pacing or Development.parameter("debug_ai_pacing")
script_data.debug_ai_pacing = debug_ai_pacing

local script_data_2 = script_data
local debug_player_intensity = script_data.debug_player_intensity

debug_player_intensity = debug_player_intensity or Development.parameter("debug_player_intensity")
script_data_2.debug_player_intensity = debug_player_intensity

local CurrentPacing = CurrentPacing

CurrentPacing = CurrentPacing or nil

Pacing.init = function (self, arg_1_1)
	-- function 1
	self.world = arg_1_1
	self.pacing_state = "pacing_build_up"
	self._threat_population = 1
	self._specials_population = 1
	self._horde_population = 1
	self._state_start_time = 0
	self.total_intensity = 0
	self.player_intensity = {}
	CurrentPacing = _G.CurrentPacing
end

Pacing.disable = function (self)
	-- function 2
	self._threat_population = 1
	self._specials_population = 0
	self._horde_population = 0
	self.pacing_state = "pacing_frozen"
end

Pacing.enable = function (self)
	-- function 3
	self._threat_population = 1
	self._specials_population = 1
	self._horde_population = 1
	self.pacing_state = "pacing_build_up"
end

Pacing.disable_roamers = function (self)
	-- function 4
	self._threat_population = 0
end

Pacing.enable_hordes = function (self, arg_5_1)
	-- function 5
	local flag

	flag = not arg_5_1 and 1 and 0
	self._horde_population = flag
end

Pacing.pacing_frozen = function (arg_6_0, arg_6_1)
	-- function 6
	return
end

Pacing.pacing_build_up = function (self, arg_7_1)
	-- function 7
	if self.total_intensity > CurrentPacing.peak_intensity_threshold then
		self:advance_pacing(arg_7_1)
	end
end

Pacing.pacing_sustain_peak = function (self, arg_8_1)
	-- function 8
	if arg_8_1 > self._end_pacing_time then
		self:advance_pacing(arg_8_1)
	end
end

Pacing.pacing_peak_fade = function (self, arg_9_1)
	-- function 9
	if self.total_intensity < CurrentPacing.peak_fade_threshold then
		self:advance_pacing(arg_9_1)
	end
end

Pacing.pacing_relax = function (self, arg_10_1)
	-- function 10
	if not (not CurrentPacing.leave_relax_if_zero_intensity and not (self.total_intensity <= 0)) then
		self:advance_pacing(arg_10_1)

		return
	end

	if arg_10_1 > self._end_pacing_time then
		self:advance_pacing(arg_10_1)
	end
end

Pacing.get_pacing_data = function (self)
	-- function 11
	return self.pacing_state, self._state_start_time, self._threat_population, self._specials_population, self._horde_population, self._end_pacing_time
end

Pacing.ignore_pacing_intensity_decay_delay = function (self)
	-- function 12
	return self.pacing_state == "pacing_relax"
end

Pacing.get_state = function (self)
	-- function 13
	return self.pacing_state
end

Pacing.threat_population = function (self)
	-- function 14
	return self._threat_population
end

Pacing.horde_population = function (self)
	-- function 15
	return self._horde_population
end

Pacing.specials_population = function (self)
	-- function 16
	return self._specials_population
end

Pacing.enemy_killed = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	for i = 1, #arg_17_2 do
		local var_17_0 = arg_17_2[i]
		local local_position = Unit.local_position(arg_17_1, 0)
		local local_position_2 = Unit.local_position(var_17_0, 0)
		local distance = Vector3.distance(local_position, local_position_2)
		local var_17_4

		if distance > 0 then
			var_17_4 = 1 / distance * CurrentIntensitySettings.intensity_add_nearby_kill
		else
			var_17_4 = CurrentIntensitySettings.intensity_add_nearby_kill
		end

		ScriptUnit.extension(var_17_0, "status_system"):add_pacing_intensity(var_17_4)
	end
end

Pacing.advance_pacing = function (self, arg_18_1, arg_18_2)
	-- function 18
	local pacing_state = self.pacing_state
	local var_18_1

	self._end_pacing_time = nil

	if pacing_state == "pacing_build_up" then
		var_18_1 = "pacing_sustain_peak"
		self._end_pacing_time = arg_18_1 + ConflictUtils.random_interval(CurrentPacing.sustain_peak_duration)
		self._threat_population = 1
		self._specials_population = 1
		self._horde_population = 1
	elseif pacing_state == "pacing_sustain_peak" then
		var_18_1 = "pacing_peak_fade"
		self._threat_population = 0
		self._specials_population = 0
		self._horde_population = 0
	elseif pacing_state == "pacing_peak_fade" then
		var_18_1 = "pacing_relax"
		self._end_pacing_time = arg_18_1 + ConflictUtils.random_interval(CurrentPacing.relax_duration)
		self._threat_population = 1
		self._specials_population = 0
		self._horde_population = 0

		Managers.state.conflict:going_to_relax_state()
		Managers.state.conflict:init_rush_check(arg_18_1)
	elseif pacing_state == "pacing_relax" then
		var_18_1 = "pacing_build_up"
		self._threat_population = 1
		self._specials_population = 1
		self._horde_population = 1

		Managers.state.conflict.specials_pacing:delay_spawning(arg_18_1, 10, math.random(5, 10))
		Managers.state.conflict:stop_rush_check()
	end

	if not script_data.debug_player_intensity then
		self:annotate_graph(var_18_1, "orange")

		if not arg_18_2 then
			self:annotate_graph(arg_18_2, "firebrick")
		end
	end

	if self.pacing_state ~= var_18_1 then
		local var_18_2 = NetworkLookup.pacing[var_18_1]

		Managers.state.network.network_transmit:send_rpc_all("rpc_pacing_changed", var_18_2)
	end

	self.pacing_state = var_18_1
	self._state_start_time = arg_18_1
end

Pacing.update = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	local count = #arg_19_3

	if count == 0 then
		return
	end

	self[self.pacing_state](self, arg_19_1)

	local num = 0

	for i = 1, count do
		local var_19_2 = arg_19_3[i]
		local get_pacing_intensity = ScriptUnit.extension(var_19_2, "status_system"):get_pacing_intensity()

		self.player_intensity[i] = get_pacing_intensity
		num = num + get_pacing_intensity
	end

	self.total_intensity = num / count
end

Pacing.toggle_graph = function (self)
	-- function 20
	if not self.graph then
		self.graph:set_active(not self.graph.active)
	end
end

Pacing.show_debug = function (self, arg_21_1)
	-- function 21
	if not self.graph then
		return false
	end

	if not arg_21_1 then
		self.graph:set_active(true)
	else
		self.graph:set_active(false)
	end

	return true
end

Pacing.debug_add_intensity = function (arg_22_0, arg_22_1, arg_22_2)
	-- function 22
	for i = 1, #arg_22_1 do
		local var_22_0 = arg_22_1[i]

		ScriptUnit.extension(var_22_0, "status_system"):add_pacing_intensity(arg_22_2)
	end
end

local num = 120
local tbl = {
	"player1",
	"player2",
	"player3",
	"player4"
}

Pacing.intensity_graphs = function (self, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	if not script_data.debug_player_intensity then
		local graph = self.graph

		if not graph then
			self.graph = Managers.state.debug.graph_drawer:create_graph("intensity", {
				"time",
				"intensity"
			})
			self.graph.visual_frame.y_max = 100
			self.graph.scroll_lock.vertical = false
			self.graph.scroll_lock.left = false
			graph = self.graph

			graph:set_plot_color("rats", "blue", "blue")
			graph:set_plot_color("sum", "red", "red")
		end

		local total_intensity = self.total_intensity

		graph:add_point(arg_23_1, total_intensity, "sum")

		self.graph.visual_frame.x_min = arg_23_1 - num

		for i = 1, #arg_23_3 do
			local var_23_2 = self.player_intensity[i]

			graph:add_point(arg_23_1, var_23_2, tbl[i])
		end

		local count_units_by_breed = Managers.state.conflict:count_units_by_breed("skaven_clan_rat")

		graph:add_point(arg_23_1, count_units_by_breed, "rats")
	elseif not self.graph then
		Managers.state.debug.graph_drawer:destroy_graph(self.graph)

		self.graph = nil
	end
end

local num_2 = 70

Pacing.annotate_graph = function (self, arg_24_1, arg_24_2)
	-- function 24
	if not self.graph then
		return
	end

	num_2 = num_2 - 6

	if num_2 <= 30 then
		num_2 = 70
	end

	local time = Managers.time:time("game")

	self.graph:add_annotation({
		live = true,
		x = time,
		y = num_2,
		text = arg_24_1,
		color = arg_24_2 or "orange"
	})
end

Pacing.get_pacing_intensity = function (self)
	-- function 25
	return self.total_intensity, self.player_intensity
end

Pacing.get_roaming_density = function (arg_26_0)
	-- function 26
	return 0.5
end
