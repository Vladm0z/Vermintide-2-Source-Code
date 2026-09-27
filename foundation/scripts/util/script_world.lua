-- chunkname: @foundation/scripts/util/script_world.lua

local ScriptWorld = ScriptWorld

ScriptWorld = ScriptWorld or {}
ScriptWorld = ScriptWorld

ScriptWorld.name = function (arg_1_0)
	-- function 1
	return World.get_data(arg_1_0, "name")
end

ScriptWorld.activate = function (arg_2_0)
	-- function 2
	World.set_data(arg_2_0, "active", true)
end

ScriptWorld.deactivate = function (arg_3_0)
	-- function 3
	World.set_data(arg_3_0, "active", false)
end

ScriptWorld.pause = function (arg_4_0)
	-- function 4
	World.set_data(arg_4_0, "paused", true)
end

ScriptWorld.unpause = function (arg_5_0)
	-- function 5
	World.set_data(arg_5_0, "paused", false)
end

ScriptWorld.create_viewport = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7)
	-- function 6
	local get_data = World.get_data(arg_6_0, "viewports")

	fassert(get_data[arg_6_1] == nil, "Viewport %q already exists", arg_6_1)

	local create_viewport = Application.create_viewport(arg_6_0, arg_6_2)

	Viewport.set_data(create_viewport, "layer", arg_6_3 or 1)
	Viewport.set_data(create_viewport, "active", true)
	Viewport.set_data(create_viewport, "name", arg_6_1)

	get_data[arg_6_1] = create_viewport

	if not arg_6_7 then
		Viewport.set_data(create_viewport, "no_scaling", true)
	end

	local splitscreen = Managers.splitscreen

	splitscreen = not splitscreen and Managers.splitscreen:active()

	if not (not splitscreen and arg_6_7) then
		Viewport.set_data(create_viewport, "rect", {
			SPLITSCREEN_OFFSET_X,
			SPLITSCREEN_OFFSET_Y,
			SPLITSCREEN_WIDTH,
			SPLITSCREEN_HEIGHT
		})
	else
		Viewport.set_data(create_viewport, "rect", {
			0,
			0,
			1,
			1
		})
	end

	Viewport.set_rect(create_viewport, unpack(Viewport.get_data(create_viewport, "rect")))

	local var_6_3

	if not arg_6_4 and not arg_6_5 then
		var_6_3 = World.spawn_unit(arg_6_0, "core/units/camera", arg_6_4, arg_6_5)
	elseif not arg_6_4 then
		var_6_3 = World.spawn_unit(arg_6_0, "core/units/camera", arg_6_4)
	else
		var_6_3 = World.spawn_unit(arg_6_0, "core/units/camera")
	end

	local camera = Unit.camera(var_6_3, "camera")

	Camera.set_data(camera, "unit", var_6_3)
	Viewport.set_data(create_viewport, "camera", camera)

	if not arg_6_6 then
		local camera_2 = Unit.camera(var_6_3, "shadow_cull_camera")

		Camera.set_data(camera_2, "unit", var_6_3)
		Viewport.set_data(create_viewport, "shadow_cull_camera", camera_2)
	end

	ScriptWorld._update_render_queue(arg_6_0)

	return create_viewport
end

