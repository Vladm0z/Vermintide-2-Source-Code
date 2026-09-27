-- chunkname: @core/wwise/lua/wwise_visualization.lua

local WwiseVisualization = WwiseVisualization

WwiseVisualization = WwiseVisualization or {}
WwiseVisualization = WwiseVisualization

local Unit = stingray.Unit
local Vector3 = stingray.Vector3
local LineObject = stingray.LineObject
local Color = stingray.Color
local LevelEditor = stingray.LevelEditor

LevelEditor = LevelEditor or LevelEditor

local tbl = {}

local function fn(arg_1_0)
	-- function 1
	local flag = true
	local get_data = Unit.get_data(arg_1_0, "Wwise", "event_name")

	if not (get_data == nil or get_data ~= "") then
		flag = false
	elseif Wwise.has_event(get_data) == false then
		print_error("WwiseVisualizaton. Wwise banks do not contain event: " .. get_data)

		flag = false
	end

	return flag
end

WwiseVisualization.add_soundscape_unit = function (arg_2_0)
	-- function 2
	if not stingray.Wwise then
		return
	end

	if not fn(arg_2_0) then
		return
	end

	tbl[#tbl + 1] = arg_2_0
end

local function fn_2(arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local get_data = Unit.get_data(arg_3_2, "Wwise", "event_name")
	local get_data_2 = Unit.get_data(arg_3_2, "Wwise", "unit_node")

	get_data_2 = get_data_2 or ""

	local num = 1

	if get_data_2 ~= "" then
		num = Unit.node(arg_3_2, get_data_2)
	end

	local world_pose = Unit.world_pose(arg_3_2, num)
	local translation = Matrix4x4.translation(world_pose)
	local lower = string.lower(Unit.get_data(arg_3_2, "Wwise", "shape"))
	local num_2 = 5
	local var_3_7 = num_2

	if lower == "sphere" then
		var_3_7 = Unit.get_data(arg_3_2, "Wwise", "sphere_radius") or num_2
	elseif lower == "box" then
		var_3_7 = Vector3(0, 0, 0)

		local get_data_3 = Unit.get_data(arg_3_2, "Wwise", "box_extents", 0)

		get_data_3 = get_data_3 or num_2
		var_3_7.x = get_data_3

		local get_data_4 = Unit.get_data(arg_3_2, "Wwise", "box_extents", 1)

		get_data_4 = get_data_4 or num_2
		var_3_7.y = get_data_4

		local get_data_5 = Unit.get_data(arg_3_2, "Wwise", "box_extents", 2)

		get_data_5 = get_data_5 or num_2
		var_3_7.z = get_data_5
	end

	local var_3_11

	if not Unit.has_data(arg_3_2, "Wwise", "trigger_range") then
		var_3_11 = Unit.get_data(arg_3_2, "Wwise", "trigger_range")
	else
		var_3_11 = Wwise.max_attenuation(get_data)
	end

	local var_3_12 = Color(0, 240, 170)
	local var_3_13 = Color(0, 160, 225)

	if Wwise.position_type(get_data) == Wwise.WWISE_3D_SOUND then
		if lower == "point" then
			LineObject.add_sphere(arg_3_1, var_3_12, translation, var_3_11)
		elseif lower == "sphere" then
			LineObject.add_sphere(arg_3_1, var_3_13, translation, var_3_7)
			LineObject.add_sphere(arg_3_1, var_3_12, translation, var_3_7 + var_3_11)
		elseif lower == "box" then
			Matrix4x4.set_x(world_pose, Vector3.normalize(Matrix4x4.x(world_pose)))
			Matrix4x4.set_y(world_pose, Vector3.normalize(Matrix4x4.y(world_pose)))
			Matrix4x4.set_z(world_pose, Vector3.normalize(Matrix4x4.z(world_pose)))
			LineObject.add_box(arg_3_1, var_3_13, world_pose, var_3_7)
			LineObject.add_box(arg_3_1, var_3_12, world_pose, var_3_7 + Vector3(1, 1, 1) * var_3_11)
		end
	end
end

WwiseVisualization.render = function (arg_4_0, arg_4_1)
	-- function 4
	if not stingray.Wwise then
		return
	end

	local var_4_0
	local var_4_1
	local var_4_2

	if not LevelEditor then
		var_4_0 = Selection.objects(LevelEditor.selection)

		local last_selected_object, var_4_4 = Selection.last_selected_object(LevelEditor.selection)
	else
		var_4_0 = LevelEditing.selection:objects()

		local last_selected_object_2, var_4_6 = Selection.last_selected_object(LevelEditing.selection)
	end

	for k, v in pairs(var_4_0) do
		local _unit = v._unit
		local index_of = Array.index_of(tbl, _unit)

		if not index_of then
			local var_4_9 = tbl[index_of]

			if not Unit.alive(var_4_9) then
				table.remove(tbl, index_of)
			else
				fn_2(arg_4_0, arg_4_1, var_4_9)
			end
		end
	end
end

return WwiseVisualization
