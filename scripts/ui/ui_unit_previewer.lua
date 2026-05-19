-- chunkname: @scripts/ui/ui_unit_previewer.lua

local var_0_0 = 0

UIUnitPreviewer = class(UIUnitPreviewer)

function UIUnitPreviewer.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	arg_1_0._background_world = arg_1_4
	arg_1_0._background_viewport = arg_1_5
	arg_1_0._unique_id = arg_1_6
	arg_1_0._loaded_packages = {}
	arg_1_0._packages_to_load = {}
	arg_1_0._camera_xy_angle_target = var_0_0
	arg_1_0._camera_xy_angle_current = var_0_0
	arg_1_0._spawn_position = arg_1_3
	arg_1_0._unit_to_spawn = arg_1_1
	arg_1_0._package_name = arg_1_2

	arg_1_0:_load_package(arg_1_2)
end

function UIUnitPreviewer.register_spawn_callback(arg_2_0, arg_2_1)
	arg_2_0._spawn_callback = arg_2_1
end

function UIUnitPreviewer.activate_auto_spin(arg_3_0)
	arg_3_0._auto_spin_random_seed = math.random(5, 30000)
end

function UIUnitPreviewer.destroy(arg_4_0)
	arg_4_0:_destroy_unit()
	arg_4_0:_unload_package()
	table.clear(arg_4_0._loaded_packages)
	table.clear(arg_4_0._packages_to_load)

	arg_4_0._background_viewport = nil
	arg_4_0._background_world = nil
end

function UIUnitPreviewer._destroy_unit(arg_5_0)
	local var_5_0 = arg_5_0._background_world
	local var_5_1 = arg_5_0._spawned_unit

	if var_5_1 then
		World.destroy_unit(var_5_0, var_5_1)

		arg_5_0._spawned_unit = nil
	end
end