ScriptWorld.render = function (arg_7_0)
	-- function 7
	local get_data = World.get_data(arg_7_0, "shading_environment")

	if not get_data then
		return
	end

	local get_data_2 = World.get_data(arg_7_0, "global_free_flight_viewport")

	if not get_data_2 then
		ShadingEnvironment.blend(get_data, World.get_data(arg_7_0, "shading_settings"))
		ShadingEnvironment.apply(get_data)

		if not (not World.has_data(arg_7_0, "shading_callback") and Viewport.get_data(get_data_2, "avoid_shading_callback")) then
			World.get_data(arg_7_0, "shading_callback")(arg_7_0, get_data, World.get_data(arg_7_0, "render_queue")[1])
		end

		local camera = ScriptViewport.camera(get_data_2)

		Application.render_world(arg_7_0, camera, get_data_2, get_data)
	else
		local get_data_3 = World.get_data(arg_7_0, "render_queue")

		if not table.is_empty(get_data_3) then
			Application.update_render_world(arg_7_0)

			return
		end

		for i, v in ipairs(get_data_3) do
			if not World.get_data(arg_7_0, "avoid_blend") then
				ShadingEnvironment.blend(get_data, World.get_data(arg_7_0, "shading_settings"), World.get_data(arg_7_0, "override_shading_settings"))
			end

			if not (not World.has_data(arg_7_0, "shading_callback") and Viewport.get_data(v, "avoid_shading_callback")) then
				World.get_data(arg_7_0, "shading_callback")(arg_7_0, get_data, v)
			end

			if not World.get_data(arg_7_0, "avoid_blend") then
				ShadingEnvironment.apply(get_data)
			end

			local camera_2 = ScriptViewport.camera(v)

			Application.render_world(arg_7_0, camera_2, v, get_data)
		end
	end
end

ScriptWorld.create_global_free_flight_viewport = function (arg_8_0, arg_8_1)
	-- function 8
	fassert(not World.has_data(arg_8_0, "global_free_flight_viewport"), "Trying to spawn global freeflight viewport when one already exists.")

	local get_data = World.get_data(arg_8_0, "viewports")

	if not table.is_empty(get_data) then
		return nil
	end

	local huge = math.huge
	local var_8_2

	for k, v in pairs(get_data) do
		local get_data_2 = Viewport.get_data(v, "layer")

		if get_data_2 < huge then
			huge, var_8_2 = get_data_2, v
		end
	end

	local create_viewport = Application.create_viewport(arg_8_0, arg_8_1)

	Viewport.set_data(create_viewport, "layer", Viewport.get_data(var_8_2, "layer"))
	World.set_data(arg_8_0, "global_free_flight_viewport", create_viewport)

	local spawn_unit = World.spawn_unit(arg_8_0, "core/units/camera")
	local camera = Unit.camera(spawn_unit, "camera")

	Camera.set_data(camera, "unit", spawn_unit)

	local camera_2 = ScriptViewport.camera(var_8_2)
	local local_pose = Camera.local_pose(camera_2)

	ScriptCamera.set_local_pose(camera, local_pose)

	local vertical_fov = Camera.vertical_fov(camera_2)

	Camera.set_vertical_fov(camera, vertical_fov)
	Viewport.set_data(create_viewport, "camera", camera)

	return create_viewport
end

ScriptWorld.destroy_global_free_flight_viewport = function (arg_9_0)
	-- function 9
	local get_data = World.get_data(arg_9_0, "global_free_flight_viewport")

	fassert(get_data, "Trying to destroy global free flight viewport when none exists.")

	local get_data_2 = Viewport.get_data(get_data, "camera")
	local get_data_3 = Camera.get_data(get_data_2, "unit")

	World.destroy_unit(arg_9_0, get_data_3)
	Application.destroy_viewport(arg_9_0, get_data)
	World.set_data(arg_9_0, "global_free_flight_viewport", nil)
end

ScriptWorld.global_free_flight_viewport = function (arg_10_0)
	-- function 10
	return World.get_data(arg_10_0, "global_free_flight_viewport")
end

ScriptWorld.create_free_flight_viewport = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	local viewport = ScriptWorld.viewport(arg_11_0, arg_11_1)
	local create_viewport = Application.create_viewport(arg_11_0, arg_11_2)

	Viewport.set_data(create_viewport, "layer", Viewport.get_data(viewport, "layer"))

	local get_data = World.get_data(arg_11_0, "free_flight_viewports")

	fassert(get_data[arg_11_1] == nil, "Free flight viewport %q already exists", arg_11_1)

	get_data[arg_11_1] = create_viewport

	local spawn_unit = World.spawn_unit(arg_11_0, "core/units/camera")
	local camera = Unit.camera(spawn_unit, "camera")

	Camera.set_data(camera, "unit", spawn_unit)

	local camera_2 = ScriptViewport.camera(viewport)
	local local_pose = Camera.local_pose(camera_2)

	ScriptCamera.set_local_pose(camera, local_pose)
	Viewport.set_data(create_viewport, "camera", camera)
	Viewport.set_data(create_viewport, "overridden_viewport", viewport)
	ScriptWorld._update_render_queue(arg_11_0)

	return create_viewport
