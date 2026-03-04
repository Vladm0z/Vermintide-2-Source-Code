-- chunkname: @scripts/ui/ui_scenegraph.lua

require("scripts/ui/ui_resolution")

UISceneGraph = {}

local var_0_0 = UISceneGraph
local var_0_1 = Vector2
local var_0_2 = Vector3
local var_0_3 = RESOLUTION_LOOKUP
local var_0_4 = Application
local var_0_5 = fassert
local var_0_6 = {
	0,
	0,
	0
}

local function var_0_7(arg_1_0)
	return {
		arg_1_0[1],
		arg_1_0[2]
	}
end

local function var_0_8(arg_2_0)
	return {
		arg_2_0[1],
		arg_2_0[2],
		arg_2_0[3] or 0
	}
end

var_0_0.ZERO_VECTOR3 = var_0_6

local var_0_9 = {
	left = 0,
	bottom = 0,
	top = 1,
	center = 0.5,
	right = 1
}

local function var_0_10(arg_3_0, arg_3_1, arg_3_2)
	return arg_3_0 + arg_3_1 * (var_0_9[arg_3_2] or 0)
end

local var_0_11 = {
	__class_name = "scenegraph",
	__newindex = function (arg_4_0, arg_4_1, arg_4_2)
		local var_4_0 = string.format("[UIScenegraph] Cannot add field %q to %s", arg_4_1, arg_4_0)

		print(var_4_0)

		return rawset(arg_4_0, arg_4_1, arg_4_2)
	end
}

local function var_0_12(arg_5_0, arg_5_1)
	for iter_5_0, iter_5_1 in pairs(arg_5_1) do
		if arg_5_0[iter_5_0] == nil then
			var_0_4.warning("[UIScenegraph] Node polluted: scenegraph[%q][%q]\n%s", arg_5_0.name, iter_5_0, Script.callstack())

			arg_5_0[iter_5_0] = type(iter_5_1) == "table" and table.clone(iter_5_1) or iter_5_1
		end
	end
end

