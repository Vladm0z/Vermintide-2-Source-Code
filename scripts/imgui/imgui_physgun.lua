-- chunkname: @scripts/imgui/imgui_physgun.lua

local var_0_0 = stingray.Vector3
local var_0_1 = stingray.Quaternion
local var_0_2 = stingray.Matrix4x4
local var_0_3 = stingray.Imgui
local var_0_4 = Unit

local function var_0_5(arg_1_0, arg_1_1, ...)
	var_0_3.text_colored(arg_1_0, 200, 200, 255, 255)
	var_0_3.same_line()
	var_0_3.text(string.format(arg_1_1, ...))
end

ImguiPhysgun = class(ImguiPhysgun)

ImguiPhysgun.init = function (arg_2_0)
	arg_2_0._delayed_initialization_done = false
	arg_2_0._camera_locked = false
	arg_2_0._is_rotating = false
end

ImguiPhysgun._delayed_initialization = function (arg_3_0)
	local var_3_0 = Managers.state and Managers.state.entity:system("ai_system")

	if not var_3_0 then
		return
	end

	local var_3_1 = var_3_0.world

	arg_3_0._world = var_3_1
	arg_3_0._physics_world = World.physics_world(var_3_1)
	arg_3_0._line_object = World.create_line_object(var_3_1)

	print("[ImguiPhysgun] Delayed initialization done")

	arg_3_0._delayed_initialization_done = true
end

ImguiPhysgun.is_persistent = function (arg_4_0)
	return true
end

ImguiPhysgun.destroy_gui = function (arg_5_0)
	local var_5_0 = arg_5_0._world
	local var_5_1 = arg_5_0._gui_navmesh

	if var_5_0 and var_5_1 then
		World.destroy_gui(arg_5_0._world, var_5_1)

		arg_5_0._gui_navmesh = nil
	end
end

ImguiPhysgun.destroy = function (arg_6_0)
	local var_6_0 = arg_6_0._world

	if var_6_0 then
		local var_6_1 = arg_6_0._line_object

		LineObject.reset(var_6_1)
		LineObject.dispatch(var_6_0, var_6_1)
		World.destroy_line_object(var_6_0, var_6_1)

		arg_6_0._world = nil
	end

	arg_6_0:destroy_gui()
	arg_6_0:set_camera_lock(false)
end

ImguiPhysgun.get_player_pos_rot = function (arg_7_0)
	local var_7_0 = Managers.player:local_player()
	local var_7_1 = var_7_0 and var_7_0.player_unit

	if not ALIVE[var_7_1] then
		return
	end

	local var_7_2 = ScriptUnit.extension(var_7_1, "first_person_system")
	local var_7_3 = var_7_2:current_position()
	local var_7_4 = var_7_2:current_rotation()

	return var_7_3, var_7_4
end

local function var_0_6(arg_8_0)
	return string.format("\\x%02x", string.byte(arg_8_0))
end

local function var_0_7(arg_9_0)
	return string.gsub(arg_9_0, ".", var_0_6)
end

ImguiPhysgun.show_unit_info = function (arg_10_0, arg_10_1)
	local var_10_0 = var_0_4

	var_0_5("ID string", "%s", var_10_0.id_string(arg_10_1))
	var_0_5("Level ID", "%s", var_10_0.level_id_string(arg_10_1))
	var_0_5("Debug name", "%q", var_10_0.debug_name(arg_10_1))
	var_0_5("Name hash", "%s", var_0_7(var_10_0.name_hash(arg_10_1)))
	var_0_5("Position", "%s", tostring(var_10_0.local_position(arg_10_1, 0)))
	var_0_5("Rotation", "%s", tostring(var_10_0.local_rotation(arg_10_1, 0)))
	var_0_5("Scale", "%s", tostring(var_10_0.local_scale(arg_10_1, 0)))
	var_0_5("Mesh#", var_10_0.num_meshes(arg_10_1))
	var_0_5("Actor#", var_10_0.num_actors(arg_10_1))
	var_0_5("Light#", var_10_0.num_lights(arg_10_1))
	var_0_5("Cameras#", var_10_0.num_cameras(arg_10_1))
	var_0_5("Is frozen?", var_10_0.is_frozen(arg_10_1) and "yes" or "no")
end

