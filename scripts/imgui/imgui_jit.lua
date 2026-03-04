-- chunkname: @scripts/imgui/imgui_jit.lua

local var_0_0 = require("jit.opt").start
local var_0_1 = string.format

ImguiJIT = class(ImguiJIT)

ImguiJIT.init = function (arg_1_0)
	if not arg_1_0._bytes then
		arg_1_0._bytes = {
			n = 240,
			d = 0
		}

		local var_1_0 = collectgarbage("count")

		for iter_1_0 = 1, arg_1_0._bytes.n do
			arg_1_0._bytes[iter_1_0] = var_1_0
		end
	end

	if not arg_1_0._root_path then
		arg_1_0._root_path = ""
		arg_1_0._snapshot_data = nil
		arg_1_0._memory_layout_name_max_size = 0
	end

	arg_1_0._gc = {
		{
			d = "The garbage-collector pause controls how long the collector waits before starting a new cycle.",
			v = 200,
			k = "setpause"
		},
		{
			d = "The step multiplier controls the relative speed of the collector relative to memory allocation.",
			v = 200,
			k = "setstepmul"
		}
	}
	arg_1_0._gc_state = "running"
	arg_1_0._opts = {
		{
			v = true,
			k = "fold"
		},
		{
			v = true,
			k = "cse"
		},
		{
			v = true,
			k = "dce"
		},
		{
			v = true,
			k = "fwd"
		},
		{
			v = true,
			k = "dse"
		},
		{
			v = true,
			k = "narrow"
		},
		{
			v = true,
			k = "loop"
		},
		{
			v = true,
			k = "abc"
		},
		{
			v = true,
			k = "sink"
		},
		{
			v = true,
			k = "fuse"
		}
	}
	arg_1_0._params = {
		{
			d = "Max. # of traces in cache.",
			v = 8000,
			k = "maxtrace"
		},
		{
			d = "Max. # of recorded IR instructions.",
			v = 16000,
			k = "maxrecord"
		},
		{
			d = "Max. # of IR constants of a trace.",
			v = 500,
			k = "maxirconst"
		},
		{
			d = "Max. # of side traces of a root trace.",
			v = 100,
			k = "maxside"
		},
		{
			d = "Max. # of snapshots for a trace.",
			v = 500,
			k = "maxsnap"
		},
		{
			d = "Min. # of IR ins for a stitched trace.",
			v = 3,
			k = "minstitch"
		},
		{
			d = "# of iter. to detect a hot loop/call.",
			v = 56,
			k = "hotloop"
		},
		{
			d = "# of taken exits to start a side trace.",
			v = 10,
			k = "hotexit"
		},
		{
			d = "# of attempts to compile a side trace.",
			v = 4,
			k = "tryside"
		},
		{
			d = "Max. unroll for instable loops.",
			v = 4,
			k = "instunroll"
		},
		{
			d = "Max. unroll for loop ops in side traces.",
			v = 15,
			k = "loopunroll"
		},
		{
			d = "Max. unroll for recursive calls.",
			v = 3,
			k = "callunroll"
		},
		{
			d = "Min. unroll for true recursion.",
			v = 2,
			k = "recunroll"
		},
		{
			d = "Size of each machine code area (in KBytes).",
			v = 64,
			k = "sizemcode"
		},
		{
			d = "Max. total size of all machine code areas (in KBytes).",
			v = 40960,
			k = "maxmcode"
		}
	}
	arg_1_0._enabled = jit.status()
	arg_1_0._traces = {}
end

local var_0_2 = true

ImguiJIT.update = function (arg_2_0)
	if var_0_2 then
		var_0_2 = arg_2_0:init()
	end
end

local function var_0_3(arg_3_0, arg_3_1)
	if Imgui.is_item_hovered() then
		Imgui.begin_tool_tip()

		if arg_3_1 then
			Imgui.text_colored(arg_3_1, 127, 127, 127, 255)
		end

		Imgui.text(arg_3_0)
		Imgui.end_tool_tip()
	end
end

