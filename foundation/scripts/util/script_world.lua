-- chunkname: @foundation/scripts/util/script_world.lua

ScriptWorld = ScriptWorld or {}

function ScriptWorld.name(arg_1_0)
	return World.get_data(arg_1_0, "name")
end

function ScriptWorld.activate(arg_2_0)
	World.set_data(arg_2_0, "active", true)
end

function ScriptWorld.deactivate(arg_3_0)
	World.set_data(arg_3_0, "active", false)
end

function ScriptWorld.pause(arg_4_0)
	World.set_data(arg_4_0, "paused", true)
end

function ScriptWorld.unpause(arg_5_0)
	World.set_data(arg_5_0, "paused", false)
end

function ScriptWorld.create_viewport(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7)
	local var_6_0 = World.get_data(arg_6_0, "viewports")

	fassert(var_6_0[arg_6_1] == nil, "Viewport %q already exists", arg_6_1)

	local var_6_1 = Application.create_viewport(arg_6_0, arg_6_2)

	Viewport.set_data(var_6_1, "layer", arg_6_3 or 1)
	Viewport.set_data(var_6_1, "active", true)
	Viewport.set_data(var_6_1, "name", arg_6_1)

	var_6_0[arg_6_1] = var_6_1

	if arg_6_7 then
		Viewport.set_data(var_6_1, "no_scaling", true)
	end

	if Managers.splitscreen and Managers.splitscreen:active() and not arg_6_7 then
		Viewport.set_data(var_6_1, "rect", {
			SPLITSCREEN_OFFSET_X,
			SPLITSCREEN_OFFSET_Y,
			SPLITSCREEN_WIDTH,
			SPLITSCREEN_HEIGHT
		})
	else
		Viewport.set_data(var_6_1, "rect", {
			0,
			0,
			1,
			1
		})
	end

	Viewport.set_rect(var_6_1, unpack(Viewport.get_data(var_6_1, "rect")))

	local var_6_2

	if arg_6_4 and arg_6_5 then
		var_6_2 = World.spawn_unit(arg_6_0, "core/units/camera", arg_6_4, arg_6_5)
	elseif arg_6_4 then
		var_6_2 = World.spawn_unit(arg_6_0, "core/units/camera", arg_6_4)
	else
		var_6_2 = World.spawn_unit(arg_6_0, "core/units/camera")
	end

	local var_6_3 = Unit.camera(var_6_2, "camera")

	Camera.set_data(var_6_3, "unit", var_6_2)
	Viewport.set_data(var_6_1, "camera", var_6_3)

	if arg_6_6 then
		local var_6_4 = Unit.camera(var_6_2, "shadow_cull_camera")

		Camera.set_data(var_6_4, "unit", var_6_2)
		Viewport.set_data(var_6_1, "shadow_cull_camera", var_6_4)
	end

	ScriptWorld._update_render_queue(arg_6_0)

	return var_6_1
end

function ScriptWorld.render(arg_7_0)
	local var_7_0 = World.get_data(arg_7_0, "shading_environment")

	if not var_7_0 then
		return
	end

	local var_7_1 = World.get_data(arg_7_0, "global_free_flight_viewport")

	if var_7_1 then
		ShadingEnvironment.blend(var_7_0, World.get_data(arg_7_0, "shading_settings"))
		ShadingEnvironment.apply(var_7_0)

		if World.has_data(arg_7_0, "shading_callback") and not Viewport.get_data(var_7_1, "avoid_shading_callback") then
			World.get_data(arg_7_0, "shading_callback")(arg_7_0, var_7_0, World.get_data(arg_7_0, "render_queue")[1])
		end

		local var_7_2 = ScriptViewport.camera(var_7_1)

		Application.render_world(arg_7_0, var_7_2, var_7_1, var_7_0)
	else
		local var_7_3 = World.get_data(arg_7_0, "render_queue")

		if table.is_empty(var_7_3) then
			Application.update_render_world(arg_7_0)

			return
		end

		for iter_7_0, iter_7_1 in ipairs(var_7_3) do
			if not World.get_data(arg_7_0, "avoid_blend") then
				ShadingEnvironment.blend(var_7_0, World.get_data(arg_7_0, "shading_settings"), World.get_data(arg_7_0, "override_shading_settings"))
			end

			if World.has_data(arg_7_0, "shading_callback") and not Viewport.get_data(iter_7_1, "avoid_shading_callback") then
				World.get_data(arg_7_0, "shading_callback")(arg_7_0, var_7_0, iter_7_1)
			end

			if not World.get_data(arg_7_0, "avoid_blend") then
				ShadingEnvironment.apply(var_7_0)
			end

			local var_7_4 = ScriptViewport.camera(iter_7_1)

			Application.render_world(arg_7_0, var_7_4, iter_7_1, var_7_0)
		end
	end