local function var_0_8(arg_11_0)
	return setmetatable({}, {
		__index = function (arg_12_0, arg_12_1)
			local var_12_0 = arg_11_0.button_index(arg_12_1)
			local var_12_1 = "pressed"

			if not var_12_0 then
				var_12_0 = arg_11_0.axis_index(arg_12_1)
				var_12_1 = "axis"
			end

			assert(var_12_0, "Not such button or axis: " .. tostring(arg_12_1))

			local function var_12_2(arg_13_0)
				if arg_13_0 == "held" then
					return arg_11_0.button(var_12_0) > 0.5
				end

				return arg_11_0[arg_13_0 or var_12_1](var_12_0)
			end

			arg_12_0[arg_12_1] = var_12_2

			return var_12_2
		end
	})
end

local var_0_9 = var_0_8(Keyboard)
local var_0_10 = var_0_8(Mouse)
local var_0_11 = {
	mouse = var_0_10.mouse,
	cursor = var_0_10.cursor,
	move_right = var_0_9.d,
	move_left = var_0_9.a,
	move_forward = var_0_9.w,
	move_back = var_0_9.s,
	snap_angles = var_0_9["left shift"],
	grab = var_0_10.left,
	rotate = var_0_10.right,
	arcball = var_0_9.e,
	generate_navmesh = var_0_9.f1,
	wheel = function (arg_14_0)
		return var_0_10.wheel("axis").y
	end,
	spawn_seedpoint = var_0_9.f,
	delete_unit = var_0_9.backspace,
	spawn_cylinder = var_0_9.c
}

local function var_0_12(arg_15_0, arg_15_1)
	return var_0_11[arg_15_0](arg_15_1)
end

ImguiPhysgun.set_camera_lock = function (arg_16_0, arg_16_1)
	if arg_16_1 ~= arg_16_0._camera_locked then
		if arg_16_1 then
			Managers.input:capture_input(ALL_INPUT_METHODS, 1, "imgui", "ImguiManager")
		else
			Window.set_show_cursor(false)
			Managers.input:release_input(ALL_INPUT_METHODS, 1, "imgui", "ImguiManager")
		end

		arg_16_0._camera_locked = arg_16_1
	end
end

ImguiPhysgun.can_grab = function (arg_17_0, arg_17_1)
	if not arg_17_1 then
		return false, "actor is nil"
	end

	local var_17_0 = Actor.unit(arg_17_1)

	if var_0_4.is_a(var_17_0, "core/editor_slave/units/animation_preview_tile/animation_preview_tile") then
		return false, "unit is the floor"
	end

	return true
end

ImguiPhysgun.grab_begin = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	local var_18_0 = Actor.unit(arg_18_3)
	local var_18_1 = var_0_4.local_position(var_18_0, 0)
	local var_18_2 = var_0_4.local_rotation(var_18_0, 0)

	arg_18_0._physgun_unit = var_18_0
	arg_18_0._physgun_actor = arg_18_3

	local var_18_3 = var_0_1.inverse(arg_18_2)

	arg_18_0._physgun_pos = Vector3Box(var_0_1.rotate(var_18_3, var_18_1 - arg_18_1))
	arg_18_0._physgun_rot = QuaternionBox(var_0_1.multiply(var_18_3, var_18_2))
	arg_18_0._physgun_pivot = Vector3Box(var_0_1.rotate(var_18_3, arg_18_4 - var_18_1))
	arg_18_0._wheel_speed = 0
	arg_18_0._physgun_dist = Vector3.distance(arg_18_1, arg_18_4)

	local var_18_4 = arg_18_0._world
	local var_18_5 = arg_18_0._physgun_actor_poses

	if not var_18_5 then
		var_18_5 = {}
		arg_18_0._physgun_actor_poses = var_18_5
	end

	local var_18_6 = var_0_2.inverse(var_0_4.local_pose(var_18_0, 0))

	for iter_18_0 = 0, var_0_4.num_actors(var_18_0) - 1 do
		local var_18_7 = var_0_4.actor(var_18_0, iter_18_0)

		if var_18_7 and Actor.is_static(var_18_7) then
			var_18_5[var_18_7] = Matrix4x4Box(var_0_2.multiply(Actor.pose(var_18_7), var_18_6))
		end
	end
end

ImguiPhysgun.grab_end = function (arg_19_0)
	arg_19_0._physgun_unit = nil
	arg_19_0._physgun_actor = nil
	arg_19_0._physgun_pos = nil
	arg_19_0._physgun_rot = nil
	arg_19_0._physgun_pivot = nil
	arg_19_0._physgun_dist = nil

	table.clear(arg_19_0._physgun_actor_poses)

	arg_19_0._is_rotating = false
end

