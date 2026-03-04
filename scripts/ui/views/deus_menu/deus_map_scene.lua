-- chunkname: @scripts/ui/views/deus_menu/deus_map_scene.lua

require("scripts/settings/dlcs/morris/deus_map_visibility_settings")

DeusMapScene = class(DeusMapScene)

local var_0_0 = "units/morris_map/deus_starting_position_token_01"
local var_0_1 = "units/morris_map/deus_map_base_sig_belakor_01"
local var_0_2 = "units/morris_map/deus_map_base_travel_belakor_01"
local var_0_3 = "units/morris_map/deus_map_base_shrine_01"
local var_0_4 = "units/morris_map/deus_map_base_arena_belakor_01"
local var_0_5 = "units/morris_map/deus_map_symbol_03"
local var_0_6 = "units/morris_map/player_token/victor_token"
local var_0_7 = "units/morris_map/player_token/sienna_token"
local var_0_8 = "units/morris_map/player_token/bardin_token"
local var_0_9 = "units/morris_map/player_token/kerillian_token"
local var_0_10 = "units/morris_map/player_token/markus_token"
local var_0_11 = {
	[DeusMapVisibilitySettings.WEAK_FOG_LEVEL] = 0,
	[DeusMapVisibilitySettings.WEAK_FOG_LEVEL + 1] = 0.333,
	[DeusMapVisibilitySettings.WEAK_FOG_LEVEL + 2] = 0.666,
	[DeusMapVisibilitySettings.WEAK_FOG_LEVEL + 3] = 1
}
local var_0_12 = 0.2
local var_0_13 = 0.15
local var_0_14 = 0.05
local var_0_15 = 0.1
local var_0_16 = 0.015
local var_0_17 = -0.01
local var_0_18 = false
local var_0_19 = false

local function var_0_20()
	local var_1_0 = Application.main_world()
	local var_1_1 = World.physics_world(var_1_0)
	local var_1_2 = LevelHelper:current_level(var_1_0)
	local var_1_3 = World.get_data(var_1_0, "viewports")
	local var_1_4, var_1_5 = next(var_1_3)
	local var_1_6 = Managers.world:wwise_world(var_1_0)
	local var_1_7 = Level.flow_variable(var_1_2, "initial_camera")
	local var_1_8 = Unit.local_pose(var_1_7, 0)
	local var_1_9 = Unit.camera(var_1_7, "camera")
	local var_1_10 = ScriptViewport.camera(var_1_5)
	local var_1_11 = Camera.vertical_fov(var_1_9)

	Camera.set_vertical_fov(var_1_10, var_1_11)
	ScriptCamera.set_local_pose(var_1_10, var_1_8)
	ScriptCamera.force_update(var_1_0, var_1_10)
	ScriptWorld.activate_viewport(var_1_0, var_1_5)

	return var_1_0, var_1_1, var_1_10, var_1_11, var_1_2
end

local function var_0_21()
	return math.random() * 0.002 - 0.001
end

