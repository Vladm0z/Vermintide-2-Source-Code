-- chunkname: @scripts/managers/room/room_manager_client.lua

require("scripts/managers/room/room_handler")

RoomManagerClient = class(RoomManagerClient)

local var_0_0 = {
	"rpc_inn_room_created",
	"rpc_inn_room_destroyed"
}

RoomManagerClient.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._peer_rooms = {}
	arg_1_0._room_order = {}
	arg_1_0._room_handler = RoomHandler:new(arg_1_1)

	arg_1_2:register(arg_1_0, unpack(var_0_0))

	arg_1_0._network_event_delegate = arg_1_2
end

RoomManagerClient.setup_level_anchor_points = function (arg_2_0, arg_2_1)
	arg_2_0._room_handler:setup_level_anchor_points(arg_2_1)
end

RoomManagerClient.create_room = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = SPProfiles[arg_3_3]

	if arg_3_0._peer_rooms[arg_3_1] then
		return
	end

	local var_3_1 = var_3_0.room_profile

	arg_3_0._room_handler:create_room(var_3_1, arg_3_2)

	arg_3_0._peer_rooms[arg_3_1] = {
		room_id = arg_3_2
	}
	arg_3_0._room_order[arg_3_2] = arg_3_1
end

RoomManagerClient.destroy_room = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0._peer_rooms[arg_4_1]

	arg_4_0._room_handler:destroy_room(var_4_0.room_id)

	arg_4_0._room_order[var_4_0.room_id] = nil
	arg_4_0._peer_rooms[arg_4_1] = nil
end

RoomManagerClient.destroy = function (arg_5_0)
	arg_5_0._room_handler:destroy()

	arg_5_0._room_handler = nil

	arg_5_0._network_event_delegate:unregister(arg_5_0)

	arg_5_0._network_event_delegate = nil
end

RoomManagerClient.rpc_inn_room_created = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	arg_6_0:create_room(arg_6_2, arg_6_3, arg_6_4)
end

RoomManagerClient.rpc_inn_room_destroyed = function (arg_7_0, arg_7_1, arg_7_2)
	arg_7_0:destroy_room(arg_7_2)
end

RoomManagerClient.get_spawn_point_by_peer = function (arg_8_0, arg_8_1)
	return arg_8_0._peer_rooms[arg_8_1].room_id
end
