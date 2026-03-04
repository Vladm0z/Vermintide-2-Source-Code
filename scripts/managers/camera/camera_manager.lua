-- chunkname: @scripts/managers/camera/camera_manager.lua

require("scripts/settings/camera_transition_templates")
require("scripts/settings/camera_settings")
require("scripts/settings/camera_effect_settings")
require("scripts/managers/camera/transitions/camera_transition_generic")
require("scripts/managers/camera/transitions/camera_transition_fov_linear")
require("scripts/managers/camera/transitions/camera_transition_position_linear")
require("scripts/managers/camera/transitions/camera_transition_rotation_lerp")
require("scripts/managers/camera/cameras/base_camera")
require("scripts/managers/camera/cameras/root_camera")
require("scripts/managers/camera/cameras/transform_camera")
require("scripts/managers/camera/cameras/scalable_transform_camera")
require("scripts/managers/camera/cameras/rotation_camera")
require("scripts/managers/camera/cameras/blend_camera")
require("scripts/managers/camera/cameras/aim_camera")
require("scripts/managers/camera/cameras/sway_camera")
require("scripts/managers/camera/cameras/object_link_camera")
require("scripts/managers/camera/cameras/offset_camera")
require("scripts/managers/camera/mood_handler/mood_handler")
require("scripts/level/environment/environment_blender")

if Development.parameter("camera_debug") then
	script_data.camera_debug = true
end

CameraManager = class(CameraManager)
CameraManager.NODE_PROPERTY_MAP = {
	"position",
	"rotation",
	"vertical_fov",
	"near_range",
	"far_range",
	"yaw_speed",
	"pitch_speed",
	"shading_environment",
	"fade_to_black",
	"pitch_offset"
}

CameraManager.init = function (arg_1_0, arg_1_1)
	arg_1_0._world = arg_1_1
	arg_1_0._scatter_system = World.scatter_system(arg_1_0._world)
	arg_1_0._node_trees = {}
	arg_1_0._current_trees = {}
	arg_1_0._camera_nodes = {}
	arg_1_0._scatter_system_observers = {}
	arg_1_0._variables = {}
	arg_1_0._listener_elevation_offset = 0
	arg_1_0._listener_elevation_scale = 1
	arg_1_0._listener_elevation_min = -math.huge
	arg_1_0._listener_elevation_max = math.huge
	arg_1_0._sequence_event_settings = {
		time_to_recover = 0,
		end_time = 0,
		start_time = 0
	}
	arg_1_0._shake_event_settings = {}
	arg_1_0._recoil_event_settings = {}
	arg_1_0._level_particle_effect_ids = {}
	arg_1_0._level_screen_effect_ids = {}
	arg_1_0._frozen = false
	arg_1_0._frame = 0
	arg_1_0._shadow_lights = {}
	arg_1_0._shadow_lights_active = false
	arg_1_0._shadow_lights_max_active = 1
	arg_1_0._shadow_lights_viewport = nil
	arg_1_0._property_temp_table = {}
	arg_1_0.mood_handler = MoodHandler:new(arg_1_1)
	arg_1_0._environment_blenders = {}
	arg_1_0._shading_environment = {}
	arg_1_0._fov_multiplier = 1
	arg_1_0._additional_fov_multiplier = 1
	arg_1_0._tobii_extended_view = {
		pitch = 0,
		yaw = 0
	}
end

CameraManager.destroy = function (arg_2_0)
	arg_2_0.mood_handler:destroy()

	arg_2_0.mood_handler = nil
end

CameraManager.set_shadow_lights = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0._shadow_lights_active = arg_3_1
	arg_3_0._shadow_lights_max_active = arg_3_2

	if not GameSettingsDevelopment.disable_shadow_lights_system and not arg_3_1 then
		for iter_3_0, iter_3_1 in ipairs(arg_3_0._shadow_lights) do
			arg_3_0:_set_shadow_light(iter_3_1.unit, false)
		end
	end
end

CameraManager.set_elevation_offset = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	arg_4_0._listener_elevation_offset = arg_4_1
	arg_4_0._listener_elevation_scale = arg_4_2
	arg_4_0._listener_elevation_min = arg_4_3 or -math.huge
	arg_4_0._listener_elevation_max = arg_4_4 or math.huge
end

CameraManager.register_shadow_lights = function (arg_5_0, arg_5_1)
	local var_5_0 = LevelHelper:current_level(arg_5_0._world)

	for iter_5_0, iter_5_1 in pairs(arg_5_1.units) do
		local var_5_1 = Level.unit_by_index(var_5_0, iter_5_1)

		arg_5_0._shadow_lights[#arg_5_0._shadow_lights + 1] = {
			distance = 0,
			unit = var_5_1
		}

		if not GameSettingsDevelopment.disable_shadow_lights_system then
			arg_5_0:_set_shadow_light(var_5_1, false)
		end
	end
end

CameraManager._set_shadow_light = function (arg_6_0, arg_6_1, arg_6_2)
	if not GameSettingsDevelopment.disable_shadow_lights_system then
		for iter_6_0 = 1, Unit.num_lights(arg_6_1) do
			local var_6_0 = Unit.light(arg_6_1, iter_6_0 - 1)

			Light.set_casts_shadows(var_6_0, arg_6_2)
		end
	end
end