end

ScriptWorld.destroy_free_flight_viewport = function (arg_12_0, arg_12_1)
	-- function 12
	local get_data = World.get_data(arg_12_0, "free_flight_viewports")

	fassert(get_data[arg_12_1], "Viewport %q doesn't exist", arg_12_1)

	local var_12_1 = get_data[arg_12_1]

	get_data[arg_12_1] = nil

	local get_data_2 = Viewport.get_data(var_12_1, "camera")
	local get_data_3 = Camera.get_data(get_data_2, "unit")

	World.destroy_unit(arg_12_0, get_data_3)
	Application.destroy_viewport(arg_12_0, var_12_1)
	ScriptWorld._update_render_queue(arg_12_0)
end

ScriptWorld.destroy_viewport = function (arg_13_0, arg_13_1)
	-- function 13
	local get_data = World.get_data(arg_13_0, "viewports")

	fassert(get_data[arg_13_1], "Viewport %q doesn't exist", arg_13_1)

	local var_13_1 = get_data[arg_13_1]

	get_data[arg_13_1] = nil

	local get_data_2 = Viewport.get_data(var_13_1, "camera")
	local get_data_3 = Camera.get_data(get_data_2, "unit")

	World.destroy_unit(arg_13_0, get_data_3)
	Application.destroy_viewport(arg_13_0, var_13_1)
	ScriptWorld._update_render_queue(arg_13_0)
end

ScriptWorld.activate_viewport = function (arg_14_0, arg_14_1)
	-- function 14
	Viewport.set_data(arg_14_1, "active", true)
	ScriptWorld._update_render_queue(arg_14_0)
end

ScriptWorld.deactivate_viewport = function (arg_15_0, arg_15_1)
	-- function 15
	Viewport.set_data(arg_15_1, "active", false)
	ScriptWorld._update_render_queue(arg_15_0)
end

ScriptWorld.has_viewport = function (arg_16_0, arg_16_1)
	-- function 16
	local flag

	flag = not World.get_data(arg_16_0, "viewports")[arg_16_1] and true and false

	return flag
end

ScriptWorld.viewport = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	local var_17_0

	if not arg_17_2 then
		var_17_0 = World.get_data(arg_17_0, "free_flight_viewports")[arg_17_1] or World.get_data(arg_17_0, "viewports")[arg_17_1]
	else
		var_17_0 = World.get_data(arg_17_0, "viewports")[arg_17_1]
	end

	fassert(var_17_0, "Viewport %q doesn't exist", arg_17_1)

	return var_17_0
end

ScriptWorld.free_flight_viewport = function (arg_18_0, arg_18_1)
	-- function 18
	local get_data = World.get_data(arg_18_0, "free_flight_viewports")

	fassert(get_data[arg_18_1], "Free flight viewport %q doesn't exists", arg_18_1)

	return get_data[arg_18_1]
end

ScriptWorld._run_safe_animation_callbacks = function ()
	-- function 19
	local entity = Managers.state.entity

	if not entity then
		return
	end

	local system = entity:system("animation_system")

	if not system then
		system:run_safe_animation_callbacks()
	end
end

ScriptWorld.update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	if not World.get_data(arg_20_0, "active") then
		if not World.get_data(arg_20_0, "paused") then
			arg_20_1 = 0
		end

		if not arg_20_3 then
			World.update_animations_with_callback(arg_20_0, arg_20_1, arg_20_3)
		else
			World.update_animations(arg_20_0, arg_20_1)
		end

		ScriptWorld._run_safe_animation_callbacks()

		if not arg_20_4 then
			World.update_scene_with_callback(arg_20_0, arg_20_1, arg_20_4)
		else
			World.update_scene(arg_20_0, arg_20_1)
		end

		if not arg_20_5 then
			arg_20_5(arg_20_0, arg_20_1, arg_20_2)
		end
	else
		World.update_timer(arg_20_0, arg_20_1)
	end
