-- chunkname: @scripts/ui/views/deus_menu/deus_map_scene.lua

require("scripts/settings/dlcs/morris/deus_map_visibility_settings")

DeusMapScene = class(DeusMapScene)

local str = "units/morris_map/deus_starting_position_token_01"
local str_2 = "units/morris_map/deus_map_base_sig_belakor_01"
local str_3 = "units/morris_map/deus_map_base_travel_belakor_01"
local str_4 = "units/morris_map/deus_map_base_shrine_01"
local str_5 = "units/morris_map/deus_map_base_arena_belakor_01"
local str_6 = "units/morris_map/deus_map_symbol_03"
local str_7 = "units/morris_map/player_token/victor_token"
local str_8 = "units/morris_map/player_token/sienna_token"
local str_9 = "units/morris_map/player_token/bardin_token"
local str_10 = "units/morris_map/player_token/kerillian_token"
local str_11 = "units/morris_map/player_token/markus_token"
local tbl = {
	[DeusMapVisibilitySettings.WEAK_FOG_LEVEL] = 0,
	[DeusMapVisibilitySettings.WEAK_FOG_LEVEL + 1] = 0.333,
	[DeusMapVisibilitySettings.WEAK_FOG_LEVEL + 2] = 0.666,
	[DeusMapVisibilitySettings.WEAK_FOG_LEVEL + 3] = 1
}
local num = 0.2
local num_2 = 0.15
local num_3 = 0.05
local num_4 = 0.1
local num_5 = 0.015
local num_6 = -0.01
local flag = false
local flag_2 = false

local function fn()
	-- function 1
	local main_world = Application.main_world()
	local physics_world = World.physics_world(main_world)
	local current_level = LevelHelper:current_level(main_world)
	local get_data = World.get_data(main_world, "viewports")
	local var_1_4, var_1_5 = next(get_data)
	local wwise_world = Managers.world:wwise_world(main_world)
	local flow_variable = Level.flow_variable(current_level, "initial_camera")
	local local_pose = Unit.local_pose(flow_variable, 0)
	local camera = Unit.camera(flow_variable, "camera")
	local camera_2 = ScriptViewport.camera(var_1_5)
	local vertical_fov = Camera.vertical_fov(camera)

	Camera.set_vertical_fov(camera_2, vertical_fov)
	ScriptCamera.set_local_pose(camera_2, local_pose)
	ScriptCamera.force_update(main_world, camera_2)
	ScriptWorld.activate_viewport(main_world, var_1_5)

	return main_world, physics_world, camera_2, vertical_fov, current_level
end

local function fn_2()
	-- function 2
	return math.random() * 0.002 - 0.001
end

