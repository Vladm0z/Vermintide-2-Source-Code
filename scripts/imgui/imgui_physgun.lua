-- chunkname: @scripts/imgui/imgui_physgun.lua

local Vector3 = stingray.Vector3
local Quaternion = stingray.Quaternion
local Matrix4x4 = stingray.Matrix4x4
local Imgui = stingray.Imgui
local Unit = Unit

local function fn(arg_1_0, arg_1_1, ...)
	-- function 1
	Imgui.text_colored(arg_1_0, 200, 200, 255, 255)
	Imgui.same_line()
	Imgui.text(string.format(arg_1_1, ...))
end

ImguiPhysgun = class(ImguiPhysgun)

ImguiPhysgun.init = function (self)
	-- function 2
	self._delayed_initialization_done = false
	self._camera_locked = false
	self._is_rotating = false
end

ImguiPhysgun._delayed_initialization = function (self)
	-- function 3
	local state = Managers.state

	state = not state and Managers.state.entity:system("ai_system")

	if not state then
		return
	end

	local world = state.world

	self._world = world
	self._physics_world = World.physics_world(world)
	self._line_object = World.create_line_object(world)

	print("[ImguiPhysgun] Delayed initialization done")

	self._delayed_initialization_done = true
end

ImguiPhysgun.is_persistent = function (arg_4_0)
	-- function 4
	return true
end

ImguiPhysgun.destroy_gui = function (self)
	-- function 5
	local _world = self._world
	local _gui_navmesh = self._gui_navmesh

	if not _world and not _gui_navmesh then
		World.destroy_gui(self._world, _gui_navmesh)

		self._gui_navmesh = nil
	end
end

ImguiPhysgun.destroy = function (self)
	-- function 6
	local _world = self._world

	if not _world then
		local _line_object = self._line_object

		LineObject.reset(_line_object)
		LineObject.dispatch(_world, _line_object)
		World.destroy_line_object(_world, _line_object)

		self._world = nil
	end

	self:destroy_gui()
	self:set_camera_lock(false)
end

ImguiPhysgun.get_player_pos_rot = function (arg_7_0)
	-- function 7
	local local_player = Managers.player:local_player()
	local flag = not local_player and local_player.player_unit

	if not ALIVE[flag] then
		return
	end

	local extension = ScriptUnit.extension(flag, "first_person_system")
	local current_position = extension:current_position()
	local current_rotation = extension:current_rotation()

	return current_position, current_rotation
end

local function fn_2(arg_8_0)
	-- function 8
	return string.format("\\x%02x", string.byte(arg_8_0))
end

local function fn_3(arg_9_0)
	-- function 9
	return string.gsub(arg_9_0, ".", fn_2)
end

ImguiPhysgun.show_unit_info = function (arg_10_0, arg_10_1)
	-- function 10
	local var_10_0 = Unit

	fn("ID string", "%s", var_10_0.id_string(arg_10_1))
	fn("Level ID", "%s", var_10_0.level_id_string(arg_10_1))
	fn("Debug name", "%q", var_10_0.debug_name(arg_10_1))
	fn("Name hash", "%s", fn_3(var_10_0.name_hash(arg_10_1)))
	fn("Position", "%s", tostring(var_10_0.local_position(arg_10_1, 0)))
	fn("Rotation", "%s", tostring(var_10_0.local_rotation(arg_10_1, 0)))
	fn("Scale", "%s", tostring(var_10_0.local_scale(arg_10_1, 0)))
	fn("Mesh#", var_10_0.num_meshes(arg_10_1))
	fn("Actor#", var_10_0.num_actors(arg_10_1))
	fn("Light#", var_10_0.num_lights(arg_10_1))
	fn("Cameras#", var_10_0.num_cameras(arg_10_1))

	local var_10_1 = fn
	local str = "Is frozen?"
	local flag

	flag = not var_10_0.is_frozen(arg_10_1) and "yes" and "no"

	var_10_1(str, flag)
end