function UIUnitPreviewer.update(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_0._unit_spawned then
		if arg_6_3 then
			local var_6_0 = Managers.input

			if var_6_0:is_device_active("mouse") then
				arg_6_0:_handle_mouse_input(arg_6_3, arg_6_1)
			elseif var_6_0:is_device_active("gamepad") then
				arg_6_0:_handle_controller_input(arg_6_3, arg_6_1)
			end
		end

		if arg_6_0._camera_xy_angle_target > math.pi * 2 then
			arg_6_0._camera_xy_angle_current = arg_6_0._camera_xy_angle_current - math.pi * 2
			arg_6_0._camera_xy_angle_target = arg_6_0._camera_xy_angle_target - math.pi * 2
		end

		local var_6_1 = math.lerp(arg_6_0._camera_xy_angle_current, arg_6_0._camera_xy_angle_target, 0.1)

		arg_6_0._camera_xy_angle_current = var_6_1

		local var_6_2, var_6_3 = arg_6_0:_auto_spin_values(arg_6_1, arg_6_2)
		local var_6_4 = Quaternion.axis_angle(Vector3(0, var_6_2, 1), -(var_6_1 + var_6_3))
		local var_6_5 = arg_6_0._spawned_unit

		Unit.set_local_rotation(var_6_5, 0, var_6_4)

		if arg_6_0._zoom_dirty then
			local var_6_6 = arg_6_0._zoom_fraction or 0
			local var_6_7 = arg_6_0._unit_start_position_boxed:unbox()

			var_6_7[1] = var_6_7[1] * (1 - var_6_6)
			var_6_7[2] = var_6_7[2] * (1 - var_6_6)

			Unit.set_local_position(var_6_5, 0, var_6_7)

			arg_6_0._zoom_dirty = nil
		end
	end
end

function UIUnitPreviewer.set_zoom_fraction(arg_7_0, arg_7_1)
	arg_7_0._zoom_fraction = math.clamp(arg_7_1, 0, 1)
	arg_7_0._zoom_dirty = true
end

function UIUnitPreviewer.set_zoom_fraction_unclamped(arg_8_0, arg_8_1)
	arg_8_0._zoom_fraction = arg_8_1
	arg_8_0._zoom_dirty = true
end

function UIUnitPreviewer.zoom_fraction(arg_9_0)
	return arg_9_0._zoom_fraction or 0
end

function UIUnitPreviewer._auto_spin_values(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._auto_spin_random_seed

	if not var_10_0 then
		return 0, 0
	end

	local var_10_1 = 0.2
	local var_10_2 = 0.3
	local var_10_3 = math.sin((var_10_0 + arg_10_2) * var_10_1) * var_10_2
	local var_10_4 = -(var_10_3 * 0.5)
	local var_10_5 = -(var_10_3 * math.pi / 2)

	return var_10_4, var_10_5
end

local var_0_1 = {}

function UIUnitPreviewer._handle_mouse_input(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_1:get("cursor")

	if not var_11_0 then
		return
	end

	if arg_11_1:get("left_press") then
		arg_11_0._is_moving_camera = true
		arg_11_0._last_mouse_position = nil
	elseif arg_11_1:get("right_press") then
		arg_11_0._camera_xy_angle_target = var_0_0
	end

	local var_11_1 = arg_11_0._is_moving_camera
	local var_11_2 = arg_11_1:get("left_hold")

	if var_11_1 and var_11_2 then
		if arg_11_0._last_mouse_position then
			arg_11_0._camera_xy_angle_target = arg_11_0._camera_xy_angle_target - (var_11_0.x - arg_11_0._last_mouse_position[1]) * 0.01
		end

		var_0_1[1] = var_11_0.x
		var_0_1[2] = var_11_0.y
		arg_11_0._last_mouse_position = var_0_1
	elseif var_11_1 then
		arg_11_0._is_moving_camera = false
	end
end

function UIUnitPreviewer._handle_controller_input(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_1:get("gamepad_right_axis")

	if var_12_0 and Vector3.length(var_12_0) > 0.01 then
		arg_12_0._camera_xy_angle_target = arg_12_0._camera_xy_angle_target + -var_12_0.x * arg_12_2 * 5
	end
end

function UIUnitPreviewer.post_update(arg_13_0, arg_13_1, arg_13_2)
	if arg_13_0._spawn_callback and arg_13_0._unit_spawned then
		arg_13_0._spawn_callback()

		arg_13_0._spawn_callback = nil
	end
end

function UIUnitPreviewer._trigger_unit_flow_event(arg_14_0, arg_14_1, arg_14_2)
	if arg_14_1 and Unit.alive(arg_14_1) then
		Unit.flow_event(arg_14_1, arg_14_2)
	end
end

function UIUnitPreviewer._get_world(arg_15_0)
	return arg_15_0._background_world, arg_15_0._background_viewport
end

function UIUnitPreviewer._get_camera_position(arg_16_0)
	local var_16_0 = arg_16_0._background_viewport
	local var_16_1 = ScriptViewport.camera(var_16_0)

	return ScriptCamera.position(var_16_1)
end

function UIUnitPreviewer._get_camera_rotation(arg_17_0)
	local var_17_0 = arg_17_0._background_viewport
	local var_17_1 = ScriptViewport.camera(var_17_0)

	return ScriptCamera.rotation(var_17_1)
end

function UIUnitPreviewer._packages_loaded(arg_18_0)
	local var_18_0 = arg_18_0.units_to_spawn
	local var_18_1 = arg_18_0._loaded_packages

	for iter_18_0, iter_18_1 in ipairs(var_18_0) do
		for iter_18_2, iter_18_3 in ipairs(iter_18_1) do
			if not var_18_1[iter_18_3.unit_name] then
				return false
			end
		end
	end

	return true
end

function UIUnitPreviewer._load_package(arg_19_0, arg_19_1)
	local var_19_0 = Managers.package
	local var_19_1 = callback(arg_19_0, "_on_load_complete", arg_19_1)
	local var_19_2 = "UIUnitPreviewer"

	if arg_19_0._unique_id then
		var_19_2 = var_19_2 .. tostring(arg_19_0._unique_id)
	end

	var_19_0:load(arg_19_1, var_19_2, var_19_1, true)
end

function UIUnitPreviewer._on_load_complete(arg_20_0, arg_20_1)
	arg_20_0._package_loaded = true

	if arg_20_0._unit_to_spawn and arg_20_0._background_viewport then
		arg_20_0._spawned_unit = arg_20_0:_spawn_unit(arg_20_0._unit_to_spawn, true)
		arg_20_0._unit_to_spawn = nil
		arg_20_0._unit_spawned = true
	end
end

function UIUnitPreviewer._unload_package(arg_21_0)
	local var_21_0 = arg_21_0._package_name
	local var_21_1 = "UIUnitPreviewer"

	if arg_21_0._unique_id then
		var_21_1 = var_21_1 .. tostring(arg_21_0._unique_id)
	end

	Managers.package:unload(var_21_0, var_21_1)
end

function UIUnitPreviewer._spawn_unit(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0:_get_camera_rotation()
	local var_22_1 = Quaternion.forward(var_22_0)
	local var_22_2 = Quaternion.look(var_22_1, Vector3.up())
	local var_22_3 = Quaternion.axis_angle(Vector3.up(), 0)
	local var_22_4 = Quaternion.multiply(var_22_2, var_22_3)
	local var_22_5 = arg_22_0._spawn_position
	local var_22_6 = arg_22_0:_get_camera_position() + var_22_1 + Vector3(var_22_5[1], var_22_5[2], var_22_5[3])
	local var_22_7 = arg_22_0._background_world
	local var_22_8 = World.spawn_unit(var_22_7, arg_22_1, var_22_6, var_22_4)

	Unit.set_unit_visibility(var_22_8, arg_22_2)

	local var_22_9 = Unit.world_position(var_22_8, 0)

	arg_22_0._unit_start_position_boxed = Vector3Box(var_22_9)

	return var_22_8
end