end

ScriptWorld._update_render_queue = function (arg_21_0)
	-- function 21
	local tbl = {}
	local get_data = World.get_data(arg_21_0, "viewports")
	local get_data_2 = World.get_data(arg_21_0, "free_flight_viewports")

	for k, v in pairs(get_data) do
		if not ScriptViewport.active(v) then
			local num = #tbl + 1
			local var_21_4 = get_data_2[k]

			var_21_4 = var_21_4 or v
			tbl[num] = var_21_4
		end
	end

	local function fn(arg_22_0, arg_22_1)
		-- function 22
		return Viewport.get_data(arg_22_0, "layer") < Viewport.get_data(arg_22_1, "layer")
	end

	table.sort(tbl, fn)
	World.set_data(arg_21_0, "render_queue", tbl)
end

ScriptWorld.create_shading_environment = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	local create_shading_environment = World.create_shading_environment(arg_23_0, arg_23_1)

	World.set_data(arg_23_0, "shading_environment", create_shading_environment)
	World.set_data(arg_23_0, "shading_callback", arg_23_2)
	World.set_data(arg_23_0, "shading_settings", {
		arg_23_3,
		1
	})

	return create_shading_environment
end

ScriptWorld.spawn_level = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6, arg_24_7)
	-- function 24
	local get_data = World.get_data(arg_24_0, "levels")

	fassert(get_data[arg_24_1] == nil, "Level %q already loaded", arg_24_1)

	local flag = true
	local var_24_2

	if not arg_24_7 then
		var_24_2 = World.spawn_level_time_sliced(arg_24_0, arg_24_1, arg_24_3 or Vector3.zero(), arg_24_4 or Quaternion.identity(), Vector3(1, 1, 1), arg_24_2 or {})
	else
		var_24_2 = World.spawn_level(arg_24_0, arg_24_1, arg_24_3 or Vector3.zero(), arg_24_4 or Quaternion.identity(), Vector3(1, 1, 1), arg_24_2 or {})
	end

	local nested_levels = Level.nested_levels(var_24_2)
	local var_24_4 = nested_levels[1]

	var_24_4 = var_24_4 or var_24_2
	get_data[arg_24_1] = {
		level = var_24_2,
		nested_levels = nested_levels,
		spawning = arg_24_7
	}

	local get_data_2 = Level.get_data(var_24_2, "shading_environment")

	if get_data_2:len() > 0 then
		local get_data_3 = World.get_data(arg_24_0, "shading_environment")

		if not get_data_3 then
			World.set_shading_environment(arg_24_0, get_data_3, get_data_2)

			if not arg_24_5 then
				World.set_data(arg_24_0, "shading_callback", arg_24_5)
			end

			if not arg_24_6 then
				World.set_data(arg_24_0, "shading_settings", {
					arg_24_6,
					1
				})
			end
		else
			local create_shading_environment = ScriptWorld.create_shading_environment(arg_24_0, get_data_2, arg_24_5, arg_24_6 or "default")
		end
	end

	return var_24_4, var_24_2
end

ScriptWorld.level = function (arg_25_0, arg_25_1)
	-- function 25
	local var_25_0 = World.get_data(arg_25_0, "levels")[arg_25_1]

	fassert(var_25_0, "Level %q doesn't exist", arg_25_1)

	local var_25_1 = var_25_0.nested_levels[1]

	var_25_1 = var_25_1 or var_25_0.level

	return var_25_1
end

ScriptWorld.nested_levels = function (arg_26_0, arg_26_1)
	-- function 26
	local var_26_0 = World.get_data(arg_26_0, "levels")[arg_26_1]

	fassert(var_26_0, "Level %q doesn't exist", arg_26_1)

	return var_26_0.nested_levels
end

ScriptWorld.destroy_level = function (arg_27_0, arg_27_1)
	-- function 27
	local get_data = World.get_data(arg_27_0, "levels")
	local var_27_1 = get_data[arg_27_1]

	fassert(var_27_1, "Level %q doesn't exist", arg_27_1)

	local level = var_27_1.level

	ScriptWorld.destroy_sublevels(arg_27_0, level)
	World.destroy_level(arg_27_0, level)

	get_data[arg_27_1] = nil