local function fn_4(arg_11_0)
	-- function 11
	return setmetatable({}, {
		__index = function (self, arg_12_1)
			-- function 12
			local button_index = arg_11_0.button_index(arg_12_1)
			local str = "pressed"

			if not button_index then
				button_index = arg_11_0.axis_index(arg_12_1)
				str = "axis"
			end

			assert(button_index, "Not such button or axis: " .. tostring(arg_12_1))

			local function fn(arg_13_0)
				-- function 13
				if arg_13_0 == "held" then
					return arg_11_0.button(button_index) > 0.5
				end

				return arg_11_0[arg_13_0 or str](button_index)
			end

			self[arg_12_1] = fn

			return fn
		end
	})
end

local var_0_9 = fn_4(Keyboard)
local var_0_10 = fn_4(Mouse)
local tbl = {
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
		-- function 14
		return var_0_10.wheel("axis").y
	end,
	spawn_seedpoint = var_0_9.f,
	delete_unit = var_0_9.backspace,
	spawn_cylinder = var_0_9.c
}

local function fn_5(arg_15_0, arg_15_1)
	-- function 15
	return tbl[arg_15_0](arg_15_1)
end

ImguiPhysgun.set_camera_lock = function (self, arg_16_1)
	-- function 16
	if arg_16_1 ~= self._camera_locked then
		if not arg_16_1 then
			Managers.input:capture_input(ALL_INPUT_METHODS, 1, "imgui", "ImguiManager")
		else
			Window.set_show_cursor(false)
			Managers.input:release_input(ALL_INPUT_METHODS, 1, "imgui", "ImguiManager")
		end

		self._camera_locked = arg_16_1
	end
end

ImguiPhysgun.can_grab = function (arg_17_0, arg_17_1)
	-- function 17
	if not arg_17_1 then
		return false, "actor is nil"
	end

	local unit = Actor.unit(arg_17_1)

	if not Unit.is_a(unit, "core/editor_slave/units/animation_preview_tile/animation_preview_tile") then
		return false, "unit is the floor"
	end

	return true
end

ImguiPhysgun.grab_begin = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	-- function 18
	local unit = Actor.unit(arg_18_3)
	local local_position = Unit.local_position(unit, 0)
	local local_rotation = Unit.local_rotation(unit, 0)

	self._physgun_unit = unit
	self._physgun_actor = arg_18_3

	local inverse = Quaternion.inverse(arg_18_2)

	self._physgun_pos = Vector3Box(Quaternion.rotate(inverse, local_position - arg_18_1))
	self._physgun_rot = QuaternionBox(Quaternion.multiply(inverse, local_rotation))
	self._physgun_pivot = Vector3Box(Quaternion.rotate(inverse, arg_18_4 - local_position))
	self._wheel_speed = 0
	self._physgun_dist = Vector3.distance(arg_18_1, arg_18_4)

	local _world = self._world
	local _physgun_actor_poses = self._physgun_actor_poses

	if not _physgun_actor_poses then
		_physgun_actor_poses = {}
		self._physgun_actor_poses = _physgun_actor_poses
	end

	local inverse_2 = Matrix4x4.inverse(Unit.local_pose(unit, 0))

	for i = 0, Unit.num_actors(unit) - 1 do
		local actor = Unit.actor(unit, i)

		if not actor and not Actor.is_static(actor) then
			_physgun_actor_poses[actor] = Matrix4x4Box(Matrix4x4.multiply(Actor.pose(actor), inverse_2))
		end
	end
end

ImguiPhysgun.grab_end = function (self)
	-- function 19
	self._physgun_unit = nil
	self._physgun_actor = nil
	self._physgun_pos = nil
	self._physgun_rot = nil
	self._physgun_pivot = nil
	self._physgun_dist = nil

	table.clear(self._physgun_actor_poses)

	self._is_rotating = false
end

local function fn_6()
	-- function 20
	local var_20_0 = fn_5("cursor")
	local resolution, var_20_2 = Gui.resolution()
	local num = 1 / math.min(resolution, var_20_2)
	local num_2 = (2 * var_20_0.x - resolution) * num
	local num_3 = (2 * var_20_0.y - var_20_2) * num
	local num_4 = num_2 * num_2 + num_3 * num_3
	local var_20_7 = Vector3
	local var_20_8 = num_2
	local var_20_9 = num_3
	local sqrt

	if num_4 < 0.5 then
		sqrt = math.sqrt(1 - num_4)

		if not sqrt then
			-- Nothing
		end
	end

	sqrt = 0.5 / math.sqrt(num_4)

	::label_20_0::

	return var_20_7(var_20_8, var_20_9, sqrt)