CameraManager._update_shadow_lights = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._shadow_lights

	if arg_7_0._shadow_lights_active and arg_7_2 == arg_7_0._shadow_lights_viewport and not table.is_empty(var_7_0) then
		local var_7_1 = arg_7_0:camera_position(arg_7_2)

		for iter_7_0, iter_7_1 in ipairs(var_7_0) do
			local var_7_2 = iter_7_1.unit

			arg_7_0:_set_shadow_light(var_7_2, false)

			iter_7_1.distance = Vector3.length(Unit.world_position(var_7_2, 0) - arg_7_0:camera_position(arg_7_2))
		end

		table.sort(var_7_0, function (arg_8_0, arg_8_1)
			return arg_8_0.distance < arg_8_1.distance
		end)

		local var_7_3 = math.min(arg_7_0._shadow_lights_max_active, #var_7_0)

		for iter_7_2 = 1, var_7_3 do
			arg_7_0:_set_shadow_light(var_7_0[iter_7_2].unit, true)
		end

		if script_data.debug_draw_shadow_lights and var_7_3 > 0 then
			local var_7_4 = 255 / var_7_3

			for iter_7_3 = 1, var_7_3 do
				QuickDrawer:sphere(Unit.local_position(var_7_0[iter_7_3].unit, 0), 0.25, Color(iter_7_3 * var_7_4, 255 - var_7_4 * iter_7_3, 0))
			end
		end
	end
end

CameraManager.add_viewport = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	arg_9_0._scatter_system_observers[arg_9_1] = ScatterSystem.make_observer(arg_9_0._scatter_system, arg_9_2, arg_9_3)
	arg_9_0._node_trees[arg_9_1] = {}
	arg_9_0._variables[arg_9_1] = {}
	arg_9_0._camera_nodes[arg_9_1] = {}
	arg_9_0._shadow_lights_viewport = arg_9_1

	local var_9_0 = ScriptWorld.viewport(arg_9_0._world, arg_9_1)

	arg_9_0._environment_blenders[arg_9_1] = EnvironmentBlender:new(arg_9_0._world, var_9_0)
end

CameraManager.create_viewport = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	ScriptWorld.create_viewport(arg_10_0._world, arg_10_1, "default", 1, arg_10_2, arg_10_3, true)
	arg_10_0:add_viewport(arg_10_1, arg_10_2, arg_10_3)
end

CameraManager.destroy_viewport = function (arg_11_0, arg_11_1)
	ScatterSystem.destroy_observer(arg_11_0._scatter_system, arg_11_0._scatter_system_observers[arg_11_1])

	arg_11_0._scatter_system_observers[arg_11_1] = nil
	arg_11_0._node_trees[arg_11_1] = nil
	arg_11_0._variables[arg_11_1] = nil
	arg_11_0._camera_nodes[arg_11_1] = nil

	arg_11_0._environment_blenders[arg_11_1]:destroy()

	arg_11_0._environment_blenders[arg_11_1] = nil
end

CameraManager.load_node_tree = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = CameraSettings[arg_12_3]
	local var_12_1 = {}
	local var_12_2 = arg_12_0:_setup_child_nodes(var_12_1, arg_12_1, arg_12_2, nil, var_12_0)
	local var_12_3 = {
		root_node = var_12_2,
		nodes = var_12_1
	}

	arg_12_0._node_trees[arg_12_1][arg_12_2] = var_12_3
end

CameraManager.node_tree_loaded = function (arg_13_0, arg_13_1, arg_13_2)
	if arg_13_0._node_trees[arg_13_1] and arg_13_0._node_trees[arg_13_1][arg_13_2] then
		return true
	end

	return false
end

CameraManager.debug_reload_tree = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	arg_14_0:load_node_tree(arg_14_1, arg_14_2, arg_14_3)
	arg_14_0:set_node_tree_root_unit(arg_14_1, arg_14_3, arg_14_5)
	arg_14_0:set_camera_node(arg_14_1, arg_14_3, arg_14_4)
end

CameraManager.set_node_tree_root_unit = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	arg_15_0._node_trees[arg_15_1][arg_15_2].root_node:set_root_unit(arg_15_3, arg_15_4, arg_15_5)
end

CameraManager.current_node_tree_root_unit = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._current_trees[arg_16_1]

	return arg_16_0._node_trees[arg_16_1][var_16_0].root_node:root_unit()
end

CameraManager.set_node_tree_root_position = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	arg_17_0._node_trees[arg_17_1][arg_17_2].root_node:set_root_position(arg_17_3)
end

CameraManager.set_node_tree_root_rotation = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	arg_18_0._node_trees[arg_18_1][arg_18_2].root_node:set_root_rotation(arg_18_3)
end

CameraManager.set_node_tree_root_vertical_fov = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	arg_19_0._node_trees[arg_19_1][arg_19_2].root_node:set_root_vertical_fov(arg_19_3)
end

CameraManager.set_node_tree_root_near_range = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	arg_20_0._node_trees[arg_20_1][arg_20_2].root_node:set_root_near_range(arg_20_3)
end

CameraManager.set_node_tree_root_far_range = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	arg_21_0._node_trees[arg_21_1][arg_21_2].root_node:set_root_far_range(arg_21_3)
end

CameraManager.set_node_tree_root_dof_enabled = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	arg_22_0._node_trees[arg_22_1][arg_22_2].root_node:set_root_dof_enabled(arg_22_3)
end

CameraManager.set_node_tree_root_focal_distance = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	arg_23_0._node_trees[arg_23_1][arg_23_2].root_node:set_root_focal_distance(arg_23_3)
end

CameraManager.set_node_tree_root_focal_region = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	arg_24_0._node_trees[arg_24_1][arg_24_2].root_node:set_root_focal_region(arg_24_3)
end

CameraManager.set_node_tree_root_focal_padding = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	arg_25_0._node_trees[arg_25_1][arg_25_2].root_node:set_root_focal_padding(arg_25_3)
end

CameraManager.set_node_tree_root_focal_scale = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	arg_26_0._node_trees[arg_26_1][arg_26_2].root_node:set_root_focal_scale(arg_26_3)
end

CameraManager.current_camera_node = function (arg_27_0, arg_27_1)
	return arg_27_0._camera_nodes[arg_27_1][#arg_27_0._camera_nodes[arg_27_1]].node:name()
end

CameraManager.tree_node = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	return arg_28_0._node_trees[arg_28_1][arg_28_2].nodes[arg_28_3]
end

local var_0_0 = {}

CameraManager.shading_callback = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	if arg_29_0._world == arg_29_1 then
		local var_29_0 = arg_29_0._shading_environment[arg_29_3] or arg_29_0._shading_environment[Viewport.get_data(arg_29_3, "overridden_viewport")] or var_0_0

		if var_29_0.dof_enabled then
			local var_29_1 = var_29_0.dof_enabled

			ShadingEnvironment.set_scalar(arg_29_2, "dof_enabled", var_29_1)

			if var_29_1 > 0 then
				local var_29_2 = var_29_0.focal_distance
				local var_29_3 = var_29_0.focal_region
				local var_29_4 = var_29_0.focal_padding
				local var_29_5 = var_29_0.focal_scale

				ShadingEnvironment.set_scalar(arg_29_2, "dof_focal_distance", var_29_2)
				ShadingEnvironment.set_scalar(arg_29_2, "dof_focal_region", var_29_3)
				ShadingEnvironment.set_scalar(arg_29_2, "dof_focal_region_start", var_29_4)
				ShadingEnvironment.set_scalar(arg_29_2, "dof_focal_region_end", var_29_4)
				ShadingEnvironment.set_scalar(arg_29_2, "dof_focal_near_scale", var_29_5)
				ShadingEnvironment.set_scalar(arg_29_2, "dof_focal_far_scale", var_29_5)
			end
		end

		if arg_29_0._frame == 0 then
			arg_29_0._frame = 1

			ShadingEnvironment.set_scalar(arg_29_2, "reset_luminance_adaption", 1)
		elseif arg_29_0._frame == 1 then
			arg_29_0._frame = 2

			ShadingEnvironment.set_scalar(arg_29_2, "reset_luminance_adaption", 0)
		end

		for iter_29_0, iter_29_1 in pairs(WorldInteractionSettings) do
			ShadingEnvironment.set_scalar(arg_29_2, iter_29_1.shading_env_variable, math.clamp(iter_29_1.window_size, 1, 50))
		end

		if arg_29_0._vignette_falloff_opacity and arg_29_0._vignette_color then
			local var_29_6 = ShadingEnvironment.vector3(arg_29_2, "vignette_color")
			local var_29_7 = ShadingEnvironment.vector3(arg_29_2, "vignette_scale_falloff_opacity")
			local var_29_8 = arg_29_0._vignette_t
			local var_29_9 = arg_29_0._vignette_falloff_opacity:unbox()
			local var_29_10 = Vector3(math.min(var_29_9.x, var_29_7.x), math.max(var_29_9.y, var_29_7.y), math.max(var_29_9.z, var_29_7.z))
			local var_29_11 = Vector3.smoothstep(var_29_8, var_29_7, var_29_10)

			ShadingEnvironment.set_vector3(arg_29_2, "vignette_color", arg_29_0._vignette_color:unbox())
			ShadingEnvironment.set_vector3(arg_29_2, "vignette_scale_falloff_opacity", var_29_11)
		end

		local var_29_12 = Application.user_setting("gamma") or 1

		ShadingEnvironment.set_scalar(arg_29_2, "exposure", ShadingEnvironment.scalar(arg_29_2, "exposure") * var_29_12)

		if Application.user_setting("render_settings", "particles_receive_shadows") then
			local var_29_13 = ShadingEnvironment.array_elements(arg_29_2, "sun_shadow_slice_depth_ranges") - 1
			local var_29_14 = ShadingEnvironment.array_vector2(arg_29_2, "sun_shadow_slice_depth_ranges", var_29_13)

			var_29_14.x = 0

			ShadingEnvironment.set_array_vector2(arg_29_2, "sun_shadow_slice_depth_ranges", var_29_13, var_29_14)
		end

		arg_29_0.mood_handler:apply_environment_variables(arg_29_2)

		local var_29_15 = World.get_data(arg_29_1, "fullscreen_blur") or 0

		if var_29_15 > 0 then
			ShadingEnvironment.set_scalar(arg_29_2, "fullscreen_blur_enabled", 1)
			ShadingEnvironment.set_scalar(arg_29_2, "fullscreen_blur_amount", math.clamp(var_29_15, 0, 1))
		else
			World.set_data(arg_29_1, "fullscreen_blur", nil)
			ShadingEnvironment.set_scalar(arg_29_2, "fullscreen_blur_enabled", 0)
		end

		local var_29_16 = World.get_data(arg_29_1, "greyscale") or 0

		if var_29_16 > 0 then
			ShadingEnvironment.set_scalar(arg_29_2, "grey_scale_enabled", 1)
			ShadingEnvironment.set_scalar(arg_29_2, "grey_scale_amount", math.clamp(var_29_16, 0, 1))
			ShadingEnvironment.set_vector3(arg_29_2, "grey_scale_weights", Vector3(0.33, 0.33, 0.33))
		else
			World.set_data(arg_29_1, "greyscale", nil)
			ShadingEnvironment.set_scalar(arg_29_2, "grey_scale_enabled", 0)
		end
	end
end

CameraManager._update_level_particle_effects = function (arg_30_0, arg_30_1)
	for iter_30_0, iter_30_1 in pairs(arg_30_0._level_particle_effect_ids) do
		World.move_particles(arg_30_0._world, iter_30_0, arg_30_0:camera_position(arg_30_1))
	end
end

CameraManager.set_camera_node = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	if not script_data.camera_debug and script_data.camera_node_debug then
		-- Nothing
	end

	local var_31_0 = arg_31_0._current_trees[arg_31_1]

	arg_31_0._current_trees[arg_31_1] = arg_31_2

	local var_31_1 = arg_31_0._camera_nodes[arg_31_1]
	local var_31_2 = var_31_1[#var_31_1]
	local var_31_3 = arg_31_0._node_trees[arg_31_1][arg_31_2]
	local var_31_4 = {
		node = var_31_3.nodes[arg_31_3]
	}

	assert(var_31_2 ~= var_31_4)

	if var_31_2 then
		local var_31_5

		if var_31_0 ~= arg_31_2 then
			local var_31_6 = var_31_2.node:tree_transitions()

			var_31_5 = var_31_6[arg_31_2] or var_31_6.default
		else
			local var_31_7 = var_31_2.node:node_transitions()

			var_31_5 = var_31_7[var_31_4.node:name()] or var_31_7.default
		end

		if var_31_5 then
			arg_31_0:_add_transition(arg_31_1, var_31_2, var_31_4, var_31_5)

			if var_31_5.inherit_aim_rotation and var_31_0 ~= arg_31_2 then
				local var_31_8 = arg_31_0._node_trees[arg_31_1][var_31_0].root_node
				local var_31_9 = var_31_8:aim_pitch()
				local var_31_10 = var_31_8:aim_yaw()

				var_31_3.root_node:set_aim_pitch(var_31_9)
				var_31_3.root_node:set_aim_yaw(var_31_10)
			end
		else
			var_31_4.transition = {}

			arg_31_0:_remove_camera_node(var_31_1, #var_31_1)
		end
	else
		var_31_4.transition = {}
	end

	var_31_4.node:set_active(true)

	var_31_1[#var_31_1 + 1] = var_31_4
end

CameraManager.set_frozen = function (arg_32_0, arg_32_1)
	arg_32_0._frozen = arg_32_1
end

CameraManager.is_in_view = function (arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = ScriptWorld.viewport(arg_33_0._world, arg_33_1)
	local var_33_1 = ScriptViewport.camera(var_33_0)

	return Camera.inside_frustum(var_33_1, arg_33_2) > 0
end

CameraManager._remove_camera_node = function (arg_34_0, arg_34_1, arg_34_2)
	for iter_34_0 = 1, arg_34_2 do
		table.remove(arg_34_1, 1).node:set_active(false)
	end
end

CameraManager.camera_position = function (arg_35_0, arg_35_1)
	local var_35_0 = ScriptWorld.viewport(arg_35_0._world, arg_35_1)
	local var_35_1 = ScriptViewport.camera(var_35_0)

	return Camera.world_position(var_35_1)
end

CameraManager.camera_rotation = function (arg_36_0, arg_36_1)
	local var_36_0 = ScriptWorld.viewport(arg_36_0._world, arg_36_1)
	local var_36_1 = ScriptViewport.camera(var_36_0)

	return Camera.world_rotation(var_36_1)
end

CameraManager.camera_pose = function (arg_37_0, arg_37_1)
	local var_37_0 = ScriptWorld.viewport(arg_37_0._world, arg_37_1)
	local var_37_1 = ScriptViewport.camera(var_37_0)

	return Camera.world_pose(var_37_1)
end

CameraManager.fov = function (arg_38_0, arg_38_1)
	local var_38_0 = ScriptWorld.viewport(arg_38_0._world, arg_38_1)
	local var_38_1 = ScriptViewport.camera(var_38_0)

	return Camera.vertical_fov(var_38_1)
end

CameraManager.has_viewport = function (arg_39_0, arg_39_1)
	return ScriptWorld.has_viewport(arg_39_0._world, arg_39_1)
end

CameraManager.aim_rotation = function (arg_40_0, arg_40_1)
	local var_40_0 = arg_40_0._camera_nodes[arg_40_1]
	local var_40_1 = arg_40_0:_current_node(var_40_0):root_node()
	local var_40_2 = var_40_1:aim_pitch()
	local var_40_3 = var_40_1:aim_yaw()
	local var_40_4 = Quaternion(Vector3(1, 0, 0), var_40_2)
	local var_40_5 = Quaternion(Vector3(0, 0, 1), var_40_3)
	local var_40_6 = Quaternion.multiply(var_40_5, var_40_4)
	local var_40_7 = arg_40_0._variables[arg_40_1].pitch_offset

	if var_40_7 then
		return (Quaternion.multiply(var_40_6, Quaternion(Vector3(1, 0, 0), var_40_7)))
	else
		return var_40_6
	end
end

CameraManager._setup_child_nodes = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5, arg_41_6)
	local var_41_0 = arg_41_5._node
	local var_41_1 = arg_41_0:_setup_node(var_41_0, arg_41_4, arg_41_6)

	arg_41_6 = arg_41_6 or var_41_1
	arg_41_1[var_41_1:name()] = var_41_1

	for iter_41_0, iter_41_1 in pairs(arg_41_5) do
		if iter_41_0 ~= "_node" then
			arg_41_0:_setup_child_nodes(arg_41_1, arg_41_2, arg_41_3, var_41_1, iter_41_1, arg_41_6)
		end
	end

	return var_41_1
end

CameraManager._setup_node = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	local var_42_0 = rawget(_G, arg_42_1.class):new(arg_42_3)

	var_42_0:parse_parameters(arg_42_1, arg_42_2)

	if arg_42_2 then
		arg_42_2:add_child_node(var_42_0)
	end

	return var_42_0
end

CameraManager.update = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	if not GameSettingsDevelopment.disable_shadow_lights_system then
		arg_43_0:_update_shadow_lights(arg_43_1, arg_43_3)
	end

	local var_43_0 = arg_43_0._node_trees[arg_43_3]
	local var_43_1 = arg_43_0._variables[arg_43_3]
	local var_43_2 = arg_43_0._node_trees[arg_43_3][arg_43_0._current_trees[arg_43_3]]
	local var_43_3 = arg_43_0._camera_nodes[arg_43_3]
	local var_43_4 = arg_43_0:_current_node(var_43_3)

	var_43_2.root_node:update_pitch_yaw(arg_43_1, var_43_1, var_43_4, arg_43_3)

	local var_43_5 = var_43_2.root_node:aim_yaw()
	local var_43_6 = var_43_2.root_node:aim_pitch()

	for iter_43_0, iter_43_1 in pairs(var_43_0) do
		if iter_43_1 ~= var_43_2 then
			iter_43_1.root_node:set_aim_pitch(var_43_6)
			iter_43_1.root_node:set_aim_yaw(var_43_5)
		end
	end

	arg_43_0:_update_level_particle_effects(arg_43_3)
	arg_43_0.mood_handler:update(arg_43_1)
	arg_43_0._environment_blenders[arg_43_3]:update(arg_43_1, arg_43_2)
end

CameraManager.set_fov_multiplier = function (arg_44_0, arg_44_1)
	arg_44_0._fov_multiplier = arg_44_1
end

CameraManager.set_additional_fov_multiplier = function (arg_45_0, arg_45_1)
	arg_45_0._additional_fov_multiplier = arg_45_1
end

CameraManager.set_additional_fov_multiplier_with_lerp_time = function (arg_46_0, arg_46_1, arg_46_2)
	arg_46_0._additional_fov_multiplier_data = {
		current_lerp_time = 0,
		total_lerp_time = arg_46_2,
		fov_multiplier = arg_46_1
	}
end

CameraManager.set_pitch_yaw = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	local var_47_0 = arg_47_0._node_trees[arg_47_1]

	for iter_47_0, iter_47_1 in pairs(var_47_0) do
		iter_47_1.root_node:set_aim_pitch(arg_47_2)
		iter_47_1.root_node:set_aim_yaw(arg_47_3)
	end
end

CameraManager.set_variable = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	arg_48_0._variables[arg_48_1][arg_48_2] = arg_48_3
end

CameraManager.variable = function (arg_49_0, arg_49_1, arg_49_2)
	return arg_49_0._variables[arg_49_1][arg_49_2]
end

CameraManager.post_update = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3)
	if arg_50_0._frozen then
		return
	end

	local var_50_0 = arg_50_0._node_trees[arg_50_3]
	local var_50_1 = arg_50_0._variables[arg_50_3]

	for iter_50_0, iter_50_1 in pairs(var_50_0) do
		arg_50_0:_update_nodes(arg_50_1, arg_50_3, iter_50_0, var_50_1)
	end

	arg_50_0:_update_camera(arg_50_1, arg_50_2, arg_50_3)
	arg_50_0:_update_sound_listener(arg_50_3)
end

CameraManager.force_update_nodes = function (arg_51_0, arg_51_1, arg_51_2)
	local var_51_0 = arg_51_0._node_trees[arg_51_2]
	local var_51_1 = arg_51_0._variables[arg_51_2]

	for iter_51_0, iter_51_1 in pairs(var_51_0) do
		arg_51_0:_update_nodes(arg_51_1, arg_51_2, iter_51_0, var_51_1)
	end
end

local var_0_1 = 0.01
local var_0_2 = 20

CameraManager._smooth_camera_collision = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
	local var_52_0 = World.get_data(arg_52_0._world, "physics_world")
	local var_52_1 = arg_52_2
	local var_52_2 = arg_52_1
	local var_52_3 = Vector3.normalize(var_52_2 - var_52_1)
	local var_52_4 = Vector3.length(var_52_2 - var_52_1)
	local var_52_5 = var_52_4
	local var_52_6 = arg_52_3

	if var_52_4 < var_52_6 then
		assert(Vector3.is_valid(var_52_2), "Trying to set invalid camera position")

		return var_52_2
	end

	local var_52_7

	if script_data.camera_debug then
		var_52_7 = Managers.state.debug:drawer({
			name = "Intersection"
		})

		var_52_7:reset()
	end

	local var_52_8, var_52_9 = PhysicsWorld.immediate_overlap(var_52_0, "shape", "sphere", "position", var_52_1, "size", arg_52_3, "types", "statics", "collision_filter", "filter_camera_sweep")

	if var_52_9 > 0 then
		if script_data.camera_debug then
			Application.warning("[CameraManager] Safe spot is intersecting with geometry")
		end

		assert(Vector3.is_valid(var_52_1), "Trying to set invalid camera position")

		return var_52_1
	end

	local var_52_10 = 0

	while true do
		if var_52_5 < var_0_1 then
			assert(Vector3.is_valid(var_52_1), "Trying to set invalid camera position")

			return var_52_1
		end

		local var_52_11 = PhysicsWorld.linear_sphere_sweep(var_52_0, var_52_1, var_52_2, var_52_6, 1, "types", "statics", "collision_filter", "filter_camera_sweep")
		local var_52_12

		if var_52_11 and #var_52_11 > 0 then
			if script_data.camera_debug then
				local var_52_13 = var_52_1

				for iter_52_0, iter_52_1 in ipairs(var_52_11) do
					local var_52_14 = Vector3.normalize(iter_52_1.position - var_52_13)
					local var_52_15 = Vector3.length(var_52_13 - iter_52_1.position)

					var_52_7:vector(var_52_13, iter_52_1.position - var_52_13, Color(0, 255, 0))
					var_52_7:sphere(iter_52_1.position, 0.1, Color(0, 255, 0))

					var_52_13 = iter_52_1.position
				end
			end

			local var_52_16 = var_52_11[1]
			local var_52_17 = Vector3.dot(var_52_3, var_52_16.position - var_52_1)
			local var_52_18 = Vector3.length(var_52_16.position - var_52_1 - var_52_17 * var_52_3)

			if var_52_18 < var_0_1 then
				local var_52_19 = var_52_16.position

				assert(Vector3.is_valid(var_52_19), "Trying to set invalid camera position")

				return var_52_19
			end

			local var_52_20

			if var_52_18 < arg_52_4 then
				var_52_20 = var_52_17 - var_52_6
			else
				var_52_20 = var_52_17 + (var_52_18 - arg_52_4) / (arg_52_3 - arg_52_4) * (var_52_4 - var_52_17) - var_52_6
			end

			if var_52_20 < var_52_5 then
				var_52_5 = var_52_20
				var_52_2 = var_52_1 + var_52_3 * var_52_5
			end

			if var_52_6 - var_52_18 < 0.05 then
				var_52_6 = math.max(var_52_6 - 0.05, arg_52_4)
			else
				var_52_6 = math.max(var_52_18, arg_52_4)
			end
		else
			if script_data.camera_debug then
				var_52_7:sphere(var_52_2, 0.2, Color(0, 0, 255))
			end

			assert(Vector3.is_valid(var_52_2), "Trying to set invalid camera position")

			return var_52_2
		end

		var_52_10 = var_52_10 + 1

		if var_52_10 > var_0_2 then
			return var_52_2
		end
	end
end

CameraManager._update_nodes = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
	local var_53_0 = arg_53_0._node_trees[arg_53_2][arg_53_3]
	local var_53_1 = arg_53_0._camera_nodes[arg_53_2]
	local var_53_2 = arg_53_0:_current_node(var_53_1)

	var_53_0.root_node:update(arg_53_1, arg_53_4, var_53_2:pitch_speed(), var_53_2:yaw_speed())
end

CameraManager._current_node = function (arg_54_0, arg_54_1)
	return arg_54_1[#arg_54_1].node
end

CameraManager.camera_effect_sequence_event = function (arg_55_0, arg_55_1, arg_55_2)
	if not Application.user_setting("camera_shake") then
		return
	end

	local var_55_0 = arg_55_0._sequence_event_settings
	local var_55_1

	if var_55_0.event then
		var_55_1 = var_55_0.current_values
	end

	var_55_0.start_time = arg_55_2
	var_55_0.event = CameraEffectSettings.sequence[arg_55_1]
	var_55_0.transition_function = CameraEffectSettings.transition_functions.lerp

	local var_55_2 = 0

	for iter_55_0, iter_55_1 in pairs(var_55_0.event.values) do
		for iter_55_2, iter_55_3 in ipairs(iter_55_1) do
			if var_55_2 < iter_55_3.time_stamp then
				var_55_2 = iter_55_3.time_stamp
			end
		end
	end

	var_55_0.end_time = arg_55_2 + var_55_2

	if var_55_1 then
		fassert(var_55_2 > 0, "Camera effect sequence duration is %f", var_55_2)

		local var_55_3 = var_55_0.event.time_to_recuperate_to

		fassert(var_55_3 > 0, "Camera effect sequence time_to_recuperate_to is %f", var_55_3)

		local var_55_4 = var_55_3 / 100 * var_55_2

		var_55_0.time_to_recover = var_55_4
		var_55_0.recovery_values = arg_55_0:_calculate_sequence_event_values_normal(var_55_0.event.values, var_55_4)
		var_55_0.previous_values = var_55_1
	end
end

CameraManager.camera_effect_shake_event = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	if not Application.user_setting("camera_shake") then
		return
	end

	local var_56_0 = {}
	local var_56_1 = CameraEffectSettings.shake[arg_56_1]
	local var_56_2 = var_56_1.duration
	local var_56_3 = var_56_1.fade_in
	local var_56_4 = var_56_1.fade_out

	if var_56_2 and var_56_4 then
		var_56_2 = var_56_2 + (var_56_3 or 0) + var_56_4
	end

	var_56_0.event = var_56_1
	var_56_0.start_time = arg_56_2
	var_56_0.end_time = var_56_2 and arg_56_2 + var_56_2
	var_56_0.fade_in_time = var_56_3 and arg_56_2 + var_56_3
	var_56_0.fade_out_time = var_56_4 and var_56_0.end_time - var_56_4
	var_56_0.seed = var_56_1.seed or Math.random(1, 100)
	var_56_0.scale = arg_56_3 or 1
	arg_56_0._shake_event_settings[var_56_0] = true

	if not var_56_1.no_rumble and Managers.state.controller_features then
		Managers.state.controller_features:add_effect("camera_shake", {
			shake_settings = var_56_0,
			scale = arg_56_3 or 1,
			duration = var_56_2,
			event_name = arg_56_1
		})
	end

	return var_56_0
end

CameraManager.stop_camera_effect_shake_event = function (arg_57_0, arg_57_1)
	arg_57_0._shake_event_settings[arg_57_1] = nil
end

CameraManager.is_recoiling = function (arg_58_0)
	return arg_58_0._recoil_event_settings and table.size(arg_58_0._recoil_event_settings) > 0, arg_58_0._total_recoil_offset
end

CameraManager.weapon_recoil = function (arg_59_0, arg_59_1)
	local var_59_0 = {}
	local var_59_1 = arg_59_1.climb_start_time
	local var_59_2 = arg_59_1.climb_end_time
	local var_59_3 = var_59_2 - var_59_1
	local var_59_4 = arg_59_1.restore_start_time
	local var_59_5 = arg_59_1.restore_end_time
	local var_59_6 = var_59_5 - var_59_4

	fassert(var_59_3 + var_59_6 > 0, "weapon recoil duration is %f", var_59_3 + var_59_6)

	var_59_0.vertical_climb = arg_59_1.vertical_climb
	var_59_0.horizontal_climb = arg_59_1.horizontal_climb
	var_59_0.climb_function = arg_59_1.climb_function
	var_59_0.restore_function = arg_59_1.restore_function
	var_59_0.climb_start_time = var_59_1
	var_59_0.climb_end_time = var_59_2
	var_59_0.climb_duration = var_59_3
	var_59_0.restore_start_time = var_59_4
	var_59_0.restore_end_time = var_59_5
	var_59_0.restore_duration = var_59_6
	var_59_0.current_climb_time = 0
	var_59_0.current_restore_time = 0
	var_59_0.id = arg_59_1.id
	arg_59_0._recoil_event_settings[var_59_0] = true

	return var_59_0
end

CameraManager.stop_weapon_recoil = function (arg_60_0, arg_60_1)
	arg_60_0._recoil_event_settings[arg_60_1] = nil
end

CameraManager.set_offset = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3)
	arg_61_0._camera_offset = arg_61_0._camera_offset and arg_61_0._camera_offset:store(Vector3(arg_61_1, arg_61_2, arg_61_3)) or Vector3Box(arg_61_1, arg_61_2, arg_61_3)
end

CameraManager._apply_offset = function (arg_62_0, arg_62_1, arg_62_2)
	local var_62_0 = arg_62_1
	local var_62_1 = arg_62_0._camera_offset and arg_62_0._camera_offset:unbox() or Vector3(0, 0, 0)
	local var_62_2 = var_62_1.x
	local var_62_3 = var_62_1.y
	local var_62_4 = var_62_1.z
	local var_62_5 = var_62_2 * Quaternion.right(arg_62_1.rotation)
	local var_62_6 = var_62_3 * Quaternion.forward(arg_62_1.rotation)
	local var_62_7 = Vector3(0, 0, var_62_4)

	var_62_0.position = arg_62_1.position + var_62_5 + var_62_6 + var_62_7

	return var_62_0
end

CameraManager._update_additional_fov_multiplier = function (arg_63_0, arg_63_1)
	local var_63_0 = arg_63_0._additional_fov_multiplier_data

	if not var_63_0 then
		return
	end

	local var_63_1 = var_63_0.current_lerp_time / var_63_0.total_lerp_time
	local var_63_2 = math.lerp(arg_63_0._additional_fov_multiplier, var_63_0.fov_multiplier, var_63_1)

	var_63_0.current_lerp_time = math.min(var_63_0.current_lerp_time + arg_63_1, var_63_0.total_lerp_time)

	if var_63_0.current_lerp_time == var_63_0.total_lerp_time then
		local var_63_3
	end

	arg_63_0._additional_fov_multiplier = var_63_2
end

CameraManager._update_camera = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3)
	local var_64_0 = ScriptWorld.viewport(arg_64_0._world, arg_64_3)
	local var_64_1 = ScriptViewport.camera(var_64_0)
	local var_64_2 = ScriptViewport.shadow_cull_camera(var_64_0)
	local var_64_3 = arg_64_0._camera_nodes[arg_64_3]
	local var_64_4 = arg_64_0:_current_node(var_64_3)
	local var_64_5 = arg_64_0:_update_transition(arg_64_3, var_64_3, arg_64_1)

	if arg_64_0._sequence_event_settings.event then
		arg_64_0:_apply_sequence_event(var_64_5, arg_64_2)
	end

	for iter_64_0, iter_64_1 in pairs(arg_64_0._shake_event_settings) do
		arg_64_0:_apply_shake_event(iter_64_0, var_64_5, arg_64_2)
	end

	for iter_64_2, iter_64_3 in pairs(arg_64_0._recoil_event_settings) do
		var_64_5 = arg_64_0:_apply_recoil_event(iter_64_2, table.clone(var_64_5), arg_64_1, arg_64_2)
	end

	if rawget(_G, "Tobii") and Application.user_setting("tobii_eyetracking") and Application.user_setting("tobii_eyetracking") and Application.user_setting("tobii_extended_view") then
		arg_64_0:_apply_extended_view(var_64_5)
	end

	arg_64_0:_apply_offset(var_64_5, arg_64_2)
	arg_64_0:_update_additional_fov_multiplier(arg_64_1)
	arg_64_0:_update_camera_properties(var_64_1, var_64_2, var_64_4, var_64_5, arg_64_3)
	ScriptCamera.force_update(arg_64_0._world, var_64_1)

	if GameSettingsDevelopment.simple_first_person then
		local var_64_6 = Camera.get_data(var_64_1, "unit")

		World.update_unit(arg_64_0._world, var_64_6)

		local var_64_7 = Unit.get_data(var_64_6, "rig_unit")

		if Unit.alive(var_64_7) then
			World.update_unit(arg_64_0._world, var_64_7)
		end
	end
end

CameraManager._apply_sequence_event = function (arg_65_0, arg_65_1, arg_65_2)
	local var_65_0 = arg_65_0._sequence_event_settings
	local var_65_1

	if arg_65_2 < var_65_0.time_to_recover + var_65_0.start_time then
		var_65_1 = arg_65_0:_calculate_sequence_event_values_recovery(arg_65_2)
	else
		local var_65_2 = arg_65_2 - var_65_0.start_time
		local var_65_3 = var_65_0.event.values

		var_65_1 = arg_65_0:_calculate_sequence_event_values_normal(var_65_3, var_65_2)
	end

	arg_65_1.position = arg_65_0:_calculate_sequence_event_position(arg_65_1, var_65_1)
	arg_65_1.rotation = arg_65_0:_calculate_sequence_event_rotation(arg_65_1, var_65_1)
	var_65_0.current_values = var_65_1

	if arg_65_2 >= arg_65_0._sequence_event_settings.end_time then
		var_65_0.start_time = 0
		var_65_0.end_time = 0
		var_65_0.event = nil
		var_65_0.current_values = nil
		var_65_0.time_to_recover = 0
		var_65_0.recovery_values = nil
		var_65_0.transition_function = nil
	end
end

CameraManager._calculate_sequence_event_values_recovery = function (arg_66_0, arg_66_1)
	local var_66_0 = {
		yaw = 0,
		z = 0,
		roll = 0,
		y = 0,
		pitch = 0,
		x = 0
	}
	local var_66_1 = arg_66_0._sequence_event_settings
	local var_66_2 = var_66_1.time_to_recover

	if var_66_2 <= 0 then
		table.dump(var_66_1)
		fassert(false, "time to recover is less than 0")
	end

	local var_66_3 = var_66_1.previous_values
	local var_66_4 = var_66_1.recovery_values
	local var_66_5 = (arg_66_1 - var_66_1.start_time) / var_66_2

	for iter_66_0, iter_66_1 in pairs(var_66_3) do
		var_66_0[iter_66_0] = math.lerp(iter_66_1, var_66_4[iter_66_0], var_66_5)
	end

	return var_66_0
end

CameraManager._calculate_sequence_event_values_normal = function (arg_67_0, arg_67_1, arg_67_2)
	local var_67_0 = {
		yaw = 0,
		z = 0,
		roll = 0,
		y = 0,
		pitch = 0,
		x = 0
	}

	for iter_67_0, iter_67_1 in pairs(arg_67_1) do
		for iter_67_2, iter_67_3 in ipairs(iter_67_1) do
			if arg_67_2 < iter_67_3.time_stamp then
				local var_67_1 = iter_67_3
				local var_67_2 = iter_67_1[iter_67_2 - 1] or CameraEffectSettings.empty_modifier_settings
				local var_67_3 = arg_67_2 - var_67_2.time_stamp
				local var_67_4 = var_67_1.time_stamp - var_67_2.time_stamp

				if var_67_4 == 0 then
					table.dump(var_67_2, "current settings")
					table.dump(var_67_1, "next_settings")
					assert(false, "Time stamp difference is 0, this would result in a div0")
				end

				local var_67_5 = var_67_3 / var_67_4

				var_67_0[iter_67_0] = arg_67_0._sequence_event_settings.transition_function(var_67_2.value, var_67_1.value, var_67_5)

				break
			end
		end
	end

	return var_67_0
end

CameraManager._calculate_sequence_event_position = function (arg_68_0, arg_68_1, arg_68_2)
	local var_68_0 = arg_68_1.position
	local var_68_1 = arg_68_1.rotation
	local var_68_2 = arg_68_2.x * Quaternion.right(var_68_1)
	local var_68_3 = arg_68_2.y * Quaternion.forward(var_68_1)
	local var_68_4 = Vector3(0, 0, arg_68_2.z)

	return var_68_0 + var_68_2 + var_68_3 + var_68_4
end

CameraManager._calculate_sequence_event_rotation = function (arg_69_0, arg_69_1, arg_69_2)
	local var_69_0 = arg_69_1.rotation
	local var_69_1 = math.pi / 180
	local var_69_2 = Quaternion(Vector3.up(), arg_69_2.yaw * var_69_1)
	local var_69_3 = Quaternion(Vector3.right(), arg_69_2.pitch * var_69_1)
	local var_69_4 = Quaternion(Vector3.forward(), arg_69_2.roll * var_69_1)
	local var_69_5 = Quaternion.multiply(Quaternion.multiply(var_69_2, var_69_3), var_69_4)

	return Quaternion.multiply(var_69_0, var_69_5)
end

CameraManager._apply_shake_event = function (arg_70_0, arg_70_1, arg_70_2, arg_70_3)
	local var_70_0 = arg_70_0._shake_event_settings
	local var_70_1 = arg_70_1.start_time
	local var_70_2 = arg_70_1.end_time
	local var_70_3 = arg_70_1.fade_in_time
	local var_70_4 = arg_70_1.fade_out_time

	if var_70_3 and arg_70_3 <= var_70_3 then
		arg_70_1.fade_progress = math.clamp((arg_70_3 - var_70_1) / (var_70_3 - var_70_1), 0, 1)
	elseif var_70_4 and var_70_4 <= arg_70_3 then
		arg_70_1.fade_progress = math.clamp((var_70_2 - arg_70_3) / (var_70_2 - var_70_4), 0, 1)
	end

	local var_70_5 = arg_70_0:_calculate_perlin_value(arg_70_3 - arg_70_1.start_time, arg_70_1) * arg_70_1.scale
	local var_70_6 = arg_70_0:_calculate_perlin_value(arg_70_3 - arg_70_1.start_time + 10, arg_70_1) * arg_70_1.scale
	local var_70_7 = arg_70_2.rotation
	local var_70_8 = math.pi / 180
	local var_70_9 = Quaternion(Vector3.up(), var_70_6 * var_70_8)
	local var_70_10 = Quaternion(Vector3.right(), var_70_5 * var_70_8)
	local var_70_11 = Quaternion.multiply(var_70_9, var_70_10)

	arg_70_2.rotation = Quaternion.multiply(var_70_7, var_70_11)

	if arg_70_1.end_time and arg_70_3 >= arg_70_1.end_time then
		var_70_0[arg_70_1] = nil
	end
end

CameraManager._apply_recoil_event = function (arg_71_0, arg_71_1, arg_71_2, arg_71_3, arg_71_4)
	local var_71_0 = arg_71_0._recoil_event_settings
	local var_71_1 = arg_71_1.vertical_climb
	local var_71_2 = arg_71_1.horizontal_climb
	local var_71_3 = arg_71_1.climb_start_time
	local var_71_4 = arg_71_1.climb_end_time
	local var_71_5 = arg_71_1.climb_duration
	local var_71_6 = arg_71_1.restore_start_time
	local var_71_7 = arg_71_1.restore_end_time
	local var_71_8 = arg_71_1.restore_duration
	local var_71_9 = arg_71_1.current_climb_time
	local var_71_10 = arg_71_1.current_restore_time
	local var_71_11 = arg_71_1.climb_function
	local var_71_12 = arg_71_1.restore_function
	local var_71_13 = arg_71_2
	local var_71_14 = arg_71_2.rotation
	local var_71_15 = arg_71_4 < var_71_4
	local var_71_16 = var_71_15 and var_71_9 / var_71_5 or var_71_10 / var_71_8

	var_71_16 = var_71_15 and var_71_11(var_71_16) or var_71_12(var_71_16)

	local var_71_17 = not var_71_15 and math.degrees_to_radians(var_71_2) or 0
	local var_71_18 = not var_71_15 and math.degrees_to_radians(var_71_1) or 0
	local var_71_19 = math.degrees_to_radians(var_71_15 and var_71_2 or -var_71_2) * var_71_16
	local var_71_20 = math.degrees_to_radians(var_71_15 and var_71_1 or -var_71_1) * var_71_16
	local var_71_21 = Quaternion(Vector3.up(), var_71_17 + var_71_19)
	local var_71_22 = Quaternion(Vector3.right(), var_71_18 + var_71_20)
	local var_71_23 = Quaternion.multiply(var_71_21, var_71_22)

	arg_71_0._total_recoil_offset = arg_71_0._total_recoil_offset and arg_71_0._total_recoil_offset:store(var_71_23) or QuaternionBox(var_71_23)
	var_71_13.rotation = Quaternion.multiply(var_71_14, var_71_23)

	if var_71_15 then
		arg_71_1.current_climb_time = var_71_9 + arg_71_3
	else
		arg_71_1.current_restore_time = var_71_10 + arg_71_3
	end

	if var_71_7 <= arg_71_4 then
		var_71_0[arg_71_1] = nil
	end

	return var_71_13
end

CameraManager._apply_extended_view = function (arg_72_0, arg_72_1)
	local var_72_0 = Quaternion(Vector3.up(), -arg_72_0._tobii_extended_view.yaw)
	local var_72_1 = Quaternion.multiply(Quaternion.inverse(arg_72_1.rotation), var_72_0)
	local var_72_2 = Quaternion.multiply(var_72_1, arg_72_1.rotation)
	local var_72_3 = Quaternion(Vector3.right(), arg_72_0._tobii_extended_view.pitch)
	local var_72_4 = Quaternion.multiply(var_72_2, var_72_3)

	arg_72_1.rotation = Quaternion.multiply(arg_72_1.rotation, var_72_4)
end

CameraManager.set_tobii_extended_view = function (arg_73_0, arg_73_1, arg_73_2)
	arg_73_0._tobii_extended_view.yaw = arg_73_1
	arg_73_0._tobii_extended_view.pitch = arg_73_2
end

CameraManager._calculate_perlin_value = function (arg_74_0, arg_74_1, arg_74_2)
	local var_74_0 = 0
	local var_74_1 = arg_74_2.event
	local var_74_2 = var_74_1.persistance
	local var_74_3 = var_74_1.octaves

	for iter_74_0 = 0, var_74_3 do
		local var_74_4 = 2^iter_74_0
		local var_74_5 = var_74_2^iter_74_0

		var_74_0 = var_74_0 + arg_74_0:_interpolated_noise(arg_74_1 * var_74_4, arg_74_2) * var_74_5
	end

	local var_74_6 = var_74_1.amplitude or 1
	local var_74_7 = arg_74_2.fade_progress or 1

	return var_74_0 * var_74_6 * var_74_7
end

CameraManager._interpolated_noise = function (arg_75_0, arg_75_1, arg_75_2)
	local var_75_0 = math.floor(arg_75_1)
	local var_75_1 = arg_75_1 - var_75_0
	local var_75_2 = arg_75_0:_smoothed_noise(var_75_0, arg_75_2)
	local var_75_3 = arg_75_0:_smoothed_noise(var_75_0 + 1, arg_75_2)

	return math.lerp(var_75_2, var_75_3, var_75_1)
end

CameraManager._smoothed_noise = function (arg_76_0, arg_76_1, arg_76_2)
	return arg_76_0:_noise(arg_76_1, arg_76_2) / 2 + arg_76_0:_noise(arg_76_1 - 1, arg_76_2) / 4 + arg_76_0:_noise(arg_76_1 + 1, arg_76_2) / 4
end

CameraManager._noise = function (arg_77_0, arg_77_1, arg_77_2)
	local var_77_0, var_77_1 = Math.next_random(arg_77_1 + arg_77_2.seed)
	local var_77_2, var_77_3 = Math.next_random(var_77_0)

	return var_77_3 * 2 - 1
end

CameraManager.apply_level_particle_effects = function (arg_78_0, arg_78_1, arg_78_2)
	for iter_78_0, iter_78_1 in ipairs(arg_78_1) do
		local var_78_0 = arg_78_0._world
		local var_78_1 = World.create_particles(var_78_0, iter_78_1, arg_78_0:camera_position(arg_78_2))

		arg_78_0._level_particle_effect_ids[var_78_1] = true
	end
end

CameraManager.apply_level_screen_effects = function (arg_79_0, arg_79_1, arg_79_2)
	for iter_79_0, iter_79_1 in ipairs(arg_79_1) do
		local var_79_0 = arg_79_0._world
		local var_79_1 = World.create_particles(var_79_0, iter_79_1, Vector3(0, 0, 0))

		arg_79_0._level_screen_effect_ids[var_79_1] = true
	end
end

CameraManager._update_camera_properties = function (arg_80_0, arg_80_1, arg_80_2, arg_80_3, arg_80_4, arg_80_5)
	if arg_80_4.position then
		local var_80_0, var_80_1 = arg_80_3:root_unit()
		local var_80_2 = arg_80_4.position

		if var_80_0 and Unit.alive(var_80_0) then
			local var_80_3 = arg_80_3:safe_position_offset()
			local var_80_4 = Unit.world_position(var_80_0, var_80_1 and Unit.node(var_80_0, var_80_1) or 0) + var_80_3:unbox()

			assert(Vector3.is_valid(var_80_4), "Trying to use invalid safe position")

			var_80_2 = arg_80_0:_smooth_camera_collision(arg_80_4.position, var_80_4, 0.35, 0.25)
		end

		if script_data.camera_debug and Managers.state.debug then
			local var_80_5 = Managers.state.debug:drawer({
				name = "CameraManager"
			})

			if DebugKeyHandler.key_pressed("z", "clear camera debug") then
				var_80_5:reset()
			end

			var_80_5:sphere(var_80_2, 0.1)
		end

		ScriptCamera.set_local_position(arg_80_1, var_80_2)
		ScatterSystem.move_observer(arg_80_0._scatter_system, arg_80_0._scatter_system_observers[arg_80_5], var_80_2, arg_80_4.rotation)

		local var_80_6 = World.get_data(arg_80_0._world, "physics_world")

		if var_80_6 and PhysicsWorld.set_observer then
			PhysicsWorld.set_observer(var_80_6, Matrix4x4.from_quaternion_position(arg_80_4.rotation, var_80_2))
		end
	end

	if arg_80_4.yaw_speed then
		arg_80_0._variables[arg_80_5].yaw_speed = arg_80_4.yaw_speed
	end

	if arg_80_4.pitch_offset then
		arg_80_0._variables[arg_80_5].pitch_offset = arg_80_4.pitch_offset
	end

	if arg_80_4.pitch_speed then
		arg_80_0._variables[arg_80_5].pitch_speed = arg_80_4.pitch_speed
	end

	if arg_80_4.rotation then
		ScriptCamera.set_local_rotation(arg_80_1, arg_80_4.rotation)
	end

	if script_data.fov_override then
		Camera.set_vertical_fov(arg_80_2, math.pi * script_data.fov_override / 180)
		Camera.set_vertical_fov(arg_80_1, math.pi * script_data.fov_override / 180)
	elseif arg_80_4.vertical_fov then
		local var_80_7 = arg_80_4.vertical_fov

		if arg_80_3:should_apply_fov_multiplier() then
			Camera.set_vertical_fov(arg_80_1, var_80_7 * arg_80_0._fov_multiplier * arg_80_0._additional_fov_multiplier)
			Camera.set_vertical_fov(arg_80_2, arg_80_3:default_fov())
		else
			Camera.set_vertical_fov(arg_80_1, var_80_7)
			Camera.set_vertical_fov(arg_80_2, arg_80_3:default_fov())
		end

		if script_data.camera_debug and Managers.state.debug then
			local var_80_8 = string.format("Vertical FOV: %s", var_80_7 * 180 / math.pi)

			Debug.text(var_80_8)
		end
	end

	if arg_80_4.near_range then
		Camera.set_near_range(arg_80_1, arg_80_4.near_range)
		Camera.set_near_range(arg_80_2, arg_80_4.near_range)
	end

	if arg_80_4.far_range then
		local var_80_9 = Camera.get_data(arg_80_1, "far_range") or arg_80_4.far_range

		Camera.set_far_range(arg_80_1, var_80_9)
		Camera.set_far_range(arg_80_2, var_80_9)
	end

	if arg_80_4.fade_to_black then
		arg_80_0._variables[arg_80_5].fade_to_black = arg_80_4.fade_to_black
	end

	local var_80_10 = ScriptWorld.viewport(arg_80_0._world, arg_80_5)

	arg_80_0._shading_environment[var_80_10] = arg_80_4.shading_environment
end

CameraManager._update_sound_listener = function (arg_81_0, arg_81_1)
	local var_81_0 = arg_81_0._world
	local var_81_1 = arg_81_0:listener_pose(arg_81_1)
	local var_81_2 = Managers.world:wwise_world(var_81_0)

	WwiseWorld.set_listener(var_81_2, 0, var_81_1)

	local var_81_3 = Matrix4x4.translation(var_81_1)
	local var_81_4 = arg_81_0._listener_elevation_scale
	local var_81_5 = arg_81_0._listener_elevation_offset
	local var_81_6 = arg_81_0._listener_elevation_min
	local var_81_7 = arg_81_0._listener_elevation_max
	local var_81_8 = math.clamp((var_81_3.z - var_81_5) * var_81_4, var_81_6, var_81_7)

	if script_data.debug_wwise_elevation then
		Debug.text("Elevation: %f", var_81_8)
		Debug.text("")
		Debug.text("Current z position: %f", var_81_3.z)
		Debug.text("Offset z: %f", var_81_5)
		Debug.text("Scale: %f", var_81_4)
		Debug.text("Min: %f", var_81_6)
		Debug.text("Max: %f", var_81_7)
	end

	WwiseWorld.set_global_parameter(var_81_2, "lua_elevation", var_81_8)
end

CameraManager.listener_pose = function (arg_82_0, arg_82_1)
	local var_82_0 = arg_82_0._world
	local var_82_1 = ScriptWorld.viewport(var_82_0, arg_82_1, true)
	local var_82_2 = ScriptViewport.camera(var_82_1)

	return (Camera.world_pose(var_82_2))
end

CameraManager._add_transition = function (arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4)
	local var_83_0 = {}

	for iter_83_0, iter_83_1 in ipairs(arg_83_0.NODE_PROPERTY_MAP) do
		local var_83_1 = arg_83_4[iter_83_1]

		if var_83_1 then
			local var_83_2 = var_83_1.duration
			local var_83_3 = var_83_1.speed

			var_83_0[iter_83_1] = rawget(_G, var_83_1.class):new(arg_83_2.node, arg_83_3.node, var_83_2, var_83_3, var_83_1)
		end
	end

	arg_83_3.transition = var_83_0
end

CameraManager._update_transition = function (arg_84_0, arg_84_1, arg_84_2, arg_84_3)
	local var_84_0 = arg_84_0._property_temp_table

	table.clear(var_84_0)

	local var_84_1
	local var_84_2 = arg_84_0.NODE_PROPERTY_MAP

	for iter_84_0, iter_84_1 in ipairs(var_84_2) do
		for iter_84_2, iter_84_3 in ipairs(arg_84_2) do
			local var_84_3 = iter_84_3.transition
			local var_84_4 = var_84_3[iter_84_1]

			if var_84_4 then
				local var_84_5
				local var_84_6 = iter_84_2 == #arg_84_2
				local var_84_7

				var_84_1, var_84_7 = var_84_4:update(arg_84_3, var_84_1, var_84_6)

				if var_84_7 then
					var_84_3[iter_84_1] = nil
				end
			else
				var_84_1 = iter_84_3.node[iter_84_1](iter_84_3.node)
			end
		end

		var_84_0[iter_84_1] = var_84_1
		var_84_1 = nil
	end

	local var_84_8

	for iter_84_4, iter_84_5 in ipairs(arg_84_2) do
		if not next(iter_84_5.transition) then
			var_84_8 = iter_84_4 - 1
		end
	end

	if var_84_8 and var_84_8 > 0 then
		arg_84_0:_remove_camera_node(arg_84_2, var_84_8)
	end

	return var_84_0
end

CameraManager.set_mood = function (arg_85_0, arg_85_1, arg_85_2, arg_85_3)
	arg_85_0.mood_handler:set_mood(arg_85_1, arg_85_2, arg_85_3)
end

CameraManager.clear_mood = function (arg_86_0, arg_86_1)
	arg_86_0.mood_handler:clear_mood(arg_86_1)
end

CameraManager.has_mood = function (arg_87_0, arg_87_1)
	arg_87_0.mood_handler:has_mood(arg_87_1)
end
