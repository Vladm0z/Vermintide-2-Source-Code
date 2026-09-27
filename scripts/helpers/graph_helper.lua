-- chunkname: @scripts/helpers/graph_helper.lua

local GraphHelper = GraphHelper

GraphHelper = GraphHelper or {}
GraphHelper = GraphHelper

local GraphHelper_2 = GraphHelper
local _known_stats = GraphHelper._known_stats

_known_stats = _known_stats or {}
GraphHelper_2._known_stats = _known_stats

local GraphHelper_3 = GraphHelper
local _known_graphs = GraphHelper._known_graphs

_known_graphs = _known_graphs or {}
GraphHelper_3._known_graphs = _known_graphs

local BUILD = BUILD
local console_command = Application.console_command
local record_statistics = Profiler.record_statistics

if not (console_command == nil or BUILD ~= "release") then
	function console_command()
		-- function 1
		return
	end
end

if not (record_statistics == nil or BUILD ~= "release") then
	function record_statistics()
		-- function 2
		return
	end
end

GraphHelper.create = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	if GraphHelper._known_graphs[arg_3_0] ~= nil then
		return
	end

	console_command("graph", "make", arg_3_0)

	for i = 1, #(arg_3_1 or {}) do
		local var_3_0 = arg_3_1[i]

		if GraphHelper._known_stats[var_3_0] == nil then
			record_statistics(var_3_0, 0)
			console_command("graph", "add", arg_3_0, var_3_0)
			record_statistics(var_3_0, 0)

			GraphHelper._known_stats[var_3_0] = "number"
		end
	end

	for j = 1, #(arg_3_2 or {}) do
		local var_3_1 = arg_3_2[j]

		if GraphHelper._known_stats[var_3_1] == nil then
			record_statistics(var_3_1, Vector3.zero())
			console_command("graph", "add_vector3", arg_3_0, var_3_1)
			record_statistics(var_3_1, Vector3.zero())

			GraphHelper._known_stats[var_3_1] = "userdata"
		end
	end

	console_command("graph", "show", arg_3_0)
end

GraphHelper.show = function (arg_4_0)
	-- function 4
	console_command("graph", "show", arg_4_0)
end

GraphHelper.hide = function (arg_5_0)
	-- function 5
	console_command("graph", "hide", arg_5_0)
end

GraphHelper.set_range = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	console_command("graph", "range", arg_6_0, tostring(arg_6_1), tostring(arg_6_2))
end

GraphHelper.update_range = function (arg_7_0)
	-- function 7
	console_command("graph", "range", arg_7_0)
end

GraphHelper.set_color = function (arg_8_0, arg_8_1)
	-- function 8
	console_command("graph", "color", arg_8_1)
end

GraphHelper.record_statistics = function (arg_9_0, arg_9_1)
	-- function 9
	assert(GraphHelper._known_stats[arg_9_0] == type(arg_9_1))
	record_statistics(arg_9_0, arg_9_1)
end