end

ScriptWorld.destroy_level_from_reference = function (arg_28_0, arg_28_1)
	-- function 28
	local get_data = World.get_data(arg_28_0, "levels")

	for k, v in pairs(get_data) do
		local level = v.level
		local nested_levels = v.nested_levels

		if level == arg_28_1 or not table.contains(nested_levels, arg_28_1) then
			ScriptWorld.destroy_sublevels(arg_28_0, level)
			World.destroy_level(arg_28_0, level)

			get_data[k] = nil

			return
		end
	end

	fassert(false, "Level doesn't exist")
end

ScriptWorld.destroy_sublevels = function (arg_29_0, arg_29_1)
	-- function 29
	local get_data = World.get_data(arg_29_0, "levels")
	local get_data_2 = Level.get_data(arg_29_1, "sub_levels")

	if not get_data_2 then
		for k, v in pairs(get_data_2) do
			World.destroy_level(arg_29_0, v)

			get_data[k] = nil
		end
	end
end

ScriptWorld.optimize_level_units = function (arg_30_0, arg_30_1)
	-- function 30
	local var_30_0 = World.get_data(arg_30_0, "levels")[arg_30_1]
	local level = var_30_0.level
	local nested_levels = var_30_0.nested_levels

	for i = 1, #nested_levels do
		local var_30_3 = nested_levels[i]
		local units = Level.units(var_30_3)

		for i_2, v in ipairs(units) do
			ScriptUnit.optimize(v)
		end
	end

	local units_2 = Level.units(level)

	for i_3, v_2 in ipairs(units_2) do
		ScriptUnit.optimize(v_2)
	end
end

ScriptWorld.trigger_level_loaded = function (arg_31_0, arg_31_1)
	-- function 31
	local var_31_0 = World.get_data(arg_31_0, "levels")[arg_31_1]
	local level = var_31_0.level
	local nested_levels = var_31_0.nested_levels

	for i = 1, #nested_levels do
		local var_31_3 = nested_levels[i]

		Level.trigger_level_loaded(var_31_3)
	end

	Level.trigger_level_loaded(level)

	local get_data = Level.get_data(level, "sub_levels")

	if not get_data then
		for k, v in pairs(get_data) do
			Level.trigger_level_loaded(v)
		end
	end
end

ScriptWorld.trigger_level_shutdown = function (arg_32_0)
	-- function 32
	local get_data = Level.get_data(arg_32_0, "sub_levels")

	if not get_data then
		for k, v in pairs(get_data) do
			Level.trigger_level_shutdown(v)
		end
	end

	Level.trigger_level_shutdown(arg_32_0)
end

ScriptWorld.create_particles_linked = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5)
	-- function 33
	local create_particles = World.create_particles(arg_33_0, arg_33_1, Vector3(0, 0, 0))

	arg_33_5 = arg_33_5 or Matrix4x4.identity()

	World.link_particles(arg_33_0, create_particles, arg_33_2, arg_33_3, arg_33_5, arg_33_4)

	return create_particles
end

ScriptWorld.set_material_variable_for_particles = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	-- function 34
	if type(arg_34_4) == "number" then
		World.set_particles_material_scalar(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	elseif type(arg_34_4) == "table" then
		local count = #arg_34_4

		if count == 2 then
			World.set_particles_material_vector2(arg_34_0, arg_34_1, arg_34_2, arg_34_3, Vector2(arg_34_4[1], arg_34_4[2]))
		elseif count == 3 then
			World.set_particles_material_vector3(arg_34_0, arg_34_1, arg_34_2, arg_34_3, Vector3(arg_34_4[1], arg_34_4[2], arg_34_4[3]))
		elseif count == 4 then
			World.set_particles_material_vector3(arg_34_0, arg_34_1, arg_34_2, arg_34_3, Color(arg_34_4[1], arg_34_4[2], arg_34_4[3], arg_34_4[4]))
		end
	end
end
