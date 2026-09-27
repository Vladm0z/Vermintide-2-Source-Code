-- chunkname: @scripts/ui/ui_scenegraph.lua

require("scripts/ui/ui_resolution")

UISceneGraph = {}

local UISceneGraph = UISceneGraph
local Vector2 = Vector2
local Vector3 = Vector3
local RESOLUTION_LOOKUP = RESOLUTION_LOOKUP
local Application = Application
local fassert = fassert
local tbl = {
	0,
	0,
	0
}

local function fn(self)
	-- function 1
	return {
		self[1],
		self[2]
	}
end

local function fn_2(self)
	-- function 2
	local tbl = {
		self[1],
		self[2]
	}
	local var_2_1 = self[3]

	var_2_1 = var_2_1 or 0
	tbl[3] = var_2_1

	return tbl
end

UISceneGraph.ZERO_VECTOR3 = tbl

local tbl_2 = {
	left = 0,
	bottom = 0,
	top = 1,
	center = 0.5,
	right = 1
}

local function fn_3(arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local var_3_0 = tbl_2[arg_3_2]

	var_3_0 = var_3_0 or 0

	return arg_3_0 + arg_3_1 * var_3_0
end

local tbl_3 = {
	__class_name = "scenegraph",
	__newindex = function (arg_4_0, arg_4_1, arg_4_2)
		-- function 4
		local format = string.format("[UIScenegraph] Cannot add field %q to %s", arg_4_1, arg_4_0)

		print(format)

		return rawset(arg_4_0, arg_4_1, arg_4_2)
	end
}

local function fn_4(self, arg_5_1)
	-- function 5
	for k, v in pairs(arg_5_1) do
		if self[k] == nil then
			Application.warning("[UIScenegraph] Node polluted: scenegraph[%q][%q]\n%s", self.name, k, Script.callstack())

			local clone

			if type(v) == "table" then
				clone = table.clone(v)

				if not clone then
					-- Nothing
				end
			end

			clone = v

			::label_5_0::

			self[k] = clone
		end
	end
end

local function fn_5(self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	fassert(self[arg_6_2] == nil, "Cycle detected at %q", arg_6_2)
	fassert(arg_6_3, "Missing definition for %q", arg_6_2)

	self[arg_6_2] = false

	local parent = arg_6_3.parent

	if not parent then
		local var_6_1 = fn_2(arg_6_3.position)
		local tbl_2 = {
			parent = false,
			name = arg_6_2,
			world_position = fn_2(arg_6_3.position),
			local_position = var_6_1,
			position = var_6_1,
			size = fn(arg_6_3.size),
			horizontal_alignment = arg_6_3.horizontal_alignment,
			vertical_alignment = arg_6_3.vertical_alignment,
			is_root = arg_6_3.is_root,
			scale = arg_6_3.scale
		}

		fn_4(tbl_2, arg_6_3)

		self[arg_6_2] = tbl_2
		self[#self + 1] = tbl_2

		return
	end

	local var_6_3 = self[parent]

	if not var_6_3 then
		fn_5(self, arg_6_1, parent, arg_6_1[parent])

		var_6_3 = self[parent]
	end

	local world_position = var_6_3.world_position
	local var_6_5 = fn_2
	local position = arg_6_3.position

	position = position or tbl

	local var_6_7 = var_6_5(position)
	local var_6_8 = fn
	local size = arg_6_3.size

	size = size or var_6_3.size

	local var_6_10 = var_6_8(size)

	if var_6_10[1] < 0 then
		var_6_10[1] = var_6_10[1] + var_6_3.size[1]
	end

	if var_6_10[2] < 0 then
		var_6_10[2] = var_6_10[2] + var_6_3.size[2]
	end

	local tbl_4 = {
		name = arg_6_2,
		parent = parent,
		world_position = {
			var_6_7[1] + world_position[1],
			var_6_7[2] + world_position[2],
			var_6_7[3] + world_position[3]
		},
		local_position = var_6_7,
		position = var_6_7,
		size = var_6_10,
		horizontal_alignment = arg_6_3.horizontal_alignment,
		vertical_alignment = arg_6_3.vertical_alignment
	}
	local offset = arg_6_3.offset

	offset = not offset and fn(arg_6_3.offset)
	tbl_4.offset = offset

	fn_4(tbl_4, arg_6_3)
	setmetatable(tbl_4, tbl_3)

	self[arg_6_2] = tbl_4

	local var_6_13 = rawget(var_6_3, "num_children")

	if not var_6_13 then
		rawset(var_6_3, "children", {
			tbl_4
		})
		rawset(var_6_3, "num_children", 1)
	else
		local num = var_6_13 + 1

		var_6_3.children[num] = tbl_4
		var_6_3.num_children = num
	end
end

UISceneGraph.init_scenegraph = function (arg_7_0)
	-- function 7
	local tbl = {}

	for k, v in pairs(arg_7_0) do
		if not tbl[k] then
			fn_5(tbl, arg_7_0, k, v)
		end
	end

	return setmetatable(tbl, tbl_3)
end

local function fn_6(self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	for i = 1, arg_8_2 do
		local var_8_0 = arg_8_1[i]
		local var_8_1
		local var_8_2
		local var_8_3
		local local_position = var_8_0.local_position
		local var_8_5, var_8_6, var_8_7 = local_position[1], local_position[2], local_position[3]
		local size = var_8_0.size
		local var_8_9 = size[1]
		local var_8_10 = size[2]
		local var_8_11 = fn_3(var_8_5 + self[1], arg_8_3 - var_8_9, var_8_0.horizontal_alignment)
		local var_8_12 = fn_3(var_8_6 + self[2], arg_8_4 - var_8_10, var_8_0.vertical_alignment)
		local offset = var_8_0.offset

		if not offset then
			var_8_11 = var_8_11 + offset[1]
			var_8_12 = var_8_12 + offset[2]

			local var_8_14 = offset[3]

			if not var_8_14 then
				var_8_7 = var_8_7 + var_8_14
			end
		end

		local world_position = var_8_0.world_position

		world_position[1], world_position[2], world_position[2] = var_8_11, var_8_12, var_8_7

		local children = var_8_0.children

		if not children then
			fn_6(world_position, children, var_8_0.num_children, var_8_9, var_8_10)
		end
	end
end

UISceneGraph.update_scenegraph = function (self, arg_9_1, arg_9_2)
	-- function 9
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local scale = RESOLUTION_LOOKUP.scale
	local inv_scale = RESOLUTION_LOOKUP.inv_scale
	local num = res_w / (1920 * scale)
	local var_9_5 = UISettings.root_scale[2]

	for i = 1, #self do
		local var_9_6 = self[i]
		local name = var_9_6.name
		local var_9_8
		local var_9_9
		local var_9_10

		if not arg_9_1 then
			local world_position = arg_9_1[arg_9_2].world_position

			var_9_8, var_9_9, var_9_10 = world_position[1], world_position[2], world_position[3]
		else
			local local_position = var_9_6.local_position

			var_9_8, var_9_9, var_9_10 = local_position[1], local_position[2], local_position[3]
		end

		local size = var_9_6.size
		local var_9_14 = size[1]
		local var_9_15 = size[2]

		if not var_9_6.is_root then
			var_9_14 = num * var_9_14
			var_9_15 = var_9_5 * res_h * inv_scale
			var_9_8 = (var_9_8 + (res_w - var_9_14 * scale) * 0.5) * inv_scale
			var_9_9 = (var_9_9 + (res_h - var_9_15 * scale) * 0.5) * inv_scale
		else
			local scale_2 = var_9_6.scale

			if scale_2 == "fit" then
				var_9_14 = res_w * inv_scale
				var_9_15 = res_h * inv_scale
				var_9_8 = 0
				var_9_9 = 0
			elseif scale_2 == "hud_scale_fit" then
				var_9_14 = var_9_14 * num
				var_9_15 = res_h * inv_scale
				var_9_8 = (var_9_8 + (res_w - var_9_14 * scale) * 0.5) * inv_scale
				var_9_9 = 0
			elseif scale_2 == "hud_fit" then
				local user_setting = Application.user_setting("safe_rect")

				user_setting = user_setting or 0

				local num_2 = user_setting * 0.01

				var_9_14 = res_w * inv_scale * (1 - num_2)
				var_9_15 = res_h * inv_scale * (1 - num_2)
				var_9_8 = res_w * num_2 * inv_scale * 0.5
				var_9_9 = res_h * num_2 * inv_scale * 0.5
			elseif scale_2 == "aspect_ratio" then
				local num_3 = res_w / res_h
				local num_4 = var_9_14 / var_9_15

				if num_3 < num_4 then
					var_9_14 = res_w
					var_9_15 = res_w / num_4
				else
					var_9_14 = res_h * num_4
					var_9_15 = res_h
				end

				var_9_14 = var_9_14 * inv_scale
				var_9_15 = var_9_15 * inv_scale
				var_9_8 = fn_3(var_9_8, res_w * inv_scale - var_9_14, var_9_6.horizontal_alignment)
				var_9_9 = fn_3(var_9_9, res_h * inv_scale - var_9_15, var_9_6.vertical_alignment)
			elseif scale_2 == "fit_width" then
				var_9_14 = res_w * inv_scale
				var_9_8 = 0
				var_9_9 = fn_3(var_9_9, res_h * inv_scale - var_9_15, var_9_6.vertical_alignment)
			elseif scale_2 == "fit_height" then
				var_9_15 = res_h * inv_scale
				var_9_8 = fn_3(var_9_8, res_w * inv_scale - var_9_14, var_9_6.horizontal_alignment)
				var_9_9 = 0
			end
		end

		local world_position_2 = var_9_6.world_position

		world_position_2[1], world_position_2[2], world_position_2[3] = var_9_8, var_9_9, var_9_10

		local children = var_9_6.children

		if not children then
			fn_6(var_9_6.world_position, children, var_9_6.num_children, var_9_14, var_9_15)
		end
	end
end

UISceneGraph.get_size = function (self, arg_10_1)
	-- function 10
	return self[arg_10_1].size
end

UISceneGraph.get_world_position = function (self, arg_11_1)
	-- function 11
	return self[arg_11_1].world_position
end

UISceneGraph.get_local_position = function (self, arg_12_1)
	-- function 12
	return self[arg_12_1].local_position
end

UISceneGraph.get_size_scaled = function (self, arg_13_1, arg_13_2)
	-- function 13
	local var_13_0 = self[arg_13_1]
	local size = var_13_0.size

	if not var_13_0.is_root then
		local res_w = RESOLUTION_LOOKUP.res_w
		local res_h = RESOLUTION_LOOKUP.res_h
		local inv_scale = RESOLUTION_LOOKUP.inv_scale

		if not arg_13_2 then
			inv_scale = inv_scale / arg_13_2
		end

		return Vector2(res_w * inv_scale / 1920 * size[1], res_h * inv_scale * UISettings.root_scale[2])
	end

	local scale = var_13_0.scale

	if not scale then
		if not arg_13_2 then
			return Vector2(size[1], size[2])
		else
			return Vector2(size[1] * arg_13_2, size[2] * arg_13_2)
		end
	end

	local res_w_2 = RESOLUTION_LOOKUP.res_w
	local res_h_2 = RESOLUTION_LOOKUP.res_h
	local inv_scale_2 = RESOLUTION_LOOKUP.inv_scale

	if scale == "fit" then
		return Vector2(res_w_2 * inv_scale_2, res_h_2 * inv_scale_2)
	elseif scale == "hud_fit" then
		local user_setting = Application.user_setting("safe_rect")

		user_setting = user_setting or 0

		local num = user_setting * 0.01

		return Vector2(res_w_2 * inv_scale_2 * (1 - num), res_h_2 * inv_scale_2 * (1 - num))
	elseif scale == "fit_width" then
		return Vector2(res_w_2 * inv_scale_2, size[2])
	elseif scale == "fit_height" then
		return Vector2(size[1], res_h_2 * inv_scale_2)
	elseif scale == "aspect_ratio" then
		local var_13_11 = size[1]
		local var_13_12 = size[2]
		local num_2 = res_w_2 / res_h_2
		local num_3 = var_13_11 / var_13_12

		if num_2 < num_3 then
			var_13_11 = res_w_2
			var_13_12 = res_w_2 / num_3
		else
			var_13_11 = res_h_2 * num_3
			var_13_12 = res_h_2
		end

		return Vector2(var_13_11 * inv_scale_2, var_13_12 * inv_scale_2)
	end
end

UISceneGraph.set_local_position = function (self, arg_14_1, arg_14_2)
	-- function 14
	local local_position = self[arg_14_1].local_position

	local_position[1] = arg_14_2[1]
	local_position[2] = arg_14_2[2]
	local_position[3] = arg_14_2[3]
end

local function fn_7(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	-- function 15
	arg_15_4 = arg_15_4 or 5
	arg_15_1 = arg_15_1 + Vector3(0, 0, 1)

	local var_15_0 = arg_15_2[1]
	local num = arg_15_2[2] - 2 * arg_15_4

	Gui.rect(arg_15_0, Vector3(arg_15_1[1], arg_15_1[2], arg_15_1[3]), Vector2(var_15_0, arg_15_4), arg_15_3)
	Gui.rect(arg_15_0, Vector3(arg_15_1[1], arg_15_1[2] + arg_15_2[2] - arg_15_4, arg_15_1[3]), Vector2(var_15_0, arg_15_4), arg_15_3)
	Gui.rect(arg_15_0, Vector3(arg_15_1[1], arg_15_1[2] + arg_15_4, arg_15_1[3]), Vector2(arg_15_4, num), arg_15_3)
	Gui.rect(arg_15_0, Vector3(arg_15_1[1] + arg_15_2[1] - arg_15_4, arg_15_1[2] + arg_15_4, arg_15_1[3]), Vector2(arg_15_4, num), arg_15_3)
end

local function fn_8(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	local axis = Mouse.axis(Mouse.axis_id("cursor"))
	local point_is_inside_2d_box = math.point_is_inside_2d_box
	local gui = Debug.gui

	arg_16_3 = arg_16_3 - 1

	local num = 4

	for i = 1, arg_16_2 do
		local var_16_4 = arg_16_1[i]
		local world_position = var_16_4.world_position
		local size = var_16_4.size

		if arg_16_3 >= 0 or not point_is_inside_2d_box(axis, world_position, size) then
			local name = var_16_4.name
			local var_16_8 = Vector3(world_position[1], world_position[2], world_position[3])
			local num_2 = tonumber(string.sub(Application.make_hash(name), 8), 16) / 4294967296
			local hsl2rgb, var_16_11, var_16_12 = Colors.hsl2rgb(num_2, 0.75, 0.5)

			Gui.rect(gui, var_16_8, Vector2(size[1], size[2]), Color(20, hsl2rgb, var_16_11, var_16_12))

			local format = string.format("%s (%d,%d,%d)[%d,%d]", name, world_position[1], world_position[2], world_position[3], size[1], size[2])

			Gui.text(gui, format, "materials/fonts/arial", 16, nil, var_16_8 + Vector2(num, num), Color(200, hsl2rgb, var_16_11, var_16_12), "shadow", Color(200, 0, 0, 0))
			fn_7(gui, var_16_8, size, Color(50, hsl2rgb, var_16_11, var_16_12), num)

			local children = var_16_4.children

			if not children then
				fn_8(arg_16_0, children, #children, arg_16_3)
			end
		end
	end
end

UISceneGraph.debug_render_scenegraph = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	return fn_8(arg_17_0, arg_17_1, #arg_17_1, arg_17_2 or 1)
end