local function var_0_13()
	local var_20_0 = var_0_12("cursor")
	local var_20_1, var_20_2 = Gui.resolution()
	local var_20_3 = 1 / math.min(var_20_1, var_20_2)
	local var_20_4 = (2 * var_20_0.x - var_20_1) * var_20_3
	local var_20_5 = (2 * var_20_0.y - var_20_2) * var_20_3
	local var_20_6 = var_20_4 * var_20_4 + var_20_5 * var_20_5

	return var_0_0(var_20_4, var_20_5, var_20_6 < 0.5 and math.sqrt(1 - var_20_6) or 0.5 / math.sqrt(var_20_6))
end

ImguiPhysgun.grab_update = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = arg_21_0._physgun_unit
	local var_21_1 = arg_21_0._physgun_actor
	local var_21_2 = arg_21_0._physgun_pos:unbox()
	local var_21_3 = arg_21_0._physgun_rot:unbox()
	local var_21_4
	local var_21_5
	local var_21_6 = 0.1 * var_0_12("wheel") / arg_21_1
	local var_21_7 = arg_21_0._wheel_speed * math.exp(-15 * arg_21_1) + var_21_6

	arg_21_0._wheel_speed = var_21_7

	local var_21_8 = var_21_7 * arg_21_1
	local var_21_9 = var_0_12("rotate", "held")

	if var_21_9 ~= arg_21_0._is_rotating then
		arg_21_0._is_rotating = var_21_9

		if not var_21_9 then
			Window.set_clip_cursor(false)
			Window.set_show_cursor(false)
		end

		arg_21_0:set_camera_lock(var_21_9)
	end

	if var_21_9 then
		local var_21_10

		if var_0_12("arcball", "pressed") then
			Window.set_clip_cursor(true)
			Window.set_show_cursor(true)
			Window.set_cursor_position(var_0_0(0.5, 0.5, 0))
		elseif var_0_12("arcball", "released") then
			Window.set_clip_cursor(false)
			Window.set_show_cursor(false)
		end

		if var_0_12("arcball", "held") then
			if var_0_12("grab", "pressed") then
				arg_21_0._trackball_start = Vector3Box(var_0_13())
			elseif var_0_12("grab", "released") then
				arg_21_0._trackball_start = nil
			elseif var_0_12("grab", "held") and arg_21_0._trackball_start then
				local var_21_11 = arg_21_0._trackball_start:unbox()
				local var_21_12 = var_0_13()
				local var_21_13 = var_0_1.rotate(arg_21_3, var_0_0.cross(var_21_11, var_21_12))
				local var_21_14 = math.acos(math.min(1, var_0_0.dot(var_21_11, var_21_12)))

				if var_21_14 > 0.001 then
					var_21_10 = var_0_1.multiply(var_0_1.axis_angle(var_21_13, var_21_14), var_0_1.inverse(var_21_3))
				end
			end
		else
			local var_21_15 = var_0_12("mouse")
			local var_21_16 = 2 * math.pi / math.min(Gui.resolution())
			local var_21_17 = var_0_12("move_right", "button") - var_0_12("move_left", "button")

			var_21_10 = var_0_1.from_yaw_pitch_roll((var_21_15.x + var_21_17) * var_21_16, var_21_15.y * var_21_16, 0)
		end

		if var_21_10 then
			var_21_3 = var_0_1.multiply(var_21_10, var_21_3)

			arg_21_0._physgun_rot:store(var_21_3)

			local var_21_18 = arg_21_0._physgun_pivot:unbox()
			local var_21_19 = var_0_1.rotate(var_21_10, var_21_18)

			arg_21_0._physgun_pivot:store(var_21_19)

			var_21_2 = var_21_2 + (var_21_18 - var_21_19)
		end

		var_21_8 = var_21_8 + 10 * arg_21_1 * (var_0_12("move_forward", "button") - var_0_12("move_back", "button"))
	end

	local var_21_20 = var_21_2 + var_0_0(0, var_21_8, 0)

	arg_21_0._physgun_pos:store(var_21_20)

	if var_0_12("snap_angles", "held") then
		local var_21_21, var_21_22, var_21_23 = var_0_1.to_euler_angles_xyz(var_21_3)
		local var_21_24 = math.round(var_21_21 / 45) * 45
		local var_21_25 = math.round(var_21_22 / 45) * 45
		local var_21_26 = math.round(var_21_23 / 45) * 45

		var_21_3 = var_0_1.from_euler_angles_xyz(var_21_24, var_21_25, var_21_26)
	end

	local var_21_27 = arg_21_2 + var_0_1.rotate(arg_21_3, var_21_20)
	local var_21_28 = var_0_1.multiply(arg_21_3, var_21_3)

	var_0_4.set_local_position(var_21_0, 0, var_0_0.lerp(var_0_4.local_position(var_21_0, 0), var_21_27, 0.25))
	var_0_4.set_local_rotation(var_21_0, 0, var_0_1.lerp(var_0_4.local_rotation(var_21_0, 0), var_21_28, 0.25))

	local var_21_29 = arg_21_0._physgun_actor_poses
	local var_21_30 = var_0_4.local_pose(var_21_0, 0)

	for iter_21_0, iter_21_1 in pairs(var_21_29) do
		Actor.teleport_pose(iter_21_0, var_0_2.multiply(iter_21_1:unbox(), var_21_30))
	end

	local var_21_31 = var_21_9 and (var_0_12("arcball", "held") and Color(255, 0, 0) or Color(0, 255, 0)) or Color(255, 255, 0)

	Actor.debug_draw(var_21_1, arg_21_0._line_object, var_21_31)
	arg_21_0:laser_update(arg_21_3)
