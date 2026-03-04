-- chunkname: @scripts/managers/conflict_director/pacing.lua

Pacing = class(Pacing)
script_data.debug_ai_pacing = script_data.debug_ai_pacing or Development.parameter("debug_ai_pacing")
script_data.debug_player_intensity = script_data.debug_player_intensity or Development.parameter("debug_player_intensity")

local var_0_0 = CurrentPacing or nil

Pacing.init = function (arg_1_0, arg_1_1)
	arg_1_0.world = arg_1_1
	arg_1_0.pacing_state = "pacing_build_up"
	arg_1_0._threat_population = 1
	arg_1_0._specials_population = 1
	arg_1_0._horde_population = 1
	arg_1_0._state_start_time = 0
	arg_1_0.total_intensity = 0
	arg_1_0.player_intensity = {}
	var_0_0 = _G.CurrentPacing
end

Pacing.disable = function (arg_2_0)
	arg_2_0._threat_population = 1
	arg_2_0._specials_population = 0
	arg_2_0._horde_population = 0
	arg_2_0.pacing_state = "pacing_frozen"
end

Pacing.enable = function (arg_3_0)
	arg_3_0._threat_population = 1
	arg_3_0._specials_population = 1
	arg_3_0._horde_population = 1
	arg_3_0.pacing_state = "pacing_build_up"
end

Pacing.disable_roamers = function (arg_4_0)
	arg_4_0._threat_population = 0
end

Pacing.enable_hordes = function (arg_5_0, arg_5_1)
	arg_5_0._horde_population = arg_5_1 and 1 or 0
end

Pacing.pacing_frozen = function (arg_6_0, arg_6_1)
	return
end

Pacing.pacing_build_up = function (arg_7_0, arg_7_1)
	if arg_7_0.total_intensity > var_0_0.peak_intensity_threshold then
		arg_7_0:advance_pacing(arg_7_1)
	end
end

Pacing.pacing_sustain_peak = function (arg_8_0, arg_8_1)
	if arg_8_1 > arg_8_0._end_pacing_time then
		arg_8_0:advance_pacing(arg_8_1)
	end
end

Pacing.pacing_peak_fade = function (arg_9_0, arg_9_1)
	if arg_9_0.total_intensity < var_0_0.peak_fade_threshold then
		arg_9_0:advance_pacing(arg_9_1)
	end
end

Pacing.pacing_relax = function (arg_10_0, arg_10_1)
	if var_0_0.leave_relax_if_zero_intensity and arg_10_0.total_intensity <= 0 then
		arg_10_0:advance_pacing(arg_10_1)

		return
	end

	if arg_10_1 > arg_10_0._end_pacing_time then
		arg_10_0:advance_pacing(arg_10_1)
	end
end

Pacing.get_pacing_data = function (arg_11_0)
	return arg_11_0.pacing_state, arg_11_0._state_start_time, arg_11_0._threat_population, arg_11_0._specials_population, arg_11_0._horde_population, arg_11_0._end_pacing_time
end

Pacing.ignore_pacing_intensity_decay_delay = function (arg_12_0)
	return arg_12_0.pacing_state == "pacing_relax"
end

Pacing.get_state = function (arg_13_0)
	return arg_13_0.pacing_state
end

Pacing.threat_population = function (arg_14_0)
	return arg_14_0._threat_population
end

Pacing.horde_population = function (arg_15_0)
	return arg_15_0._horde_population
end

Pacing.specials_population = function (arg_16_0)
	return arg_16_0._specials_population
end

Pacing.enemy_killed = function (arg_17_0, arg_17_1, arg_17_2)
	for iter_17_0 = 1, #arg_17_2 do
		local var_17_0 = arg_17_2[iter_17_0]
		local var_17_1 = Unit.local_position(arg_17_1, 0)
		local var_17_2 = Unit.local_position(var_17_0, 0)
		local var_17_3 = Vector3.distance(var_17_1, var_17_2)
		local var_17_4

		if var_17_3 > 0 then
			var_17_4 = 1 / var_17_3 * CurrentIntensitySettings.intensity_add_nearby_kill
		else
			var_17_4 = CurrentIntensitySettings.intensity_add_nearby_kill
		end

		ScriptUnit.extension(var_17_0, "status_system"):add_pacing_intensity(var_17_4)
	end
end

