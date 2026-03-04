-- chunkname: @core/wwise/lua/wwise_visualization.lua

WwiseVisualization = WwiseVisualization or {}

local var_0_0 = stingray.Unit
local var_0_1 = stingray.Vector3
local var_0_2 = stingray.LineObject
local var_0_3 = stingray.Color
local var_0_4 = stingray.LevelEditor or LevelEditor
local var_0_5 = {}

local function var_0_6(arg_1_0)
	local var_1_0 = true
	local var_1_1 = var_0_0.get_data(arg_1_0, "Wwise", "event_name")

	if var_1_1 == nil or var_1_1 == "" then
		var_1_0 = false
	elseif Wwise.has_event(var_1_1) == false then
		print_error("WwiseVisualizaton. Wwise banks do not contain event: " .. var_1_1)

		var_1_0 = false
	end

	return var_1_0
end

function WwiseVisualization.add_soundscape_unit(arg_2_0)
	if not stingray.Wwise then
		return
	end

	if not var_0_6(arg_2_0) then
		return
	end

	var_0_5[#var_0_5 + 1] = arg_2_0
end

local function var_0_7(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = var_0_0.get_data(arg_3_2, "Wwise", "event_name")
	local var_3_1 = var_0_0.get_data(arg_3_2, "Wwise", "unit_node") or ""
	local var_3_2 = 1

	if var_3_1 ~= "" then
		var_3_2 = var_0_0.node(arg_3_2, var_3_1)
	end

	local var_3_3 = var_0_0.world_pose(arg_3_2, var_3_2)
	local var_3_4 = Matrix4x4.translation(var_3_3)
	local var_3_5 = string.lower(var_0_0.get_data(arg_3_2, "Wwise", "shape"))
	local var_3_6 = 5
	local var_3_7 = var_3_6

	if var_3_5 == "sphere" then
		var_3_7 = var_0_0.get_data(arg_3_2, "Wwise", "sphere_radius") or var_3_6
	elseif var_3_5 == "box" then
		var_3_7 = var_0_1(0, 0, 0)
		var_3_7.x = var_0_0.get_data(arg_3_2, "Wwise", "box_extents", 0) or var_3_6
		var_3_7.y = var_0_0.get_data(arg_3_2, "Wwise", "box_extents", 1) or var_3_6
		var_3_7.z = var_0_0.get_data(arg_3_2, "Wwise", "box_extents", 2) or var_3_6
	end

	local var_3_8

	if var_0_0.has_data(arg_3_2, "Wwise", "trigger_range") then
		var_3_8 = var_0_0.get_data(arg_3_2, "Wwise", "trigger_range")
	else
		var_3_8 = Wwise.max_attenuation(var_3_0)
	end

	local var_3_9 = var_0_3(0, 240, 170)
	local var_3_10 = var_0_3(0, 160, 225)

	if Wwise.position_type(var_3_0) == Wwise.WWISE_3D_SOUND then
		if var_3_5 == "point" then
			var_0_2.add_sphere(arg_3_1, var_3_9, var_3_4, var_3_8)
		elseif var_3_5 == "sphere" then
			var_0_2.add_sphere(arg_3_1, var_3_10, var_3_4, var_3_7)
			var_0_2.add_sphere(arg_3_1, var_3_9, var_3_4, var_3_7 + var_3_8)
		elseif var_3_5 == "box" then
			Matrix4x4.set_x(var_3_3, var_0_1.normalize(Matrix4x4.x(var_3_3)))
			Matrix4x4.set_y(var_3_3, var_0_1.normalize(Matrix4x4.y(var_3_3)))
			Matrix4x4.set_z(var_3_3, var_0_1.normalize(Matrix4x4.z(var_3_3)))
			var_0_2.add_box(arg_3_1, var_3_10, var_3_3, var_3_7)
			var_0_2.add_box(arg_3_1, var_3_9, var_3_3, var_3_7 + var_0_1(1, 1, 1) * var_3_8)
		end
	end
end

function WwiseVisualization.render(arg_4_0, arg_4_1)
	if not stingray.Wwise then
		return
	end

	local var_4_0
	local var_4_1
	local var_4_2

	if var_0_4 then
		var_4_0 = Selection.objects(var_0_4.selection)

		local var_4_3, var_4_4 = Selection.last_selected_object(var_0_4.selection)
	else
		var_4_0 = LevelEditing.selection:objects()

		local var_4_5, var_4_6 = Selection.last_selected_object(LevelEditing.selection)
	end

	for iter_4_0, iter_4_1 in pairs(var_4_0) do
		local var_4_7 = iter_4_1._unit
		local var_4_8 = Array.index_of(var_0_5, var_4_7)

		if var_4_8 then
			local var_4_9 = var_0_5[var_4_8]

			if not var_0_0.alive(var_4_9) then
				table.remove(var_0_5, var_4_8)
			else
				var_0_7(arg_4_0, arg_4_1, var_4_9)
			end
		end
	end
end

return WwiseVisualization
