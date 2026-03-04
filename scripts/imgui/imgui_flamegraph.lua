-- chunkname: @scripts/imgui/imgui_flamegraph.lua

ImguiFlamegraph = class(ImguiFlamegraph)

local var_0_0 = Gui.rect
local var_0_1 = Gui.text
local var_0_2 = Vector2
local var_0_3 = Vector3
local var_0_4 = Color
local var_0_5 = Mouse
local var_0_6 = require("jit.profile")
local var_0_7 = var_0_6.dumpstack
local var_0_8 = string.gmatch
local var_0_9 = string.find
local var_0_10 = string.byte
local var_0_11 = string.sub
local var_0_12 = math.floor
local var_0_13 = math.point_is_inside_2d_box
local var_0_14 = Colors.hsl2rgb
local var_0_15 = tonumber
local var_0_16 = pairs
local var_0_17 = Application.make_hash
local var_0_18 = false

ImguiFlamegraph.init = function (arg_1_0)
	arg_1_0._recording = false
	arg_1_0._rendering = false
	arg_1_0._invert = false
	arg_1_0._search = ""

	arg_1_0:clear_data()
	arg_1_0:reset_zoom()
end

ImguiFlamegraph.do_cell = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8, arg_2_9)
	local var_2_0 = var_0_4(var_0_14(var_0_15(var_0_11(var_0_17(arg_2_3), 1, 2), 16) / 256, 0.4, 0.5))
	local var_2_1 = arg_2_0._search
	local var_2_2 = var_2_1 ~= "" and var_0_9(arg_2_3, var_2_1) and var_0_4(255, 255, 255) or var_0_4(64, 64, 64)
	local var_2_3 = var_0_3(arg_2_8, arg_2_9, 999)
	local var_2_4 = var_0_2(arg_2_6, math.max(2, arg_2_7))

	var_0_0(arg_2_1, var_2_3, var_2_4, var_2_2)
	var_0_0(arg_2_1, var_2_3 + var_0_3(1, 1, 1), var_2_4 - var_0_2(2, 2), var_2_0)

	local var_2_5 = arg_2_6 / arg_2_5
	local var_2_6 = arg_2_8
	local var_2_7 = arg_2_9 - arg_2_7
	local var_2_8 = var_0_13(arg_2_2, var_2_3, var_2_4)

	if var_2_8 and var_0_5.pressed(var_0_5.button_id("left")) then
		arg_2_0._draw_name = arg_2_3
		arg_2_0._draw_node = arg_2_4
	end

	for iter_2_0, iter_2_1 in var_0_16(arg_2_4) do
		if iter_2_0 then
			local var_2_9 = iter_2_1[false]
			local var_2_10 = var_2_5 * var_2_9

			var_2_8 = arg_2_0:do_cell(arg_2_1, arg_2_2, iter_2_0, iter_2_1, var_2_9, var_2_10, arg_2_7, var_2_6, var_2_7) or var_2_8
			var_2_6 = var_2_6 + var_2_10
		end
	end

	if var_2_8 then
		var_0_1(arg_2_1, arg_2_3 .. " (" .. arg_2_5 .. ")", "materials/fonts/arial", arg_2_7, nil, var_0_3(arg_2_8, arg_2_9 + 3, 1000))

		return true
	end
end

ImguiFlamegraph.update = function (arg_3_0)
	if arg_3_0._rendering then
		var_0_18 = true

		if var_0_5.pressed(var_0_5.button_id("right")) then
			arg_3_0:reset_zoom()
		end

		local var_3_0 = arg_3_0._draw_node
		local var_3_1 = var_3_0[false]

		if var_3_1 > 0 then
			local var_3_2, var_3_3 = Gui.resolution()
			local var_3_4 = Debug.gui
			local var_3_5 = var_0_5.axis(var_0_5.axis_id("cursor"))

			arg_3_0:do_cell(var_3_4, var_3_5, arg_3_0._draw_name, var_3_0, var_3_1, var_3_2 - 50, 12, 25, var_3_3 - 50)
		end

		var_0_18 = false
	end
end

ImguiFlamegraph.is_persistent = function (arg_4_0)
	return false
end

ImguiFlamegraph.clear_data = function (arg_5_0)
	ImguiFlamegraph._root = {
		[false] = 0
	}

	arg_5_0:reset_zoom()
end

ImguiFlamegraph.reset_zoom = function (arg_6_0)
	arg_6_0._draw_name = "@root"
	arg_6_0._draw_node = ImguiFlamegraph._root
end

ImguiFlamegraph.profile_cb = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if var_0_18 then
		return
	end

	local var_7_0 = arg_7_0._invert and 100 or -100
	local var_7_1 = var_0_7(arg_7_1, "pFZ;", var_7_0)

	if var_0_9(var_7_1, "^scripts/boot.lua:%d+$") then
		return
	end

	local var_7_2 = ImguiFlamegraph._root

	var_7_2[false] = var_7_2[false] + arg_7_2

	for iter_7_0 in var_0_8(var_7_1, "[^;]+") do
		local var_7_3 = var_7_2[iter_7_0]

		if var_7_3 then
			var_7_3[false] = var_7_3[false] + arg_7_2
		else
			var_7_3 = {
				[false] = arg_7_2
			}
			var_7_2[iter_7_0] = var_7_3
		end

		var_7_2 = var_7_3
	end
end

ImguiFlamegraph.toggle_recording = function (arg_8_0, arg_8_1)
	if arg_8_1 == nil then
		arg_8_1 = not arg_8_0._recording
	end

	if arg_8_0._recording ~= arg_8_1 then
		if arg_8_1 then
			var_0_6.start("fi33", callback(arg_8_0, "profile_cb"))
		else
			var_0_6.stop()
		end

		arg_8_0._recording = arg_8_1
	end
end

ImguiFlamegraph.toggle_rendering = function (arg_9_0, arg_9_1)
	if arg_9_1 == nil then
		arg_9_1 = not arg_9_0._rendering
	end

	arg_9_0._rendering = arg_9_1
end

local var_0_19 = "Flamegraph help\n---------------\nUses LuaJIT's in-built statistical profiler.\nIt needs to run for a while to capture nested calls.\nFlamegraph rendering is excluded from samples.\nIt's still recommendable to disable it while recording.\n\nLeft-click on a segment to focus on it.\nRight-click anywhere to reset the view.\n"

ImguiFlamegraph.draw = function (arg_10_0)
	local var_10_0 = Imgui.begin_window("Flamegraph")
	local var_10_1 = Imgui.checkbox("Recording", arg_10_0._recording)

	if var_10_1 ~= arg_10_0._recording then
		arg_10_0:toggle_recording(var_10_1)
	end

	local var_10_2 = Imgui.checkbox("Draw flamegraph", arg_10_0._rendering)

	if var_10_2 ~= arg_10_0._rendering then
		arg_10_0:toggle_rendering(var_10_2)
	end

	local var_10_3 = Imgui.checkbox("Invert", arg_10_0._invert)

	if not var_10_1 and not next(ImguiFlamegraph._root, false) then
		arg_10_0._invert = var_10_3
	end

	Imgui.text("Total samples: " .. tostring(arg_10_0._root[false]))

	if Imgui.button("Reset") then
		arg_10_0:clear_data()
	end

	arg_10_0._search = Imgui.input_text("Search", arg_10_0._search)

	Imgui.dummy(1, 20)
	Imgui.text(var_0_19)
	Imgui.end_window()

	return var_10_0
end