end

function ScriptWorld.create_global_free_flight_viewport(arg_8_0, arg_8_1)
	fassert(not World.has_data(arg_8_0, "global_free_flight_viewport"), "Trying to spawn global freeflight viewport when one already exists.")

	local var_8_0 = World.get_data(arg_8_0, "viewports")

	if table.is_empty(var_8_0) then
		return nil
	end

	local var_8_1 = math.huge
	local var_8_2

	for iter_8_0, iter_8_1 in pairs(var_8_0) do
		local var_8_3 = Viewport.get_data(iter_8_1, "layer")

		if var_8_3 < var_8_1 then
			var_8_1, var_8_2 = var_8_3, iter_8_1
		end
	end

	local var_8_4 = Application.create_viewport(arg_8_0, arg_8_1)

	Viewport.set_data(var_8_4, "layer", Viewport.get_data(var_8_2, "layer"))
	World.set_data(arg_8_0, "global_free_flight_viewport", var_8_4)

	local var_8_5 = World.spawn_unit(arg_8_0, "core/units/camera")
	local var_8_6 = Unit.camera(var_8_5, "camera")

	Camera.set_data(var_8_6, "unit", var_8_5)

	local var_8_7 = ScriptViewport.camera(var_8_2)
	local var_8_8 = Camera.local_pose(var_8_7)

	ScriptCamera.set_local_pose(var_8_6, var_8_8)

	local var_8_9 = Camera.vertical_fov(var_8_7)

	Camera.set_vertical_fov(var_8_6, var_8_9)
	Viewport.set_data(var_8_4, "camera", var_8_6)

	return var_8_4
end

function ScriptWorld.destroy_global_free_flight_viewport(arg_9_0)
	local var_9_0 = World.get_data(arg_9_0, "global_free_flight_viewport")

	fassert(var_9_0, "Trying to destroy global free flight viewport when none exists.")

	local var_9_1 = Viewport.get_data(var_9_0, "camera")
	local var_9_2 = Camera.get_data(var_9_1, "unit")

	World.destroy_unit(arg_9_0, var_9_2)
	Application.destroy_viewport(arg_9_0, var_9_0)
	World.set_data(arg_9_0, "global_free_flight_viewport", nil)
end

function ScriptWorld.global_free_flight_viewport(arg_10_0)
	return World.get_data(arg_10_0, "global_free_flight_viewport")
end