local function var_0_22(arg_3_0)
	local var_3_0 = Level.flow_variable(arg_3_0, "map_bottom_left")
	local var_3_1 = Level.flow_variable(arg_3_0, "map_bottom_right")
	local var_3_2 = Level.flow_variable(arg_3_0, "map_top_left")
	local var_3_3 = Level.flow_variable(arg_3_0, "fog_bottom_left")
	local var_3_4 = Level.flow_variable(arg_3_0, "fog_bottom_right")
	local var_3_5 = Level.flow_variable(arg_3_0, "fog_top_left")
	local var_3_6 = Level.flow_variable(arg_3_0, "ref_a_node_from")
	local var_3_7 = Level.flow_variable(arg_3_0, "ref_a_edge")
	local var_3_8 = Level.flow_variable(arg_3_0, "ref_a_node_to")
	local var_3_9 = Level.flow_variable(arg_3_0, "ref_b_node_from")
	local var_3_10 = Level.flow_variable(arg_3_0, "ref_b_edge")
	local var_3_11 = Level.flow_variable(arg_3_0, "ref_b_node_to")
	local var_3_12 = Level.flow_variable(arg_3_0, "ref_token_1")
	local var_3_13 = Level.flow_variable(arg_3_0, "ref_token_2")
	local var_3_14 = Level.flow_variable(arg_3_0, "ref_token_3")
	local var_3_15 = Level.flow_variable(arg_3_0, "ref_token_4")
	local var_3_16 = Level.flow_variable(arg_3_0, "ref_token_node")
	local var_3_17 = Level.flow_variable(arg_3_0, "base_camera_bottom_left")
	local var_3_18 = Level.flow_variable(arg_3_0, "base_camera_top_right")
	local var_3_19 = Level.flow_variable(arg_3_0, "zoom_camera_bottom_left")
	local var_3_20 = Level.flow_variable(arg_3_0, "zoom_camera_top_right")
	local var_3_21 = Unit.local_pose(var_3_16, 0)
	local var_3_22 = Matrix4x4.inverse(var_3_21)
	local var_3_23 = Unit.local_pose(var_3_12, 0)
	local var_3_24 = Unit.local_pose(var_3_13, 0)
	local var_3_25 = Unit.local_pose(var_3_14, 0)
	local var_3_26 = Unit.local_pose(var_3_15, 0)
	local var_3_27 = Matrix4x4.multiply(var_3_23, var_3_22)
	local var_3_28 = Matrix4x4.multiply(var_3_24, var_3_22)
	local var_3_29 = Matrix4x4.multiply(var_3_25, var_3_22)
	local var_3_30 = Matrix4x4.multiply(var_3_26, var_3_22)
	local var_3_31 = {
		map_bottom_left_pos = Vector3Box(Unit.local_position(var_3_0, 0)),
		map_bottom_right_pos = Vector3Box(Unit.local_position(var_3_1, 0)),
		map_top_left_pos = Vector3Box(Unit.local_position(var_3_2, 0)),
		fog_bottom_left_pos = Vector3Box(Unit.local_position(var_3_3, 0)),
		fog_bottom_right_pos = Vector3Box(Unit.local_position(var_3_4, 0)),
		fog_top_left_pos = Vector3Box(Unit.local_position(var_3_5, 0)),
		referenced_token_poses = {
			Matrix4x4Box(var_3_27),
			Matrix4x4Box(var_3_28),
			Matrix4x4Box(var_3_29),
			(Matrix4x4Box(var_3_30))
		},
		camera_zoom_bottom_left_pose = Matrix4x4Box(Unit.local_pose(var_3_19, 0)),
		camera_zoom_top_right_pose = Matrix4x4Box(Unit.local_pose(var_3_20, 0)),
		camera_bottom_left_pose = Matrix4x4Box(Unit.local_pose(var_3_17, 0)),
		camera_top_right_pose = Matrix4x4Box(Unit.local_pose(var_3_18, 0)),
		ref_a_node_from_pos = Vector3Box(Unit.local_position(var_3_6, 0)),
		ref_a_node_to_pos = Vector3Box(Unit.local_position(var_3_8, 0)),
		ref_a_edge_pos = Vector3Box(Unit.local_position(var_3_7, 0)),
		ref_a_edge_scale = Vector3Box(Unit.local_scale(var_3_7, 0)),
		ref_b_node_from_pos = Vector3Box(Unit.local_position(var_3_9, 0)),
		ref_b_node_to_pos = Vector3Box(Unit.local_position(var_3_11, 0)),
		ref_b_edge_pos = Vector3Box(Unit.local_position(var_3_10, 0)),
		ref_b_edge_scale = Vector3Box(Unit.local_scale(var_3_10, 0))
	}

	Unit.disable_physics(var_3_6)
	Unit.disable_physics(var_3_7)
	Unit.disable_physics(var_3_8)
	Unit.disable_physics(var_3_9)
	Unit.disable_physics(var_3_10)
	Unit.disable_physics(var_3_11)
	Unit.disable_physics(var_3_12)
	Unit.disable_physics(var_3_13)
	Unit.disable_physics(var_3_14)
	Unit.disable_physics(var_3_15)
	Unit.disable_physics(var_3_16)
	Unit.set_unit_visibility(var_3_6, false)
	Unit.set_unit_visibility(var_3_7, false)
	Unit.set_unit_visibility(var_3_8, false)
	Unit.set_unit_visibility(var_3_9, false)
	Unit.set_unit_visibility(var_3_10, false)
	Unit.set_unit_visibility(var_3_11, false)
	Unit.set_unit_visibility(var_3_12, false)
	Unit.set_unit_visibility(var_3_13, false)
	Unit.set_unit_visibility(var_3_14, false)
	Unit.set_unit_visibility(var_3_15, false)
	Unit.set_unit_visibility(var_3_16, false)

	return var_3_31
end