local function var_0_4(arg_4_0)
	local var_4_0 = math.huge
	local var_4_1 = -math.huge
	local var_4_2 = 0
	local var_4_3 = 0
	local var_4_4 = 0
	local var_4_5 = #arg_4_0

	for iter_4_0 = 1, var_4_5 do
		local var_4_6 = arg_4_0[iter_4_0]

		if var_4_6 < var_4_0 then
			var_4_0 = var_4_6
		end

		if var_4_1 < var_4_6 then
			var_4_1 = var_4_6
		end

		local var_4_7 = var_4_6 - var_4_2

		var_4_2 = var_4_2 + var_4_7 / iter_4_0
		var_4_3 = var_4_3 + var_4_7 * (var_4_6 - var_4_2)
		var_4_4 = var_4_4 + var_4_7 * (var_4_5 - iter_4_0 - 0.5 * (iter_4_0 + 1))
	end

	return var_4_2, var_4_3 / (var_4_5 - 1), var_4_0, var_4_1, var_4_4 / (var_4_5 - 1)
end

local function var_0_5(arg_5_0)
	return UIUtils.comma_value(math.ceil(1024 * arg_5_0) .. " bytes")
end

local var_0_6 = {}

ImguiJIT._recursive_header = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7)
	local var_6_0 = (arg_6_6[arg_6_1] - 1) * 10

	Imgui.dummy(var_6_0, 0)
	Imgui.same_line()

	if Imgui.collapsing_header(string.format("%s%s (self: %sb)", string.pad_right(arg_6_3[arg_6_1], arg_6_7 + 4, " ", var_0_6), string.pad_right(string.chunk_from_right(tostring(arg_6_4[arg_6_1]), 3, "'") .. "b", 15, " ", var_0_6), string.chunk_from_right(tostring(arg_6_5[arg_6_1]), 3, "'")), false) then
		local var_6_1 = arg_6_2[arg_6_1]
		local var_6_2, var_6_3 = table.max_func(var_6_1, function (arg_7_0)
			return #arg_6_3[arg_7_0]
		end)

		arg_6_0._memory_layout_name_max_size = math.clamp(#arg_6_3[var_6_3], arg_6_0._memory_layout_name_max_size, 125)

		for iter_6_0 = 1, #var_6_1 do
			arg_6_0:_recursive_header(var_6_1[iter_6_0], arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_0._memory_layout_name_max_size)
		end

		Imgui.tree_pop()
	end
end

ImguiJIT.draw = function (arg_8_0)
	local var_8_0 = Imgui.begin_window("JIT utilities")
	local var_8_1 = Imgui.checkbox("JIT enabled", arg_8_0._enabled or false)

	if var_8_1 ~= arg_8_0._enabled then
		jit[var_8_1 and "on" or "off"]()

		arg_8_0._enabled = var_8_1
	end

	Imgui.same_line()

	if Imgui.button("Flush") then
		jit.flush()
	end

	Imgui.separator()

	if Imgui.collapsing_header("Parameters", false) then
		for iter_8_0, iter_8_1 in pairs(arg_8_0._params) do
			local var_8_2 = Imgui.input_int(iter_8_1.k, math.max(0, iter_8_1.v))

			var_0_3(iter_8_1.d, iter_8_1.k)

			if var_8_2 ~= iter_8_1.v then
				var_0_0(var_0_1("%s=%d", iter_8_1.k, var_8_2))

				iter_8_1.v = var_8_2
			end
		end

		Imgui.tree_pop()
	end

	if Imgui.collapsing_header("Options", false) then
		for iter_8_2, iter_8_3 in pairs(arg_8_0._opts) do
			local var_8_3 = Imgui.checkbox(iter_8_3.k, iter_8_3.v)

			if var_8_3 ~= iter_8_3.v then
				var_0_0(var_0_1("%s%s", var_8_3 and "+" or "-", iter_8_3.k))

				iter_8_3.v = var_8_3
			end
		end

		Imgui.tree_pop()
	end

	if Imgui.collapsing_header("Traces", false) then
		Imgui.text("Traces go here.")

		local var_8_4 = arg_8_0._traces

		for iter_8_4, iter_8_5 in pairs(var_8_4) do
			Imgui.text(tostring(iter_8_5))
		end

		Imgui.tree_pop()
	end

	if Imgui.collapsing_header("Garbage", false) then
		local var_8_5 = arg_8_0._bytes
		local var_8_6 = Imgui.input_int("History period", math.max(0, var_8_5.n))

		var_8_5.n = var_8_6

		local var_8_7 = collectgarbage("count")

		var_8_5[#var_8_5 + 1] = var_8_7

		for iter_8_6 = 1, #var_8_5 - var_8_6 do
			table.remove(var_8_5, 1)
		end

		Imgui.plot_lines("Garbage count", var_8_5)

		local var_8_8, var_8_9, var_8_10, var_8_11, var_8_12 = var_0_4(var_8_5)
		local var_8_13 = 12 * var_8_12 / (var_8_6 * var_8_6 - 1)
		local var_8_14 = var_8_8 - var_8_13 * (var_8_6 + 1) * 0.5

		Imgui.text(string.format("Current: %20s   ", var_0_5(var_8_7)))
		Imgui.text(string.format("Average: %20s //", var_0_5(var_8_8)))
		Imgui.same_line()
		Imgui.text(string.format("Std.dev: %20s   ", var_0_5(var_8_9^0.5)))
		Imgui.text(string.format("Minimum: %20s //", var_0_5(var_8_10)))
		Imgui.same_line()
		Imgui.text(string.format("Lire.b0: %20s   ", var_0_5(var_8_14)))
		Imgui.text(string.format("Maximum: %20s //", var_0_5(var_8_11)))
		Imgui.same_line()
		Imgui.text(string.format("Lire.b1: %20s   ", var_0_5(var_8_13)))
		Imgui.separator()

		for iter_8_7, iter_8_8 in pairs(arg_8_0._gc) do
			local var_8_15 = Imgui.input_int(iter_8_8.k, math.max(0, iter_8_8.v))

			collectgarbage(iter_8_8.k, var_8_15)

			iter_8_8.v = var_8_15

			var_0_3(iter_8_8.d, iter_8_8.k)
		end

		Imgui.separator()

		if Imgui.button("Collect") then
			arg_8_0._gc_state = "running"

			collectgarbage("collect")
			var_0_3("performs a full garbage-collection cycle. This is the default option.", "collect")
		end

		Imgui.same_line()

		if Imgui.button("Stop") then
			arg_8_0._gc_state = "stopped"

			collectgarbage("stop")
			var_0_3("stops the garbage collector.", "stop")
		end

		Imgui.same_line()

		if Imgui.button("Restart") then
			arg_8_0._gc_state = "running"

			collectgarbage("restart")
			var_0_3("restarts the garbage collector.", "restart")
		end

		Imgui.same_line()

		if Imgui.button("Step") then
			collectgarbage("step")
			var_0_3("performs a garbage-collection step. The step \"size\" is controlled by arg (larger values mean more steps) in a non-specified way. If you want to control the step size you must experimentally tune the value of arg. Returns true if the step finished a collection cycle.", "step")
		end

		Imgui.text("Last known state: " .. arg_8_0._gc_state)
		Imgui.tree_pop()
	end

	if Imgui.collapsing_header("Memory Layout", false) then
		arg_8_0._root_path = Imgui.input_text("Path", arg_8_0._root_path)

		local var_8_16

		if arg_8_0._root_path == "" then
			var_8_16 = _G
		else
			var_8_16 = success and val
		end

		if var_8_16 then
			Imgui.same_line()

			if Imgui.button("Snapshot") and var_8_16 then
				arg_8_0._snapshot_data = nil

				collectgarbage("collect")

				arg_8_0._snapshot_data = {
					grab_lua_memory_tree_snapshot(var_8_16)
				}
			end

			if arg_8_0._snapshot_data then
				local var_8_17, var_8_18, var_8_19, var_8_20, var_8_21 = unpack(arg_8_0._snapshot_data)

				arg_8_0._memory_layout_name_max_size = math.max(arg_8_0._memory_layout_name_max_size, #var_8_18[var_8_16])

				arg_8_0:_recursive_header(var_8_16, var_8_17, var_8_18, var_8_19, var_8_20, var_8_21, arg_8_0._memory_layout_name_max_size)
			end
		end

		Imgui.tree_pop()
	end

	Imgui.end_window()

	return var_8_0
end

ImguiJIT.is_persistent = function (arg_9_0)
	return false
end