end

ImguiPhysgun.laser_update = function (arg_22_0, arg_22_1)
	return
end

ImguiPhysgun.do_grab = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	if not arg_23_0._physgun_actor then
		local var_23_0 = var_0_12("rotate", "held")

		if var_23_0 or var_0_12("grab", "held") then
			local var_23_1, var_23_2 = arg_23_0:can_grab(arg_23_4)

			if var_23_1 then
				arg_23_0:grab_begin(arg_23_2, arg_23_3, arg_23_4, arg_23_5)

				if var_23_0 then
					arg_23_0._is_rotating = true

					arg_23_0:set_camera_lock(true)
				end
			else
				Debug.text("Cannot grab unit: %s", var_23_2)
			end
		end
	else
		local var_23_3 = arg_23_0._physgun_unit

		if not var_0_4.alive(var_23_3) or not arg_23_0._is_rotating and not var_0_12("grab", "held") then
			arg_23_0:grab_end()
			arg_23_0:set_camera_lock(false)
		else
			arg_23_0:grab_update(arg_23_1, arg_23_2, arg_23_3)
		end
	end
end

ImguiPhysgun.on_hide = function (arg_24_0)
	if arg_24_0._delayed_initialization_done then
		local var_24_0 = arg_24_0._line_object

		LineObject.reset(var_24_0)
		LineObject.dispatch(arg_24_0._world, var_24_0)
	end
end

local var_0_14 = true

ImguiPhysgun.update = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	if var_0_14 then
		var_0_14 = arg_25_0:init()
	end
end

ImguiPhysgun.draw = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	if not arg_26_0._delayed_initialization_done then
		arg_26_0:_delayed_initialization()
	end

	local var_26_0 = var_0_3.begin_window("Physgun")
	local var_26_1 = arg_26_0._line_object
	local var_26_2, var_26_3 = arg_26_0:get_player_pos_rot()

	if var_26_2 then
		local var_26_4 = var_0_1.forward(var_26_3)
		local var_26_5 = 30
		local var_26_6, var_26_7, var_26_8, var_26_9, var_26_10 = PhysicsWorld.raycast(arg_26_0._physics_world, var_26_2, var_26_4, var_26_5, "closest", "collision_filter", "filter_in_line_of_sight_no_players_no_enemies")

		if var_26_6 and not arg_26_0._physgun_unit then
			LineObject.add_circle(var_26_1, Color(255, 255, 0, 0), var_26_7, 0.1, var_26_9)
			LineObject.add_line(var_26_1, Color(255, 255, 0, 0), var_26_7, var_26_7 + 0.1 * var_26_9)
			Actor.debug_draw(var_26_10, var_26_1, Color(255, 255, 0, 0))

			if var_0_12("delete_unit") then
				local var_26_11 = Actor.unit(var_26_10)

				if var_26_11 == arg_26_0._physgun_unit then
					arg_26_0:grab_end()
				end

				World.destroy_unit(arg_26_0._world, var_26_11)

				var_26_10 = nil
			elseif var_0_12("spawn_cylinder") then
				-- Nothing
			end
		end

		local var_26_12 = arg_26_0._physgun_unit or var_26_10 and Actor.unit(var_26_10)

		if var_26_12 then
			arg_26_0:show_unit_info(var_26_12)
		end

		arg_26_0:do_grab(arg_26_3, var_26_2, var_26_3, var_26_10, var_26_7)
	else
		var_0_3.text("Could not raycast.")

		if arg_26_0._physgun_unit then
			arg_26_0:grab_end()
		end
	end

	LineObject.dispatch(arg_26_0._world, var_26_1)
	LineObject.reset(var_26_1)
	var_0_3.end_window()

	return var_26_0
end