local function var_0_23(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_1.map_bottom_left_pos:unbox()
	local var_4_1 = arg_4_1.map_bottom_right_pos:unbox()
	local var_4_2 = arg_4_1.map_top_left_pos:unbox()
	local var_4_3 = arg_4_1.ref_a_node_from_pos:unbox()
	local var_4_4 = arg_4_1.ref_a_node_to_pos:unbox()
	local var_4_5 = arg_4_1.ref_a_edge_pos:unbox()
	local var_4_6 = arg_4_1.ref_a_edge_scale:unbox()
	local var_4_7 = arg_4_1.ref_b_node_from_pos:unbox()
	local var_4_8 = arg_4_1.ref_b_node_to_pos:unbox()
	local var_4_9 = arg_4_1.ref_b_edge_pos:unbox()
	local var_4_10 = arg_4_1.ref_b_edge_scale:unbox()
	local var_4_11 = {}
	local var_4_12 = {}
	local var_4_13 = {}
	local var_4_14 = var_4_1 - var_4_0
	local var_4_15 = var_4_2 - var_4_0

	for iter_4_0, iter_4_1 in pairs(arg_4_2) do
		local var_4_16 = var_4_0 + (var_4_14 * iter_4_1.layout_x + var_4_15 * iter_4_1.layout_y)

		var_4_16.z = var_4_16.z + var_0_21()
		var_4_13[iter_4_0] = var_4_16
	end

	local var_4_17 = Vector3.length_squared(var_4_4 - var_4_3)
	local var_4_18 = Vector3.length_squared(var_4_8 - var_4_7)
	local var_4_19 = Vector3.length_squared(var_4_5 - var_4_3)
	local var_4_20 = Vector3.length_squared(var_4_9 - var_4_7)

	for iter_4_2, iter_4_3 in pairs(arg_4_2) do
		local var_4_21 = iter_4_3.level
		local var_4_22

		if iter_4_2 == "start" then
			var_4_22 = var_0_0
		else
			local var_4_23 = string.sub(var_4_21, 1, string.find(var_4_21, "_") - 1)

			if var_4_23 == "sig" then
				var_4_22 = var_0_1
			elseif var_4_23 == "pat" then
				var_4_22 = var_0_2
			elseif var_4_23 == "arena" then
				var_4_22 = var_0_4
			else
				var_4_22 = var_0_3
			end
		end

		local var_4_24 = var_4_13[iter_4_2]
		local var_4_25 = World.spawn_unit(arg_4_0, var_4_22, var_4_24)

		var_4_11[iter_4_2] = var_4_25

		Unit.set_data(var_4_25, "deus_node_key", iter_4_2)
		Unit.set_data(var_4_25, "theme", iter_4_3.theme)
		Unit.set_data(var_4_25, "level", iter_4_3.base_level)

		var_4_12[iter_4_2] = {}

		for iter_4_4, iter_4_5 in pairs(iter_4_3.next) do
			local var_4_26 = var_4_13[iter_4_5]
			local var_4_27 = var_4_26 - var_4_24
			local var_4_28 = World.spawn_unit(arg_4_0, var_0_5)

			var_4_12[iter_4_2][iter_4_5] = var_4_28

			local var_4_29 = Vector3.normalize(var_4_27)
			local var_4_30 = Quaternion.look(var_4_29, Vector3.up())

			Unit.set_local_rotation(var_4_28, 0, var_4_30)

			local var_4_31 = (Vector3.length_squared(var_4_26 - var_4_24) - var_4_17) / (var_4_18 - var_4_17)
			local var_4_32 = math.lerp(var_4_19, var_4_20, var_4_31)
			local var_4_33 = var_4_24 + var_4_29 * (var_4_32 >= 0 and math.sqrt(var_4_32) or 0)

			var_4_33.z = var_4_33.z + var_0_21()

			Unit.set_local_position(var_4_28, 0, var_4_33)

			local var_4_34 = math.lerp(var_4_6, var_4_10, var_4_31)

			Unit.set_local_scale(var_4_28, 0, var_4_34)
			Unit.set_data(var_4_28, "highlighted", false)
			Unit.flow_event(var_4_28, "update_visuals")
		end

		Unit.flow_event(var_4_25, "update_visuals")
	end

	local var_4_35 = World.spawn_unit(arg_4_0, var_0_6)
	local var_4_36 = World.spawn_unit(arg_4_0, var_0_7)
	local var_4_37 = World.spawn_unit(arg_4_0, var_0_8)
	local var_4_38 = World.spawn_unit(arg_4_0, var_0_9)
	local var_4_39 = World.spawn_unit(arg_4_0, var_0_10)
	local var_4_40 = {
		var_4_35,
		var_4_36,
		var_4_37,
		var_4_38,
		var_4_39
	}

	return var_4_11, var_4_12, var_4_40
end

local function var_0_24(arg_5_0, arg_5_1, arg_5_2)
	for iter_5_0, iter_5_1 in pairs(arg_5_2) do
		local var_5_0 = arg_5_0[iter_5_0]

		Unit.set_data(var_5_0, "visibility_level", iter_5_1)
		Unit.flow_event(var_5_0, "update_visuals")

		for iter_5_2, iter_5_3 in pairs(arg_5_1[iter_5_0]) do
			Unit.set_data(iter_5_3, "visibility_level", iter_5_1)
		end
	end
end

local function var_0_25(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = arg_6_1.map_bottom_left_pos:unbox()
	local var_6_1 = arg_6_1.map_bottom_right_pos:unbox()
	local var_6_2 = arg_6_1.map_top_left_pos:unbox()
	local var_6_3 = arg_6_1.fog_bottom_left_pos:unbox()
	local var_6_4 = arg_6_1.fog_bottom_right_pos:unbox()
	local var_6_5 = arg_6_1.fog_top_left_pos:unbox()
	local var_6_6 = var_6_4 - var_6_3
	local var_6_7 = var_6_1 - var_6_0
	local var_6_8 = var_6_5 - var_6_3
	local var_6_9 = var_6_2 - var_6_0
	local var_6_10 = Vector2(var_6_7.x / var_6_6.x, var_6_9.y / var_6_8.y)
	local var_6_11 = var_6_0 - var_6_3
	local var_6_12 = Vector2(var_6_11.x / var_6_6.x, var_6_11.y / var_6_8.y)
	local var_6_13 = RESOLUTION_LOOKUP.res_w
	local var_6_14 = RESOLUTION_LOOKUP.res_h

	local function var_6_15(arg_7_0, arg_7_1)
		return arg_7_0 * var_6_10.x + var_6_12.x + var_0_16, arg_7_1 * var_6_10.y + var_6_12.y + var_0_17
	end

	local var_6_16 = World.create_screen_gui(arg_6_0, "material", "materials/deus_map_fog_mask/deus_map_fog_mask", "immediate")
	local var_6_17 = Vector3.length(var_6_6) / Vector3.length(var_6_8)

	Gui.bitmap(var_6_16, "default_deus_map_fog_mask_clear", Vector3(0, 0, 0), Vector2(var_6_13, var_6_14), Color(255, 0, 0, 0))

	local function var_6_18(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, arg_8_9, arg_8_10, arg_8_11, arg_8_12, arg_8_13, arg_8_14)
		Gui.triangle(var_6_16, Vector3(arg_8_3, 0, arg_8_4), Vector3(arg_8_5, 0, arg_8_6), Vector3(arg_8_7, 0, arg_8_8), 0, Color(255, arg_8_1 * 255, arg_8_2 * 255, 255), arg_8_0, Vector2(arg_8_9, arg_8_10), Vector2(arg_8_11, arg_8_12), Vector2(arg_8_13, arg_8_14))
	end

	local function var_6_19(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_9, arg_9_10, arg_9_11, arg_9_12, arg_9_13, arg_9_14, arg_9_15, arg_9_16, arg_9_17, arg_9_18)
		var_6_18(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_11, arg_9_12, arg_9_13, arg_9_14, arg_9_15, arg_9_16)
		var_6_18(arg_9_0, arg_9_1, arg_9_2, arg_9_7, arg_9_8, arg_9_9, arg_9_10, arg_9_3, arg_9_4, arg_9_15, arg_9_16, arg_9_17, arg_9_18, arg_9_11, arg_9_12)
	end

	local function var_6_20(arg_10_0, arg_10_1)
		local var_10_0 = var_0_11[arg_6_3[arg_10_0]]
		local var_10_1 = var_0_11[arg_6_3[arg_10_1]]
		local var_10_2 = arg_6_2[arg_10_0]
		local var_10_3 = arg_6_2[arg_10_1]
		local var_10_4, var_10_5 = var_6_15(var_10_2.layout_x, var_10_2.layout_y)
		local var_10_6 = var_10_4 * var_6_13
		local var_10_7 = var_10_5 * var_6_14
		local var_10_8, var_10_9 = var_6_15(var_10_3.layout_x, var_10_3.layout_y)
		local var_10_10 = var_10_8 * var_6_13
		local var_10_11 = var_10_9 * var_6_14
		local var_10_12 = var_10_10 - var_10_6
		local var_10_13 = var_10_11 - var_10_7
		local var_10_14 = math.sqrt(var_10_12 * var_10_12 + var_10_13 * var_10_13)
		local var_10_15 = var_10_12 / var_10_14
		local var_10_16 = var_10_13 / var_10_14
		local var_10_17 = arg_10_0 == "final" and var_0_12 or var_0_13
		local var_10_18 = var_10_17 * var_6_13
		local var_10_19 = var_10_17 * var_6_17 * var_6_14
		local var_10_20 = var_10_6 + var_10_16 * var_10_18
		local var_10_21 = var_10_7 - var_10_15 * var_10_19
		local var_10_22 = var_10_6 - var_10_16 * var_10_18
		local var_10_23 = var_10_7 + var_10_15 * var_10_19
		local var_10_24 = var_10_10 + var_10_16 * var_10_18
		local var_10_25 = var_10_11 - var_10_15 * var_10_19
		local var_10_26 = var_10_10 - var_10_16 * var_10_18
		local var_10_27 = var_10_11 + var_10_15 * var_10_19

		var_6_19("default_deus_map_fog_mask_edge", var_10_0, var_10_1, var_10_24, var_10_25, var_10_20, var_10_21, var_10_22, var_10_23, var_10_26, var_10_27, 1, 0, 0, 0, 0, 1, 1, 1)
	end

	local function var_6_21(arg_11_0)
		local var_11_0 = var_0_11[arg_6_3[arg_11_0]]
		local var_11_1 = arg_6_2[arg_11_0]
		local var_11_2, var_11_3 = var_6_15(var_11_1.layout_x, var_11_1.layout_y)
		local var_11_4 = var_11_2 * var_6_13
		local var_11_5 = var_11_3 * var_6_14
		local var_11_6 = arg_11_0 == "final" and var_0_12 or var_0_13
		local var_11_7 = var_11_6 * var_6_13
		local var_11_8 = var_11_6 * var_6_17 * var_6_14
		local var_11_9 = var_11_4 - var_11_7
		local var_11_10 = var_11_5 - var_11_8
		local var_11_11 = var_11_4 + var_11_7
		local var_11_12 = var_11_5 - var_11_8
		local var_11_13 = var_11_4 - var_11_7
		local var_11_14 = var_11_5 + var_11_8
		local var_11_15 = var_11_4 + var_11_7
		local var_11_16 = var_11_5 + var_11_8

		var_6_19("default_deus_map_fog_mask_node", var_11_0, var_11_0, var_11_13, var_11_14, var_11_9, var_11_10, var_11_11, var_11_12, var_11_15, var_11_16, 1, 0, 0, 0, 0, 1, 1, 1)
	end

	local function var_6_22(arg_12_0)
		local var_12_0 = arg_6_2[arg_12_0]

		var_6_21(arg_12_0)

		for iter_12_0, iter_12_1 in ipairs(var_12_0.next) do
			var_6_20(arg_12_0, iter_12_1)
			var_6_22(iter_12_1)
		end
	end

	var_6_22("start")

	local var_6_23, var_6_24 = var_6_15(arg_6_2.start.layout_x, arg_6_2.start.layout_y)
	local var_6_25 = 0
	local var_6_26 = 1
	local var_6_27 = 0
	local var_6_28 = 1 - var_0_15
	local var_6_29 = var_6_23
	local var_6_30 = 1
	local var_6_31 = var_6_23
	local var_6_32 = 1 - var_0_15
	local var_6_33 = 0
	local var_6_34 = var_0_15
	local var_6_35 = 0
	local var_6_36 = 0
	local var_6_37 = var_6_23
	local var_6_38 = var_0_15
	local var_6_39 = var_6_23
	local var_6_40 = 0
	local var_6_41 = 1 - var_0_14
	local var_6_42 = var_0_15
	local var_6_43 = 1 - var_0_14
	local var_6_44 = 0
	local var_6_45 = 1
	local var_6_46 = var_0_15
	local var_6_47 = 1
	local var_6_48 = 0
	local var_6_49 = 1 - var_0_14
	local var_6_50 = 1
	local var_6_51 = 1 - var_0_14
	local var_6_52 = 1 - var_0_15
	local var_6_53 = 1
	local var_6_54 = 1
	local var_6_55 = 1
	local var_6_56 = 1 - var_0_15

	var_6_19("default_deus_map_fog_mask_border", 1, 0, var_6_27 * var_6_13, var_6_28 * var_6_14, var_6_33 * var_6_13, var_6_34 * var_6_14, var_6_37 * var_6_13, var_6_38 * var_6_14, var_6_31 * var_6_13, var_6_32 * var_6_14, 0, 0, 0, 0, 1, 0, 1, 0)
	var_6_19("default_deus_map_fog_mask_border", 1, 0, var_6_27 * var_6_13, var_6_28 * var_6_14, var_6_31 * var_6_13, var_6_32 * var_6_14, var_6_29 * var_6_13, var_6_30 * var_6_14, var_6_25 * var_6_13, var_6_26 * var_6_14, 0, 0, 1, 0, 0, 0, 0, 0)
	var_6_19("default_deus_map_fog_mask_border", 1, 0, var_6_31 * var_6_13, var_6_32 * var_6_14, var_6_51 * var_6_13, var_6_52 * var_6_14, var_6_49 * var_6_13, var_6_50 * var_6_14, var_6_29 * var_6_13, var_6_30 * var_6_14, 1, 0, 1, 0, 0, 0, 0, 0)
	var_6_19("default_deus_map_fog_mask_border", 1, 0, var_6_51 * var_6_13, var_6_52 * var_6_14, var_6_55 * var_6_13, var_6_56 * var_6_14, var_6_53 * var_6_13, var_6_54 * var_6_14, var_6_49 * var_6_13, var_6_50 * var_6_14, 1, 0, 0, 0, 0, 0, 0, 0)
	var_6_19("default_deus_map_fog_mask_border", 1, 0, var_6_51 * var_6_13, var_6_52 * var_6_14, var_6_41 * var_6_13, var_6_42 * var_6_14, var_6_45 * var_6_13, var_6_46 * var_6_14, var_6_55 * var_6_13, var_6_56 * var_6_14, 1, 0, 1, 0, 0, 0, 0, 0)
	var_6_19("default_deus_map_fog_mask_border", 1, 0, var_6_43 * var_6_13, var_6_44 * var_6_14, var_6_47 * var_6_13, var_6_48 * var_6_14, var_6_45 * var_6_13, var_6_46 * var_6_14, var_6_41 * var_6_13, var_6_42 * var_6_14, 0, 0, 0, 0, 0, 0, 1, 0)
	var_6_19("default_deus_map_fog_mask_border", 1, 0, var_6_37 * var_6_13, var_6_38 * var_6_14, var_6_39 * var_6_13, var_6_40 * var_6_14, var_6_43 * var_6_13, var_6_44 * var_6_14, var_6_41 * var_6_13, var_6_42 * var_6_14, 1, 0, 0, 0, 0, 0, 1, 0)
	var_6_19("default_deus_map_fog_mask_border", 1, 0, var_6_35 * var_6_13, var_6_36 * var_6_14, var_6_39 * var_6_13, var_6_40 * var_6_14, var_6_37 * var_6_13, var_6_38 * var_6_14, var_6_33 * var_6_13, var_6_34 * var_6_14, 0, 0, 0, 0, 1, 0, 0, 0)
end

local function var_0_26(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
	local var_13_0 = Camera.screen_to_world(arg_13_0, arg_13_2, 0)
	local var_13_1 = Camera.screen_to_world(arg_13_0, Vector3(arg_13_2.x, arg_13_2.y, 0), 1) - var_13_0
	local var_13_2 = Vector3.normalize(var_13_1)

	return PhysicsWorld.immediate_raycast(arg_13_1, var_13_0, var_13_2, arg_13_4, arg_13_3, "types", "statics", "collision_filter", arg_13_5)
end

local function var_0_27(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = Matrix4x4.translation(arg_14_0)
	local var_14_1 = Matrix4x4.translation(arg_14_1)
	local var_14_2 = Matrix4x4.rotation(arg_14_0)
	local var_14_3 = Matrix4x4.rotation(arg_14_1)
	local var_14_4 = (arg_14_2 + arg_14_3) / math.sqrt(2)
	local var_14_5 = Vector3(math.lerp(var_14_0[1], var_14_1[1], arg_14_2), math.lerp(var_14_0[2], var_14_1[2], arg_14_3), math.lerp(var_14_0[3], var_14_1[3], var_14_4))
	local var_14_6 = Quaternion.lerp(var_14_2, var_14_3, var_14_4)

	return (Matrix4x4.from_quaternion_position(var_14_6, var_14_5))
end

local function var_0_28(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6)
	local var_15_0
	local var_15_1 = arg_15_5 - arg_15_4
	local var_15_2

	if var_15_1 <= 0.001 then
		var_15_2 = 1
	else
		local var_15_3 = math.clamp((arg_15_6 - arg_15_4) / var_15_1, 0, 1)

		var_15_2 = (3 - 2 * var_15_3) * var_15_3^2
	end

	local var_15_4 = Matrix4x4.lerp(arg_15_2, arg_15_3, var_15_2)

	ScriptCamera.set_local_pose(arg_15_0, var_15_4)
	Camera.set_vertical_fov(arg_15_0, arg_15_1)
end

local function var_0_29(arg_16_0, arg_16_1, arg_16_2)
	ScriptCamera.set_local_pose(arg_16_0, arg_16_2)
	Camera.set_vertical_fov(arg_16_0, arg_16_1)
end

local var_0_30 = {
	paused = "paused",
	active = "active",
	initialized = "initialized"
}

DeusMapScene.init = function (arg_17_0)
	arg_17_0._state = var_0_30.initialized
end

DeusMapScene.on_enter = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	arg_18_0:_clear()

	arg_18_0._state = var_0_30.active
	arg_18_0._world, arg_18_0._physics_world, arg_18_0._camera, arg_18_0._fov, arg_18_0._level = var_0_20()
	arg_18_0._selected_unit = nil
	arg_18_0._cursor_update_enabled = true
	arg_18_0._input_service = arg_18_2
	arg_18_0._node_pressed_cb = arg_18_3
	arg_18_0._node_hovered_cb = arg_18_4
	arg_18_0._node_unhovered_cb = arg_18_5
	arg_18_0._level_ref_values = var_0_22(arg_18_0._level)
	arg_18_0._graph_data = arg_18_1
	arg_18_0._nodes_to_units, arg_18_0._edges_to_units, arg_18_0._profile_index_to_token = var_0_23(arg_18_0._world, arg_18_0._level_ref_values, arg_18_1)

	for iter_18_0, iter_18_1 in pairs(arg_18_0._profile_index_to_token) do
		arg_18_0:_hide_token(iter_18_0)
	end

	arg_18_0._event_manager = Managers.state.event

	arg_18_0._event_manager:register(arg_18_0, "on_game_options_changed", "_on_game_options_changed")
end

DeusMapScene.on_finish = function (arg_19_0)
	if arg_19_0._hovered_node_key then
		arg_19_0._node_unhovered_cb()

		arg_19_0._hovered_node_key = nil
	end

	arg_19_0._cursor_update_enabled = false

	arg_19_0._event_manager:unregister("on_game_options_changed", arg_19_0)

	arg_19_0._event_manager = nil
end

DeusMapScene.update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	if (RESOLUTION_LOOKUP.modified or arg_20_0._game_options_changed) and arg_20_0._last_visibility_data then
		arg_20_0:setup_fog(arg_20_0._last_visibility_data)
	end

	arg_20_0._game_options_changed = false

	if arg_20_0._state == var_0_30.active and arg_20_0._cursor_update_enabled then
		arg_20_0:_update_cursor(arg_20_3)
	end
end

DeusMapScene.post_update = function (arg_21_0, arg_21_1, arg_21_2)
	if arg_21_0._state ~= var_0_30.initialized then
		arg_21_0:_update_camera(arg_21_2)
	end
end

DeusMapScene.destroy = function (arg_22_0)
	arg_22_0:_clear()

	if arg_22_0._event_manager then
		arg_22_0._event_manager:unregister("on_game_options_changed", arg_22_0)

		arg_22_0._event_manager = nil
	end
end

DeusMapScene._clear = function (arg_23_0)
	arg_23_0._node_pressed_cb = nil
	arg_23_0._node_hovered_cb = nil
	arg_23_0._node_unhovered_cb = nil

	if arg_23_0._nodes_to_units then
		for iter_23_0, iter_23_1 in pairs(arg_23_0._nodes_to_units) do
			World.destroy_unit(arg_23_0._world, iter_23_1)
		end
	end

	if arg_23_0._profile_index_to_token then
		for iter_23_2, iter_23_3 in pairs(arg_23_0._profile_index_to_token) do
			World.destroy_unit(arg_23_0._world, iter_23_3)
		end
	end

	if arg_23_0._edges_to_units then
		for iter_23_4, iter_23_5 in pairs(arg_23_0._edges_to_units) do
			for iter_23_6, iter_23_7 in pairs(iter_23_5) do
				World.destroy_unit(arg_23_0._world, iter_23_7)
			end
		end
	end

	arg_23_0._profile_index_to_token = nil
	arg_23_0._nodes_to_units = nil
	arg_23_0._edges_to_units = nil
	arg_23_0._own_hero_name = nil
end

DeusMapScene._update_camera = function (arg_24_0, arg_24_1)
	if not arg_24_0._camera_animation_start_time then
		arg_24_0._camera_animation_start_time = arg_24_1
		arg_24_0._camera_animation_end_time = arg_24_1 + arg_24_0._camera_animation_duration
	end

	local var_24_0 = arg_24_0._camera

	var_0_28(var_24_0, arg_24_0._fov, arg_24_0._camera_source_pose:unbox(), arg_24_0._camera_target_pose:unbox(), arg_24_0._camera_animation_start_time, arg_24_0._camera_animation_end_time, arg_24_1)
	ScriptCamera.force_update(arg_24_0._world, var_24_0)
end

local var_0_31 = {
	0,
	0,
	0
}

DeusMapScene._update_cursor = function (arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0._input_service:get("cursor") or var_0_31
	local var_25_1

	if IS_XB1 and not arg_25_1 then
		var_25_1 = UIScaleVectorToResolution(Vector3(var_25_0[1], 1080 - var_25_0[2], var_25_0[3]))
	elseif arg_25_1 then
		var_25_1 = UIScaleVectorToResolution(var_25_0)
	else
		var_25_1 = var_25_0
	end

	local var_25_2, var_25_3, var_25_4, var_25_5, var_25_6 = var_0_26(arg_25_0._camera, arg_25_0._physics_world, var_25_1, "closest", 3, "filter_deus_map_node_click", arg_25_0._debug_drawer_stay)
	local var_25_7

	if var_25_2 then
		local var_25_8 = Actor.unit(var_25_6)

		var_25_7 = Unit.get_data(var_25_8, "deus_node_key")
	end

	if var_25_7 then
		if arg_25_0._selectables and (arg_25_0._input_service:get("confirm_press") or arg_25_0._input_service:get("left_press")) and table.contains(arg_25_0._selectables, var_25_7) then
			arg_25_0._node_pressed_cb(var_25_7)
		end

		if arg_25_0._hovered_node_key ~= var_25_7 then
			if arg_25_0._hovered_node_key then
				arg_25_0._node_unhovered_cb()
			end

			arg_25_0._hovered_node_key = var_25_7

			arg_25_0._node_hovered_cb(var_25_7)
		end

		if arg_25_1 then
			Managers.input:set_hovering(true)
		end
	elseif arg_25_0._hovered_node_key then
		arg_25_0._node_unhovered_cb()

		arg_25_0._hovered_node_key = nil
	end
end

DeusMapScene.setup_fog = function (arg_26_0, arg_26_1)
	arg_26_0._last_visibility_data = arg_26_1

	var_0_25(arg_26_0._world, arg_26_0._level_ref_values, arg_26_0._graph_data, arg_26_0._last_visibility_data, arg_26_0._debug_drawer)
	var_0_24(arg_26_0._nodes_to_units, arg_26_0._edges_to_units, arg_26_0._last_visibility_data)
end

DeusMapScene._on_game_options_changed = function (arg_27_0)
	arg_27_0._game_options_changed = true
end

DeusMapScene.animate_camera_to = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	arg_28_0._started_once = true
	arg_28_0._camera_animation_duration = arg_28_3
	arg_28_0._camera_animation_start_time = nil
	arg_28_0._camera_animation_end_time = nil
	arg_28_0._camera_source_pose = Matrix4x4Box(ScriptCamera.pose(arg_28_0._camera))

	local var_28_0 = arg_28_0._level_ref_values.camera_bottom_left_pose:unbox()
	local var_28_1 = arg_28_0._level_ref_values.camera_top_right_pose:unbox()

	arg_28_0._camera_target_pose = Matrix4x4Box(var_0_27(var_28_0, var_28_1, arg_28_1, arg_28_2))
end

DeusMapScene.zoom_camera_to = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	arg_29_0._started_once = true
	arg_29_0._camera_animation_duration = arg_29_3
	arg_29_0._camera_animation_start_time = nil
	arg_29_0._camera_animation_end_time = nil
	arg_29_0._camera_source_pose = Matrix4x4Box(ScriptCamera.pose(arg_29_0._camera))

	local var_29_0 = arg_29_0._level_ref_values.camera_zoom_bottom_left_pose:unbox()
	local var_29_1 = arg_29_0._level_ref_values.camera_zoom_top_right_pose:unbox()

	arg_29_0._camera_target_pose = Matrix4x4Box(var_0_27(var_29_0, var_29_1, arg_29_1, arg_29_2))
end

DeusMapScene.set_zoomed_camera_to = function (arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0._level_ref_values.camera_zoom_bottom_left_pose:unbox()
	local var_30_1 = arg_30_0._level_ref_values.camera_zoom_top_right_pose:unbox()
	local var_30_2 = var_0_27(var_30_0, var_30_1, arg_30_1, arg_30_2)

	var_0_29(arg_30_0._camera, arg_30_0._fov, var_30_2)
end

DeusMapScene.place_token = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	arg_31_0:_place_token(arg_31_1, arg_31_2, arg_31_3)
end

DeusMapScene.hide_token = function (arg_32_0, arg_32_1)
	arg_32_0:_hide_token(arg_32_1)
end

DeusMapScene.set_own_hero_name = function (arg_33_0, arg_33_1)
	if arg_33_0._own_hero_name ~= arg_33_1 then
		for iter_33_0, iter_33_1 in pairs(arg_33_0._nodes_to_units) do
			Unit.set_data(iter_33_1, "hero_name", arg_33_1)
			Unit.flow_event(iter_33_1, "update_visuals")
		end
	end

	arg_33_0._own_hero_name = arg_33_1
end

DeusMapScene.undiscover_node = function (arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0._nodes_to_units[arg_34_1]

	Unit.set_data(var_34_0, "discovered", false)
	Unit.flow_event(var_34_0, "update_visuals")
end

DeusMapScene.discover_node = function (arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0._nodes_to_units[arg_35_1]

	Unit.set_data(var_35_0, "discovered", true)
	Unit.flow_event(var_35_0, "update_visuals")
end

DeusMapScene.selectable_node = function (arg_36_0, arg_36_1)
	local var_36_0 = arg_36_0._nodes_to_units[arg_36_1]

	Unit.set_data(var_36_0, "selectable", true)
	Unit.flow_event(var_36_0, "update_visuals")

	arg_36_0._selectables = arg_36_0._selectables or {}

	for iter_36_0, iter_36_1 in ipairs(arg_36_0._selectables) do
		if iter_36_1 == arg_36_1 then
			return
		end
	end

	arg_36_0._selectables[#arg_36_0._selectables + 1] = arg_36_1
end

DeusMapScene.unselectable_node = function (arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0._nodes_to_units[arg_37_1]

	Unit.set_data(var_37_0, "selectable", false)
	Unit.flow_event(var_37_0, "update_visuals")

	if arg_37_0._selectables then
		local var_37_1 = table.index_of(arg_37_0._selectables, arg_37_1)

		if var_37_1 ~= -1 then
			table.swap_delete(arg_37_0._selectables, var_37_1)
		end
	end
end

DeusMapScene.untraversed_node = function (arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0._nodes_to_units[arg_38_1]

	Unit.set_data(var_38_0, "traversed", false)
	Unit.flow_event(var_38_0, "update_visuals")
end

DeusMapScene.traversed_node = function (arg_39_0, arg_39_1)
	local var_39_0 = arg_39_0._nodes_to_units[arg_39_1]

	Unit.set_data(var_39_0, "traversed", true)
	Unit.flow_event(var_39_0, "update_visuals")
end

DeusMapScene.unreachable_node = function (arg_40_0, arg_40_1)
	local var_40_0 = arg_40_0._nodes_to_units[arg_40_1]

	Unit.set_data(var_40_0, "unreachable", true)
	Unit.flow_event(var_40_0, "update_visuals")
end

DeusMapScene.select_node = function (arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = arg_41_0._nodes_to_units[arg_41_1]

	Unit.set_data(var_41_0, "selected", true)
	Unit.flow_event(var_41_0, "update_visuals")

	if arg_41_2 and Managers.state.network:game() then
		Managers.state.entity:system("audio_system"):play_2d_audio_event(arg_41_2)
	end
end

DeusMapScene.unselect_node = function (arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0._nodes_to_units[arg_42_1]

	Unit.set_data(var_42_0, "selected", false)
	Unit.flow_event(var_42_0, "update_visuals")
end

DeusMapScene.set_final_node = function (arg_43_0, arg_43_1)
	local var_43_0 = arg_43_0._nodes_to_units[arg_43_1]

	Unit.set_data(var_43_0, "selected", true)
	Unit.set_data(var_43_0, "selectable", true)
	Unit.flow_event(var_43_0, "update_visuals")
end

DeusMapScene.highlight_edge = function (arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = arg_44_0._edges_to_units[arg_44_1][arg_44_2]

	if not var_44_0 then
		local var_44_1 = Managers.mechanism:game_mechanism():get_deus_run_controller()
		local var_44_2 = var_44_1:get_traversed_nodes()
		local var_44_3 = var_44_1:get_graph_data()

		printf("self._edges_to_units:%s\ntraversed_nodes:%s\ngraph:%s", table.tostring(arg_44_0._edges_to_units), table.tostring(var_44_2), table.tostring(var_44_3, 2))
		ferror("[DeusMapScene] edge from<%s> to<%s> doesn't exist!", arg_44_1, arg_44_2)
	end

	Unit.set_data(var_44_0, "highlighted", true)
	Unit.flow_event(var_44_0, "update_visuals")
end

DeusMapScene.unhighlight_edge = function (arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = arg_45_0._edges_to_units[arg_45_1][arg_45_2]

	if not var_45_0 then
		local var_45_1 = Managers.mechanism:game_mechanism():get_deus_run_controller()
		local var_45_2 = var_45_1:get_traversed_nodes()
		local var_45_3 = var_45_1:get_graph_data()

		printf("self._edges_to_units:%s\ntraversed_nodes:%s\ngraph:%s", table.tostring(arg_45_0._edges_to_units), table.tostring(var_45_2), table.tostring(var_45_3, 2))
		ferror("[DeusMapScene] edge from<%s> to<%s> doesn't exist!", arg_45_1, arg_45_2)
	end

	Unit.set_data(var_45_0, "highlighted", false)
	Unit.flow_event(var_45_0, "update_visuals")
end

DeusMapScene.hover_node = function (arg_46_0, arg_46_1)
	local var_46_0 = arg_46_0._nodes_to_units[arg_46_1]

	Unit.set_data(var_46_0, "hovered", true)
	Unit.flow_event(var_46_0, "update_visuals")
end

DeusMapScene.unhover_node = function (arg_47_0, arg_47_1)
	local var_47_0 = arg_47_0._nodes_to_units[arg_47_1]

	Unit.set_data(var_47_0, "hovered", false)
	Unit.flow_event(var_47_0, "update_visuals")
end

DeusMapScene.get_screen_pos_of_node = function (arg_48_0, arg_48_1)
	local var_48_0 = arg_48_0._nodes_to_units[arg_48_1]

	return Camera.world_to_screen(arg_48_0._camera, Unit.local_position(var_48_0, 0))
end

DeusMapScene.animate_arena_belakor_node = function (arg_49_0, arg_49_1)
	local var_49_0 = arg_49_0._nodes_to_units[arg_49_1]

	Unit.flow_event(var_49_0, "first_time_seeing_arena_belakor_node")
end

DeusMapScene._place_token = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3)
	local var_50_0 = arg_50_0._profile_index_to_token[arg_50_1]
	local var_50_1 = arg_50_0._nodes_to_units[arg_50_3]
	local var_50_2 = arg_50_0._level_ref_values.referenced_token_poses[arg_50_2]
	local var_50_3 = Matrix4x4.multiply(Unit.local_pose(var_50_1, 0), var_50_2:unbox())

	Unit.set_unit_visibility(var_50_0, true)
	Unit.set_local_pose(var_50_0, 0, var_50_3)
end

DeusMapScene._hide_token = function (arg_51_0, arg_51_1)
	local var_51_0 = arg_51_0._profile_index_to_token[arg_51_1]

	Unit.set_unit_visibility(var_51_0, false)
end