end

ImguiPhysgun.grab_update = function (self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	local _physgun_unit = self._physgun_unit
	local _physgun_actor = self._physgun_actor
	local unbox = self._physgun_pos:unbox()
	local unbox_2 = self._physgun_rot:unbox()
	local var_21_4
	local var_21_5
	local num = 0.1 * fn_5("wheel") / arg_21_1
	local num_2 = self._wheel_speed * math.exp(-15 * arg_21_1) + num

	self._wheel_speed = num_2

	local num_3 = num_2 * arg_21_1
	local var_21_9 = fn_5("rotate", "held")

	if var_21_9 ~= self._is_rotating then
		self._is_rotating = var_21_9

		if not var_21_9 then
			Window.set_clip_cursor(false)
			Window.set_show_cursor(false)
		end

		self:set_camera_lock(var_21_9)
	end

	if not var_21_9 then
		local var_21_10

		if not fn_5("arcball", "pressed") then
			Window.set_clip_cursor(true)
			Window.set_show_cursor(true)
			Window.set_cursor_position(Vector3(0.5, 0.5, 0))
		elseif not fn_5("arcball", "released") then
			Window.set_clip_cursor(false)
			Window.set_show_cursor(false)
		end

		if not fn_5("arcball", "held") then
			if not fn_5("grab", "pressed") then
				self._trackball_start = Vector3Box(fn_6())
			elseif not fn_5("grab", "released") then
				self._trackball_start = nil
			elseif not fn_5("grab", "held") and not self._trackball_start then
				local unbox_3 = self._trackball_start:unbox()
				local var_21_12 = fn_6()
				local rotate = Quaternion.rotate(arg_21_3, Vector3.cross(unbox_3, var_21_12))
				local acos = math.acos(math.min(1, Vector3.dot(unbox_3, var_21_12)))

				if acos > 0.001 then
					var_21_10 = Quaternion.multiply(Quaternion.axis_angle(rotate, acos), Quaternion.inverse(unbox_2))
				end
			end
		else
			local var_21_15 = fn_5("mouse")
			local num_4 = 2 * math.pi / math.min(Gui.resolution())
			local num_5 = fn_5("move_right", "button") - fn_5("move_left", "button")

			var_21_10 = Quaternion.from_yaw_pitch_roll((var_21_15.x + num_5) * num_4, var_21_15.y * num_4, 0)
		end

		if not var_21_10 then
			unbox_2 = Quaternion.multiply(var_21_10, unbox_2)

			self._physgun_rot:store(unbox_2)

			local unbox_4 = self._physgun_pivot:unbox()
			local rotate_2 = Quaternion.rotate(var_21_10, unbox_4)

			self._physgun_pivot:store(rotate_2)

			unbox = unbox + (unbox_4 - rotate_2)
		end

		num_3 = num_3 + 10 * arg_21_1 * (fn_5("move_forward", "button") - fn_5("move_back", "button"))
	end

	local num_6 = unbox + Vector3(0, num_3, 0)

	self._physgun_pos:store(num_6)

	if not fn_5("snap_angles", "held") then
		local to_euler_angles_xyz, var_21_22, var_21_23 = Quaternion.to_euler_angles_xyz(unbox_2)
		local num_7 = math.round(to_euler_angles_xyz / 45) * 45
		local num_8 = math.round(var_21_22 / 45) * 45
		local num_9 = math.round(var_21_23 / 45) * 45

		unbox_2 = Quaternion.from_euler_angles_xyz(num_7, num_8, num_9)
	end

	local num_10 = arg_21_2 + Quaternion.rotate(arg_21_3, num_6)
	local multiply = Quaternion.multiply(arg_21_3, unbox_2)

	Unit.set_local_position(_physgun_unit, 0, Vector3.lerp(Unit.local_position(_physgun_unit, 0), num_10, 0.25))
	Unit.set_local_rotation(_physgun_unit, 0, Quaternion.lerp(Unit.local_rotation(_physgun_unit, 0), multiply, 0.25))

	local _physgun_actor_poses = self._physgun_actor_poses
	local local_pose = Unit.local_pose(_physgun_unit, 0)

	for k, v in pairs(_physgun_actor_poses) do
		Actor.teleport_pose(k, Matrix4x4.multiply(v:unbox(), local_pose))
	end

	local var_21_31

	if not var_21_9 then
		if not fn_5("arcball", "held") then
			var_21_31 = Color(255, 0, 0)

			if not var_21_31 then
				-- Nothing
			end
		end

		var_21_31 = Color(0, 255, 0)

		if not var_21_31 then
			-- Nothing
		end
	end

	var_21_31 = Color(255, 255, 0)

	::label_21_0::

	Actor.debug_draw(_physgun_actor, self._line_object, var_21_31)
	self:laser_update(arg_21_3)
end

ImguiPhysgun.laser_update = function (arg_22_0, arg_22_1)
	-- function 22
	return
end

ImguiPhysgun.do_grab = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	-- function 23
	if not self._physgun_actor then
		local var_23_0 = fn_5("rotate", "held")

		if var_23_0 or not fn_5("grab", "held") then
			local can_grab, var_23_2 = self:can_grab(arg_23_4)

			if not can_grab then
				self:grab_begin(arg_23_2, arg_23_3, arg_23_4, arg_23_5)

				if not var_23_0 then
					self._is_rotating = true

					self:set_camera_lock(true)
				end
			else
				Debug.text("Cannot grab unit: %s", var_23_2)
			end
		end
	else
		local _physgun_unit = self._physgun_unit

		if not (not Unit.alive(_physgun_unit) and self._is_rotating and fn_5("grab", "held")) then
			self:grab_end()
			self:set_camera_lock(false)
		else
			self:grab_update(arg_23_1, arg_23_2, arg_23_3)
		end
	end
end

ImguiPhysgun.on_hide = function (self)
	-- function 24
	if not self._delayed_initialization_done then
		local _line_object = self._line_object

		LineObject.reset(_line_object)
		LineObject.dispatch(self._world, _line_object)
	end
end

local flag = true

ImguiPhysgun.update = function (self, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	if not flag then
		flag = self:init()
	end
end

ImguiPhysgun.draw = function (self, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	if not self._delayed_initialization_done then
		self:_delayed_initialization()
	end

	local begin_window = Imgui.begin_window("Physgun")
	local _line_object = self._line_object
	local get_player_pos_rot, var_26_3 = self:get_player_pos_rot()

	if not get_player_pos_rot then
		local forward = Quaternion.forward(var_26_3)
		local num = 30
		local raycast, var_26_7, var_26_8, var_26_9, var_26_10 = PhysicsWorld.raycast(self._physics_world, get_player_pos_rot, forward, num, "closest", "collision_filter", "filter_in_line_of_sight_no_players_no_enemies")

		if not (not raycast and self._physgun_unit) then
			LineObject.add_circle(_line_object, Color(255, 255, 0, 0), var_26_7, 0.1, var_26_9)
			LineObject.add_line(_line_object, Color(255, 255, 0, 0), var_26_7, var_26_7 + 0.1 * var_26_9)
			Actor.debug_draw(var_26_10, _line_object, Color(255, 255, 0, 0))

			if not fn_5("delete_unit") then
				local unit = Actor.unit(var_26_10)

				if unit == self._physgun_unit then
					self:grab_end()
				end

				World.destroy_unit(self._world, unit)

				var_26_10 = nil
			elseif not fn_5("spawn_cylinder") then
				-- Nothing
			end
		end

		local flag = not var_26_10 and Actor.unit(var_26_10) and self._physgun_unit

		if not flag then
			self:show_unit_info(flag)
		end

		self:do_grab(arg_26_3, get_player_pos_rot, var_26_3, var_26_10, var_26_7)
	else
		Imgui.text("Could not raycast.")

		if not self._physgun_unit then
			self:grab_end()
		end
	end

	LineObject.dispatch(self._world, _line_object)
	LineObject.reset(_line_object)
	Imgui.end_window()

	return begin_window
end