function ScriptWorld.create_free_flight_viewport(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = ScriptWorld.viewport(arg_11_0, arg_11_1)
	local var_11_1 = Application.create_viewport(arg_11_0, arg_11_2)

	Viewport.set_data(var_11_1, "layer", Viewport.get_data(var_11_0, "layer"))

	local var_11_2 = World.get_data(arg_11_0, "free_flight_viewports")

	fassert(var_11_2[arg_11_1] == nil, "Free flight viewport %q already exists", arg_11_1)

	var_11_2[arg_11_1] = var_11_1

	local var_11_3 = World.spawn_unit(arg_11_0, "core/units/camera")
	local var_11_4 = Unit.camera(var_11_3, "camera")

	Camera.set_data(var_11_4, "unit", var_11_3)

	local var_11_5 = ScriptViewport.camera(var_11_0)
	local var_11_6 = Camera.local_pose(var_11_5)

	ScriptCamera.set_local_pose(var_11_4, var_11_6)
	Viewport.set_data(var_11_1, "camera", var_11_4)
	Viewport.set_data(var_11_1, "overridden_viewport", var_11_0)
	ScriptWorld._update_render_queue(arg_11_0)

	return var_11_1
end

function ScriptWorld.destroy_free_flight_viewport(arg_12_0, arg_12_1)
	local var_12_0 = World.get_data(arg_12_0, "free_flight_viewports")

	fassert(var_12_0[arg_12_1], "Viewport %q doesn't exist", arg_12_1)

	local var_12_1 = var_12_0[arg_12_1]

	var_12_0[arg_12_1] = nil

	local var_12_2 = Viewport.get_data(var_12_1, "camera")
	local var_12_3 = Camera.get_data(var_12_2, "unit")

	World.destroy_unit(arg_12_0, var_12_3)
	Application.destroy_viewport(arg_12_0, var_12_1)
	ScriptWorld._update_render_queue(arg_12_0)
end

function ScriptWorld.destroy_viewport(arg_13_0, arg_13_1)
	local var_13_0 = World.get_data(arg_13_0, "viewports")

	fassert(var_13_0[arg_13_1], "Viewport %q doesn't exist", arg_13_1)

	local var_13_1 = var_13_0[arg_13_1]

	var_13_0[arg_13_1] = nil

	local var_13_2 = Viewport.get_data(var_13_1, "camera")
	local var_13_3 = Camera.get_data(var_13_2, "unit")

	World.destroy_unit(arg_13_0, var_13_3)
	Application.destroy_viewport(arg_13_0, var_13_1)
	ScriptWorld._update_render_queue(arg_13_0)
end

function ScriptWorld.activate_viewport(arg_14_0, arg_14_1)
	Viewport.set_data(arg_14_1, "active", true)
	ScriptWorld._update_render_queue(arg_14_0)
end

function ScriptWorld.deactivate_viewport(arg_15_0, arg_15_1)
	Viewport.set_data(arg_15_1, "active", false)
	ScriptWorld._update_render_queue(arg_15_0)
end

function ScriptWorld.has_viewport(arg_16_0, arg_16_1)
	return World.get_data(arg_16_0, "viewports")[arg_16_1] and true or false
end

function ScriptWorld.viewport(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0

	if arg_17_2 then
		var_17_0 = World.get_data(arg_17_0, "free_flight_viewports")[arg_17_1] or World.get_data(arg_17_0, "viewports")[arg_17_1]
	else
		var_17_0 = World.get_data(arg_17_0, "viewports")[arg_17_1]
	end

	fassert(var_17_0, "Viewport %q doesn't exist", arg_17_1)

	return var_17_0
end

function ScriptWorld.free_flight_viewport(arg_18_0, arg_18_1)
	local var_18_0 = World.get_data(arg_18_0, "free_flight_viewports")

	fassert(var_18_0[arg_18_1], "Free flight viewport %q doesn't exists", arg_18_1)

	return var_18_0[arg_18_1]
end

function ScriptWorld._run_safe_animation_callbacks()
	local var_19_0 = Managers.state.entity

	if not var_19_0 then
		return
	end

	local var_19_1 = var_19_0:system("animation_system")

	if var_19_1 then
		var_19_1:run_safe_animation_callbacks()
	end
end

function ScriptWorld.update(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	if World.get_data(arg_20_0, "active") then
		if World.get_data(arg_20_0, "paused") then
			arg_20_1 = 0
		end

		if arg_20_3 then
			World.update_animations_with_callback(arg_20_0, arg_20_1, arg_20_3)
		else
			World.update_animations(arg_20_0, arg_20_1)
		end

		ScriptWorld._run_safe_animation_callbacks()

		if arg_20_4 then
			World.update_scene_with_callback(arg_20_0, arg_20_1, arg_20_4)
		else
			World.update_scene(arg_20_0, arg_20_1)
		end

		if arg_20_5 then
			arg_20_5(arg_20_0, arg_20_1, arg_20_2)
		end
	else
		World.update_timer(arg_20_0, arg_20_1)
	end
end

function ScriptWorld._update_render_queue(arg_21_0)
	local var_21_0 = {}
	local var_21_1 = World.get_data(arg_21_0, "viewports")
	local var_21_2 = World.get_data(arg_21_0, "free_flight_viewports")

	for iter_21_0, iter_21_1 in pairs(var_21_1) do
		if ScriptViewport.active(iter_21_1) then
			var_21_0[#var_21_0 + 1] = var_21_2[iter_21_0] or iter_21_1
		end
	end

	local function var_21_3(arg_22_0, arg_22_1)
		return Viewport.get_data(arg_22_0, "layer") < Viewport.get_data(arg_22_1, "layer")
	end

	table.sort(var_21_0, var_21_3)
	World.set_data(arg_21_0, "render_queue", var_21_0)
end

function ScriptWorld.create_shading_environment(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = World.create_shading_environment(arg_23_0, arg_23_1)

	World.set_data(arg_23_0, "shading_environment", var_23_0)
	World.set_data(arg_23_0, "shading_callback", arg_23_2)
	World.set_data(arg_23_0, "shading_settings", {
		arg_23_3,
		1
	})

	return var_23_0
end

function ScriptWorld.spawn_level(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6, arg_24_7)
	local var_24_0 = World.get_data(arg_24_0, "levels")

	fassert(var_24_0[arg_24_1] == nil, "Level %q already loaded", arg_24_1)

	local var_24_1 = true
	local var_24_2

	if arg_24_7 then
		var_24_2 = World.spawn_level_time_sliced(arg_24_0, arg_24_1, arg_24_3 or Vector3.zero(), arg_24_4 or Quaternion.identity(), Vector3(1, 1, 1), arg_24_2 or {})
	else
		var_24_2 = World.spawn_level(arg_24_0, arg_24_1, arg_24_3 or Vector3.zero(), arg_24_4 or Quaternion.identity(), Vector3(1, 1, 1), arg_24_2 or {})
	end

	local var_24_3 = Level.nested_levels(var_24_2)
	local var_24_4 = var_24_3[1] or var_24_2

	var_24_0[arg_24_1] = {
		level = var_24_2,
		nested_levels = var_24_3,
		spawning = arg_24_7
	}

	local var_24_5 = Level.get_data(var_24_2, "shading_environment")

	if var_24_5:len() > 0 then
		local var_24_6 = World.get_data(arg_24_0, "shading_environment")

		if var_24_6 then
			World.set_shading_environment(arg_24_0, var_24_6, var_24_5)

			if arg_24_5 then
				World.set_data(arg_24_0, "shading_callback", arg_24_5)
			end

			if arg_24_6 then
				World.set_data(arg_24_0, "shading_settings", {
					arg_24_6,
					1
				})
			end
		else
			local var_24_7 = ScriptWorld.create_shading_environment(arg_24_0, var_24_5, arg_24_5, arg_24_6 or "default")
		end
	end

	return var_24_4, var_24_2
end

function ScriptWorld.level(arg_25_0, arg_25_1)
	local var_25_0 = World.get_data(arg_25_0, "levels")[arg_25_1]

	fassert(var_25_0, "Level %q doesn't exist", arg_25_1)

	return var_25_0.nested_levels[1] or var_25_0.level
end

function ScriptWorld.nested_levels(arg_26_0, arg_26_1)
	local var_26_0 = World.get_data(arg_26_0, "levels")[arg_26_1]

	fassert(var_26_0, "Level %q doesn't exist", arg_26_1)

	return var_26_0.nested_levels
end

function ScriptWorld.destroy_level(arg_27_0, arg_27_1)
	local var_27_0 = World.get_data(arg_27_0, "levels")
	local var_27_1 = var_27_0[arg_27_1]

	fassert(var_27_1, "Level %q doesn't exist", arg_27_1)

	local var_27_2 = var_27_1.level

	ScriptWorld.destroy_sublevels(arg_27_0, var_27_2)
	World.destroy_level(arg_27_0, var_27_2)

	var_27_0[arg_27_1] = nil
end

function ScriptWorld.destroy_level_from_reference(arg_28_0, arg_28_1)
	local var_28_0 = World.get_data(arg_28_0, "levels")

	for iter_28_0, iter_28_1 in pairs(var_28_0) do
		local var_28_1 = iter_28_1.level
		local var_28_2 = iter_28_1.nested_levels

		if var_28_1 == arg_28_1 or table.contains(var_28_2, arg_28_1) then
			ScriptWorld.destroy_sublevels(arg_28_0, var_28_1)
			World.destroy_level(arg_28_0, var_28_1)

			var_28_0[iter_28_0] = nil

			return
		end
	end

	fassert(false, "Level doesn't exist")
end

function ScriptWorld.destroy_sublevels(arg_29_0, arg_29_1)
	local var_29_0 = World.get_data(arg_29_0, "levels")
	local var_29_1 = Level.get_data(arg_29_1, "sub_levels")

	if var_29_1 then
		for iter_29_0, iter_29_1 in pairs(var_29_1) do
			World.destroy_level(arg_29_0, iter_29_1)

			var_29_0[iter_29_0] = nil
		end
	end
end

function ScriptWorld.optimize_level_units(arg_30_0, arg_30_1)
	local var_30_0 = World.get_data(arg_30_0, "levels")[arg_30_1]
	local var_30_1 = var_30_0.level
	local var_30_2 = var_30_0.nested_levels

	for iter_30_0 = 1, #var_30_2 do
		local var_30_3 = var_30_2[iter_30_0]
		local var_30_4 = Level.units(var_30_3)

		for iter_30_1, iter_30_2 in ipairs(var_30_4) do
			ScriptUnit.optimize(iter_30_2)
		end
	end

	local var_30_5 = Level.units(var_30_1)

	for iter_30_3, iter_30_4 in ipairs(var_30_5) do
		ScriptUnit.optimize(iter_30_4)
	end
end

function ScriptWorld.trigger_level_loaded(arg_31_0, arg_31_1)
	local var_31_0 = World.get_data(arg_31_0, "levels")[arg_31_1]
	local var_31_1 = var_31_0.level
	local var_31_2 = var_31_0.nested_levels

	for iter_31_0 = 1, #var_31_2 do
		local var_31_3 = var_31_2[iter_31_0]

		Level.trigger_level_loaded(var_31_3)
	end

	Level.trigger_level_loaded(var_31_1)

	local var_31_4 = Level.get_data(var_31_1, "sub_levels")

	if var_31_4 then
		for iter_31_1, iter_31_2 in pairs(var_31_4) do
			Level.trigger_level_loaded(iter_31_2)
		end
	end
end

function ScriptWorld.trigger_level_shutdown(arg_32_0)
	local var_32_0 = Level.get_data(arg_32_0, "sub_levels")

	if var_32_0 then
		for iter_32_0, iter_32_1 in pairs(var_32_0) do
			Level.trigger_level_shutdown(iter_32_1)
		end
	end

	Level.trigger_level_shutdown(arg_32_0)
end

function ScriptWorld.create_particles_linked(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5)
	local var_33_0 = World.create_particles(arg_33_0, arg_33_1, Vector3(0, 0, 0))

	arg_33_5 = arg_33_5 or Matrix4x4.identity()

	World.link_particles(arg_33_0, var_33_0, arg_33_2, arg_33_3, arg_33_5, arg_33_4)

	return var_33_0
end

function ScriptWorld.set_material_variable_for_particles(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	if type(arg_34_4) == "number" then
		World.set_particles_material_scalar(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	elseif type(arg_34_4) == "table" then
		local var_34_0 = #arg_34_4

		if var_34_0 == 2 then
			World.set_particles_material_vector2(arg_34_0, arg_34_1, arg_34_2, arg_34_3, Vector2(arg_34_4[1], arg_34_4[2]))
		elseif var_34_0 == 3 then
			World.set_particles_material_vector3(arg_34_0, arg_34_1, arg_34_2, arg_34_3, Vector3(arg_34_4[1], arg_34_4[2], arg_34_4[3]))
		elseif var_34_0 == 4 then
			World.set_particles_material_vector3(arg_34_0, arg_34_1, arg_34_2, arg_34_3, Color(arg_34_4[1], arg_34_4[2], arg_34_4[3], arg_34_4[4]))
		end
	end
end