Pacing.advance_pacing = function (arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0.pacing_state
	local var_18_1

	arg_18_0._end_pacing_time = nil

	if var_18_0 == "pacing_build_up" then
		var_18_1 = "pacing_sustain_peak"
		arg_18_0._end_pacing_time = arg_18_1 + ConflictUtils.random_interval(var_0_0.sustain_peak_duration)
		arg_18_0._threat_population = 1
		arg_18_0._specials_population = 1
		arg_18_0._horde_population = 1
	elseif var_18_0 == "pacing_sustain_peak" then
		var_18_1 = "pacing_peak_fade"
		arg_18_0._threat_population = 0
		arg_18_0._specials_population = 0
		arg_18_0._horde_population = 0
	elseif var_18_0 == "pacing_peak_fade" then
		var_18_1 = "pacing_relax"
		arg_18_0._end_pacing_time = arg_18_1 + ConflictUtils.random_interval(var_0_0.relax_duration)
		arg_18_0._threat_population = 1
		arg_18_0._specials_population = 0
		arg_18_0._horde_population = 0

		Managers.state.conflict:going_to_relax_state()
		Managers.state.conflict:init_rush_check(arg_18_1)
	elseif var_18_0 == "pacing_relax" then
		var_18_1 = "pacing_build_up"
		arg_18_0._threat_population = 1
		arg_18_0._specials_population = 1
		arg_18_0._horde_population = 1

		Managers.state.conflict.specials_pacing:delay_spawning(arg_18_1, 10, math.random(5, 10))
		Managers.state.conflict:stop_rush_check()
	end

	if script_data.debug_player_intensity then
		arg_18_0:annotate_graph(var_18_1, "orange")

		if arg_18_2 then
			arg_18_0:annotate_graph(arg_18_2, "firebrick")
		end
	end

	if arg_18_0.pacing_state ~= var_18_1 then
		local var_18_2 = NetworkLookup.pacing[var_18_1]

		Managers.state.network.network_transmit:send_rpc_all("rpc_pacing_changed", var_18_2)
	end

	arg_18_0.pacing_state = var_18_1
	arg_18_0._state_start_time = arg_18_1
end

Pacing.update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	local var_19_0 = #arg_19_3

	if var_19_0 == 0 then
		return
	end

	arg_19_0[arg_19_0.pacing_state](arg_19_0, arg_19_1)

	local var_19_1 = 0

	for iter_19_0 = 1, var_19_0 do
		local var_19_2 = arg_19_3[iter_19_0]
		local var_19_3 = ScriptUnit.extension(var_19_2, "status_system"):get_pacing_intensity()

		arg_19_0.player_intensity[iter_19_0] = var_19_3
		var_19_1 = var_19_1 + var_19_3
	end

	arg_19_0.total_intensity = var_19_1 / var_19_0
end

Pacing.toggle_graph = function (arg_20_0)
	if arg_20_0.graph then
		arg_20_0.graph:set_active(not arg_20_0.graph.active)
	end
end

Pacing.show_debug = function (arg_21_0, arg_21_1)
	if not arg_21_0.graph then
		return false
	end

	if arg_21_1 then
		arg_21_0.graph:set_active(true)
	else
		arg_21_0.graph:set_active(false)
	end

	return true
end

Pacing.debug_add_intensity = function (arg_22_0, arg_22_1, arg_22_2)
	for iter_22_0 = 1, #arg_22_1 do
		local var_22_0 = arg_22_1[iter_22_0]

		ScriptUnit.extension(var_22_0, "status_system"):add_pacing_intensity(arg_22_2)
	end
end

local var_0_1 = 120
local var_0_2 = {
	"player1",
	"player2",
	"player3",
	"player4"
}

Pacing.intensity_graphs = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	if script_data.debug_player_intensity then
		local var_23_0 = arg_23_0.graph

		if not var_23_0 then
			arg_23_0.graph = Managers.state.debug.graph_drawer:create_graph("intensity", {
				"time",
				"intensity"
			})
			arg_23_0.graph.visual_frame.y_max = 100
			arg_23_0.graph.scroll_lock.vertical = false
			arg_23_0.graph.scroll_lock.left = false
			var_23_0 = arg_23_0.graph

			var_23_0:set_plot_color("rats", "blue", "blue")
			var_23_0:set_plot_color("sum", "red", "red")
		end

		local var_23_1 = arg_23_0.total_intensity

		var_23_0:add_point(arg_23_1, var_23_1, "sum")

		arg_23_0.graph.visual_frame.x_min = arg_23_1 - var_0_1

		for iter_23_0 = 1, #arg_23_3 do
			local var_23_2 = arg_23_0.player_intensity[iter_23_0]

			var_23_0:add_point(arg_23_1, var_23_2, var_0_2[iter_23_0])
		end

		local var_23_3 = Managers.state.conflict:count_units_by_breed("skaven_clan_rat")

		var_23_0:add_point(arg_23_1, var_23_3, "rats")
	elseif arg_23_0.graph then
		Managers.state.debug.graph_drawer:destroy_graph(arg_23_0.graph)

		arg_23_0.graph = nil
	end
end

local var_0_3 = 70

Pacing.annotate_graph = function (arg_24_0, arg_24_1, arg_24_2)
	if not arg_24_0.graph then
		return
	end

	var_0_3 = var_0_3 - 6

	if var_0_3 <= 30 then
		var_0_3 = 70
	end

	local var_24_0 = Managers.time:time("game")

	arg_24_0.graph:add_annotation({
		live = true,
		x = var_24_0,
		y = var_0_3,
		text = arg_24_1,
		color = arg_24_2 or "orange"
	})
end

Pacing.get_pacing_intensity = function (arg_25_0)
	return arg_25_0.total_intensity, arg_25_0.player_intensity
end

Pacing.get_roaming_density = function (arg_26_0)
	return 0.5
end
