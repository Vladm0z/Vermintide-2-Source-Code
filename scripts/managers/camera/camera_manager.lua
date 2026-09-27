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

if not Development.parameter("camera_debug") then
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

CameraManager.init = function (self, arg_1_1)
	-- function 1
	self._world = arg_1_1
	self._scatter_system = World.scatter_system(self._world)
	self._node_trees = {}
	self._current_trees = {}
	self._camera_nodes = {}
	self._scatter_system_observers = {}
	self._variables = {}
	self._listener_elevation_offset = 0
	self._listener_elevation_scale = 1
	self._listener_elevation_min = -math.huge
	self._listener_elevation_max = math.huge
	self._sequence_event_settings = {
		time_to_recover = 0,
		end_time = 0,
		start_time = 0
	}
	self._shake_event_settings = {}
	self._recoil_event_settings = {}
	self._level_particle_effect_ids = {}
	self._level_screen_effect_ids = {}
	self._frozen = false
	self._frame = 0
	self._shadow_lights = {}
	self._shadow_lights_active = false
	self._shadow_lights_max_active = 1
	self._shadow_lights_viewport = nil
	self._property_temp_table = {}
	self.mood_handler = MoodHandler:new(arg_1_1)
	self._environment_blenders = {}
	self._shading_environment = {}
	self._fov_multiplier = 1
	self._additional_fov_multiplier = 1
	self._tobii_extended_view = {
		pitch = 0,
		yaw = 0
	}
end

CameraManager.destroy = function (self)
	-- function 2
	self.mood_handler:destroy()

	self.mood_handler = nil
end

CameraManager.set_shadow_lights = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	self._shadow_lights_active = arg_3_1
	self._shadow_lights_max_active = arg_3_2

	if not (GameSettingsDevelopment.disable_shadow_lights_system or arg_3_1) then
		for i, v in ipairs(self._shadow_lights) do
			self:_set_shadow_light(v.unit, false)
		end
	end
end

CameraManager.set_elevation_offset = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	self._listener_elevation_offset = arg_4_1
	self._listener_elevation_scale = arg_4_2
	self._listener_elevation_min = arg_4_3 or -math.huge
	self._listener_elevation_max = arg_4_4 or math.huge
end

CameraManager.register_shadow_lights = function (self, arg_5_1)
	-- function 5
	local current_level = LevelHelper:current_level(self._world)

	for k, v in pairs(arg_5_1.units) do
		local unit_by_index = Level.unit_by_index(current_level, v)

		self._shadow_lights[#self._shadow_lights + 1] = {
			distance = 0,
			unit = unit_by_index
		}

		if not GameSettingsDevelopment.disable_shadow_lights_system then
			self:_set_shadow_light(unit_by_index, false)
		end
	end
end

CameraManager._set_shadow_light = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	if not GameSettingsDevelopment.disable_shadow_lights_system then
		for i = 1, Unit.num_lights(arg_6_1) do
			local light = Unit.light(arg_6_1, i - 1)

			Light.set_casts_shadows(light, arg_6_2)
		end
	end
end

