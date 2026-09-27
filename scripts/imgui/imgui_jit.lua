-- chunkname: @scripts/imgui/imgui_jit.lua

local start = require("jit.opt").start
local format = string.format

ImguiJIT = class(ImguiJIT)

ImguiJIT.init = function (self)
	-- function 1
	if not self._bytes then
		self._bytes = {
			n = 240,
			d = 0
		}

		local var_1_0 = collectgarbage("count")

		for i = 1, self._bytes.n do
			self._bytes[i] = var_1_0
		end
	end

	if not self._root_path then
		self._root_path = ""
		self._snapshot_data = nil
		self._memory_layout_name_max_size = 0
	end

	self._gc = {
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
	self._gc_state = "running"
	self._opts = {
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
	self._params = {
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
	self._enabled = jit.status()
	self._traces = {}
end

local flag = true

ImguiJIT.update = function (self)
	-- function 2
	if not flag then
		flag = self:init()
	end
end

local function fn(arg_3_0, arg_3_1)
	-- function 3
	if not Imgui.is_item_hovered() then
		Imgui.begin_tool_tip()

		if not arg_3_1 then
			Imgui.text_colored(arg_3_1, 127, 127, 127, 255)
		end

		Imgui.text(arg_3_0)
		Imgui.end_tool_tip()
	end
end

local function fn_2(self)
	-- function 4
	local huge = math.huge
	local num = -math.huge
	local num_2 = 0
	local num_3 = 0
	local num_4 = 0
	local count = #self

	for i = 1, count do
		local var_4_6 = self[i]

		if var_4_6 < huge then
			huge = var_4_6
		end

		if num < var_4_6 then
			num = var_4_6
		end

		local num_5 = var_4_6 - num_2

		num_2 = num_2 + num_5 / i
		num_3 = num_3 + num_5 * (var_4_6 - num_2)
		num_4 = num_4 + num_5 * (count - i - 0.5 * (i + 1))
	end

	return num_2, num_3 / (count - 1), huge, num, num_4 / (count - 1)
end

local function fn_3(arg_5_0)
	-- function 5
	return UIUtils.comma_value(math.ceil(1024 * arg_5_0) .. " bytes")
end

local tbl = {}

ImguiJIT._recursive_header = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7)
	-- function 6
	local num = (arg_6_6[arg_6_1] - 1) * 10

	Imgui.dummy(num, 0)
	Imgui.same_line()

	if not Imgui.collapsing_header(string.format("%s%s (self: %sb)", string.pad_right(arg_6_3[arg_6_1], arg_6_7 + 4, " ", tbl), string.pad_right(string.chunk_from_right(tostring(arg_6_4[arg_6_1]), 3, "'") .. "b", 15, " ", tbl), string.chunk_from_right(tostring(arg_6_5[arg_6_1]), 3, "'")), false) then
		local var_6_1 = arg_6_2[arg_6_1]
		local max_func, var_6_3 = table.max_func(var_6_1, function (arg_7_0)
			-- function 7
			return #arg_6_3[arg_7_0]
		end)

		self._memory_layout_name_max_size = math.clamp(#arg_6_3[var_6_3], self._memory_layout_name_max_size, 125)

		for i = 1, #var_6_1 do
			self:_recursive_header(var_6_1[i], arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, self._memory_layout_name_max_size)
		end

		Imgui.tree_pop()
	end
end

ImguiJIT.draw = function (self)
	-- function 8
	local begin_window = Imgui.begin_window("JIT utilities")
	local checkbox = Imgui.checkbox
	local str = "JIT enabled"
	local _enabled = self._enabled

	_enabled = _enabled or false

	local var_8_4 = checkbox(str, _enabled)

	if var_8_4 ~= self._enabled then
		local jit = jit
		local flag

		flag = not var_8_4 and "on" and "off"

		jit[flag]()

		self._enabled = var_8_4
	end

	Imgui.same_line()

	if not Imgui.button("Flush") then
		jit.flush()
	end

	Imgui.separator()

	if not Imgui.collapsing_header("Parameters", false) then
		for k, v in pairs(self._params) do
			local input_int = Imgui.input_int(v.k, math.max(0, v.v))

			fn(v.d, v.k)

			if input_int ~= v.v then
				start(format("%s=%d", v.k, input_int))

				v.v = input_int
			end
		end

		Imgui.tree_pop()
	end

	if not Imgui.collapsing_header("Options", false) then
		for k_2, v_2 in pairs(self._opts) do
			local checkbox_2 = Imgui.checkbox(v_2.k, v_2.v)

			if checkbox_2 ~= v_2.v then
				local var_8_9 = start
				local var_8_10 = format
				local str_2 = "%s%s"
				local flag_2

				flag_2 = not checkbox_2 and "+" and "-"

				var_8_9(var_8_10(str_2, flag_2, v_2.k))

				v_2.v = checkbox_2
			end
		end

		Imgui.tree_pop()
	end

	if not Imgui.collapsing_header("Traces", false) then
		Imgui.text("Traces go here.")

		local _traces = self._traces

		for k_3, v_3 in pairs(_traces) do
			Imgui.text(tostring(v_3))
		end

		Imgui.tree_pop()
	end

	if not Imgui.collapsing_header("Garbage", false) then
		local _bytes = self._bytes
		local input_int_2 = Imgui.input_int("History period", math.max(0, _bytes.n))

		_bytes.n = input_int_2

		local var_8_16 = collectgarbage("count")

		_bytes[#_bytes + 1] = var_8_16

		for i6 = 1, #_bytes - input_int_2 do
			table.remove(_bytes, 1)
		end

		Imgui.plot_lines("Garbage count", _bytes)

		local var_8_17, var_8_18, var_8_19, var_8_20, var_8_21 = fn_2(_bytes)
		local num = 12 * var_8_21 / (input_int_2 * input_int_2 - 1)
		local num_2 = var_8_17 - num * (input_int_2 + 1) * 0.5

		Imgui.text(string.format("Current: %20s   ", fn_3(var_8_16)))
		Imgui.text(string.format("Average: %20s //", fn_3(var_8_17)))
		Imgui.same_line()
		Imgui.text(string.format("Std.dev: %20s   ", fn_3(var_8_18^0.5)))
		Imgui.text(string.format("Minimum: %20s //", fn_3(var_8_19)))
		Imgui.same_line()
		Imgui.text(string.format("Lire.b0: %20s   ", fn_3(num_2)))
		Imgui.text(string.format("Maximum: %20s //", fn_3(var_8_20)))
		Imgui.same_line()
		Imgui.text(string.format("Lire.b1: %20s   ", fn_3(num)))
		Imgui.separator()

		for k_4, v_4 in pairs(self._gc) do
			local input_int_3 = Imgui.input_int(v_4.k, math.max(0, v_4.v))

			collectgarbage(v_4.k, input_int_3)

			v_4.v = input_int_3

			fn(v_4.d, v_4.k)
		end

		Imgui.separator()

		if not Imgui.button("Collect") then
			self._gc_state = "running"

			collectgarbage("collect")
			fn("performs a full garbage-collection cycle. This is the default option.", "collect")
		end

		Imgui.same_line()

		if not Imgui.button("Stop") then
			self._gc_state = "stopped"

			collectgarbage("stop")
			fn("stops the garbage collector.", "stop")
		end

		Imgui.same_line()

		if not Imgui.button("Restart") then
			self._gc_state = "running"

			collectgarbage("restart")
			fn("restarts the garbage collector.", "restart")
		end

		Imgui.same_line()

		if not Imgui.button("Step") then
			collectgarbage("step")
			fn("performs a garbage-collection step. The step \"size\" is controlled by arg (larger values mean more steps) in a non-specified way. If you want to control the step size you must experimentally tune the value of arg. Returns true if the step finished a collection cycle.", "step")
		end

		Imgui.text("Last known state: " .. self._gc_state)
		Imgui.tree_pop()
	end

	if not Imgui.collapsing_header("Memory Layout", false) then
		self._root_path = Imgui.input_text("Path", self._root_path)

		local var_8_25

		if self._root_path == "" then
			var_8_25 = _G
		else
			var_8_25 = not success and val
		end

		if not var_8_25 then
			Imgui.same_line()

			if not Imgui.button("Snapshot") and not var_8_25 then
				self._snapshot_data = nil

				collectgarbage("collect")

				self._snapshot_data = {
					grab_lua_memory_tree_snapshot(var_8_25)
				}
			end

			if not self._snapshot_data then
				local var_8_26, var_8_27, var_8_28, var_8_29, var_8_30 = unpack(self._snapshot_data)

				self._memory_layout_name_max_size = math.max(self._memory_layout_name_max_size, #var_8_27[var_8_25])

				self:_recursive_header(var_8_25, var_8_26, var_8_27, var_8_28, var_8_29, var_8_30, self._memory_layout_name_max_size)
			end
		end

		Imgui.tree_pop()
	end

	Imgui.end_window()

	return begin_window
end

ImguiJIT.is_persistent = function (arg_9_0)
	-- function 9
	return false
end
