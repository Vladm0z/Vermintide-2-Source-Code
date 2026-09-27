-- chunkname: @scripts/imgui/imgui_flamegraph.lua

ImguiFlamegraph = class(ImguiFlamegraph)

local rect = Gui.rect
local text = Gui.text
local Vector2 = Vector2
local Vector3 = Vector3
local Color = Color
local Mouse = Mouse
local profile = require("jit.profile")
local dumpstack = profile.dumpstack
local gmatch = string.gmatch
local find = string.find
local byte = string.byte
local sub = string.sub
local floor = math.floor
local point_is_inside_2d_box = math.point_is_inside_2d_box
local hsl2rgb = Colors.hsl2rgb
local tonumber = tonumber
local pairs = pairs
local make_hash = Application.make_hash
local flag = false

ImguiFlamegraph.init = function (self)
	-- function 1
	self._recording = false
	self._rendering = false
	self._invert = false
	self._search = ""

	self:clear_data()
	self:reset_zoom()
end

ImguiFlamegraph.do_cell = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8, arg_2_9)
	-- function 2
	local var_2_0 = Color(hsl2rgb(tonumber(sub(make_hash(arg_2_3), 1, 2), 16) / 256, 0.4, 0.5))
	local _search = self._search
	local var_2_2

	if _search == "" or not find(arg_2_3, _search) then
		var_2_2 = Color(255, 255, 255)

		if not var_2_2 then
			-- Nothing
		end
	end

	var_2_2 = Color(64, 64, 64)

	::label_2_0::

	local var_2_3 = Vector3(arg_2_8, arg_2_9, 999)
	local var_2_4 = Vector2(arg_2_6, math.max(2, arg_2_7))

	rect(arg_2_1, var_2_3, var_2_4, var_2_2)
	rect(arg_2_1, var_2_3 + Vector3(1, 1, 1), var_2_4 - Vector2(2, 2), var_2_0)

	local num = arg_2_6 / arg_2_5
	local var_2_6 = arg_2_8
	local num_2 = arg_2_9 - arg_2_7
	local var_2_8 = point_is_inside_2d_box(arg_2_2, var_2_3, var_2_4)

	if not var_2_8 and not Mouse.pressed(Mouse.button_id("left")) then
		self._draw_name = arg_2_3
		self._draw_node = arg_2_4
	end

	for iter_2_0, iter_2_1 in pairs(arg_2_4) do
		if not iter_2_0 then
			local var_2_9 = iter_2_1[false]
			local num_3 = num * var_2_9

			var_2_8 = self:do_cell(arg_2_1, arg_2_2, iter_2_0, iter_2_1, var_2_9, num_3, arg_2_7, var_2_6, num_2) or var_2_8
			var_2_6 = var_2_6 + num_3
		end
	end

	if not var_2_8 then
		text(arg_2_1, arg_2_3 .. " (" .. arg_2_5 .. ")", "materials/fonts/arial", arg_2_7, nil, Vector3(arg_2_8, arg_2_9 + 3, 1000))

		return true
	end
end

ImguiFlamegraph.update = function (self)
	-- function 3
	if not self._rendering then
		flag = true

		if not Mouse.pressed(Mouse.button_id("right")) then
			self:reset_zoom()
		end

		local _draw_node = self._draw_node
		local var_3_1 = _draw_node[false]

		if var_3_1 > 0 then
			local resolution, var_3_3 = Gui.resolution()
			local gui = Debug.gui
			local axis = Mouse.axis(Mouse.axis_id("cursor"))

			self:do_cell(gui, axis, self._draw_name, _draw_node, var_3_1, resolution - 50, 12, 25, var_3_3 - 50)
		end

		flag = false
	end
end

ImguiFlamegraph.is_persistent = function (arg_4_0)
	-- function 4
	return false
end

ImguiFlamegraph.clear_data = function (self)
	-- function 5
	ImguiFlamegraph._root = {
		[false] = 0
	}

	self:reset_zoom()
end

ImguiFlamegraph.reset_zoom = function (self)
	-- function 6
	self._draw_name = "@root"
	self._draw_node = ImguiFlamegraph._root
end

ImguiFlamegraph.profile_cb = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	if not flag then
		return
	end

	local flag_2

	flag_2 = not self._invert and 100 and -100

	local var_7_1 = dumpstack(arg_7_1, "pFZ;", flag_2)

	if not find(var_7_1, "^scripts/boot.lua:%d+$") then
		return
	end

	local _root = ImguiFlamegraph._root

	_root[false] = _root[false] + arg_7_2

	for iter_7_0 in gmatch(var_7_1, "[^;]+") do
		local var_7_3 = _root[iter_7_0]

		if not var_7_3 then
			var_7_3[false] = var_7_3[false] + arg_7_2
		else
			var_7_3 = {
				[false] = arg_7_2
			}
			_root[iter_7_0] = var_7_3
		end

		_root = var_7_3
	end
end

ImguiFlamegraph.toggle_recording = function (self, arg_8_1)
	-- function 8
	if arg_8_1 == nil then
		arg_8_1 = not self._recording
	end

	if self._recording ~= arg_8_1 then
		if not arg_8_1 then
			profile.start("fi33", callback(self, "profile_cb"))
		else
			profile.stop()
		end

		self._recording = arg_8_1
	end
end

ImguiFlamegraph.toggle_rendering = function (self, arg_9_1)
	-- function 9
	if arg_9_1 == nil then
		arg_9_1 = not self._rendering
	end

	self._rendering = arg_9_1
end

local str = "Flamegraph help\n---------------\nUses LuaJIT's in-built statistical profiler.\nIt needs to run for a while to capture nested calls.\nFlamegraph rendering is excluded from samples.\nIt's still recommendable to disable it while recording.\n\nLeft-click on a segment to focus on it.\nRight-click anywhere to reset the view.\n"

ImguiFlamegraph.draw = function (self)
	-- function 10
	local begin_window = Imgui.begin_window("Flamegraph")
	local checkbox = Imgui.checkbox("Recording", self._recording)

	if checkbox ~= self._recording then
		self:toggle_recording(checkbox)
	end

	local checkbox_2 = Imgui.checkbox("Draw flamegraph", self._rendering)

	if checkbox_2 ~= self._rendering then
		self:toggle_rendering(checkbox_2)
	end

	local checkbox_3 = Imgui.checkbox("Invert", self._invert)

	if not (checkbox or next(ImguiFlamegraph._root, false)) then
		self._invert = checkbox_3
	end

	Imgui.text("Total samples: " .. tostring(self._root[false]))

	if not Imgui.button("Reset") then
		self:clear_data()
	end

	self._search = Imgui.input_text("Search", self._search)

	Imgui.dummy(1, 20)
	Imgui.text(str)
	Imgui.end_window()

	return begin_window
end