local function var_0_13(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	var_0_5(arg_6_0[arg_6_2] == nil, "Cycle detected at %q", arg_6_2)
	var_0_5(arg_6_3, "Missing definition for %q", arg_6_2)

	arg_6_0[arg_6_2] = false

	local var_6_0 = arg_6_3.parent

	if not var_6_0 then
		local var_6_1 = var_0_8(arg_6_3.position)
		local var_6_2 = {
			parent = false,
			name = arg_6_2,
			world_position = var_0_8(arg_6_3.position),
			local_position = var_6_1,
			position = var_6_1,
			size = var_0_7(arg_6_3.size),
			horizontal_alignment = arg_6_3.horizontal_alignment,
			vertical_alignment = arg_6_3.vertical_alignment,
			is_root = arg_6_3.is_root,
			scale = arg_6_3.scale
		}

		var_0_12(var_6_2, arg_6_3)

		arg_6_0[arg_6_2] = var_6_2
		arg_6_0[#arg_6_0 + 1] = var_6_2

		return
	end

	local var_6_3 = arg_6_0[var_6_0]

	if not var_6_3 then
		var_0_13(arg_6_0, arg_6_1, var_6_0, arg_6_1[var_6_0])

		var_6_3 = arg_6_0[var_6_0]
	end

	local var_6_4 = var_6_3.world_position
	local var_6_5 = var_0_8(arg_6_3.position or var_0_6)
	local var_6_6 = var_0_7(arg_6_3.size or var_6_3.size)

	if var_6_6[1] < 0 then
		var_6_6[1] = var_6_6[1] + var_6_3.size[1]
	end

	if var_6_6[2] < 0 then
		var_6_6[2] = var_6_6[2] + var_6_3.size[2]
	end

	local var_6_7 = {
		name = arg_6_2,
		parent = var_6_0,
		world_position = {
			var_6_5[1] + var_6_4[1],
			var_6_5[2] + var_6_4[2],
			var_6_5[3] + var_6_4[3]
		},
		local_position = var_6_5,
		position = var_6_5,
		size = var_6_6,
		horizontal_alignment = arg_6_3.horizontal_alignment,
		vertical_alignment = arg_6_3.vertical_alignment,
		offset = arg_6_3.offset and var_0_7(arg_6_3.offset)
	}

	var_0_12(var_6_7, arg_6_3)
	setmetatable(var_6_7, var_0_11)

	arg_6_0[arg_6_2] = var_6_7

	local var_6_8 = rawget(var_6_3, "num_children")

	if not var_6_8 then
		rawset(var_6_3, "children", {
			var_6_7
		})
		rawset(var_6_3, "num_children", 1)
	else
		local var_6_9 = var_6_8 + 1

		var_6_3.children[var_6_9] = var_6_7
		var_6_3.num_children = var_6_9
	end
end

var_0_0.init_scenegraph = function (arg_7_0)
	local var_7_0 = {}

	for iter_7_0, iter_7_1 in pairs(arg_7_0) do
		if not var_7_0[iter_7_0] then
			var_0_13(var_7_0, arg_7_0, iter_7_0, iter_7_1)
		end
	end

	return setmetatable(var_7_0, var_0_11)
end

local function var_0_14(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	for iter_8_0 = 1, arg_8_2 do
		local var_8_0 = arg_8_1[iter_8_0]
		local var_8_1
		local var_8_2
		local var_8_3
		local var_8_4 = var_8_0.local_position
		local var_8_5, var_8_6, var_8_7 = var_8_4[1], var_8_4[2], var_8_4[3]
		local var_8_8 = var_8_0.size
		local var_8_9 = var_8_8[1]
		local var_8_10 = var_8_8[2]
		local var_8_11 = var_0_10(var_8_5 + arg_8_0[1], arg_8_3 - var_8_9, var_8_0.horizontal_alignment)
		local var_8_12 = var_0_10(var_8_6 + arg_8_0[2], arg_8_4 - var_8_10, var_8_0.vertical_alignment)
		local var_8_13 = var_8_0.offset

		if var_8_13 then
			var_8_11 = var_8_11 + var_8_13[1]
			var_8_12 = var_8_12 + var_8_13[2]

			local var_8_14 = var_8_13[3]

			if var_8_14 then
				var_8_7 = var_8_7 + var_8_14
			end
		end

		local var_8_15 = var_8_0.world_position

		var_8_15[1], var_8_15[2], var_8_15[2] = var_8_11, var_8_12, var_8_7

		local var_8_16 = var_8_0.children

		if var_8_16 then
			var_0_14(var_8_15, var_8_16, var_8_0.num_children, var_8_9, var_8_10)
		end
	end
end

var_0_0.update_scenegraph = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = var_0_3.res_w
	local var_9_1 = var_0_3.res_h
	local var_9_2 = var_0_3.scale
	local var_9_3 = var_0_3.inv_scale
	local var_9_4 = var_9_0 / (1920 * var_9_2)
	local var_9_5 = UISettings.root_scale[2]

	for iter_9_0 = 1, #arg_9_0 do
		local var_9_6 = arg_9_0[iter_9_0]
		local var_9_7 = var_9_6.name
		local var_9_8
		local var_9_9
		local var_9_10

		if arg_9_1 then
			local var_9_11 = arg_9_1[arg_9_2].world_position

			var_9_8, var_9_9, var_9_10 = var_9_11[1], var_9_11[2], var_9_11[3]
		else
			local var_9_12 = var_9_6.local_position

			var_9_8, var_9_9, var_9_10 = var_9_12[1], var_9_12[2], var_9_12[3]
		end

		local var_9_13 = var_9_6.size
		local var_9_14 = var_9_13[1]
		local var_9_15 = var_9_13[2]

		if var_9_6.is_root then
			var_9_14 = var_9_4 * var_9_14
			var_9_15 = var_9_5 * var_9_1 * var_9_3
			var_9_8 = (var_9_8 + (var_9_0 - var_9_14 * var_9_2) * 0.5) * var_9_3
			var_9_9 = (var_9_9 + (var_9_1 - var_9_15 * var_9_2) * 0.5) * var_9_3
		else
			local var_9_16 = var_9_6.scale

			if var_9_16 == "fit" then
				var_9_14 = var_9_0 * var_9_3
				var_9_15 = var_9_1 * var_9_3
				var_9_8 = 0
				var_9_9 = 0
			elseif var_9_16 == "hud_scale_fit" then
				var_9_14 = var_9_14 * var_9_4
				var_9_15 = var_9_1 * var_9_3
				var_9_8 = (var_9_8 + (var_9_0 - var_9_14 * var_9_2) * 0.5) * var_9_3
				var_9_9 = 0
			elseif var_9_16 == "hud_fit" then
				local var_9_17 = (var_0_4.user_setting("safe_rect") or 0) * 0.01

				var_9_14 = var_9_0 * var_9_3 * (1 - var_9_17)
				var_9_15 = var_9_1 * var_9_3 * (1 - var_9_17)
				var_9_8 = var_9_0 * var_9_17 * var_9_3 * 0.5
				var_9_9 = var_9_1 * var_9_17 * var_9_3 * 0.5
			elseif var_9_16 == "aspect_ratio" then
				local var_9_18 = var_9_0 / var_9_1
				local var_9_19 = var_9_14 / var_9_15

				if var_9_18 < var_9_19 then
					var_9_14 = var_9_0
					var_9_15 = var_9_0 / var_9_19
				else
					var_9_14 = var_9_1 * var_9_19
					var_9_15 = var_9_1
				end

				var_9_14 = var_9_14 * var_9_3
				var_9_15 = var_9_15 * var_9_3
				var_9_8 = var_0_10(var_9_8, var_9_0 * var_9_3 - var_9_14, var_9_6.horizontal_alignment)
				var_9_9 = var_0_10(var_9_9, var_9_1 * var_9_3 - var_9_15, var_9_6.vertical_alignment)
			elseif var_9_16 == "fit_width" then
				var_9_14 = var_9_0 * var_9_3
				var_9_8 = 0
				var_9_9 = var_0_10(var_9_9, var_9_1 * var_9_3 - var_9_15, var_9_6.vertical_alignment)
			elseif var_9_16 == "fit_height" then
				var_9_15 = var_9_1 * var_9_3
				var_9_8 = var_0_10(var_9_8, var_9_0 * var_9_3 - var_9_14, var_9_6.horizontal_alignment)
				var_9_9 = 0
			end
		end

		local var_9_20 = var_9_6.world_position

		var_9_20[1], var_9_20[2], var_9_20[3] = var_9_8, var_9_9, var_9_10

		local var_9_21 = var_9_6.children

		if var_9_21 then
			var_0_14(var_9_6.world_position, var_9_21, var_9_6.num_children, var_9_14, var_9_15)
		end
	end
end

var_0_0.get_size = function (arg_10_0, arg_10_1)
	return arg_10_0[arg_10_1].size
end

var_0_0.get_world_position = function (arg_11_0, arg_11_1)
	return arg_11_0[arg_11_1].world_position
end

var_0_0.get_local_position = function (arg_12_0, arg_12_1)
	return arg_12_0[arg_12_1].local_position
end

var_0_0.get_size_scaled = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0[arg_13_1]
	local var_13_1 = var_13_0.size

	if var_13_0.is_root then
		local var_13_2 = var_0_3.res_w
		local var_13_3 = var_0_3.res_h
		local var_13_4 = var_0_3.inv_scale

		if arg_13_2 then
			var_13_4 = var_13_4 / arg_13_2
		end

		return var_0_1(var_13_2 * var_13_4 / 1920 * var_13_1[1], var_13_3 * var_13_4 * UISettings.root_scale[2])
	end

	local var_13_5 = var_13_0.scale

	if not var_13_5 then
		if not arg_13_2 then
			return var_0_1(var_13_1[1], var_13_1[2])
		else
			return var_0_1(var_13_1[1] * arg_13_2, var_13_1[2] * arg_13_2)
		end
	end

	local var_13_6 = var_0_3.res_w
	local var_13_7 = var_0_3.res_h
	local var_13_8 = var_0_3.inv_scale

	if var_13_5 == "fit" then
		return var_0_1(var_13_6 * var_13_8, var_13_7 * var_13_8)
	elseif var_13_5 == "hud_fit" then
		local var_13_9 = (var_0_4.user_setting("safe_rect") or 0) * 0.01

		return var_0_1(var_13_6 * var_13_8 * (1 - var_13_9), var_13_7 * var_13_8 * (1 - var_13_9))
	elseif var_13_5 == "fit_width" then
		return var_0_1(var_13_6 * var_13_8, var_13_1[2])
	elseif var_13_5 == "fit_height" then
		return var_0_1(var_13_1[1], var_13_7 * var_13_8)
	elseif var_13_5 == "aspect_ratio" then
		local var_13_10 = var_13_1[1]
		local var_13_11 = var_13_1[2]
		local var_13_12 = var_13_6 / var_13_7
		local var_13_13 = var_13_10 / var_13_11

		if var_13_12 < var_13_13 then
			var_13_10 = var_13_6
			var_13_11 = var_13_6 / var_13_13
		else
			var_13_10 = var_13_7 * var_13_13
			var_13_11 = var_13_7
		end

		return var_0_1(var_13_10 * var_13_8, var_13_11 * var_13_8)
	end
end

var_0_0.set_local_position = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0[arg_14_1].local_position

	var_14_0[1] = arg_14_2[1]
	var_14_0[2] = arg_14_2[2]
	var_14_0[3] = arg_14_2[3]
end

local function var_0_15(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	arg_15_4 = arg_15_4 or 5
	arg_15_1 = arg_15_1 + var_0_2(0, 0, 1)

	local var_15_0 = arg_15_2[1]
	local var_15_1 = arg_15_2[2] - 2 * arg_15_4

	Gui.rect(arg_15_0, var_0_2(arg_15_1[1], arg_15_1[2], arg_15_1[3]), var_0_1(var_15_0, arg_15_4), arg_15_3)
	Gui.rect(arg_15_0, var_0_2(arg_15_1[1], arg_15_1[2] + arg_15_2[2] - arg_15_4, arg_15_1[3]), var_0_1(var_15_0, arg_15_4), arg_15_3)
	Gui.rect(arg_15_0, var_0_2(arg_15_1[1], arg_15_1[2] + arg_15_4, arg_15_1[3]), var_0_1(arg_15_4, var_15_1), arg_15_3)
	Gui.rect(arg_15_0, var_0_2(arg_15_1[1] + arg_15_2[1] - arg_15_4, arg_15_1[2] + arg_15_4, arg_15_1[3]), var_0_1(arg_15_4, var_15_1), arg_15_3)
end

local function var_0_16(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = Mouse.axis(Mouse.axis_id("cursor"))
	local var_16_1 = math.point_is_inside_2d_box
	local var_16_2 = Debug.gui

	arg_16_3 = arg_16_3 - 1

	local var_16_3 = 4

	for iter_16_0 = 1, arg_16_2 do
		local var_16_4 = arg_16_1[iter_16_0]
		local var_16_5 = var_16_4.world_position
		local var_16_6 = var_16_4.size

		if arg_16_3 >= 0 or var_16_1(var_16_0, var_16_5, var_16_6) then
			local var_16_7 = var_16_4.name
			local var_16_8 = var_0_2(var_16_5[1], var_16_5[2], var_16_5[3])
			local var_16_9 = tonumber(string.sub(var_0_4.make_hash(var_16_7), 8), 16) / 4294967296
			local var_16_10, var_16_11, var_16_12 = Colors.hsl2rgb(var_16_9, 0.75, 0.5)

			Gui.rect(var_16_2, var_16_8, var_0_1(var_16_6[1], var_16_6[2]), Color(20, var_16_10, var_16_11, var_16_12))

			local var_16_13 = string.format("%s (%d,%d,%d)[%d,%d]", var_16_7, var_16_5[1], var_16_5[2], var_16_5[3], var_16_6[1], var_16_6[2])

			Gui.text(var_16_2, var_16_13, "materials/fonts/arial", 16, nil, var_16_8 + var_0_1(var_16_3, var_16_3), Color(200, var_16_10, var_16_11, var_16_12), "shadow", Color(200, 0, 0, 0))
			var_0_15(var_16_2, var_16_8, var_16_6, Color(50, var_16_10, var_16_11, var_16_12), var_16_3)

			local var_16_14 = var_16_4.children

			if var_16_14 then
				var_0_16(arg_16_0, var_16_14, #var_16_14, arg_16_3)
			end
		end
	end
end

var_0_0.debug_render_scenegraph = function (arg_17_0, arg_17_1, arg_17_2)
	return var_0_16(arg_17_0, arg_17_1, #arg_17_1, arg_17_2 or 1)
end
