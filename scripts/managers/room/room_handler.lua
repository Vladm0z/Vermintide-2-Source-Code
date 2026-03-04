-- chunkname: @scripts/managers/room/room_handler.lua

require("scripts/settings/profiles/room_profiles")

RoomHandler = class(RoomHandler)

function RoomHandler.init(arg_1_0, arg_1_1)
	arg_1_0._world = arg_1_1
	arg_1_0._rooms = {}
	arg_1_0._level_anchor_points = {}
	arg_1_0._num_active_rooms = 0
end

function RoomHandler.setup_level_anchor_points(arg_2_0, arg_2_1)
	local var_2_0 = Level.units(arg_2_1)

	for iter_2_0, iter_2_1 in ipairs(var_2_0) do
		if Unit.has_data(iter_2_1, "room_id") then
			local var_2_1 = Unit.get_data(iter_2_1, "room_id")

			fassert(var_2_1 ~= -1, "There exist a room_anchor_point without a room_id set in this level")
			fassert(arg_2_0._rooms[var_2_1] == nil, "There are two room_anchor_points with the same room_id (room_id: %s)", tostring(var_2_1))

			local var_2_2 = Unit.world_position(iter_2_1, 0)
			local var_2_3 = Unit.world_rotation(iter_2_1, 0)
			local var_2_4 = Quaternion.forward(var_2_3)

			arg_2_0._level_anchor_points[var_2_1] = {
				position = Vector3Box(var_2_2),
				normal = Vector3Box(var_2_4)
			}
			arg_2_0._rooms[var_2_1] = {
				available = true
			}
		end
	end
end

function RoomHandler.create_room(arg_3_0, arg_3_1, arg_3_2)
	arg_3_2 = arg_3_2 or arg_3_0:_available_room_id()

	fassert(arg_3_0._rooms[arg_3_2].available, "[RoomHandler]: room_id %q is not available", arg_3_2)

	local var_3_0 = arg_3_0._level_anchor_points[arg_3_2]
	local var_3_1 = var_3_0.position:unbox()
	local var_3_2 = var_3_0.normal:unbox()
	local var_3_3 = Quaternion.look(-var_3_2)
	local var_3_4 = arg_3_0._world
	local var_3_5 = arg_3_1.level_name
	local var_3_6 = World.spawn_level(var_3_4, var_3_5, var_3_1, var_3_3)
	local var_3_7 = "room_" .. tostring(arg_3_2) .. "_spawned"

	LevelHelper:flow_event(var_3_4, var_3_7)

	local var_3_8 = {
		available = false,
		level = var_3_6
	}

	arg_3_0._rooms[arg_3_2] = var_3_8

	printf("[RoomHandler]: Created room with room_id: %s at position: %s, %s, %s", tostring(arg_3_2), tostring(var_3_1.x), tostring(var_3_1.y), tostring(var_3_1.z))

	return arg_3_2
end

function RoomHandler.destroy_room(arg_4_0, arg_4_1)
	printf("[RoomHandler]: Destroying room with room_id: %s", tostring(arg_4_1))

	local var_4_0 = arg_4_0._world
	local var_4_1 = "room_" .. tostring(arg_4_1) .. "_destroyed"

	LevelHelper:flow_event(var_4_0, var_4_1)

	local var_4_2 = arg_4_0._rooms[arg_4_1]

	ScriptWorld.destroy_level_from_reference(var_4_0, var_4_2.level)

	arg_4_0._rooms[arg_4_1] = {
		available = true
	}
end

function RoomHandler._available_room_id(arg_5_0)
	local var_5_0 = #arg_5_0._rooms

	for iter_5_0 = 1, var_5_0 do
		if arg_5_0._rooms[iter_5_0].available then
			return iter_5_0
		end
	end

	error("[RoomHandler]: There's no rooms available. Lobby size to big? Not enough anchor points?")
end

function RoomHandler._debug_print(arg_6_0)
	local var_6_0 = ""
	local var_6_1 = ""
	local var_6_2 = #arg_6_0._rooms

	for iter_6_0 = 1, var_6_2 do
		if not arg_6_0._rooms[iter_6_0].available then
			var_6_0 = var_6_0 .. iter_6_0 .. ", "
		else
			var_6_1 = var_6_1 .. iter_6_0 .. ", "
		end
	end

	Managers.state.debug_text:output_screen_text("Occupied: " .. var_6_0 .. "\n" .. "Available: " .. var_6_1, 22, 5)
end

function RoomHandler.room_from_id(arg_7_0, arg_7_1)
	return arg_7_0._rooms[arg_7_1]
end

function RoomHandler.destroy(arg_8_0)
	local var_8_0 = arg_8_0._num_active_rooms

	for iter_8_0 = 1, var_8_0 do
		local var_8_1 = arg_8_0._rooms[iter_8_0]

		ScriptWorld.destroy_level_from_reference(arg_8_0._world, var_8_1.level)
	end
end