local function fn_3(arg_3_0)
	-- function 3
	local flow_variable = Level.flow_variable(arg_3_0, "map_bottom_left")
	local flow_variable_2 = Level.flow_variable(arg_3_0, "map_bottom_right")
	local flow_variable_3 = Level.flow_variable(arg_3_0, "map_top_left")
	local flow_variable_4 = Level.flow_variable(arg_3_0, "fog_bottom_left")
	local flow_variable_5 = Level.flow_variable(arg_3_0, "fog_bottom_right")
	local flow_variable_6 = Level.flow_variable(arg_3_0, "fog_top_left")
	local flow_variable_7 = Level.flow_variable(arg_3_0, "ref_a_node_from")
	local flow_variable_8 = Level.flow_variable(arg_3_0, "ref_a_edge")
	local flow_variable_9 = Level.flow_variable(arg_3_0, "ref_a_node_to")
	local flow_variable_10 = Level.flow_variable(arg_3_0, "ref_b_node_from")
	local flow_variable_11 = Level.flow_variable(arg_3_0, "ref_b_edge")
	local flow_variable_12 = Level.flow_variable(arg_3_0, "ref_b_node_to")
	local flow_variable_13 = Level.flow_variable(arg_3_0, "ref_token_1")
	local flow_variable_14 = Level.flow_variable(arg_3_0, "ref_token_2")
	local flow_variable_15 = Level.flow_variable(arg_3_0, "ref_token_3")
	local flow_variable_16 = Level.flow_variable(arg_3_0, "ref_token_4")
	local flow_variable_17 = Level.flow_variable(arg_3_0, "ref_token_node")
	local flow_variable_18 = Level.flow_variable(arg_3_0, "base_camera_bottom_left")
	local flow_variable_19 = Level.flow_variable(arg_3_0, "base_camera_top_right")
	local flow_variable_20 = Level.flow_variable(arg_3_0, "zoom_camera_bottom_left")
	local flow_variable_21 = Level.flow_variable(arg_3_0, "zoom_camera_top_right")
	local local_pose = Unit.local_pose(flow_variable_17, 0)
	local inverse = Matrix4x4.inverse(local_pose)
	local local_pose_2 = Unit.local_pose(flow_variable_13, 0)
	local local_pose_3 = Unit.local_pose(flow_variable_14, 0)
	local local_pose_4 = Unit.local_pose(flow_variable_15, 0)
	local local_pose_5 = Unit.local_pose(flow_variable_16, 0)
	local multiply = Matrix4x4.multiply(local_pose_2, inverse)
	local multiply_2 = Matrix4x4.multiply(local_pose_3, inverse)
	local multiply_3 = Matrix4x4.multiply(local_pose_4, inverse)
	local multiply_4 = Matrix4x4.multiply(local_pose_5, inverse)
	local tbl = {
		map_bottom_left_pos = Vector3Box(Unit.local_position(flow_variable, 0)),
		map_bottom_right_pos = Vector3Box(Unit.local_position(flow_variable_2, 0)),
		map_top_left_pos = Vector3Box(Unit.local_position(flow_variable_3, 0)),
		fog_bottom_left_pos = Vector3Box(Unit.local_position(flow_variable_4, 0)),
		fog_bottom_right_pos = Vector3Box(Unit.local_position(flow_variable_5, 0)),
		fog_top_left_pos = Vector3Box(Unit.local_position(flow_variable_6, 0)),
		referenced_token_poses = {
			Matrix4x4Box(multiply),
			Matrix4x4Box(multiply_2),
			Matrix4x4Box(multiply_3),
			(Matrix4x4Box(multiply_4))
		},
		camera_zoom_bottom_left_pose = Matrix4x4Box(Unit.local_pose(flow_variable_20, 0)),
		camera_zoom_top_right_pose = Matrix4x4Box(Unit.local_pose(flow_variable_21, 0)),
		camera_bottom_left_pose = Matrix4x4Box(Unit.local_pose(flow_variable_18, 0)),
		camera_top_right_pose = Matrix4x4Box(Unit.local_pose(flow_variable_19, 0)),
		ref_a_node_from_pos = Vector3Box(Unit.local_position(flow_variable_7, 0)),
		ref_a_node_to_pos = Vector3Box(Unit.local_position(flow_variable_9, 0)),
		ref_a_edge_pos = Vector3Box(Unit.local_position(flow_variable_8, 0)),
		ref_a_edge_scale = Vector3Box(Unit.local_scale(flow_variable_8, 0)),
		ref_b_node_from_pos = Vector3Box(Unit.local_position(flow_variable_10, 0)),
		ref_b_node_to_pos = Vector3Box(Unit.local_position(flow_variable_12, 0)),
		ref_b_edge_pos = Vector3Box(Unit.local_position(flow_variable_11, 0)),
		ref_b_edge_scale = Vector3Box(Unit.local_scale(flow_variable_11, 0))
	}

	Unit.disable_physics(flow_variable_7)
	Unit.disable_physics(flow_variable_8)
	Unit.disable_physics(flow_variable_9)
	Unit.disable_physics(flow_variable_10)
	Unit.disable_physics(flow_variable_11)
	Unit.disable_physics(flow_variable_12)
	Unit.disable_physics(flow_variable_13)
	Unit.disable_physics(flow_variable_14)
	Unit.disable_physics(flow_variable_15)
	Unit.disable_physics(flow_variable_16)
	Unit.disable_physics(flow_variable_17)
	Unit.set_unit_visibility(flow_variable_7, false)
	Unit.set_unit_visibility(flow_variable_8, false)
	Unit.set_unit_visibility(flow_variable_9, false)
	Unit.set_unit_visibility(flow_variable_10, false)
	Unit.set_unit_visibility(flow_variable_11, false)
	Unit.set_unit_visibility(flow_variable_12, false)
	Unit.set_unit_visibility(flow_variable_13, false)
	Unit.set_unit_visibility(flow_variable_14, false)
	Unit.set_unit_visibility(flow_variable_15, false)
	Unit.set_unit_visibility(flow_variable_16, false)
	Unit.set_unit_visibility(flow_variable_17, false)

	return tbl
end

