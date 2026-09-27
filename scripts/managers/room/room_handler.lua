-- chunkname: @scripts/managers/room/room_handler.lua

require("scripts/settings/profiles/room_profiles")

RoomHandler = class(RoomHandler)

RoomHandler.init = function (self, arg_1_1)
	-- function 1
	self._world = arg_1_1
	self._rooms = {}
	self._level_anchor_points = {}
	self._num_active_rooms = 0
end

RoomHandler.setup_level_anchor_points = function (self, arg_2_1)
	-- function 2
	local units = Level.units(arg_2_1)

	for i, v in ipairs(units) do
		if not Unit.has_data(v, "room_id") then
			local get_data = Unit.get_data(v, "room_id")

			fassert(get_data ~= -1, "There exist a room_anchor_point without a room_id set in this level")
			fassert(self._rooms[get_data] == nil, "There are two room_anchor_points with the same room_id (room_id: %s)", tostring(get_data))

			local world_position = Unit.world_position(v, 0)
			local world_rotation = Unit.world_rotation(v, 0)
			local forward = Quaternion.forward(world_rotation)

			self._level_anchor_points[get_data] = {
				position = Vector3Box(world_position),
				normal = Vector3Box(forward)
			}
			self._rooms[get_data] = {
				available = true
			}
		end
	end
end

RoomHandler.create_room = function (self, arg_3_1, arg_3_2)
	-- function 3
	arg_3_2 = arg_3_2 or self:_available_room_id()

	fassert(self._rooms[arg_3_2].available, "[RoomHandler]: room_id %q is not available", arg_3_2)

	local var_3_0 = self._level_anchor_points[arg_3_2]
	local unbox = var_3_0.position:unbox()
	local unbox_2 = var_3_0.normal:unbox()
	local look = Quaternion.look(-unbox_2)
	local _world = self._world
	local level_name = arg_3_1.level_name
	local spawn_level = World.spawn_level(_world, level_name, unbox, look)
	local str = "room_" .. tostring(arg_3_2) .. "_spawned"

	LevelHelper:flow_event(_world, str)

	local tbl = {
		available = false,
		level = spawn_level
	}

	self._rooms[arg_3_2] = tbl

	printf("[RoomHandler]: Created room with room_id: %s at position: %s, %s, %s", tostring(arg_3_2), tostring(unbox.x), tostring(unbox.y), tostring(unbox.z))

	return arg_3_2
end

RoomHandler.destroy_room = function (self, arg_4_1)
	-- function 4
	printf("[RoomHandler]: Destroying room with room_id: %s", tostring(arg_4_1))

	local _world = self._world
	local str = "room_" .. tostring(arg_4_1) .. "_destroyed"

	LevelHelper:flow_event(_world, str)

	local var_4_2 = self._rooms[arg_4_1]

	ScriptWorld.destroy_level_from_reference(_world, var_4_2.level)

	self._rooms[arg_4_1] = {
		available = true
	}
end

RoomHandler._available_room_id = function (self)
	-- function 5
	local count = #self._rooms

	for i = 1, count do
		if not self._rooms[i].available then
			return i
		end
	end

	error("[RoomHandler]: There's no rooms available. Lobby size to big? Not enough anchor points?")
end

RoomHandler._debug_print = function (self)
	-- function 6
	local str = ""
	local str_2 = ""
	local count = #self._rooms

	for i = 1, count do
		if not self._rooms[i].available then
			str = str .. i .. ", "
		else
			str_2 = str_2 .. i .. ", "
		end
	end

	Managers.state.debug_text:output_screen_text("Occupied: " .. str .. "\n" .. "Available: " .. str_2, 22, 5)
end

RoomHandler.room_from_id = function (self, arg_7_1)
	-- function 7
	return self._rooms[arg_7_1]
end

RoomHandler.destroy = function (self)
	-- function 8
	local _num_active_rooms = self._num_active_rooms

	for i = 1, _num_active_rooms do
		local var_8_1 = self._rooms[i]

		ScriptWorld.destroy_level_from_reference(self._world, var_8_1.level)
	end
end