CameraManager._update_shadow_lights = function (self, arg_7_1, arg_7_2)
	-- function 7
	local _shadow_lights = self._shadow_lights

	if not (not self._shadow_lights_active and arg_7_2 ~= self._shadow_lights_viewport or table.is_empty(_shadow_lights)) then
		local camera_position = self:camera_position(arg_7_2)

		for i, v in ipairs(_shadow_lights) do
			local unit = v.unit

			self:_set_shadow_light(unit, false)

			v.distance = Vector3.length(Unit.world_position(unit, 0) - self:camera_position(arg_7_2))
		end

		table.sort(_shadow_lights, function (self, arg_8_1)
			-- function 8
			return self.distance < arg_8_1.distance
		end)

		local min = math.min(self._shadow_lights_max_active, #_shadow_lights)

		for k = 1, min do
			self:_set_shadow_light(_shadow_lights[k].unit, true)
		end

		if not (not script_data.debug_draw_shadow_lights and not (min > 0)) then
			local num = 255 / min

			for l = 1, min do
				QuickDrawer:sphere(Unit.local_position(_shadow_lights[l].unit, 0), 0.25, Color(l * num, 255 - num * l, 0))
			end
		end
	end
end

CameraManager.add_viewport = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	self._scatter_system_observers[arg_9_1] = ScatterSystem.make_observer(self._scatter_system, arg_9_2, arg_9_3)
	self._node_trees[arg_9_1] = {}
	self._variables[arg_9_1] = {}
	self._camera_nodes[arg_9_1] = {}
	self._shadow_lights_viewport = arg_9_1

	local viewport = ScriptWorld.viewport(self._world, arg_9_1)

	self._environment_blenders[arg_9_1] = EnvironmentBlender:new(self._world, viewport)
end

CameraManager.create_viewport = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	ScriptWorld.create_viewport(self._world, arg_10_1, "default", 1, arg_10_2, arg_10_3, true)
	self:add_viewport(arg_10_1, arg_10_2, arg_10_3)
end

CameraManager.destroy_viewport = function (self, arg_11_1)
	-- function 11
	ScatterSystem.destroy_observer(self._scatter_system, self._scatter_system_observers[arg_11_1])

	self._scatter_system_observers[arg_11_1] = nil
	self._node_trees[arg_11_1] = nil
	self._variables[arg_11_1] = nil
	self._camera_nodes[arg_11_1] = nil

	self._environment_blenders[arg_11_1]:destroy()

	self._environment_blenders[arg_11_1] = nil
end

CameraManager.load_node_tree = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local var_12_0 = CameraSettings[arg_12_3]
	local tbl = {}
	local _setup_child_nodes = self:_setup_child_nodes(tbl, arg_12_1, arg_12_2, nil, var_12_0)
	local tbl_2 = {
		root_node = _setup_child_nodes,
		nodes = tbl
	}

	self._node_trees[arg_12_1][arg_12_2] = tbl_2
end

CameraManager.node_tree_loaded = function (self, arg_13_1, arg_13_2)
	-- function 13
	if not self._node_trees[arg_13_1] and not self._node_trees[arg_13_1][arg_13_2] then
		return true
	end

	return false
end

CameraManager.debug_reload_tree = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	self:load_node_tree(arg_14_1, arg_14_2, arg_14_3)
	self:set_node_tree_root_unit(arg_14_1, arg_14_3, arg_14_5)
	self:set_camera_node(arg_14_1, arg_14_3, arg_14_4)
end

CameraManager.set_node_tree_root_unit = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	self._node_trees[arg_15_1][arg_15_2].root_node:set_root_unit(arg_15_3, arg_15_4, arg_15_5)
end

CameraManager.current_node_tree_root_unit = function (self, arg_16_1)
	-- function 16
	local var_16_0 = self._current_trees[arg_16_1]

	return self._node_trees[arg_16_1][var_16_0].root_node:root_unit()
end

CameraManager.set_node_tree_root_position = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	self._node_trees[arg_17_1][arg_17_2].root_node:set_root_position(arg_17_3)
end

CameraManager.set_node_tree_root_rotation = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	self._node_trees[arg_18_1][arg_18_2].root_node:set_root_rotation(arg_18_3)
end

CameraManager.set_node_tree_root_vertical_fov = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	self._node_trees[arg_19_1][arg_19_2].root_node:set_root_vertical_fov(arg_19_3)
end

CameraManager.set_node_tree_root_near_range = function (self, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	self._node_trees[arg_20_1][arg_20_2].root_node:set_root_near_range(arg_20_3)
end

CameraManager.set_node_tree_root_far_range = function (self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	self._node_trees[arg_21_1][arg_21_2].root_node:set_root_far_range(arg_21_3)
end

CameraManager.set_node_tree_root_dof_enabled = function (self, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	self._node_trees[arg_22_1][arg_22_2].root_node:set_root_dof_enabled(arg_22_3)
end

CameraManager.set_node_tree_root_focal_distance = function (self, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	self._node_trees[arg_23_1][arg_23_2].root_node:set_root_focal_distance(arg_23_3)
end

CameraManager.set_node_tree_root_focal_region = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	self._node_trees[arg_24_1][arg_24_2].root_node:set_root_focal_region(arg_24_3)
end

CameraManager.set_node_tree_root_focal_padding = function (self, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	self._node_trees[arg_25_1][arg_25_2].root_node:set_root_focal_padding(arg_25_3)
end

CameraManager.set_node_tree_root_focal_scale = function (self, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	self._node_trees[arg_26_1][arg_26_2].root_node:set_root_focal_scale(arg_26_3)
end

CameraManager.current_camera_node = function (self, arg_27_1)
	-- function 27
	return self._camera_nodes[arg_27_1][#self._camera_nodes[arg_27_1]].node:name()
end

CameraManager.tree_node = function (self, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	return self._node_trees[arg_28_1][arg_28_2].nodes[arg_28_3]
end

local tbl = {}

CameraManager.shading_callback = function (self, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	if self._world == arg_29_1 then
		local var_29_0 = self._shading_environment[arg_29_3]

		if not var_29_0 then
			var_29_0 = self._shading_environment[Viewport.get_data(arg_29_3, "overridden_viewport")]
			var_29_0 = var_29_0 or tbl
		end

		if not var_29_0.dof_enabled then
			local dof_enabled = var_29_0.dof_enabled

			ShadingEnvironment.set_scalar(arg_29_2, "dof_enabled", dof_enabled)

			if dof_enabled > 0 then
				local focal_distance = var_29_0.focal_distance
				local focal_region = var_29_0.focal_region
				local focal_padding = var_29_0.focal_padding
				local focal_scale = var_29_0.focal_scale

				ShadingEnvironment.set_scalar(arg_29_2, "dof_focal_distance", focal_distance)
				ShadingEnvironment.set_scalar(arg_29_2, "dof_focal_region", focal_region)
				ShadingEnvironment.set_scalar(arg_29_2, "dof_focal_region_start", focal_padding)
				ShadingEnvironment.set_scalar(arg_29_2, "dof_focal_region_end", focal_padding)
				ShadingEnvironment.set_scalar(arg_29_2, "dof_focal_near_scale", focal_scale)
				ShadingEnvironment.set_scalar(arg_29_2, "dof_focal_far_scale", focal_scale)
			end
		end

		if self._frame == 0 then
			self._frame = 1

			ShadingEnvironment.set_scalar(arg_29_2, "reset_luminance_adaption", 1)
		elseif self._frame == 1 then
			self._frame = 2

			ShadingEnvironment.set_scalar(arg_29_2, "reset_luminance_adaption", 0)
		end

		for k, v in pairs(WorldInteractionSettings) do
			ShadingEnvironment.set_scalar(arg_29_2, v.shading_env_variable, math.clamp(v.window_size, 1, 50))
		end

		if not self._vignette_falloff_opacity and not self._vignette_color then
			local vector3 = ShadingEnvironment.vector3(arg_29_2, "vignette_color")
			local vector3_2 = ShadingEnvironment.vector3(arg_29_2, "vignette_scale_falloff_opacity")
			local _vignette_t = self._vignette_t
			local unbox = self._vignette_falloff_opacity:unbox()
			local var_29_10 = Vector3(math.min(unbox.x, vector3_2.x), math.max(unbox.y, vector3_2.y), math.max(unbox.z, vector3_2.z))
			local smoothstep = Vector3.smoothstep(_vignette_t, vector3_2, var_29_10)

			ShadingEnvironment.set_vector3(arg_29_2, "vignette_color", self._vignette_color:unbox())
			ShadingEnvironment.set_vector3(arg_29_2, "vignette_scale_falloff_opacity", smoothstep)
		end

		local user_setting = Application.user_setting("gamma")

		user_setting = user_setting or 1

		ShadingEnvironment.set_scalar(arg_29_2, "exposure", ShadingEnvironment.scalar(arg_29_2, "exposure") * user_setting)

		if not Application.user_setting("render_settings", "particles_receive_shadows") then
			local num = ShadingEnvironment.array_elements(arg_29_2, "sun_shadow_slice_depth_ranges") - 1
			local array_vector2 = ShadingEnvironment.array_vector2(arg_29_2, "sun_shadow_slice_depth_ranges", num)

			array_vector2.x = 0

			ShadingEnvironment.set_array_vector2(arg_29_2, "sun_shadow_slice_depth_ranges", num, array_vector2)
		end

		self.mood_handler:apply_environment_variables(arg_29_2)

		local get_data = World.get_data(arg_29_1, "fullscreen_blur")

		get_data = get_data or 0

		if get_data > 0 then
			ShadingEnvironment.set_scalar(arg_29_2, "fullscreen_blur_enabled", 1)
			ShadingEnvironment.set_scalar(arg_29_2, "fullscreen_blur_amount", math.clamp(get_data, 0, 1))
		else
			World.set_data(arg_29_1, "fullscreen_blur", nil)
			ShadingEnvironment.set_scalar(arg_29_2, "fullscreen_blur_enabled", 0)
		end

		local get_data_2 = World.get_data(arg_29_1, "greyscale")

		get_data_2 = get_data_2 or 0

		if get_data_2 > 0 then
			ShadingEnvironment.set_scalar(arg_29_2, "grey_scale_enabled", 1)
			ShadingEnvironment.set_scalar(arg_29_2, "grey_scale_amount", math.clamp(get_data_2, 0, 1))
			ShadingEnvironment.set_vector3(arg_29_2, "grey_scale_weights", Vector3(0.33, 0.33, 0.33))
		else
			World.set_data(arg_29_1, "greyscale", nil)
			ShadingEnvironment.set_scalar(arg_29_2, "grey_scale_enabled", 0)
		end
	end
end

CameraManager._update_level_particle_effects = function (self, arg_30_1)
	-- function 30
	for k, v in pairs(self._level_particle_effect_ids) do
		World.move_particles(self._world, k, self:camera_position(arg_30_1))
	end
end

CameraManager.set_camera_node = function (self, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	if script_data.camera_debug or not script_data.camera_node_debug then
		-- Nothing
	end

	local var_31_0 = self._current_trees[arg_31_1]

	self._current_trees[arg_31_1] = arg_31_2

	local var_31_1 = self._camera_nodes[arg_31_1]
	local var_31_2 = var_31_1[#var_31_1]
	local var_31_3 = self._node_trees[arg_31_1][arg_31_2]
	local tbl = {
		node = var_31_3.nodes[arg_31_3]
	}

	assert(var_31_2 ~= tbl)

	if not var_31_2 then
		local var_31_5

		if var_31_0 ~= arg_31_2 then
			local tree_transitions = var_31_2.node:tree_transitions()

			var_31_5 = tree_transitions[arg_31_2] or tree_transitions.default
		else
			local node_transitions = var_31_2.node:node_transitions()

			var_31_5 = node_transitions[tbl.node:name()] or node_transitions.default
		end

		if not var_31_5 then
			self:_add_transition(arg_31_1, var_31_2, tbl, var_31_5)

			if not (not var_31_5.inherit_aim_rotation and var_31_0 == arg_31_2) then
				local root_node = self._node_trees[arg_31_1][var_31_0].root_node
				local aim_pitch = root_node:aim_pitch()
				local aim_yaw = root_node:aim_yaw()

				var_31_3.root_node:set_aim_pitch(aim_pitch)
				var_31_3.root_node:set_aim_yaw(aim_yaw)
			end
		else
			tbl.transition = {}

			self:_remove_camera_node(var_31_1, #var_31_1)
		end
	else
		tbl.transition = {}
	end

	tbl.node:set_active(true)

	var_31_1[#var_31_1 + 1] = tbl
end

CameraManager.set_frozen = function (self, arg_32_1)
	-- function 32
	self._frozen = arg_32_1
end

CameraManager.is_in_view = function (self, arg_33_1, arg_33_2)
	-- function 33
	local viewport = ScriptWorld.viewport(self._world, arg_33_1)
	local camera = ScriptViewport.camera(viewport)

	return Camera.inside_frustum(camera, arg_33_2) > 0
end

CameraManager._remove_camera_node = function (arg_34_0, arg_34_1, arg_34_2)
	-- function 34
	for i = 1, arg_34_2 do
		table.remove(arg_34_1, 1).node:set_active(false)
	end
end

CameraManager.camera_position = function (self, arg_35_1)
	-- function 35
	local viewport = ScriptWorld.viewport(self._world, arg_35_1)
	local camera = ScriptViewport.camera(viewport)

	return Camera.world_position(camera)
end

CameraManager.camera_rotation = function (self, arg_36_1)
	-- function 36
	local viewport = ScriptWorld.viewport(self._world, arg_36_1)
	local camera = ScriptViewport.camera(viewport)

	return Camera.world_rotation(camera)
end

CameraManager.camera_pose = function (self, arg_37_1)
	-- function 37
	local viewport = ScriptWorld.viewport(self._world, arg_37_1)
	local camera = ScriptViewport.camera(viewport)

	return Camera.world_pose(camera)
end

CameraManager.fov = function (self, arg_38_1)
	-- function 38
	local viewport = ScriptWorld.viewport(self._world, arg_38_1)
	local camera = ScriptViewport.camera(viewport)

	return Camera.vertical_fov(camera)
end

CameraManager.has_viewport = function (self, arg_39_1)
	-- function 39
	return ScriptWorld.has_viewport(self._world, arg_39_1)
end

CameraManager.aim_rotation = function (self, arg_40_1)
	-- function 40
	local var_40_0 = self._camera_nodes[arg_40_1]
	local root_node = self:_current_node(var_40_0):root_node()
	local aim_pitch = root_node:aim_pitch()
	local aim_yaw = root_node:aim_yaw()
	local var_40_4 = Quaternion(Vector3(1, 0, 0), aim_pitch)
	local var_40_5 = Quaternion(Vector3(0, 0, 1), aim_yaw)
	local multiply = Quaternion.multiply(var_40_5, var_40_4)
	local pitch_offset = self._variables[arg_40_1].pitch_offset

	if not pitch_offset then
		return (Quaternion.multiply(multiply, Quaternion(Vector3(1, 0, 0), pitch_offset)))
	else
		return multiply
	end
end

CameraManager._setup_child_nodes = function (self, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5, arg_41_6)
	-- function 41
	local _node = arg_41_5._node
	local _setup_node = self:_setup_node(_node, arg_41_4, arg_41_6)

	arg_41_6 = arg_41_6 or _setup_node
	arg_41_1[_setup_node:name()] = _setup_node

	for k, v in pairs(arg_41_5) do
		if k ~= "_node" then
			self:_setup_child_nodes(arg_41_1, arg_41_2, arg_41_3, _setup_node, v, arg_41_6)
		end
	end

	return _setup_node
end

CameraManager._setup_node = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	-- function 42
	local var_42_0 = rawget(_G, arg_42_1.class):new(arg_42_3)

	var_42_0:parse_parameters(arg_42_1, arg_42_2)

	if not arg_42_2 then
		arg_42_2:add_child_node(var_42_0)
	end

	return var_42_0
end

CameraManager.update = function (self, arg_43_1, arg_43_2, arg_43_3)
	-- function 43
	if not GameSettingsDevelopment.disable_shadow_lights_system then
		self:_update_shadow_lights(arg_43_1, arg_43_3)
	end

	local var_43_0 = self._node_trees[arg_43_3]
	local var_43_1 = self._variables[arg_43_3]
	local var_43_2 = self._node_trees[arg_43_3][self._current_trees[arg_43_3]]
	local var_43_3 = self._camera_nodes[arg_43_3]
	local _current_node = self:_current_node(var_43_3)

	var_43_2.root_node:update_pitch_yaw(arg_43_1, var_43_1, _current_node, arg_43_3)

	local aim_yaw = var_43_2.root_node:aim_yaw()
	local aim_pitch = var_43_2.root_node:aim_pitch()

	for k, v in pairs(var_43_0) do
		if v ~= var_43_2 then
			v.root_node:set_aim_pitch(aim_pitch)
			v.root_node:set_aim_yaw(aim_yaw)
		end
	end

	self:_update_level_particle_effects(arg_43_3)
	self.mood_handler:update(arg_43_1)
	self._environment_blenders[arg_43_3]:update(arg_43_1, arg_43_2)
end

CameraManager.set_fov_multiplier = function (self, arg_44_1)
	-- function 44
	self._fov_multiplier = arg_44_1
end

CameraManager.set_additional_fov_multiplier = function (self, arg_45_1)
	-- function 45
	self._additional_fov_multiplier = arg_45_1
end

CameraManager.set_additional_fov_multiplier_with_lerp_time = function (self, arg_46_1, arg_46_2)
	-- function 46
	self._additional_fov_multiplier_data = {
		current_lerp_time = 0,
		total_lerp_time = arg_46_2,
		fov_multiplier = arg_46_1
	}
end

CameraManager.set_pitch_yaw = function (self, arg_47_1, arg_47_2, arg_47_3)
	-- function 47
	local var_47_0 = self._node_trees[arg_47_1]

	for k, v in pairs(var_47_0) do
		v.root_node:set_aim_pitch(arg_47_2)
		v.root_node:set_aim_yaw(arg_47_3)
	end
end

CameraManager.set_variable = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	-- function 48
	arg_48_0._variables[arg_48_1][arg_48_2] = arg_48_3
end

CameraManager.variable = function (self, arg_49_1, arg_49_2)
	-- function 49
	return self._variables[arg_49_1][arg_49_2]
end

CameraManager.post_update = function (self, arg_50_1, arg_50_2, arg_50_3)
	-- function 50
	if not self._frozen then
		return
	end

	local var_50_0 = self._node_trees[arg_50_3]
	local var_50_1 = self._variables[arg_50_3]

	for k, v in pairs(var_50_0) do
		self:_update_nodes(arg_50_1, arg_50_3, k, var_50_1)
	end

	self:_update_camera(arg_50_1, arg_50_2, arg_50_3)
	self:_update_sound_listener(arg_50_3)
end

CameraManager.force_update_nodes = function (self, arg_51_1, arg_51_2)
	-- function 51
	local var_51_0 = self._node_trees[arg_51_2]
	local var_51_1 = self._variables[arg_51_2]

	for k, v in pairs(var_51_0) do
		self:_update_nodes(arg_51_1, arg_51_2, k, var_51_1)
	end
end

local num = 0.01
local num_2 = 20

CameraManager._smooth_camera_collision = function (self, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
	-- function 52
	local get_data = World.get_data(self._world, "physics_world")
	local var_52_1 = arg_52_2
	local var_52_2 = arg_52_1
	local normalize = Vector3.normalize(var_52_2 - var_52_1)
	local length = Vector3.length(var_52_2 - var_52_1)
	local var_52_5 = length
	local var_52_6 = arg_52_3

	if length < var_52_6 then
		assert(Vector3.is_valid(var_52_2), "Trying to set invalid camera position")

		return var_52_2
	end

	local var_52_7

	if not script_data.camera_debug then
		var_52_7 = Managers.state.debug:drawer({
			name = "Intersection"
		})

		var_52_7:reset()
	end

	local immediate_overlap, var_52_9 = PhysicsWorld.immediate_overlap(get_data, "shape", "sphere", "position", var_52_1, "size", arg_52_3, "types", "statics", "collision_filter", "filter_camera_sweep")

	if var_52_9 > 0 then
		if not script_data.camera_debug then
			Application.warning("[CameraManager] Safe spot is intersecting with geometry")
		end

		assert(Vector3.is_valid(var_52_1), "Trying to set invalid camera position")

		return var_52_1
	end

	local num_3 = 0

	while true do
		if var_52_5 < num then
			assert(Vector3.is_valid(var_52_1), "Trying to set invalid camera position")

			return var_52_1
		end

		local linear_sphere_sweep = PhysicsWorld.linear_sphere_sweep(get_data, var_52_1, var_52_2, var_52_6, 1, "types", "statics", "collision_filter", "filter_camera_sweep")
		local var_52_12

		if not (not linear_sphere_sweep and not (#linear_sphere_sweep > 0)) then
			if not script_data.camera_debug then
				local var_52_13 = var_52_1

				for i, v in ipairs(linear_sphere_sweep) do
					local normalize_2 = Vector3.normalize(v.position - var_52_13)
					local length_2 = Vector3.length(var_52_13 - v.position)

					var_52_7:vector(var_52_13, v.position - var_52_13, Color(0, 255, 0))
					var_52_7:sphere(v.position, 0.1, Color(0, 255, 0))

					var_52_13 = v.position
				end
			end

			local var_52_16 = linear_sphere_sweep[1]
			local dot = Vector3.dot(normalize, var_52_16.position - var_52_1)
			local length_3 = Vector3.length(var_52_16.position - var_52_1 - dot * normalize)

			if length_3 < num then
				local position = var_52_16.position

				assert(Vector3.is_valid(position), "Trying to set invalid camera position")

				return position
			end

			local var_52_20

			if length_3 < arg_52_4 then
				var_52_20 = dot - var_52_6
			else
				var_52_20 = dot + (length_3 - arg_52_4) / (arg_52_3 - arg_52_4) * (length - dot) - var_52_6
			end

			if var_52_20 < var_52_5 then
				var_52_5 = var_52_20
				var_52_2 = var_52_1 + normalize * var_52_5
			end

			if var_52_6 - length_3 < 0.05 then
				var_52_6 = math.max(var_52_6 - 0.05, arg_52_4)
			else
				var_52_6 = math.max(length_3, arg_52_4)
			end
		else
			if not script_data.camera_debug then
				var_52_7:sphere(var_52_2, 0.2, Color(0, 0, 255))
			end

			assert(Vector3.is_valid(var_52_2), "Trying to set invalid camera position")

			return var_52_2
		end

		num_3 = num_3 + 1

		if num_3 > num_2 then
			return var_52_2
		end
	end
end

CameraManager._update_nodes = function (self, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
	-- function 53
	local var_53_0 = self._node_trees[arg_53_2][arg_53_3]
	local var_53_1 = self._camera_nodes[arg_53_2]
	local _current_node = self:_current_node(var_53_1)

	var_53_0.root_node:update(arg_53_1, arg_53_4, _current_node:pitch_speed(), _current_node:yaw_speed())
end

CameraManager._current_node = function (arg_54_0, arg_54_1)
	-- function 54
	return arg_54_1[#arg_54_1].node
end

CameraManager.camera_effect_sequence_event = function (self, arg_55_1, arg_55_2)
	-- function 55
	if not Application.user_setting("camera_shake") then
		return
	end

	local _sequence_event_settings = self._sequence_event_settings
	local var_55_1

	if not _sequence_event_settings.event then
		var_55_1 = _sequence_event_settings.current_values
	end

	_sequence_event_settings.start_time = arg_55_2
	_sequence_event_settings.event = CameraEffectSettings.sequence[arg_55_1]
	_sequence_event_settings.transition_function = CameraEffectSettings.transition_functions.lerp

	local num = 0

	for k, v in pairs(_sequence_event_settings.event.values) do
		for i, v_2 in ipairs(v) do
			if num < v_2.time_stamp then
				num = v_2.time_stamp
			end
		end
	end

	_sequence_event_settings.end_time = arg_55_2 + num

	if not var_55_1 then
		fassert(num > 0, "Camera effect sequence duration is %f", num)

		local time_to_recuperate_to = _sequence_event_settings.event.time_to_recuperate_to

		fassert(time_to_recuperate_to > 0, "Camera effect sequence time_to_recuperate_to is %f", time_to_recuperate_to)

		local num_2 = time_to_recuperate_to / 100 * num

		_sequence_event_settings.time_to_recover = num_2
		_sequence_event_settings.recovery_values = self:_calculate_sequence_event_values_normal(_sequence_event_settings.event.values, num_2)
		_sequence_event_settings.previous_values = var_55_1
	end
end

CameraManager.camera_effect_shake_event = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	-- function 56
	if not Application.user_setting("camera_shake") then
		return
	end

	local tbl = {}
	local var_56_1 = CameraEffectSettings.shake[arg_56_1]
	local duration = var_56_1.duration
	local fade_in = var_56_1.fade_in
	local fade_out = var_56_1.fade_out

	if not duration and not fade_out then
		duration = duration + (fade_in or 0) + fade_out
	end

	tbl.event = var_56_1
	tbl.start_time = arg_56_2
	tbl.end_time = not duration and arg_56_2 + duration
	tbl.fade_in_time = not fade_in and arg_56_2 + fade_in
	tbl.fade_out_time = not fade_out and tbl.end_time - fade_out

	local seed = var_56_1.seed

	seed = seed or Math.random(1, 100)
	tbl.seed = seed
	tbl.scale = arg_56_3 or 1
	arg_56_0._shake_event_settings[tbl] = true

	if not not var_56_1.no_rumble and not Managers.state.controller_features then
		Managers.state.controller_features:add_effect("camera_shake", {
			shake_settings = tbl,
			scale = arg_56_3 or 1,
			duration = duration,
			event_name = arg_56_1
		})
	end

	return tbl
end

CameraManager.stop_camera_effect_shake_event = function (arg_57_0, arg_57_1)
	-- function 57
	arg_57_0._shake_event_settings[arg_57_1] = nil
end

CameraManager.is_recoiling = function (self)
	-- function 58
	local _recoil_event_settings = self._recoil_event_settings

	_recoil_event_settings = not _recoil_event_settings and table.size(self._recoil_event_settings) > 0

	return _recoil_event_settings, self._total_recoil_offset
end

CameraManager.weapon_recoil = function (arg_59_0, arg_59_1)
	-- function 59
	local tbl = {}
	local climb_start_time = arg_59_1.climb_start_time
	local climb_end_time = arg_59_1.climb_end_time
	local num = climb_end_time - climb_start_time
	local restore_start_time = arg_59_1.restore_start_time
	local restore_end_time = arg_59_1.restore_end_time
	local num_2 = restore_end_time - restore_start_time

	fassert(num + num_2 > 0, "weapon recoil duration is %f", num + num_2)

	tbl.vertical_climb = arg_59_1.vertical_climb
	tbl.horizontal_climb = arg_59_1.horizontal_climb
	tbl.climb_function = arg_59_1.climb_function
	tbl.restore_function = arg_59_1.restore_function
	tbl.climb_start_time = climb_start_time
	tbl.climb_end_time = climb_end_time
	tbl.climb_duration = num
	tbl.restore_start_time = restore_start_time
	tbl.restore_end_time = restore_end_time
	tbl.restore_duration = num_2
	tbl.current_climb_time = 0
	tbl.current_restore_time = 0
	tbl.id = arg_59_1.id
	arg_59_0._recoil_event_settings[tbl] = true

	return tbl
end

CameraManager.stop_weapon_recoil = function (arg_60_0, arg_60_1)
	-- function 60
	arg_60_0._recoil_event_settings[arg_60_1] = nil
end

CameraManager.set_offset = function (self, arg_61_1, arg_61_2, arg_61_3)
	-- function 61
	local store

	if not self._camera_offset then
		store = self._camera_offset:store(Vector3(arg_61_1, arg_61_2, arg_61_3))

		if not store then
			-- Nothing
		end
	end

	store = Vector3Box(arg_61_1, arg_61_2, arg_61_3)

	::label_61_0::

	self._camera_offset = store
end

CameraManager._apply_offset = function (self, arg_62_1, arg_62_2)
	-- function 62
	local var_62_0 = arg_62_1
	local unbox

	if not self._camera_offset then
		unbox = self._camera_offset:unbox()

		if not unbox then
			-- Nothing
		end
	end

	unbox = Vector3(0, 0, 0)

	::label_62_0::

	local x = unbox.x
	local y = unbox.y
	local z = unbox.z
	local num = x * Quaternion.right(arg_62_1.rotation)
	local num_2 = y * Quaternion.forward(arg_62_1.rotation)
	local var_62_7 = Vector3(0, 0, z)

	var_62_0.position = arg_62_1.position + num + num_2 + var_62_7

	return var_62_0
end

CameraManager._update_additional_fov_multiplier = function (self, arg_63_1)
	-- function 63
	local _additional_fov_multiplier_data = self._additional_fov_multiplier_data

	if not _additional_fov_multiplier_data then
		return
	end

	local num = _additional_fov_multiplier_data.current_lerp_time / _additional_fov_multiplier_data.total_lerp_time
	local lerp = math.lerp(self._additional_fov_multiplier, _additional_fov_multiplier_data.fov_multiplier, num)

	_additional_fov_multiplier_data.current_lerp_time = math.min(_additional_fov_multiplier_data.current_lerp_time + arg_63_1, _additional_fov_multiplier_data.total_lerp_time)

	if _additional_fov_multiplier_data.current_lerp_time == _additional_fov_multiplier_data.total_lerp_time then
		local var_63_3
	end

	self._additional_fov_multiplier = lerp
end

CameraManager._update_camera = function (self, arg_64_1, arg_64_2, arg_64_3)
	-- function 64
	local viewport = ScriptWorld.viewport(self._world, arg_64_3)
	local camera = ScriptViewport.camera(viewport)
	local shadow_cull_camera = ScriptViewport.shadow_cull_camera(viewport)
	local var_64_3 = self._camera_nodes[arg_64_3]
	local _current_node = self:_current_node(var_64_3)
	local _update_transition = self:_update_transition(arg_64_3, var_64_3, arg_64_1)

	if not self._sequence_event_settings.event then
		self:_apply_sequence_event(_update_transition, arg_64_2)
	end

	for k, v in pairs(self._shake_event_settings) do
		self:_apply_shake_event(k, _update_transition, arg_64_2)
	end

	for k_2, v_2 in pairs(self._recoil_event_settings) do
		_update_transition = self:_apply_recoil_event(k_2, table.clone(_update_transition), arg_64_1, arg_64_2)
	end

	local var_64_6 = rawget(_G, "Tobii")

	var_64_6 = not var_64_6 and Application.user_setting("tobii_eyetracking")

	if not var_64_6 and not Application.user_setting("tobii_eyetracking") and not Application.user_setting("tobii_extended_view") then
		self:_apply_extended_view(_update_transition)
	end

	self:_apply_offset(_update_transition, arg_64_2)
	self:_update_additional_fov_multiplier(arg_64_1)
	self:_update_camera_properties(camera, shadow_cull_camera, _current_node, _update_transition, arg_64_3)
	ScriptCamera.force_update(self._world, camera)

	if not GameSettingsDevelopment.simple_first_person then
		local get_data = Camera.get_data(camera, "unit")

		World.update_unit(self._world, get_data)

		local get_data_2 = Unit.get_data(get_data, "rig_unit")

		if not Unit.alive(get_data_2) then
			World.update_unit(self._world, get_data_2)
		end
	end
end

CameraManager._apply_sequence_event = function (self, arg_65_1, arg_65_2)
	-- function 65
	local _sequence_event_settings = self._sequence_event_settings
	local var_65_1

	if arg_65_2 < _sequence_event_settings.time_to_recover + _sequence_event_settings.start_time then
		var_65_1 = self:_calculate_sequence_event_values_recovery(arg_65_2)
	else
		local num = arg_65_2 - _sequence_event_settings.start_time
		local values = _sequence_event_settings.event.values

		var_65_1 = self:_calculate_sequence_event_values_normal(values, num)
	end

	arg_65_1.position = self:_calculate_sequence_event_position(arg_65_1, var_65_1)
	arg_65_1.rotation = self:_calculate_sequence_event_rotation(arg_65_1, var_65_1)
	_sequence_event_settings.current_values = var_65_1

	if arg_65_2 >= self._sequence_event_settings.end_time then
		_sequence_event_settings.start_time = 0
		_sequence_event_settings.end_time = 0
		_sequence_event_settings.event = nil
		_sequence_event_settings.current_values = nil
		_sequence_event_settings.time_to_recover = 0
		_sequence_event_settings.recovery_values = nil
		_sequence_event_settings.transition_function = nil
	end
end

CameraManager._calculate_sequence_event_values_recovery = function (self, arg_66_1)
	-- function 66
	local tbl = {
		yaw = 0,
		z = 0,
		roll = 0,
		y = 0,
		pitch = 0,
		x = 0
	}
	local _sequence_event_settings = self._sequence_event_settings
	local time_to_recover = _sequence_event_settings.time_to_recover

	if time_to_recover <= 0 then
		table.dump(_sequence_event_settings)
		fassert(false, "time to recover is less than 0")
	end

	local previous_values = _sequence_event_settings.previous_values
	local recovery_values = _sequence_event_settings.recovery_values
	local num = (arg_66_1 - _sequence_event_settings.start_time) / time_to_recover

	for k, v in pairs(previous_values) do
		tbl[k] = math.lerp(v, recovery_values[k], num)
	end

	return tbl
end

CameraManager._calculate_sequence_event_values_normal = function (self, arg_67_1, arg_67_2)
	-- function 67
	local tbl = {
		yaw = 0,
		z = 0,
		roll = 0,
		y = 0,
		pitch = 0,
		x = 0
	}

	for k, v in pairs(arg_67_1) do
		for i, v_2 in ipairs(v) do
			if arg_67_2 < v_2.time_stamp then
				local var_67_1 = v_2
				local var_67_2 = v[i - 1]

				var_67_2 = var_67_2 or CameraEffectSettings.empty_modifier_settings

				local num = arg_67_2 - var_67_2.time_stamp
				local num_2 = var_67_1.time_stamp - var_67_2.time_stamp

				if num_2 == 0 then
					table.dump(var_67_2, "current settings")
					table.dump(var_67_1, "next_settings")
					assert(false, "Time stamp difference is 0, this would result in a div0")
				end

				local num_3 = num / num_2

				tbl[k] = self._sequence_event_settings.transition_function(var_67_2.value, var_67_1.value, num_3)

				break
			end
		end
	end

	return tbl
end

CameraManager._calculate_sequence_event_position = function (arg_68_0, arg_68_1, arg_68_2)
	-- function 68
	local position = arg_68_1.position
	local rotation = arg_68_1.rotation
	local num = arg_68_2.x * Quaternion.right(rotation)
	local num_2 = arg_68_2.y * Quaternion.forward(rotation)
	local var_68_4 = Vector3(0, 0, arg_68_2.z)

	return position + num + num_2 + var_68_4
end

CameraManager._calculate_sequence_event_rotation = function (arg_69_0, arg_69_1, arg_69_2)
	-- function 69
	local rotation = arg_69_1.rotation
	local num = math.pi / 180
	local var_69_2 = Quaternion(Vector3.up(), arg_69_2.yaw * num)
	local var_69_3 = Quaternion(Vector3.right(), arg_69_2.pitch * num)
	local var_69_4 = Quaternion(Vector3.forward(), arg_69_2.roll * num)
	local multiply = Quaternion.multiply(Quaternion.multiply(var_69_2, var_69_3), var_69_4)

	return Quaternion.multiply(rotation, multiply)
end

CameraManager._apply_shake_event = function (self, arg_70_1, arg_70_2, arg_70_3)
	-- function 70
	local _shake_event_settings = self._shake_event_settings
	local start_time = arg_70_1.start_time
	local end_time = arg_70_1.end_time
	local fade_in_time = arg_70_1.fade_in_time
	local fade_out_time = arg_70_1.fade_out_time

	if not (not fade_in_time and not (arg_70_3 <= fade_in_time)) then
		arg_70_1.fade_progress = math.clamp((arg_70_3 - start_time) / (fade_in_time - start_time), 0, 1)
	elseif not (not fade_out_time and not (fade_out_time <= arg_70_3)) then
		arg_70_1.fade_progress = math.clamp((end_time - arg_70_3) / (end_time - fade_out_time), 0, 1)
	end

	local num = self:_calculate_perlin_value(arg_70_3 - arg_70_1.start_time, arg_70_1) * arg_70_1.scale
	local num_2 = self:_calculate_perlin_value(arg_70_3 - arg_70_1.start_time + 10, arg_70_1) * arg_70_1.scale
	local rotation = arg_70_2.rotation
	local num_3 = math.pi / 180
	local var_70_9 = Quaternion(Vector3.up(), num_2 * num_3)
	local var_70_10 = Quaternion(Vector3.right(), num * num_3)
	local multiply = Quaternion.multiply(var_70_9, var_70_10)

	arg_70_2.rotation = Quaternion.multiply(rotation, multiply)

	if not (not arg_70_1.end_time and not (arg_70_3 >= arg_70_1.end_time)) then
		_shake_event_settings[arg_70_1] = nil
	end
end

CameraManager._apply_recoil_event = function (self, arg_71_1, arg_71_2, arg_71_3, arg_71_4)
	-- function 71
	local _recoil_event_settings = self._recoil_event_settings
	local vertical_climb = arg_71_1.vertical_climb
	local horizontal_climb = arg_71_1.horizontal_climb
	local climb_start_time = arg_71_1.climb_start_time
	local climb_end_time = arg_71_1.climb_end_time
	local climb_duration = arg_71_1.climb_duration
	local restore_start_time = arg_71_1.restore_start_time
	local restore_end_time = arg_71_1.restore_end_time
	local restore_duration = arg_71_1.restore_duration
	local current_climb_time = arg_71_1.current_climb_time
	local current_restore_time = arg_71_1.current_restore_time
	local climb_function = arg_71_1.climb_function
	local restore_function = arg_71_1.restore_function
	local var_71_13 = arg_71_2
	local rotation = arg_71_2.rotation
	local flag = arg_71_4 < climb_end_time
	local num

	if not flag then
		num = current_climb_time / climb_duration

		if not num then
			-- Nothing
		end
	end

	num = current_restore_time / restore_duration

	::label_71_0::

	num = not flag and climb_function(num) and restore_function(num)

	local degrees_to_radians

	if not flag then
		degrees_to_radians = math.degrees_to_radians(horizontal_climb)

		if not degrees_to_radians then
			-- Nothing
		end
	end

	degrees_to_radians = 0

	do
		local degrees_to_radians_2
	end

	::label_71_1::

	if not flag then
		degrees_to_radians_2 = math.degrees_to_radians(vertical_climb)

		if not degrees_to_radians_2 then
			-- Nothing
		end
	end

	degrees_to_radians_2 = 0

	::label_71_2::

	local num_2 = math.degrees_to_radians(not flag and horizontal_climb and -horizontal_climb) * num
	local num_3 = math.degrees_to_radians(not flag and vertical_climb and -vertical_climb) * num
	local var_71_21 = Quaternion(Vector3.up(), degrees_to_radians + num_2)
	local var_71_22 = Quaternion(Vector3.right(), degrees_to_radians_2 + num_3)
	local multiply = Quaternion.multiply(var_71_21, var_71_22)
	local store

	if not self._total_recoil_offset then
		store = self._total_recoil_offset:store(multiply)

		if not store then
			-- Nothing
		end
	end

	store = QuaternionBox(multiply)

	::label_71_3::

	self._total_recoil_offset = store
	var_71_13.rotation = Quaternion.multiply(rotation, multiply)

	if not flag then
		arg_71_1.current_climb_time = current_climb_time + arg_71_3
	else
		arg_71_1.current_restore_time = current_restore_time + arg_71_3
	end

	if restore_end_time <= arg_71_4 then
		_recoil_event_settings[arg_71_1] = nil
	end

	return var_71_13
end

CameraManager._apply_extended_view = function (self, arg_72_1)
	-- function 72
	local var_72_0 = Quaternion(Vector3.up(), -self._tobii_extended_view.yaw)
	local multiply = Quaternion.multiply(Quaternion.inverse(arg_72_1.rotation), var_72_0)
	local multiply_2 = Quaternion.multiply(multiply, arg_72_1.rotation)
	local var_72_3 = Quaternion(Vector3.right(), self._tobii_extended_view.pitch)
	local multiply_3 = Quaternion.multiply(multiply_2, var_72_3)

	arg_72_1.rotation = Quaternion.multiply(arg_72_1.rotation, multiply_3)
end

CameraManager.set_tobii_extended_view = function (arg_73_0, arg_73_1, arg_73_2)
	-- function 73
	arg_73_0._tobii_extended_view.yaw = arg_73_1
	arg_73_0._tobii_extended_view.pitch = arg_73_2
end

CameraManager._calculate_perlin_value = function (self, arg_74_1, arg_74_2)
	-- function 74
	local num = 0
	local event = arg_74_2.event
	local persistance = event.persistance
	local octaves = event.octaves

	for i = 0, octaves do
		local num_2 = 2^i
		local num_3 = persistance^i

		num = num + self:_interpolated_noise(arg_74_1 * num_2, arg_74_2) * num_3
	end

	local amplitude = event.amplitude

	amplitude = amplitude or 1

	local fade_progress = arg_74_2.fade_progress

	fade_progress = fade_progress or 1

	return num * amplitude * fade_progress
end

CameraManager._interpolated_noise = function (self, arg_75_1, arg_75_2)
	-- function 75
	local floor = math.floor(arg_75_1)
	local num = arg_75_1 - floor
	local _smoothed_noise = self:_smoothed_noise(floor, arg_75_2)
	local _smoothed_noise_2 = self:_smoothed_noise(floor + 1, arg_75_2)

	return math.lerp(_smoothed_noise, _smoothed_noise_2, num)
end

CameraManager._smoothed_noise = function (self, arg_76_1, arg_76_2)
	-- function 76
	return self:_noise(arg_76_1, arg_76_2) / 2 + self:_noise(arg_76_1 - 1, arg_76_2) / 4 + self:_noise(arg_76_1 + 1, arg_76_2) / 4
end

CameraManager._noise = function (arg_77_0, arg_77_1, arg_77_2)
	-- function 77
	local next_random, var_77_1 = Math.next_random(arg_77_1 + arg_77_2.seed)
	local next_random_2, var_77_3 = Math.next_random(next_random)

	return var_77_3 * 2 - 1
end

CameraManager.apply_level_particle_effects = function (self, arg_78_1, arg_78_2)
	-- function 78
	for i, v in ipairs(arg_78_1) do
		local _world = self._world
		local create_particles = World.create_particles(_world, v, self:camera_position(arg_78_2))

		self._level_particle_effect_ids[create_particles] = true
	end
end

CameraManager.apply_level_screen_effects = function (self, arg_79_1, arg_79_2)
	-- function 79
	for i, v in ipairs(arg_79_1) do
		local _world = self._world
		local create_particles = World.create_particles(_world, v, Vector3(0, 0, 0))

		self._level_screen_effect_ids[create_particles] = true
	end
end

CameraManager._update_camera_properties = function (self, arg_80_1, arg_80_2, arg_80_3, arg_80_4, arg_80_5)
	-- function 80
	if not arg_80_4.position then
		local root_unit, var_80_1 = arg_80_3:root_unit()
		local position = arg_80_4.position

		if not root_unit and not Unit.alive(root_unit) then
			local safe_position_offset = arg_80_3:safe_position_offset()
			local world_position = Unit.world_position
			local var_80_5 = root_unit
			local node

			if not var_80_1 then
				node = Unit.node(root_unit, var_80_1)

				if not node then
					-- Nothing
				end
			end

			node = 0

			::label_80_0::

			local num = world_position(var_80_5, node) + safe_position_offset:unbox()

			assert(Vector3.is_valid(num), "Trying to use invalid safe position")

			position = self:_smooth_camera_collision(arg_80_4.position, num, 0.35, 0.25)
		end

		if not script_data.camera_debug and not Managers.state.debug then
			local drawer = Managers.state.debug:drawer({
				name = "CameraManager"
			})

			if not DebugKeyHandler.key_pressed("z", "clear camera debug") then
				drawer:reset()
			end

			drawer:sphere(position, 0.1)
		end

		ScriptCamera.set_local_position(arg_80_1, position)
		ScatterSystem.move_observer(self._scatter_system, self._scatter_system_observers[arg_80_5], position, arg_80_4.rotation)

		local get_data = World.get_data(self._world, "physics_world")

		if not get_data and not PhysicsWorld.set_observer then
			PhysicsWorld.set_observer(get_data, Matrix4x4.from_quaternion_position(arg_80_4.rotation, position))
		end
	end

	if not arg_80_4.yaw_speed then
		self._variables[arg_80_5].yaw_speed = arg_80_4.yaw_speed
	end

	if not arg_80_4.pitch_offset then
		self._variables[arg_80_5].pitch_offset = arg_80_4.pitch_offset
	end

	if not arg_80_4.pitch_speed then
		self._variables[arg_80_5].pitch_speed = arg_80_4.pitch_speed
	end

	if not arg_80_4.rotation then
		ScriptCamera.set_local_rotation(arg_80_1, arg_80_4.rotation)
	end

	if not script_data.fov_override then
		Camera.set_vertical_fov(arg_80_2, math.pi * script_data.fov_override / 180)
		Camera.set_vertical_fov(arg_80_1, math.pi * script_data.fov_override / 180)
	elseif not arg_80_4.vertical_fov then
		local vertical_fov = arg_80_4.vertical_fov

		if not arg_80_3:should_apply_fov_multiplier() then
			Camera.set_vertical_fov(arg_80_1, vertical_fov * self._fov_multiplier * self._additional_fov_multiplier)
			Camera.set_vertical_fov(arg_80_2, arg_80_3:default_fov())
		else
			Camera.set_vertical_fov(arg_80_1, vertical_fov)
			Camera.set_vertical_fov(arg_80_2, arg_80_3:default_fov())
		end

		if not script_data.camera_debug and not Managers.state.debug then
			local format = string.format("Vertical FOV: %s", vertical_fov * 180 / math.pi)

			Debug.text(format)
		end
	end

	if not arg_80_4.near_range then
		Camera.set_near_range(arg_80_1, arg_80_4.near_range)
		Camera.set_near_range(arg_80_2, arg_80_4.near_range)
	end

	if not arg_80_4.far_range then
		local get_data_2 = Camera.get_data(arg_80_1, "far_range")

		get_data_2 = get_data_2 or arg_80_4.far_range

		Camera.set_far_range(arg_80_1, get_data_2)
		Camera.set_far_range(arg_80_2, get_data_2)
	end

	if not arg_80_4.fade_to_black then
		self._variables[arg_80_5].fade_to_black = arg_80_4.fade_to_black
	end

	local viewport = ScriptWorld.viewport(self._world, arg_80_5)

	self._shading_environment[viewport] = arg_80_4.shading_environment
end

CameraManager._update_sound_listener = function (self, arg_81_1)
	-- function 81
	local _world = self._world
	local listener_pose = self:listener_pose(arg_81_1)
	local wwise_world = Managers.world:wwise_world(_world)

	WwiseWorld.set_listener(wwise_world, 0, listener_pose)

	local translation = Matrix4x4.translation(listener_pose)
	local _listener_elevation_scale = self._listener_elevation_scale
	local _listener_elevation_offset = self._listener_elevation_offset
	local _listener_elevation_min = self._listener_elevation_min
	local _listener_elevation_max = self._listener_elevation_max
	local clamp = math.clamp((translation.z - _listener_elevation_offset) * _listener_elevation_scale, _listener_elevation_min, _listener_elevation_max)

	if not script_data.debug_wwise_elevation then
		Debug.text("Elevation: %f", clamp)
		Debug.text("")
		Debug.text("Current z position: %f", translation.z)
		Debug.text("Offset z: %f", _listener_elevation_offset)
		Debug.text("Scale: %f", _listener_elevation_scale)
		Debug.text("Min: %f", _listener_elevation_min)
		Debug.text("Max: %f", _listener_elevation_max)
	end

	WwiseWorld.set_global_parameter(wwise_world, "lua_elevation", clamp)
end

CameraManager.listener_pose = function (self, arg_82_1)
	-- function 82
	local _world = self._world
	local viewport = ScriptWorld.viewport(_world, arg_82_1, true)
	local camera = ScriptViewport.camera(viewport)

	return (Camera.world_pose(camera))
end

CameraManager._add_transition = function (self, arg_83_1, arg_83_2, arg_83_3, arg_83_4)
	-- function 83
	local tbl = {}

	for i, v in ipairs(self.NODE_PROPERTY_MAP) do
		local var_83_1 = arg_83_4[v]

		if not var_83_1 then
			local duration = var_83_1.duration
			local speed = var_83_1.speed

			tbl[v] = rawget(_G, var_83_1.class):new(arg_83_2.node, arg_83_3.node, duration, speed, var_83_1)
		end
	end

	arg_83_3.transition = tbl
end

CameraManager._update_transition = function (self, arg_84_1, arg_84_2, arg_84_3)
	-- function 84
	local _property_temp_table = self._property_temp_table

	table.clear(_property_temp_table)

	local var_84_1
	local NODE_PROPERTY_MAP = self.NODE_PROPERTY_MAP

	for i, v in ipairs(NODE_PROPERTY_MAP) do
		for i_2, v_2 in ipairs(arg_84_2) do
			local transition = v_2.transition
			local var_84_4 = transition[v]

			if not var_84_4 then
				local var_84_5
				local flag = i_2 == #arg_84_2
				local var_84_7

				var_84_1, var_84_7 = var_84_4:update(arg_84_3, var_84_1, flag)

				if not var_84_7 then
					transition[v] = nil
				end
			else
				var_84_1 = v_2.node[v](v_2.node)
			end
		end

		_property_temp_table[v] = var_84_1
		var_84_1 = nil
	end

	local var_84_8

	for i_3, v_3 in ipairs(arg_84_2) do
		if not next(v_3.transition) then
			var_84_8 = i_3 - 1
		end
	end

	if not (not var_84_8 and not (var_84_8 > 0)) then
		self:_remove_camera_node(arg_84_2, var_84_8)
	end

	return _property_temp_table
end

CameraManager.set_mood = function (self, arg_85_1, arg_85_2, arg_85_3)
	-- function 85
	self.mood_handler:set_mood(arg_85_1, arg_85_2, arg_85_3)
end

CameraManager.clear_mood = function (self, arg_86_1)
	-- function 86
	self.mood_handler:clear_mood(arg_86_1)
end

CameraManager.has_mood = function (self, arg_87_1)
	-- function 87
	self.mood_handler:has_mood(arg_87_1)
end