local function fn_4(arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	local unbox = arg_4_1.map_bottom_left_pos:unbox()
	local unbox_2 = arg_4_1.map_bottom_right_pos:unbox()
	local unbox_3 = arg_4_1.map_top_left_pos:unbox()
	local unbox_4 = arg_4_1.ref_a_node_from_pos:unbox()
	local unbox_5 = arg_4_1.ref_a_node_to_pos:unbox()
	local unbox_6 = arg_4_1.ref_a_edge_pos:unbox()
	local unbox_7 = arg_4_1.ref_a_edge_scale:unbox()
	local unbox_8 = arg_4_1.ref_b_node_from_pos:unbox()
	local unbox_9 = arg_4_1.ref_b_node_to_pos:unbox()
	local unbox_10 = arg_4_1.ref_b_edge_pos:unbox()
	local unbox_11 = arg_4_1.ref_b_edge_scale:unbox()
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local num = unbox_2 - unbox
	local num_2 = unbox_3 - unbox

	for k, v in pairs(arg_4_2) do
		local num_3 = unbox + (num * v.layout_x + num_2 * v.layout_y)

		num_3.z = num_3.z + fn_2()
		tbl_3[k] = num_3
	end

	local length_squared = Vector3.length_squared(unbox_5 - unbox_4)
	local length_squared_2 = Vector3.length_squared(unbox_9 - unbox_8)
	local length_squared_3 = Vector3.length_squared(unbox_6 - unbox_4)
	local length_squared_4 = Vector3.length_squared(unbox_10 - unbox_8)

	for k_2, v_2 in pairs(arg_4_2) do
		local level = v_2.level
		local var_4_22

		if k_2 == "start" then
			var_4_22 = str
		else
			local sub = string.sub(level, 1, string.find(level, "_") - 1)

			if sub == "sig" then
				var_4_22 = str_2
			elseif sub == "pat" then
				var_4_22 = str_3
			elseif sub == "arena" then
				var_4_22 = str_5
			else
				var_4_22 = str_4
			end
		end

		local var_4_24 = tbl_3[k_2]
		local spawn_unit = World.spawn_unit(arg_4_0, var_4_22, var_4_24)

		tbl[k_2] = spawn_unit

		Unit.set_data(spawn_unit, "deus_node_key", k_2)
		Unit.set_data(spawn_unit, "theme", v_2.theme)
		Unit.set_data(spawn_unit, "level", v_2.base_level)

		tbl_2[k_2] = {}

		for k_3, v_3 in pairs(v_2.next) do
			local var_4_26 = tbl_3[v_3]
			local num_4 = var_4_26 - var_4_24
			local spawn_unit_2 = World.spawn_unit(arg_4_0, str_6)

			tbl_2[k_2][v_3] = spawn_unit_2

			local normalize = Vector3.normalize(num_4)
			local look = Quaternion.look(normalize, Vector3.up())

			Unit.set_local_rotation(spawn_unit_2, 0, look)

			local num_5 = (Vector3.length_squared(var_4_26 - var_4_24) - length_squared) / (length_squared_2 - length_squared)
			local lerp = math.lerp(length_squared_3, length_squared_4, num_5)
			local sqrt

			if lerp >= 0 then
				sqrt = math.sqrt(lerp)

				if not sqrt then
					-- Nothing
				end
			end

			sqrt = 0

			::label_4_0::

			local num_6 = var_4_24 + normalize * sqrt

			num_6.z = num_6.z + fn_2()

			Unit.set_local_position(spawn_unit_2, 0, num_6)

			local lerp_2 = math.lerp(unbox_7, unbox_11, num_5)

			Unit.set_local_scale(spawn_unit_2, 0, lerp_2)
			Unit.set_data(spawn_unit_2, "highlighted", false)
			Unit.flow_event(spawn_unit_2, "update_visuals")
		end

		Unit.flow_event(spawn_unit, "update_visuals")
	end

	local spawn_unit_3 = World.spawn_unit(arg_4_0, str_7)
	local spawn_unit_4 = World.spawn_unit(arg_4_0, str_8)
	local spawn_unit_5 = World.spawn_unit(arg_4_0, str_9)
	local spawn_unit_6 = World.spawn_unit(arg_4_0, str_10)
	local spawn_unit_7 = World.spawn_unit(arg_4_0, str_11)
	local tbl_4 = {
		spawn_unit_3,
		spawn_unit_4,
		spawn_unit_5,
		spawn_unit_6,
		spawn_unit_7
	}

	return tbl, tbl_2, tbl_4
end

local function fn_5(self, arg_5_1, arg_5_2)
	-- function 5
	for k, v in pairs(arg_5_2) do
		local var_5_0 = self[k]

		Unit.set_data(var_5_0, "visibility_level", v)
		Unit.flow_event(var_5_0, "update_visuals")

		for k_2, v_2 in pairs(arg_5_1[k]) do
			Unit.set_data(v_2, "visibility_level", v)
		end
	end
end

local function fn_6(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local unbox = arg_6_1.map_bottom_left_pos:unbox()
	local unbox_2 = arg_6_1.map_bottom_right_pos:unbox()
	local unbox_3 = arg_6_1.map_top_left_pos:unbox()
	local unbox_4 = arg_6_1.fog_bottom_left_pos:unbox()
	local unbox_5 = arg_6_1.fog_bottom_right_pos:unbox()
	local unbox_6 = arg_6_1.fog_top_left_pos:unbox()
	local num_7 = unbox_5 - unbox_4
	local num_8 = unbox_2 - unbox
	local num_9 = unbox_6 - unbox_4
	local num_10 = unbox_3 - unbox
	local var_6_10 = Vector2(num_8.x / num_7.x, num_10.y / num_9.y)
	local num_11 = unbox - unbox_4
	local var_6_12 = Vector2(num_11.x / num_7.x, num_11.y / num_9.y)
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h

	local function fn(arg_7_0, arg_7_1)
		-- function 7
		return arg_7_0 * var_6_10.x + var_6_12.x + num_5, arg_7_1 * var_6_10.y + var_6_12.y + num_6
	end

	local create_screen_gui = World.create_screen_gui(arg_6_0, "material", "materials/deus_map_fog_mask/deus_map_fog_mask", "immediate")
	local num_12 = Vector3.length(num_7) / Vector3.length(num_9)

	Gui.bitmap(create_screen_gui, "default_deus_map_fog_mask_clear", Vector3(0, 0, 0), Vector2(res_w, res_h), Color(255, 0, 0, 0))

	local function fn_2(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, arg_8_9, arg_8_10, arg_8_11, arg_8_12, arg_8_13, arg_8_14)
		-- function 8
		Gui.triangle(create_screen_gui, Vector3(arg_8_3, 0, arg_8_4), Vector3(arg_8_5, 0, arg_8_6), Vector3(arg_8_7, 0, arg_8_8), 0, Color(255, arg_8_1 * 255, arg_8_2 * 255, 255), arg_8_0, Vector2(arg_8_9, arg_8_10), Vector2(arg_8_11, arg_8_12), Vector2(arg_8_13, arg_8_14))
	end

	local function fn_3(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_9, arg_9_10, arg_9_11, arg_9_12, arg_9_13, arg_9_14, arg_9_15, arg_9_16, arg_9_17, arg_9_18)
		-- function 9
		fn_2(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_11, arg_9_12, arg_9_13, arg_9_14, arg_9_15, arg_9_16)
		fn_2(arg_9_0, arg_9_1, arg_9_2, arg_9_7, arg_9_8, arg_9_9, arg_9_10, arg_9_3, arg_9_4, arg_9_15, arg_9_16, arg_9_17, arg_9_18, arg_9_11, arg_9_12)
	end

	local function fn_4(arg_10_0, arg_10_1)
		-- function 10
		local var_10_0 = tbl[arg_6_3[arg_10_0]]
		local var_10_1 = tbl[arg_6_3[arg_10_1]]
		local var_10_2 = arg_6_2[arg_10_0]
		local var_10_3 = arg_6_2[arg_10_1]
		local var_10_4, var_10_5 = fn(var_10_2.layout_x, var_10_2.layout_y)
		local num_3 = var_10_4 * res_w
		local num_4 = var_10_5 * res_h
		local var_10_8, var_10_9 = fn(var_10_3.layout_x, var_10_3.layout_y)
		local num_5 = var_10_8 * res_w
		local num_6 = var_10_9 * res_h
		local num_7 = num_5 - num_3
		local num_8 = num_6 - num_4
		local sqrt = math.sqrt(num_7 * num_7 + num_8 * num_8)
		local num_9 = num_7 / sqrt
		local num_10 = num_8 / sqrt
		local var_10_17

		if arg_10_0 == "final" then
			var_10_17 = num

			if not var_10_17 then
				-- Nothing
			end
		end

		var_10_17 = num_2

		::label_10_0::

		local num_11 = var_10_17 * res_w
		local num_13 = var_10_17 * num_12 * res_h
		local num_14 = num_3 + num_10 * num_11
		local num_15 = num_4 - num_9 * num_13
		local num_16 = num_3 - num_10 * num_11
		local num_17 = num_4 + num_9 * num_13
		local num_18 = num_5 + num_10 * num_11
		local num_19 = num_6 - num_9 * num_13
		local num_20 = num_5 - num_10 * num_11
		local num_21 = num_6 + num_9 * num_13

		fn_3("default_deus_map_fog_mask_edge", var_10_0, var_10_1, num_18, num_19, num_14, num_15, num_16, num_17, num_20, num_21, 1, 0, 0, 0, 0, 1, 1, 1)
	end

	local function fn_5(arg_11_0)
		-- function 11
		local var_11_0 = tbl[arg_6_3[arg_11_0]]
		local var_11_1 = arg_6_2[arg_11_0]
		local var_11_2, var_11_3 = fn(var_11_1.layout_x, var_11_1.layout_y)
		local num_3 = var_11_2 * res_w
		local num_4 = var_11_3 * res_h
		local var_11_6

		if arg_11_0 == "final" then
			var_11_6 = num

			if not var_11_6 then
				-- Nothing
			end
		end

		var_11_6 = num_2

		::label_11_0::

		local num_5 = var_11_6 * res_w
		local num_6 = var_11_6 * num_12 * res_h
		local num_7 = num_3 - num_5
		local num_8 = num_4 - num_6
		local num_9 = num_3 + num_5
		local num_10 = num_4 - num_6
		local num_11 = num_3 - num_5
		local num_13 = num_4 + num_6
		local num_14 = num_3 + num_5
		local num_15 = num_4 + num_6

		fn_3("default_deus_map_fog_mask_node", var_11_0, var_11_0, num_11, num_13, num_7, num_8, num_9, num_10, num_14, num_15, 1, 0, 0, 0, 0, 1, 1, 1)
	end

	local function fn_6(arg_12_0)
		-- function 12
		local var_12_0 = arg_6_2[arg_12_0]

		fn_5(arg_12_0)

		for i, v in ipairs(var_12_0.next) do
			fn_4(arg_12_0, v)
			fn_6(v)
		end
	end

	fn_6("start")

	local var_6_23, var_6_24 = fn(arg_6_2.start.layout_x, arg_6_2.start.layout_y)
	local num_13 = 0
	local num_14 = 1
	local num_15 = 0
	local num_16 = 1 - num_4
	local var_6_29 = var_6_23
	local num_17 = 1
	local var_6_31 = var_6_23
	local num_18 = 1 - num_4
	local num_19 = 0
	local var_6_34 = num_4
	local num_20 = 0
	local num_21 = 0
	local var_6_37 = var_6_23
	local var_6_38 = num_4
	local var_6_39 = var_6_23
	local num_22 = 0
	local num_23 = 1 - num_3
	local var_6_42 = num_4
	local num_24 = 1 - num_3
	local num_25 = 0
	local num_26 = 1
	local var_6_46 = num_4
	local num_27 = 1
	local num_28 = 0
	local num_29 = 1 - num_3
	local num_30 = 1
	local num_31 = 1 - num_3
	local num_32 = 1 - num_4
	local num_33 = 1
	local num_34 = 1
	local num_35 = 1
	local num_36 = 1 - num_4

	fn_3("default_deus_map_fog_mask_border", 1, 0, num_15 * res_w, num_16 * res_h, num_19 * res_w, var_6_34 * res_h, var_6_37 * res_w, var_6_38 * res_h, var_6_31 * res_w, num_18 * res_h, 0, 0, 0, 0, 1, 0, 1, 0)
	fn_3("default_deus_map_fog_mask_border", 1, 0, num_15 * res_w, num_16 * res_h, var_6_31 * res_w, num_18 * res_h, var_6_29 * res_w, num_17 * res_h, num_13 * res_w, num_14 * res_h, 0, 0, 1, 0, 0, 0, 0, 0)
	fn_3("default_deus_map_fog_mask_border", 1, 0, var_6_31 * res_w, num_18 * res_h, num_31 * res_w, num_32 * res_h, num_29 * res_w, num_30 * res_h, var_6_29 * res_w, num_17 * res_h, 1, 0, 1, 0, 0, 0, 0, 0)
	fn_3("default_deus_map_fog_mask_border", 1, 0, num_31 * res_w, num_32 * res_h, num_35 * res_w, num_36 * res_h, num_33 * res_w, num_34 * res_h, num_29 * res_w, num_30 * res_h, 1, 0, 0, 0, 0, 0, 0, 0)
	fn_3("default_deus_map_fog_mask_border", 1, 0, num_31 * res_w, num_32 * res_h, num_23 * res_w, var_6_42 * res_h, num_26 * res_w, var_6_46 * res_h, num_35 * res_w, num_36 * res_h, 1, 0, 1, 0, 0, 0, 0, 0)
	fn_3("default_deus_map_fog_mask_border", 1, 0, num_24 * res_w, num_25 * res_h, num_27 * res_w, num_28 * res_h, num_26 * res_w, var_6_46 * res_h, num_23 * res_w, var_6_42 * res_h, 0, 0, 0, 0, 0, 0, 1, 0)
	fn_3("default_deus_map_fog_mask_border", 1, 0, var_6_37 * res_w, var_6_38 * res_h, var_6_39 * res_w, num_22 * res_h, num_24 * res_w, num_25 * res_h, num_23 * res_w, var_6_42 * res_h, 1, 0, 0, 0, 0, 0, 1, 0)
	fn_3("default_deus_map_fog_mask_border", 1, 0, num_20 * res_w, num_21 * res_h, var_6_39 * res_w, num_22 * res_h, var_6_37 * res_w, var_6_38 * res_h, num_19 * res_w, var_6_34 * res_h, 0, 0, 0, 0, 1, 0, 0, 0)
end

local function fn_7(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
	-- function 13
	local screen_to_world = Camera.screen_to_world(arg_13_0, arg_13_2, 0)
	local num = Camera.screen_to_world(arg_13_0, Vector3(arg_13_2.x, arg_13_2.y, 0), 1) - screen_to_world
	local normalize = Vector3.normalize(num)

	return PhysicsWorld.immediate_raycast(arg_13_1, screen_to_world, normalize, arg_13_4, arg_13_3, "types", "statics", "collision_filter", arg_13_5)
end

local function fn_8(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local translation = Matrix4x4.translation(arg_14_0)
	local translation_2 = Matrix4x4.translation(arg_14_1)
	local rotation = Matrix4x4.rotation(arg_14_0)
	local rotation_2 = Matrix4x4.rotation(arg_14_1)
	local num = (arg_14_2 + arg_14_3) / math.sqrt(2)
	local var_14_5 = Vector3(math.lerp(translation[1], translation_2[1], arg_14_2), math.lerp(translation[2], translation_2[2], arg_14_3), math.lerp(translation[3], translation_2[3], num))
	local lerp = Quaternion.lerp(rotation, rotation_2, num)

	return (Matrix4x4.from_quaternion_position(lerp, var_14_5))
end

local function fn_9(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6)
	-- function 15
	local var_15_0
	local num = arg_15_5 - arg_15_4
	local num_2

	if num <= 0.001 then
		num_2 = 1
	else
		local clamp = math.clamp((arg_15_6 - arg_15_4) / num, 0, 1)

		num_2 = (3 - 2 * clamp) * clamp^2
	end

	local lerp = Matrix4x4.lerp(arg_15_2, arg_15_3, num_2)

	ScriptCamera.set_local_pose(arg_15_0, lerp)
	Camera.set_vertical_fov(arg_15_0, arg_15_1)
end

local function fn_10(arg_16_0, arg_16_1, arg_16_2)
	-- function 16
	ScriptCamera.set_local_pose(arg_16_0, arg_16_2)
	Camera.set_vertical_fov(arg_16_0, arg_16_1)
end

local tbl_2 = {
	paused = "paused",
	active = "active",
	initialized = "initialized"
}

DeusMapScene.init = function (self)
	-- function 17
	self._state = tbl_2.initialized
end

DeusMapScene.on_enter = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	-- function 18
	self:_clear()

	self._state = tbl_2.active
	self._world, self._physics_world, self._camera, self._fov, self._level = fn()
	self._selected_unit = nil
	self._cursor_update_enabled = true
	self._input_service = arg_18_2
	self._node_pressed_cb = arg_18_3
	self._node_hovered_cb = arg_18_4
	self._node_unhovered_cb = arg_18_5
	self._level_ref_values = fn_3(self._level)
	self._graph_data = arg_18_1
	self._nodes_to_units, self._edges_to_units, self._profile_index_to_token = fn_4(self._world, self._level_ref_values, arg_18_1)

	for k, v in pairs(self._profile_index_to_token) do
		self:_hide_token(k)
	end

	self._event_manager = Managers.state.event

	self._event_manager:register(self, "on_game_options_changed", "_on_game_options_changed")
end

DeusMapScene.on_finish = function (self)
	-- function 19
	if not self._hovered_node_key then
		self._node_unhovered_cb()

		self._hovered_node_key = nil
	end

	self._cursor_update_enabled = false

	self._event_manager:unregister("on_game_options_changed", self)

	self._event_manager = nil
end

DeusMapScene.update = function (self, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	local modified = RESOLUTION_LOOKUP.modified

	modified = modified or self._game_options_changed

	if not modified and not self._last_visibility_data then
		self:setup_fog(self._last_visibility_data)
	end

	self._game_options_changed = false

	if self._state ~= tbl_2.active or not self._cursor_update_enabled then
		self:_update_cursor(arg_20_3)
	end
end

DeusMapScene.post_update = function (self, arg_21_1, arg_21_2)
	-- function 21
	if self._state ~= tbl_2.initialized then
		self:_update_camera(arg_21_2)
	end
end

DeusMapScene.destroy = function (self)
	-- function 22
	self:_clear()

	if not self._event_manager then
		self._event_manager:unregister("on_game_options_changed", self)

		self._event_manager = nil
	end
end

DeusMapScene._clear = function (self)
	-- function 23
	self._node_pressed_cb = nil
	self._node_hovered_cb = nil
	self._node_unhovered_cb = nil

	if not self._nodes_to_units then
		for k, v in pairs(self._nodes_to_units) do
			World.destroy_unit(self._world, v)
		end
	end

	if not self._profile_index_to_token then
		for k_2, v_2 in pairs(self._profile_index_to_token) do
			World.destroy_unit(self._world, v_2)
		end
	end

	if not self._edges_to_units then
		for k_3, v_3 in pairs(self._edges_to_units) do
			for k_4, v_4 in pairs(v_3) do
				World.destroy_unit(self._world, v_4)
			end
		end
	end

	self._profile_index_to_token = nil
	self._nodes_to_units = nil
	self._edges_to_units = nil
	self._own_hero_name = nil
end

DeusMapScene._update_camera = function (self, arg_24_1)
	-- function 24
	if not self._camera_animation_start_time then
		self._camera_animation_start_time = arg_24_1
		self._camera_animation_end_time = arg_24_1 + self._camera_animation_duration
	end

	local _camera = self._camera

	fn_9(_camera, self._fov, self._camera_source_pose:unbox(), self._camera_target_pose:unbox(), self._camera_animation_start_time, self._camera_animation_end_time, arg_24_1)
	ScriptCamera.force_update(self._world, _camera)
end

local tbl_3 = {
	0,
	0,
	0
}

DeusMapScene._update_cursor = function (self, arg_25_1)
	-- function 25
	local get = self._input_service:get("cursor")

	get = get or tbl_3

	local var_25_1

	if not (not IS_XB1 and arg_25_1) then
		var_25_1 = UIScaleVectorToResolution(Vector3(get[1], 1080 - get[2], get[3]))
	elseif not arg_25_1 then
		var_25_1 = UIScaleVectorToResolution(get)
	else
		var_25_1 = get
	end

	local var_25_2, var_25_3, var_25_4, var_25_5, var_25_6 = fn_7(self._camera, self._physics_world, var_25_1, "closest", 3, "filter_deus_map_node_click", self._debug_drawer_stay)
	local var_25_7

	if not var_25_2 then
		local unit = Actor.unit(var_25_6)

		var_25_7 = Unit.get_data(unit, "deus_node_key")
	end

	if not var_25_7 then
		if not self._selectables and self._input_service:get("confirm_press") and not self._input_service:get("left_press") and not table.contains(self._selectables, var_25_7) then
			self._node_pressed_cb(var_25_7)
		end

		if self._hovered_node_key ~= var_25_7 then
			if not self._hovered_node_key then
				self._node_unhovered_cb()
			end

			self._hovered_node_key = var_25_7

			self._node_hovered_cb(var_25_7)
		end

		if not arg_25_1 then
			Managers.input:set_hovering(true)
		end
	elseif not self._hovered_node_key then
		self._node_unhovered_cb()

		self._hovered_node_key = nil
	end
end

DeusMapScene.setup_fog = function (self, arg_26_1)
	-- function 26
	self._last_visibility_data = arg_26_1

	fn_6(self._world, self._level_ref_values, self._graph_data, self._last_visibility_data, self._debug_drawer)
	fn_5(self._nodes_to_units, self._edges_to_units, self._last_visibility_data)
end

DeusMapScene._on_game_options_changed = function (self)
	-- function 27
	self._game_options_changed = true
end

DeusMapScene.animate_camera_to = function (self, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	self._started_once = true
	self._camera_animation_duration = arg_28_3
	self._camera_animation_start_time = nil
	self._camera_animation_end_time = nil
	self._camera_source_pose = Matrix4x4Box(ScriptCamera.pose(self._camera))

	local unbox = self._level_ref_values.camera_bottom_left_pose:unbox()
	local unbox_2 = self._level_ref_values.camera_top_right_pose:unbox()

	self._camera_target_pose = Matrix4x4Box(fn_8(unbox, unbox_2, arg_28_1, arg_28_2))
end

DeusMapScene.zoom_camera_to = function (self, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	self._started_once = true
	self._camera_animation_duration = arg_29_3
	self._camera_animation_start_time = nil
	self._camera_animation_end_time = nil
	self._camera_source_pose = Matrix4x4Box(ScriptCamera.pose(self._camera))

	local unbox = self._level_ref_values.camera_zoom_bottom_left_pose:unbox()
	local unbox_2 = self._level_ref_values.camera_zoom_top_right_pose:unbox()

	self._camera_target_pose = Matrix4x4Box(fn_8(unbox, unbox_2, arg_29_1, arg_29_2))
end

DeusMapScene.set_zoomed_camera_to = function (self, arg_30_1, arg_30_2)
	-- function 30
	local unbox = self._level_ref_values.camera_zoom_bottom_left_pose:unbox()
	local unbox_2 = self._level_ref_values.camera_zoom_top_right_pose:unbox()
	local var_30_2 = fn_8(unbox, unbox_2, arg_30_1, arg_30_2)

	fn_10(self._camera, self._fov, var_30_2)
end

DeusMapScene.place_token = function (self, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	self:_place_token(arg_31_1, arg_31_2, arg_31_3)
end

DeusMapScene.hide_token = function (self, arg_32_1)
	-- function 32
	self:_hide_token(arg_32_1)
end

DeusMapScene.set_own_hero_name = function (self, arg_33_1)
	-- function 33
	if self._own_hero_name ~= arg_33_1 then
		for k, v in pairs(self._nodes_to_units) do
			Unit.set_data(v, "hero_name", arg_33_1)
			Unit.flow_event(v, "update_visuals")
		end
	end

	self._own_hero_name = arg_33_1
end

DeusMapScene.undiscover_node = function (self, arg_34_1)
	-- function 34
	local var_34_0 = self._nodes_to_units[arg_34_1]

	Unit.set_data(var_34_0, "discovered", false)
	Unit.flow_event(var_34_0, "update_visuals")
end

DeusMapScene.discover_node = function (self, arg_35_1)
	-- function 35
	local var_35_0 = self._nodes_to_units[arg_35_1]

	Unit.set_data(var_35_0, "discovered", true)
	Unit.flow_event(var_35_0, "update_visuals")
end

DeusMapScene.selectable_node = function (self, arg_36_1)
	-- function 36
	local var_36_0 = self._nodes_to_units[arg_36_1]

	Unit.set_data(var_36_0, "selectable", true)
	Unit.flow_event(var_36_0, "update_visuals")

	local _selectables = self._selectables

	_selectables = _selectables or {}
	self._selectables = _selectables

	for i, v in ipairs(self._selectables) do
		if v == arg_36_1 then
			return
		end
	end

	self._selectables[#self._selectables + 1] = arg_36_1
end

DeusMapScene.unselectable_node = function (self, arg_37_1)
	-- function 37
	local var_37_0 = self._nodes_to_units[arg_37_1]

	Unit.set_data(var_37_0, "selectable", false)
	Unit.flow_event(var_37_0, "update_visuals")

	if not self._selectables then
		local index_of = table.index_of(self._selectables, arg_37_1)

		if index_of ~= -1 then
			table.swap_delete(self._selectables, index_of)
		end
	end
end

DeusMapScene.untraversed_node = function (self, arg_38_1)
	-- function 38
	local var_38_0 = self._nodes_to_units[arg_38_1]

	Unit.set_data(var_38_0, "traversed", false)
	Unit.flow_event(var_38_0, "update_visuals")
end

DeusMapScene.traversed_node = function (self, arg_39_1)
	-- function 39
	local var_39_0 = self._nodes_to_units[arg_39_1]

	Unit.set_data(var_39_0, "traversed", true)
	Unit.flow_event(var_39_0, "update_visuals")
end

DeusMapScene.unreachable_node = function (self, arg_40_1)
	-- function 40
	local var_40_0 = self._nodes_to_units[arg_40_1]

	Unit.set_data(var_40_0, "unreachable", true)
	Unit.flow_event(var_40_0, "update_visuals")
end

DeusMapScene.select_node = function (self, arg_41_1, arg_41_2)
	-- function 41
	local var_41_0 = self._nodes_to_units[arg_41_1]

	Unit.set_data(var_41_0, "selected", true)
	Unit.flow_event(var_41_0, "update_visuals")

	if not arg_41_2 and not Managers.state.network:game() then
		Managers.state.entity:system("audio_system"):play_2d_audio_event(arg_41_2)
	end
end

DeusMapScene.unselect_node = function (self, arg_42_1)
	-- function 42
	local var_42_0 = self._nodes_to_units[arg_42_1]

	Unit.set_data(var_42_0, "selected", false)
	Unit.flow_event(var_42_0, "update_visuals")
end

DeusMapScene.set_final_node = function (self, arg_43_1)
	-- function 43
	local var_43_0 = self._nodes_to_units[arg_43_1]

	Unit.set_data(var_43_0, "selected", true)
	Unit.set_data(var_43_0, "selectable", true)
	Unit.flow_event(var_43_0, "update_visuals")
end

DeusMapScene.highlight_edge = function (self, arg_44_1, arg_44_2)
	-- function 44
	local var_44_0 = self._edges_to_units[arg_44_1][arg_44_2]

	if not var_44_0 then
		local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()
		local get_traversed_nodes = get_deus_run_controller:get_traversed_nodes()
		local get_graph_data = get_deus_run_controller:get_graph_data()

		printf("self._edges_to_units:%s\ntraversed_nodes:%s\ngraph:%s", table.tostring(self._edges_to_units), table.tostring(get_traversed_nodes), table.tostring(get_graph_data, 2))
		ferror("[DeusMapScene] edge from<%s> to<%s> doesn't exist!", arg_44_1, arg_44_2)
	end

	Unit.set_data(var_44_0, "highlighted", true)
	Unit.flow_event(var_44_0, "update_visuals")
end

DeusMapScene.unhighlight_edge = function (self, arg_45_1, arg_45_2)
	-- function 45
	local var_45_0 = self._edges_to_units[arg_45_1][arg_45_2]

	if not var_45_0 then
		local get_deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()
		local get_traversed_nodes = get_deus_run_controller:get_traversed_nodes()
		local get_graph_data = get_deus_run_controller:get_graph_data()

		printf("self._edges_to_units:%s\ntraversed_nodes:%s\ngraph:%s", table.tostring(self._edges_to_units), table.tostring(get_traversed_nodes), table.tostring(get_graph_data, 2))
		ferror("[DeusMapScene] edge from<%s> to<%s> doesn't exist!", arg_45_1, arg_45_2)
	end

	Unit.set_data(var_45_0, "highlighted", false)
	Unit.flow_event(var_45_0, "update_visuals")
end

DeusMapScene.hover_node = function (self, arg_46_1)
	-- function 46
	local var_46_0 = self._nodes_to_units[arg_46_1]

	Unit.set_data(var_46_0, "hovered", true)
	Unit.flow_event(var_46_0, "update_visuals")
end

DeusMapScene.unhover_node = function (self, arg_47_1)
	-- function 47
	local var_47_0 = self._nodes_to_units[arg_47_1]

	Unit.set_data(var_47_0, "hovered", false)
	Unit.flow_event(var_47_0, "update_visuals")
end

DeusMapScene.get_screen_pos_of_node = function (self, arg_48_1)
	-- function 48
	local var_48_0 = self._nodes_to_units[arg_48_1]

	return Camera.world_to_screen(self._camera, Unit.local_position(var_48_0, 0))
end

DeusMapScene.animate_arena_belakor_node = function (self, arg_49_1)
	-- function 49
	local var_49_0 = self._nodes_to_units[arg_49_1]

	Unit.flow_event(var_49_0, "first_time_seeing_arena_belakor_node")
end

DeusMapScene._place_token = function (self, arg_50_1, arg_50_2, arg_50_3)
	-- function 50
	local var_50_0 = self._profile_index_to_token[arg_50_1]
	local var_50_1 = self._nodes_to_units[arg_50_3]
	local var_50_2 = self._level_ref_values.referenced_token_poses[arg_50_2]
	local multiply = Matrix4x4.multiply(Unit.local_pose(var_50_1, 0), var_50_2:unbox())

	Unit.set_unit_visibility(var_50_0, true)
	Unit.set_local_pose(var_50_0, 0, multiply)
end

DeusMapScene._hide_token = function (self, arg_51_1)
	-- function 51
	local var_51_0 = self._profile_index_to_token[arg_51_1]

	Unit.set_unit_visibility(var_51_0, false)
end
