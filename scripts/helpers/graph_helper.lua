-- chunkname: @scripts/helpers/graph_helper.lua

GraphHelper = GraphHelper or {}
GraphHelper._known_stats = GraphHelper._known_stats or {}
GraphHelper._known_graphs = GraphHelper._known_graphs or {}

local var_0_0 = BUILD
local var_0_1 = Application.console_command
local var_0_2 = Profiler.record_statistics

if var_0_1 == nil or var_0_0 == "release" then
	function var_0_1()
		return
	end
end

if var_0_2 == nil or var_0_0 == "release" then
	function var_0_2()
		return
	end
end

GraphHelper.create = function (arg_3_0, arg_3_1, arg_3_2)
	if GraphHelper._known_graphs[arg_3_0] ~= nil then
		return
	end

	var_0_1("graph", "make", arg_3_0)

	for iter_3_0 = 1, #(arg_3_1 or {}) do
		local var_3_0 = arg_3_1[iter_3_0]

		if GraphHelper._known_stats[var_3_0] == nil then
			var_0_2(var_3_0, 0)
			var_0_1("graph", "add", arg_3_0, var_3_0)
			var_0_2(var_3_0, 0)

			GraphHelper._known_stats[var_3_0] = "number"
		end
	end

	for iter_3_1 = 1, #(arg_3_2 or {}) do
		local var_3_1 = arg_3_2[iter_3_1]

		if GraphHelper._known_stats[var_3_1] == nil then
			var_0_2(var_3_1, Vector3.zero())
			var_0_1("graph", "add_vector3", arg_3_0, var_3_1)
			var_0_2(var_3_1, Vector3.zero())

			GraphHelper._known_stats[var_3_1] = "userdata"
		end
	end

	var_0_1("graph", "show", arg_3_0)
end

GraphHelper.show = function (arg_4_0)
	var_0_1("graph", "show", arg_4_0)
end

GraphHelper.hide = function (arg_5_0)
	var_0_1("graph", "hide", arg_5_0)
end

GraphHelper.set_range = function (arg_6_0, arg_6_1, arg_6_2)
	var_0_1("graph", "range", arg_6_0, tostring(arg_6_1), tostring(arg_6_2))
end

GraphHelper.update_range = function (arg_7_0)
	var_0_1("graph", "range", arg_7_0)
end

GraphHelper.set_color = function (arg_8_0, arg_8_1)
	var_0_1("graph", "color", arg_8_1)
end

GraphHelper.record_statistics = function (arg_9_0, arg_9_1)
	assert(GraphHelper._known_stats[arg_9_0] == type(arg_9_1))
	var_0_2(arg_9_0, arg_9_1)
end
